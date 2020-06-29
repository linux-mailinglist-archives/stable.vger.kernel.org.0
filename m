Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2E620E6B3
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391504AbgF2Vtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgF2Sfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA06524752;
        Mon, 29 Jun 2020 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444070;
        bh=aOH9HybceEhdkBw2hpKtir49HQep7EQFMRd25mjVXiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIZt2jUcj0E/+a4ybtnSfzMktb2DMOxIcujdw4OY82wirY9rYjFytyvJxtYVbXWBd
         LiE5g211hMbDu2m3EdmTXwfFjdnU25pwdbF7i9bI6IJMTIqx1MCFKnvV32fVZgaEeT
         Rngp4pIeR2Mwu7G/dE6xP2c4PJ/gvPkxTAE0vjpU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        syzbot+5ac8bac25f95e8b221e7@syzkaller.appspotmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Wagner <dwagner@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 179/265] sched/deadline: Initialize ->dl_boosted
Date:   Mon, 29 Jun 2020 11:16:52 -0400
Message-Id: <20200629151818.2493727-180-sashal@kernel.org>
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

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit ce9bc3b27f2a21a7969b41ffb04df8cf61bd1592 ]

syzbot reported the following warning triggered via SYSC_sched_setattr():

  WARNING: CPU: 0 PID: 6973 at kernel/sched/deadline.c:593 setup_new_dl_entity /kernel/sched/deadline.c:594 [inline]
  WARNING: CPU: 0 PID: 6973 at kernel/sched/deadline.c:593 enqueue_dl_entity /kernel/sched/deadline.c:1370 [inline]
  WARNING: CPU: 0 PID: 6973 at kernel/sched/deadline.c:593 enqueue_task_dl+0x1c17/0x2ba0 /kernel/sched/deadline.c:1441

This happens because the ->dl_boosted flag is currently not initialized by
__dl_clear_params() (unlike the other flags) and setup_new_dl_entity()
rightfully complains about it.

Initialize dl_boosted to 0.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Reported-by: syzbot+5ac8bac25f95e8b221e7@syzkaller.appspotmail.com
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Daniel Wagner <dwagner@suse.de>
Link: https://lkml.kernel.org/r/20200617072919.818409-1-juri.lelli@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 504d2f51b0d63..f63f337c7147a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2692,6 +2692,7 @@ void __dl_clear_params(struct task_struct *p)
 	dl_se->dl_bw			= 0;
 	dl_se->dl_density		= 0;
 
+	dl_se->dl_boosted		= 0;
 	dl_se->dl_throttled		= 0;
 	dl_se->dl_yielded		= 0;
 	dl_se->dl_non_contending	= 0;
-- 
2.25.1

