Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4410F44274
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbfFMQWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731042AbfFMIiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:38:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19F092064A;
        Thu, 13 Jun 2019 08:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415094;
        bh=hB0qPcv1bOLL0EP6nUoOqmHaJ0lna32eXvP9pNC7aNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSX0BaLBnPvb1BiVOxljiLtLedSFQxCkhpJpfKMLVBCycNjRlsTb49pRvJLpKJa9o
         yyYpaeiIyM4Y39iC3pv87k86BxFVVMuLK8ApmF8rQ5CCVuahsX+lv+q7mBSwyOvWGs
         SMK4O9WTu4RI7dGikr7CTahlpX+FD1q5c1oTHO3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 68/81] block, bfq: increase idling for weight-raised queues
Date:   Thu, 13 Jun 2019 10:33:51 +0200
Message-Id: <20190613075653.988319178@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 778c02a236a8728bb992de10ed1f12c0be5b7b0e ]

If a sync bfq_queue has a higher weight than some other queue, and
remains temporarily empty while in service, then, to preserve the
bandwidth share of the queue, it is necessary to plug I/O dispatching
until a new request arrives for the queue. In addition, a timeout
needs to be set, to avoid waiting for ever if the process associated
with the queue has actually finished its I/O.

Even with the above timeout, the device is however not fed with new
I/O for a while, if the process has finished its I/O. If this happens
often, then throughput drops and latencies grow. For this reason, the
timeout is kept rather low: 8 ms is the current default.

Unfortunately, such a low value may cause, on the opposite end, a
violation of bandwidth guarantees for a process that happens to issue
new I/O too late. The higher the system load, the higher the
probability that this happens to some process. This is a problem in
scenarios where service guarantees matter more than throughput. One
important case are weight-raised queues, which need to be granted a
very high fraction of the bandwidth.

To address this issue, this commit lower-bounds the plugging timeout
for weight-raised queues to 20 ms. This simple change provides
relevant benefits. For example, on a PLEXTOR PX-256M5S, with which
gnome-terminal starts in 0.6 seconds if there is no other I/O in
progress, the same applications starts in
- 0.8 seconds, instead of 1.2 seconds, if ten files are being read
  sequentially in parallel
- 1 second, instead of 2 seconds, if, in parallel, five files are
  being read sequentially, and five more files are being written
  sequentially

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 3b44bd28fc45..7d45ac451745 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2282,6 +2282,8 @@ static void bfq_arm_slice_timer(struct bfq_data *bfqd)
 	if (BFQQ_SEEKY(bfqq) && bfqq->wr_coeff == 1 &&
 	    bfq_symmetric_scenario(bfqd))
 		sl = min_t(u64, sl, BFQ_MIN_TT);
+	else if (bfqq->wr_coeff > 1)
+		sl = max_t(u32, sl, 20ULL * NSEC_PER_MSEC);
 
 	bfqd->last_idling_start = ktime_get();
 	hrtimer_start(&bfqd->idle_slice_timer, ns_to_ktime(sl),
-- 
2.20.1



