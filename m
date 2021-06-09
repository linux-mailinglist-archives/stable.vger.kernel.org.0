Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4193A1E2E
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 22:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhFIUkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 16:40:36 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:49748 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhFIUkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 16:40:35 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8988840137;
        Wed,  9 Jun 2021 20:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1623271120; bh=x5FZ7s0gV3TtZbTpP8ZsfARwbUhd7+uaV2J4rMMqm00=;
        h=From:To:Cc:Subject:Date:From;
        b=POuVRDtyBlXcMS9O86zOEcpQMRthj9jSEcMlEoy/JCbVnjS8IdDSNMWfwzVZVAJ3F
         QycEpLZDRgdmWyCtD7efSUeHZsJ8Y1ce7VaVsySiFnNuNGbF/IlxXo3/jk9VAfdGpH
         45fyqinxauXZaVeECkP9bC12GaHDQH0ZNxMqWC6jORkic/Kh49DUIq0GU1ahOIi2tm
         nIbHFR6FVT16oiB1egf1t3Ms3FD4fLG+ZPpVIkw68s+h+7p/koTfVdPeTQMNXj33T/
         uQzY4S1z4WrYlMS63hiR01M5yr6UadCztUayftRncFuAx/toKZmO+/usK9yJekDEH7
         bdTnKx8zo6iWA==
Received: from vineetg-Latitude-7400.internal.synopsys.com (snps-fugpbdpduq.internal.synopsys.com [10.202.17.37])
        by mailhost.synopsys.com (Postfix) with ESMTP id 64D4BA005E;
        Wed,  9 Jun 2021 20:38:38 +0000 (UTC)
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     linux-snps-arc@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org,
        Vladimir Isaev <Vladimir.Isaev@synopsys.com>
Subject: [PATCH] ARCv2: save ABI registers across signal handling
Date:   Wed,  9 Jun 2021 13:38:36 -0700
Message-Id: <20210609203836.2213688-1-vgupta@synopsys.com>
X-Mailer: git-send-email 2.25.1
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
Reported-by: Vladimir Isaev <isaev@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/uapi/asm/sigcontext.h |  1 +
 arch/arc/kernel/signal.c               | 29 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

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
index b3ccb9e5ffe4..534b3d9bafc8 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -94,6 +94,21 @@ stash_usr_regs(struct rt_sigframe __user *sf, struct pt_regs *regs,
 
 	err = __copy_to_user(&(sf->uc.uc_mcontext.regs.scratch), &uregs.scratch,
 			     sizeof(sf->uc.uc_mcontext.regs.scratch));
+
+	if (is_isa_arcv2()) {
+		struct user_regs_arcv2 v2abi;
+
+		v2abi.r30 = regs->r30;
+#ifdef CONFIG_ARC_HAS_ACCL_REGS
+		v2abi.r58 = regs->r58;
+		v2abi.r59 = regs->r59;
+#else
+		v2abi.r58 = v2abi.r59 = 0;
+#endif
+		err |= __copy_to_user(&(sf->uc.uc_mcontext.v2abi), &v2abi,
+				      sizeof(sf->uc.uc_mcontext.v2abi));
+	}
+
 	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(sigset_t));
 
 	return err ? -EFAULT : 0;
@@ -109,6 +124,20 @@ static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
 	err |= __copy_from_user(&uregs.scratch,
 				&(sf->uc.uc_mcontext.regs.scratch),
 				sizeof(sf->uc.uc_mcontext.regs.scratch));
+
+	if (is_isa_arcv2()) {
+		struct user_regs_arcv2 v2abi;
+
+		err |= __copy_from_user(&v2abi,	&(sf->uc.uc_mcontext.v2abi),
+					sizeof(sf->uc.uc_mcontext.v2abi));
+
+		regs->r30 = v2abi.r30;
+#ifdef CONFIG_ARC_HAS_ACCL_REGS
+		regs->r58 = v2abi.r58;
+		regs->r59 = v2abi.r59;
+#endif
+	}
+
 	if (err)
 		return -EFAULT;
 
-- 
2.25.1

