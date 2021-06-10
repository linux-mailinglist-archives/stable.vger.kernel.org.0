Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4793A33BE
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 21:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhFJTOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 15:14:17 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:60508 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230117AbhFJTOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 15:14:16 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 003FAC0AE5;
        Thu, 10 Jun 2021 19:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1623352339; bh=7khdIaQtTK1MIOXk3FXEO2cEA11Zp9810SHnpbDPJZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUHwsYR6TvXrg+CISQaPZ9xrmolRCxM+Zou0Jd01wAIiYogg+XWB6Ato+QTFgkYqd
         A9nUT4rZW8JdJOplZYGt6MDyWicNV5efvlermv5xuitdMrPUgK047SYD3+x+M4g2JV
         ZnAoy88i4y7MYV+s6isuAMrLF9BKVJnCODsU5XGZSM0Gh5K0GG7zIkNvxkULBKI2rl
         OKJ0mKG26mPik+bwlLgHBwnsaji3CKJtf0YMck+yBNfj496cjH7LD0c2rGoZiNJHZv
         X4oRE32v8e1+HuClTzdhiht/PFqJwerxi6O0LoONoFo5DQN23w1hT7pJAdcCdqEShq
         ahYJDmTJoiJag==
Received: from vineetg-Latitude-7400.internal.synopsys.com (snps-fugpbdpduq.internal.synopsys.com [10.202.17.37])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7CD70A0072;
        Thu, 10 Jun 2021 19:12:18 +0000 (UTC)
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     linux-snps-arc@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Vladimir Isaev <Vladimir.Isaev@synopsys.com>
Subject: [PATCH v2] ARCv2: save ABI registers across signal handling
Date:   Thu, 10 Jun 2021 12:12:16 -0700
Message-Id: <20210610191216.2936035-1-vgupta@synopsys.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <202106101254.80jqhB9j-lkp@intel.com>
References: <202106101254.80jqhB9j-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index b3ccb9e5ffe4..cb2f88502baf 100644
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
@@ -94,6 +129,10 @@ stash_usr_regs(struct rt_sigframe __user *sf, struct pt_regs *regs,
 
 	err = __copy_to_user(&(sf->uc.uc_mcontext.regs.scratch), &uregs.scratch,
 			     sizeof(sf->uc.uc_mcontext.regs.scratch));
+
+	if (is_isa_arcv2())
+		err |= save_arcv2_regs(&(sf->uc.uc_mcontext), regs);
+
 	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(sigset_t));
 
 	return err ? -EFAULT : 0;
@@ -109,6 +148,10 @@ static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
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
2.25.1

