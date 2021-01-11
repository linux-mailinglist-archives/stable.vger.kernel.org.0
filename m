Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C2F2F1357
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbhAKNH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:07:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbhAKNH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:07:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B00E32251F;
        Mon, 11 Jan 2021 13:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370433;
        bh=fLXC7Df1GHk9gRTDjHLdUfWBVUVc21PxXynDGsHCSJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sx1k7AsjXnN1MtoQjfdNMOGlffFwIlU9xc+eDUVJHhED50AIUvI2flOUtYCNAP7T/
         51LsnuI5+9gjTJSiBCoQJGgu+M2S7tTVg5Fz1pNmaumbsG78a0RSF5SNPVhH/oHSaz
         6tiguiWr50JPYqVh3u0rdb1O3WxEUiq98E37tx6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/77] workqueue: Kick a worker based on the actual activation of delayed works
Date:   Mon, 11 Jan 2021 14:01:11 +0100
Message-Id: <20210111130036.523486697@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit 01341fbd0d8d4e717fc1231cdffe00343088ce0b ]

In realtime scenario, We do not want to have interference on the
isolated cpu cores. but when invoking alloc_workqueue() for percpu wq
on the housekeeping cpu, it kick a kworker on the isolated cpu.

  alloc_workqueue
    pwq_adjust_max_active
      wake_up_worker

The comment in pwq_adjust_max_active() said:
  "Need to kick a worker after thawed or an unbound wq's
   max_active is bumped"

So it is unnecessary to kick a kworker for percpu's wq when invoking
alloc_workqueue(). this patch only kick a worker based on the actual
activation of delayed works.

Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index eef77c82d2e19..cd98ef48345e1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3554,17 +3554,24 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	 * is updated and visible.
 	 */
 	if (!freezable || !workqueue_freezing) {
+		bool kick = false;
+
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
-		       pwq->nr_active < pwq->max_active)
+		       pwq->nr_active < pwq->max_active) {
 			pwq_activate_first_delayed(pwq);
+			kick = true;
+		}
 
 		/*
 		 * Need to kick a worker after thawed or an unbound wq's
-		 * max_active is bumped.  It's a slow path.  Do it always.
+		 * max_active is bumped. In realtime scenarios, always kicking a
+		 * worker will cause interference on the isolated cpu cores, so
+		 * let's kick iff work items were activated.
 		 */
-		wake_up_worker(pwq->pool);
+		if (kick)
+			wake_up_worker(pwq->pool);
 	} else {
 		pwq->max_active = 0;
 	}
-- 
2.27.0



