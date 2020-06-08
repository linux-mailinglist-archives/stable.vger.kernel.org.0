Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194B21F2F71
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgFIAuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgFHXKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7208F20890;
        Mon,  8 Jun 2020 23:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657832;
        bh=YI/7tjuFBmB0rVIIsPJ7JnNmguqrLJZDN6HRzg1aR3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6lqGC2oXWHI1yllfZlbMDyWVn/7QoTXFwEtKP13qMGJhUJZzFvG35S6qsc7QRmR0
         cXdzaa7K70vmVOB+fdh9zCG2mW8ZWO7wrRqR1fdjDN9z25M8vDggKpjhEXmwoqGhOJ
         Wr0Jjqp/n8O+dnwhT9PMkIGpA/AqT/vgRzS39WwQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 202/274] iocost: don't let vrate run wild while there's no saturation signal
Date:   Mon,  8 Jun 2020 19:04:55 -0400
Message-Id: <20200608230607.3361041-202-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 81ca627a933063fa63a6d4c66425de822a2ab7f5 ]

When the QoS targets are met and nothing is being throttled, there's
no way to tell how saturated the underlying device is - it could be
almost entirely idle, at the cusp of saturation or anywhere inbetween.
Given that there's no information, it's best to keep vrate as-is in
this state.  Before 7cd806a9a953 ("iocost: improve nr_lagging
handling"), this was the case - if the device isn't missing QoS
targets and nothing is being throttled, busy_level was reset to zero.

While fixing nr_lagging handling, 7cd806a9a953 ("iocost: improve
nr_lagging handling") broke this.  Now, while the device is hitting
QoS targets and nothing is being throttled, vrate keeps getting
adjusted according to the existing busy_level.

This led to vrate keeping climing till it hits max when there's an IO
issuer with limited request concurrency if the vrate started low.
vrate starts getting adjusted upwards until the issuer can issue IOs
w/o being throttled.  From then on, QoS targets keeps getting met and
nothing on the system needs throttling and vrate keeps getting
increased due to the existing busy_level.

This patch makes the following changes to the busy_level logic.

* Reset busy_level if nr_shortages is zero to avoid the above
  scenario.

* Make non-zero nr_lagging block lowering nr_level but still clear
  positive busy_level if there's clear non-saturation signal - QoS
  targets are met and nr_shortages is non-zero.  nr_lagging's role is
  preventing adjusting vrate upwards while there are long-running
  commands and it shouldn't keep busy_level positive while there's
  clear non-saturation signal.

* Restructure code for clarity and add comments.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Andy Newell <newella@fb.com>
Fixes: 7cd806a9a953 ("iocost: improve nr_lagging handling")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7c1fe605d0d6..ef193389fffe 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1543,19 +1543,39 @@ static void ioc_timer_fn(struct timer_list *timer)
 	if (rq_wait_pct > RQ_WAIT_BUSY_PCT ||
 	    missed_ppm[READ] > ppm_rthr ||
 	    missed_ppm[WRITE] > ppm_wthr) {
+		/* clearly missing QoS targets, slow down vrate */
 		ioc->busy_level = max(ioc->busy_level, 0);
 		ioc->busy_level++;
 	} else if (rq_wait_pct <= RQ_WAIT_BUSY_PCT * UNBUSY_THR_PCT / 100 &&
 		   missed_ppm[READ] <= ppm_rthr * UNBUSY_THR_PCT / 100 &&
 		   missed_ppm[WRITE] <= ppm_wthr * UNBUSY_THR_PCT / 100) {
-		/* take action iff there is contention */
-		if (nr_shortages && !nr_lagging) {
+		/* QoS targets are being met with >25% margin */
+		if (nr_shortages) {
+			/*
+			 * We're throttling while the device has spare
+			 * capacity.  If vrate was being slowed down, stop.
+			 */
 			ioc->busy_level = min(ioc->busy_level, 0);
-			/* redistribute surpluses first */
-			if (!nr_surpluses)
+
+			/*
+			 * If there are IOs spanning multiple periods, wait
+			 * them out before pushing the device harder.  If
+			 * there are surpluses, let redistribution work it
+			 * out first.
+			 */
+			if (!nr_lagging && !nr_surpluses)
 				ioc->busy_level--;
+		} else {
+			/*
+			 * Nobody is being throttled and the users aren't
+			 * issuing enough IOs to saturate the device.  We
+			 * simply don't know how close the device is to
+			 * saturation.  Coast.
+			 */
+			ioc->busy_level = 0;
 		}
 	} else {
+		/* inside the hysterisis margin, we're good */
 		ioc->busy_level = 0;
 	}
 
-- 
2.25.1

