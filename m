Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07922F175A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbhAKND7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730063AbhAKND6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AD2422BE9;
        Mon, 11 Jan 2021 13:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370182;
        bh=MYM37uODWsKeqUYiME2eaMnBLxDgO0Kqe4gjPegcPuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5C5NKxX6ft+uoVoMVl6eLCP1LC6T9kXBKxEf+cwfUtH6B3TRHTJMxJsFqAWGttnN
         eBzmd58O60XZSvWuNHUwGNmuBeLse9+nIN6+hxcV/c5GqMgmKK26J5L06mq2W56iVQ
         y39xuPhfXOOVQc9BrXJ4PMDHawp0x0jdCrs/mS8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/45] workqueue: Kick a worker based on the actual activation of delayed works
Date:   Mon, 11 Jan 2021 14:00:40 +0100
Message-Id: <20210111130033.795951550@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
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
index 00c295d3104bb..205c3131f8b05 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3448,17 +3448,24 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
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



