Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B309B2595ED
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbgIAP5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbgIAPoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5CE52064B;
        Tue,  1 Sep 2020 15:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975044;
        bh=r9HBhZi5uRfTCPjOUZlAFzjcdKyoVIqdk98dp7qcDAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAjvg+jiButgE/y/ixwrX7McM6LflBvGprTEykOf8ZGLjjSRIsXi2XkFkYkXtO2+l
         sjYIUwVB9g54hxosfxw0Z1+fv98iAPxvEjjBAdvdavX5JeupypcOAuAEtLY6meZSZQ
         1509X/XgBP1hn54A0wH/K0Bf0eey8+6VPt38+WUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Lee Duncan <lduncan@suse.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 147/255] scsi: scsi_debug: Fix scp is NULL errors
Date:   Tue,  1 Sep 2020 17:10:03 +0200
Message-Id: <20200901151007.745398956@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



