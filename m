Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A8F3AF085
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhFUQuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232115AbhFUQrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 847746141A;
        Mon, 21 Jun 2021 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293209;
        bh=jypisFtS2T5AuEse6LX+tOnwzhhUTeKbeHc8WA6noSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8bN0d5cdN+OZgxcl4gZDzVikfgfKygoiXsc4m4gBLscRFgbnb0s67NUC2jaTnsq8
         HK13H9Rh+ijpWXphBdewsBmOFcLuYQyJ/kQQJmJ2Ilv2pll9yyGoPoa0Hex8th8rbO
         jxcCGH2SAxMvxaOryuUaFlMVO9x9vjTRVAwoslk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Vladimir Isaev <isaev@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.12 139/178] ARCv2: save ABI registers across signal handling
Date:   Mon, 21 Jun 2021 18:15:53 +0200
Message-Id: <20210621154927.503421315@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/arc/include/uapi/asm/sigcontext.h |    1 
 arch/arc/kernel/signal.c               |   43 +++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

--- a/arch/arc/include/uapi/asm/sigcontext.h
+++ b/arch/arc/include/uapi/asm/sigcontext.h
@@ -18,6 +18,7 @@
  */
 struct sigcontext {
 	struct user_regs_struct regs;
+	struct user_regs_arcv2 v2abi;
 };
 
 #endif /* _ASM_ARC_SIGCONTEXT_H */
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -61,6 +61,41 @@ struct rt_sigframe {
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
@@ -94,6 +129,10 @@ stash_usr_regs(struct rt_sigframe __user
 
 	err = __copy_to_user(&(sf->uc.uc_mcontext.regs.scratch), &uregs.scratch,
 			     sizeof(sf->uc.uc_mcontext.regs.scratch));
+
+	if (is_isa_arcv2())
+		err |= save_arcv2_regs(&(sf->uc.uc_mcontext), regs);
+
 	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(sigset_t));
 
 	return err ? -EFAULT : 0;
@@ -109,6 +148,10 @@ static int restore_usr_regs(struct pt_re
 	err |= __copy_from_user(&uregs.scratch,
 				&(sf->uc.uc_mcontext.regs.scratch),
 				sizeof(sf->uc.uc_mcontext.regs.scratch));
+
+	if (is_isa_arcv2())
+		err |= restore_arcv2_regs(&(sf->uc.uc_mcontext), regs);
+
 	if (err)
 		return -EFAULT;
 


