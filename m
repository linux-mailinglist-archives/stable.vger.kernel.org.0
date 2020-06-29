Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA6D20E854
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404739AbgF2WFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgF2SfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C5AF24757;
        Mon, 29 Jun 2020 15:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444072;
        bh=ez/Xza8UAdQdL+cOs3YfVkwIynKjFgX2omR/0GaZb1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUWMbIW/UDbfVVPtABk1o0h2ntRkuehxdxEs+2ao8/uOlGI8BC2vEt8Tr8WTCTdk1
         lw+/llLhLVRWKc7gVGZZWj6heq0Wy9Q8NMH+JhOO3ts7ZgIamvZMNMGL0kg8WDXbye
         JaXZv32ZEoYfkHKyb9xvaL5cxqe+6rjJMHZ/zOXg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        kernel test robot <rong.a.chen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 181/265] sched/cfs: change initial value of runnable_avg
Date:   Mon, 29 Jun 2020 11:16:54 -0400
Message-Id: <20200629151818.2493727-182-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit e21cf43406a190adfcc4bfe592768066fb3aaa9b ]

Some performance regression on reaim benchmark have been raised with
  commit 070f5e860ee2 ("sched/fair: Take into account runnable_avg to classify group")

The problem comes from the init value of runnable_avg which is initialized
with max value. This can be a problem if the newly forked task is finally
a short task because the group of CPUs is wrongly set to overloaded and
tasks are pulled less agressively.

Set initial value of runnable_avg equals to util_avg to reflect that there
is no waiting time so far.

Fixes: 070f5e860ee2 ("sched/fair: Take into account runnable_avg to classify group")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200624154422.29166-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2ae7e30ccb33c..5725199b32dcf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -807,7 +807,7 @@ void post_init_entity_util_avg(struct task_struct *p)
 		}
 	}
 
-	sa->runnable_avg = cpu_scale;
+	sa->runnable_avg = sa->util_avg;
 
 	if (p->sched_class != &fair_sched_class) {
 		/*
-- 
2.25.1

