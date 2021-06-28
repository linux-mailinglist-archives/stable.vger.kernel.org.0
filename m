Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCBB3B5FE4
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhF1OVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbhF1OVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCFF161C7C;
        Mon, 28 Jun 2021 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889925;
        bh=5rOQupjjZgh47bxS7ksr+TyjzazY8fTSdgFPweGQWH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNewHWrpCigIPibQO9gYTnadjrro3o41KXClBE8zXNNfvGxKyuiYm+RTT4fcOi1Tj
         rCzjGXSQfBuJ3sx2MDb+MnGI4s8aw3i8M4Ir26g+CslOuydC/jIEdYECYPNGo2IsEN
         D6/MbZdvqCwwYNicb/hvlZuvOnWRZV1/90jxHSIR3z0kKlriwOSzHIC/6FcyCFHMiR
         l835ERtyht0o2cKSIn6bdTwRms0ryJxlRxQaYoklPM7SD8u/SVmlRlVJMsLJK0PeaP
         CjKAYih6ORuhsN3Kx+O/IQLx2jmqPNhn7Yng+X+gpfBB157SgpZS6I8Y5deqrHPARW
         vhRzTPgfNv/lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 017/110] x86/xen: Fix noinstr fail in exc_xen_unknown_trap()
Date:   Mon, 28 Jun 2021 10:16:55 -0400
Message-Id: <20210628141828.31757-18-sashal@kernel.org>
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

[ Upstream commit 4c9c26f1e67648f41f28f8c997c5c9467a3dbbe4 ]

Fix:

  vmlinux.o: warning: objtool: exc_xen_unknown_trap()+0x7: call to printk() leaves .noinstr.text section

Fixes: 2e92493637a0 ("x86/xen: avoid warning in Xen pv guest with CONFIG_AMD_MEM_ENCRYPT enabled")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210621120120.606560778@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten_pv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 8183ddb3700c..64db5852432e 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -592,8 +592,10 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
 DEFINE_IDTENTRY_RAW(exc_xen_unknown_trap)
 {
 	/* This should never happen and there is no way to handle it. */
+	instrumentation_begin();
 	pr_err("Unknown trap in Xen PV mode.");
 	BUG();
+	instrumentation_end();
 }
 
 #ifdef CONFIG_X86_MCE
-- 
2.30.2

