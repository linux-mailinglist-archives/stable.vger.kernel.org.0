Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E051250599
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgHXRRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbgHXQgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:36:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8D9722D04;
        Mon, 24 Aug 2020 16:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286961;
        bh=r9HBhZi5uRfTCPjOUZlAFzjcdKyoVIqdk98dp7qcDAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgBcG/7KD9bulRRhKzF5njETlnlqZvZr8oORAZMQ3eJAQu/lmXi54JMcnhvKFLdBO
         VwqptH+aebpv8Xrq5NPfFNqyJnTfzOSBnHHO+vEmhsO2lawgX/Ic0kUoT/9+J/uYQl
         1lZjSNF0B8uJj+9LYkw6rSmEakfQQiWQjCVDXzf0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        John Garry <john.garry@huawei.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 42/63] scsi: scsi_debug: Fix scp is NULL errors
Date:   Mon, 24 Aug 2020 12:34:42 -0400
Message-Id: <20200824163504.605538-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

[ Upstream commit 223f91b48079227f914657f07d2d686f7b60aa26 ]

John Garry reported 'sdebug_q_cmd_complete: scp is NULL' failures that were
mainly seen on aarch64 machines (e.g. RPi 4 with four A72 CPUs). The
problem was tracked down to a missing critical section on a "short circuit"
path. Namely, the time to process the current command so far has already
exceeded the requested command duration (i.e. the number of nanoseconds in
the ndelay parameter).

The random=1 parameter setting was pivotal in finding this error.  The
failure scenario involved first taking that "short circuit" path (due to a
very short command duration) and then taking the more likely
hrtimer_start() path (due to a longer command duration). With random=1 each
command's duration is taken from the uniformly distributed [0..ndelay)
interval.  The fio utility also helped by reliably generating the error
scenario at about once per minute on a RPi 4 (64 bit OS).

Link: https://lore.kernel.org/r/20200813155738.109298-1-dgilbert@interlog.com
Reported-by: John Garry <john.garry@huawei.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b0d93bf79978f..25faad7f8e617 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5486,9 +5486,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				u64 d = ktime_get_boottime_ns() - ns_from_boot;
 
 				if (kt <= d) {	/* elapsed duration >= kt */
+					spin_lock_irqsave(&sqp->qc_lock, iflags);
 					sqcp->a_cmnd = NULL;
 					atomic_dec(&devip->num_in_q);
 					clear_bit(k, sqp->in_use_bm);
+					spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 					if (new_sd_dp)
 						kfree(sd_dp);
 					/* call scsi_done() from this thread */
-- 
2.25.1

