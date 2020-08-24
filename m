Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C77D250381
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgHXQpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728586AbgHXQjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:39:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A33D22CB1;
        Mon, 24 Aug 2020 16:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287163;
        bh=4TG4KMIY0v5Q13GLnA/64q9bgsmokJekESKQfdHsjfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooHO/LAYaVVxBXlO4WkbAZ74n6SUBGoWdlBb8lf624HN3fx1zge4ugzww+plaDIht
         iAqK7JP55N6XGT1OvzPjr2VATvfvf42qYBfOc6EAIVujCw474LFsOkdKJp2YsqbULN
         7979X0Satwtymic4d19z63+YvOvnbHqsxHdpdV6E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/11] s390/cio: add cond_resched() in the slow_eval_known_fn() loop
Date:   Mon, 24 Aug 2020 12:39:09 -0400
Message-Id: <20200824163914.607152-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163914.607152-1-sashal@kernel.org>
References: <20200824163914.607152-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 0b8eb2ee9da1e8c9b8082f404f3948aa82a057b2 ]

The scanning through subchannels during the time of an event could
take significant amount of time in case of platforms with lots of
known subchannels. This might result in higher scheduling latencies
for other tasks especially on systems with a single CPU. Add
cond_resched() call, as the loop in slow_eval_known_fn() can be
executed for a longer duration.

Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index dadff1838fec1..e2026d54dd375 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -581,6 +581,11 @@ static int slow_eval_known_fn(struct subchannel *sch, void *data)
 		rc = css_evaluate_known_subchannel(sch, 1);
 		if (rc == -EAGAIN)
 			css_schedule_eval(sch->schid);
+		/*
+		 * The loop might take long time for platforms with lots of
+		 * known devices. Allow scheduling here.
+		 */
+		cond_resched();
 	}
 	return 0;
 }
-- 
2.25.1

