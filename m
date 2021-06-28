Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769283B5FE5
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhF1OVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232607AbhF1OVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E0F061C76;
        Mon, 28 Jun 2021 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889924;
        bh=W8V2ZZiakS+GRcsZKpC1kctO4lSXpbIs4D3BLLRXLSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msUeyp/Yo+gEflbPglnF7aNSpWOGrH9Q1Ex+OMBNl4rRj9m5/WydVcJpEur+usUil
         Sft5cz9e8xuMz3VItXQ6a8VRk67NyBVAiuJK880vUwoukcx0a5Njmh+YStkCa8ZnOl
         t92BsNIkyfpMcxsDbUUanumDRY7zoi6raMcL635i+ngCCMPvvn+Fm8n31SbiH9fXis
         zsOdS/zGIDutP8+BzRDdr9zfsK2TeCXAT8kIpgZOY0s8tMeze948qjwcCMZEpjpukQ
         rrrp90JM5+QLBikiZspHkTy3rTvC/FeceZ4tGeGV+313NnOojN8qhy4JKLE5Sql2T7
         Ppee00ZklQ3Mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 016/110] x86/xen: Fix noinstr fail in xen_pv_evtchn_do_upcall()
Date:   Mon, 28 Jun 2021 10:16:54 -0400
Message-Id: <20210628141828.31757-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 84e60065df9ef03759115a7e48c04bbc0d292165 ]

Fix:

  vmlinux.o: warning: objtool: xen_pv_evtchn_do_upcall()+0x23: call to irq_enter_rcu() leaves .noinstr.text section

Fixes: 359f01d1816f ("x86/entry: Use run_sysvec_on_irqstack_cond() for XEN upcall")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210621120120.532960208@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index cbe19c87e6be..8767dc53b569 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -266,15 +266,16 @@ __visible noinstr void xen_pv_evtchn_do_upcall(struct pt_regs *regs)
 	irqentry_state_t state = irqentry_enter(regs);
 	bool inhcall;
 
+	instrumentation_begin();
 	run_sysvec_on_irqstack_cond(__xen_pv_evtchn_do_upcall, regs);
 
 	inhcall = get_and_clear_inhcall();
 	if (inhcall && !WARN_ON_ONCE(state.exit_rcu)) {
-		instrumentation_begin();
 		irqentry_exit_cond_resched();
 		instrumentation_end();
 		restore_inhcall(inhcall);
 	} else {
+		instrumentation_end();
 		irqentry_exit(regs, state);
 	}
 }
-- 
2.30.2

