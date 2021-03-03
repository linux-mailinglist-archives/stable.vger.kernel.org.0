Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25EF32C812
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbhCDAdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:33:49 -0500
Received: from 8bytes.org ([81.169.241.247]:57472 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348829AbhCCOSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 09:18:36 -0500
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 1E31D48E;
        Wed,  3 Mar 2021 15:17:25 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 5/5] x86/sev-es: Use __copy_from_user_inatomic()
Date:   Wed,  3 Mar 2021 15:17:16 +0100
Message-Id: <20210303141716.29223-6-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210303141716.29223-1-joro@8bytes.org>
References: <20210303141716.29223-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The #VC handler must run atomic and can not be put to sleep. This is a
problem when it tries to fetch instruction bytes from user-space via
copy_from_user.

Introduce a insn_fetch_from_user_inatomic() helper which uses
__copy_from_user_inatomic() to safely copy the instruction bytes to
kernel memory in the #VC handler.

Fixes: 5e3427a7bc432 ("x86/sev-es: Handle instruction fetches from user-space")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/insn-eval.h |  2 +
 arch/x86/kernel/sev-es.c         |  2 +-
 arch/x86/lib/insn-eval.c         | 66 +++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index a0f839aa144d..98b4dae5e8bc 100644
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
index 3d8ec5bf6f79..26f5479a97a8 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -270,7 +270,7 @@ static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
 	int res;
 
 	if (user_mode(ctxt->regs)) {
-		res = insn_fetch_from_user(ctxt->regs, buffer);
+		res = insn_fetch_from_user_inatomic(ctxt->regs, buffer);
 		if (!res) {
 			ctxt->fi.vector     = X86_TRAP_PF;
 			ctxt->fi.error_code = X86_PF_INSTR | X86_PF_USER;
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index 4229950a5d78..bb0b3fe1e0a0 100644
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
-- 
2.30.1

