Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAAF2EA202
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbhAEA76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 19:59:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbhAEA76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 19:59:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DFCD2253A;
        Tue,  5 Jan 2021 00:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808357;
        bh=VoLbMH8dpj/kUif6dI+kfY6B54I14mpcwZXtcniup8A=;
        h=From:To:Cc:Subject:Date:From;
        b=ubjmhnlzPp1wB6g5+Ow+hkUfPCT3bNBe8UiX5fE86t99OBAaL568czaY0/iWhUCR0
         dDs/D0aegDCQdjHkoIao6tG79JFeO7ELIVtRvLgqOD2BgHOGlu27jxB1tcyVqdVBzn
         THjZ9I2vDilLX0fsUkKabr8UtyBLZBt3/Ni87VWvvBwuI/hx0hLRpOB/TEZ0OB8FUH
         Y/X/i6BwbOkvdZvDIWBthukaZPmKKKn0jlybwC0W/D3MarAGjK4wxe2kNBTuQZXPzr
         Xc3LVaO2bdV17e05RrDqfjRkZqbjtNW4j+rB6ZqY2eehBoUhxMLaTudxs1d8jmN/Xc
         u7gRKaMAg4ZPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunfeng Ye <yeyunfeng@huawei.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 01/17] workqueue: Kick a worker based on the actual activation of delayed works
Date:   Mon,  4 Jan 2021 19:58:59 -0500
Message-Id: <20210105005915.3954208-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 437935e7a1991..0695c7895c892 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3728,17 +3728,24 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
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

