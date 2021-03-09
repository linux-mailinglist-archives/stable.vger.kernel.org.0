Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2B6332B8D
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 17:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhCIQIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 11:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbhCIQIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 11:08:14 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9FDC06174A;
        Tue,  9 Mar 2021 08:08:14 -0800 (PST)
Date:   Tue, 09 Mar 2021 16:08:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615306092;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4oKnzr0uBAmthc+mtFDYGBTY0n/S6HSbqDR1yGD74oY=;
        b=E32sU3XROmMExlWeHSLp022qB060dzbpQ2hKTHfWC4/ky/IiyauXBi1HyWHAdUo/EtMKXq
        1if2zhQ5XqpxI39k4U3wAWQhn/7qhORCCawRvakRADxVb9PhiicdZLMQ2ySosDwcc2mGhC
        XGm1mx4KJx9yHo/hy6girMA0bEiDIdaEiEStva1A5fxuRZOoPonprlLd8NKwzv4hkLipRB
        +1Db2tp0LIQ0TGP0EJ9sxbTKmA+b28PuM9Ah752MTL38EGoM2HjKPDheYnBb7Pha1Es54d
        nGd6x83pz+pSdqGkWxZE/LPPZCuEmjtYyKGH8FE10zTzE9z5dWm3hJuJxCIrVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615306092;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4oKnzr0uBAmthc+mtFDYGBTY0n/S6HSbqDR1yGD74oY=;
        b=RRKMEb8olJYcGa3jgLm9BHDX50w40whIN+oy0DZW2+jjwrMwst1ZEnwJvYYC873ME5aDkJ
        UFueFuQkQjzREEDw==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev-es: Use __copy_from_user_inatomic()
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v5.10+@tip-bot2.tec.linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210303141716.29223-6-joro@8bytes.org>
References: <20210303141716.29223-6-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <161530609145.398.11788933296819355210.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     bffe30dd9f1f3b2608a87ac909a224d6be472485
Gitweb:        https://git.kernel.org/tip/bffe30dd9f1f3b2608a87ac909a224d6be472485
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Wed, 03 Mar 2021 15:17:16 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 09 Mar 2021 12:37:54 +01:00

x86/sev-es: Use __copy_from_user_inatomic()

The #VC handler must run in atomic context and cannot sleep. This is a
problem when it tries to fetch instruction bytes from user-space via
copy_from_user().

Introduce a insn_fetch_from_user_inatomic() helper which uses
__copy_from_user_inatomic() to safely copy the instruction bytes to
kernel memory in the #VC handler.

Fixes: 5e3427a7bc432 ("x86/sev-es: Handle instruction fetches from user-space")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v5.10+
Link: https://lkml.kernel.org/r/20210303141716.29223-6-joro@8bytes.org
---
 arch/x86/include/asm/insn-eval.h |  2 +-
 arch/x86/kernel/sev-es.c         |  2 +-
 arch/x86/lib/insn-eval.c         | 66 ++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index a0f839a..98b4dae 100644
--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -23,6 +23,8 @@ unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx);
 int insn_get_code_seg_params(struct pt_regs *regs);
 int insn_fetch_from_user(struct pt_regs *regs,
 			 unsigned char buf[MAX_INSN_SIZE]);
+int insn_fetch_from_user_inatomic(struct pt_regs *regs,
+				  unsigned char buf[MAX_INSN_SIZE]);
 bool insn_decode(struct insn *insn, struct pt_regs *regs,
 		 unsigned char buf[MAX_INSN_SIZE], int buf_size);
 
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index c3fd8fa..04a780a 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -258,7 +258,7 @@ static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
 	int res;
 
 	if (user_mode(ctxt->regs)) {
-		res = insn_fetch_from_user(ctxt->regs, buffer);
+		res = insn_fetch_from_user_inatomic(ctxt->regs, buffer);
 		if (!res) {
 			ctxt->fi.vector     = X86_TRAP_PF;
 			ctxt->fi.error_code = X86_PF_INSTR | X86_PF_USER;
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index 4229950..bb0b3fe 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1415,6 +1415,25 @@ void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs)
 	}
 }
 
+static unsigned long insn_get_effective_ip(struct pt_regs *regs)
+{
+	unsigned long seg_base = 0;
+
+	/*
+	 * If not in user-space long mode, a custom code segment could be in
+	 * use. This is true in protected mode (if the process defined a local
+	 * descriptor table), or virtual-8086 mode. In most of the cases
+	 * seg_base will be zero as in USER_CS.
+	 */
+	if (!user_64bit_mode(regs)) {
+		seg_base = insn_get_seg_base(regs, INAT_SEG_REG_CS);
+		if (seg_base == -1L)
+			return 0;
+	}
+
+	return seg_base + regs->ip;
+}
+
 /**
  * insn_fetch_from_user() - Copy instruction bytes from user-space memory
  * @regs:	Structure with register values as seen when entering kernel mode
@@ -1431,24 +1450,43 @@ void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs)
  */
 int insn_fetch_from_user(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
 {
-	unsigned long seg_base = 0;
+	unsigned long ip;
 	int not_copied;
 
-	/*
-	 * If not in user-space long mode, a custom code segment could be in
-	 * use. This is true in protected mode (if the process defined a local
-	 * descriptor table), or virtual-8086 mode. In most of the cases
-	 * seg_base will be zero as in USER_CS.
-	 */
-	if (!user_64bit_mode(regs)) {
-		seg_base = insn_get_seg_base(regs, INAT_SEG_REG_CS);
-		if (seg_base == -1L)
-			return 0;
-	}
+	ip = insn_get_effective_ip(regs);
+	if (!ip)
+		return 0;
+
+	not_copied = copy_from_user(buf, (void __user *)ip, MAX_INSN_SIZE);
 
+	return MAX_INSN_SIZE - not_copied;
+}
+
+/**
+ * insn_fetch_from_user_inatomic() - Copy instruction bytes from user-space memory
+ *                                   while in atomic code
+ * @regs:	Structure with register values as seen when entering kernel mode
+ * @buf:	Array to store the fetched instruction
+ *
+ * Gets the linear address of the instruction and copies the instruction bytes
+ * to the buf. This function must be used in atomic context.
+ *
+ * Returns:
+ *
+ * Number of instruction bytes copied.
+ *
+ * 0 if nothing was copied.
+ */
+int insn_fetch_from_user_inatomic(struct pt_regs *regs, unsigned char buf[MAX_INSN_SIZE])
+{
+	unsigned long ip;
+	int not_copied;
+
+	ip = insn_get_effective_ip(regs);
+	if (!ip)
+		return 0;
 
-	not_copied = copy_from_user(buf, (void __user *)(seg_base + regs->ip),
-				    MAX_INSN_SIZE);
+	not_copied = __copy_from_user_inatomic(buf, (void __user *)ip, MAX_INSN_SIZE);
 
 	return MAX_INSN_SIZE - not_copied;
 }
