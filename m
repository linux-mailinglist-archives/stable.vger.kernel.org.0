Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA8E33BAB4
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhCOOKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234643AbhCOOEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4E5C64EF9;
        Mon, 15 Mar 2021 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817081;
        bh=YLrLZWd9bqysywbk0zeXsYYl+s/6QqVWmtVC29uteLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyBl4bqlgFhFgfSLcXu9snBJf1wOgYAX6ziX1Oww7RFBB6dgCij1mFh4MgBjzBMIb
         BikY6fgLAkt7sRiK16JHGL6B4VefllYtlCyurmHOWKFE0COBvN1OUrv/pu6iYH6QjI
         UN/tVEbatZAiF4HB8k8X0bRFqWaa3JvC8kDZWDw0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.11 290/306] x86/sev-es: Use __copy_from_user_inatomic()
Date:   Mon, 15 Mar 2021 14:55:53 +0100
Message-Id: <20210315135517.488727059@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joerg Roedel <jroedel@suse.de>

commit bffe30dd9f1f3b2608a87ac909a224d6be472485 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/insn-eval.h |    2 +
 arch/x86/kernel/sev-es.c         |    2 -
 arch/x86/lib/insn-eval.c         |   66 ++++++++++++++++++++++++++++++---------
 3 files changed, 55 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -23,6 +23,8 @@ unsigned long insn_get_seg_base(struct p
 int insn_get_code_seg_params(struct pt_regs *regs);
 int insn_fetch_from_user(struct pt_regs *regs,
 			 unsigned char buf[MAX_INSN_SIZE]);
+int insn_fetch_from_user_inatomic(struct pt_regs *regs,
+				  unsigned char buf[MAX_INSN_SIZE]);
 bool insn_decode(struct insn *insn, struct pt_regs *regs,
 		 unsigned char buf[MAX_INSN_SIZE], int buf_size);
 
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -258,7 +258,7 @@ static enum es_result vc_decode_insn(str
 	int res;
 
 	if (user_mode(ctxt->regs)) {
-		res = insn_fetch_from_user(ctxt->regs, buffer);
+		res = insn_fetch_from_user_inatomic(ctxt->regs, buffer);
 		if (!res) {
 			ctxt->fi.vector     = X86_TRAP_PF;
 			ctxt->fi.error_code = X86_PF_INSTR | X86_PF_USER;
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1415,6 +1415,25 @@ void __user *insn_get_addr_ref(struct in
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
@@ -1431,24 +1450,43 @@ void __user *insn_get_addr_ref(struct in
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
+
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
 
+	ip = insn_get_effective_ip(regs);
+	if (!ip)
+		return 0;
 
-	not_copied = copy_from_user(buf, (void __user *)(seg_base + regs->ip),
-				    MAX_INSN_SIZE);
+	not_copied = __copy_from_user_inatomic(buf, (void __user *)ip, MAX_INSN_SIZE);
 
 	return MAX_INSN_SIZE - not_copied;
 }


