Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D653B6363
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhF1O4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235447AbhF1OwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:52:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61B2E61CA0;
        Mon, 28 Jun 2021 14:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891036;
        bh=AMRNq82L8/VQmA8YXlo0+swCoNiRblO7beLYo6e9MzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YD3VwulqNBEUZrw+sF+ohVDONywBbnv7XGoG4tagp+pt9qE1HWeLMIo/lkgZHNuz9
         Um77OFdpyDciOdBBmbmpwCDRx3vXPTTyr/viSNYbRuTaStyUuMyJLjGreLUy+TC1+7
         ZREReKNACwN2ujHX5kKHc6MnBcKoyvxlcDkorLJoDE3GXpaa0hjHLfn02YaPMEHXMJ
         MeTFsX06frhcD81V5rYcZNjudieXhK7zLiqBdBHU4ki2UNXHkxIbqZeCwrMt1b+Q/N
         XsLK3/1iCebaOva4KR9/nEOKlbcAy7mhLQvD+vGbLs4hex/10yF/G/s1obynUjsnS2
         P3g6aBij6VcSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        kernel test robot <lkp@intel.com>,
        Vladimir Isaev <isaev@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 53/88] ARCv2: save ABI registers across signal handling
Date:   Mon, 28 Jun 2021 10:35:53 -0400
Message-Id: <20210628143628.33342-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

commit 96f1b00138cb8f04c742c82d0a7c460b2202e887 upstream.

ARCv2 has some configuration dependent registers (r30, r58, r59) which
could be targetted by the compiler. To keep the ABI stable, these were
unconditionally part of the glibc ABI
(sysdeps/unix/sysv/linux/arc/sys/ucontext.h:mcontext_t) however we
missed populating them (by saving/restoring them across signal
handling).

This patch fixes the issue by
 - adding arcv2 ABI regs to kernel struct sigcontext
 - populating them during signal handling

Change to struct sigcontext might seem like a glibc ABI change (although
it primarily uses ucontext_t:mcontext_t) but the fact is
 - it has only been extended (existing fields are not touched)
 - the old sigcontext was ABI incomplete to begin with anyways

Fixes: https://github.com/foss-for-synopsys-dwc-arc-processors/linux/issues/53
Cc: <stable@vger.kernel.org>
Tested-by: kernel test robot <lkp@intel.com>
Reported-by: Vladimir Isaev <isaev@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/include/uapi/asm/sigcontext.h |  1 +
 arch/arc/kernel/signal.c               | 43 ++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/arc/include/uapi/asm/sigcontext.h b/arch/arc/include/uapi/asm/sigcontext.h
index 95f8a4380e11..7a5449dfcb29 100644
--- a/arch/arc/include/uapi/asm/sigcontext.h
+++ b/arch/arc/include/uapi/asm/sigcontext.h
@@ -18,6 +18,7 @@
  */
 struct sigcontext {
 	struct user_regs_struct regs;
+	struct user_regs_arcv2 v2abi;
 };
 
 #endif /* _ASM_ARC_SIGCONTEXT_H */
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index da243420bcb5..68901f6f18ba 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -64,6 +64,41 @@ struct rt_sigframe {
 	unsigned int sigret_magic;
 };
 
+static int save_arcv2_regs(struct sigcontext *mctx, struct pt_regs *regs)
+{
+	int err = 0;
+#ifndef CONFIG_ISA_ARCOMPACT
+	struct user_regs_arcv2 v2abi;
+
+	v2abi.r30 = regs->r30;
+#ifdef CONFIG_ARC_HAS_ACCL_REGS
+	v2abi.r58 = regs->r58;
+	v2abi.r59 = regs->r59;
+#else
+	v2abi.r58 = v2abi.r59 = 0;
+#endif
+	err = __copy_to_user(&mctx->v2abi, &v2abi, sizeof(v2abi));
+#endif
+	return err;
+}
+
+static int restore_arcv2_regs(struct sigcontext *mctx, struct pt_regs *regs)
+{
+	int err = 0;
+#ifndef CONFIG_ISA_ARCOMPACT
+	struct user_regs_arcv2 v2abi;
+
+	err = __copy_from_user(&v2abi, &mctx->v2abi, sizeof(v2abi));
+
+	regs->r30 = v2abi.r30;
+#ifdef CONFIG_ARC_HAS_ACCL_REGS
+	regs->r58 = v2abi.r58;
+	regs->r59 = v2abi.r59;
+#endif
+#endif
+	return err;
+}
+
 static int
 stash_usr_regs(struct rt_sigframe __user *sf, struct pt_regs *regs,
 	       sigset_t *set)
@@ -97,6 +132,10 @@ stash_usr_regs(struct rt_sigframe __user *sf, struct pt_regs *regs,
 
 	err = __copy_to_user(&(sf->uc.uc_mcontext.regs.scratch), &uregs.scratch,
 			     sizeof(sf->uc.uc_mcontext.regs.scratch));
+
+	if (is_isa_arcv2())
+		err |= save_arcv2_regs(&(sf->uc.uc_mcontext), regs);
+
 	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(sigset_t));
 
 	return err ? -EFAULT : 0;
@@ -112,6 +151,10 @@ static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
 	err |= __copy_from_user(&uregs.scratch,
 				&(sf->uc.uc_mcontext.regs.scratch),
 				sizeof(sf->uc.uc_mcontext.regs.scratch));
+
+	if (is_isa_arcv2())
+		err |= restore_arcv2_regs(&(sf->uc.uc_mcontext), regs);
+
 	if (err)
 		return -EFAULT;
 
-- 
2.30.2

