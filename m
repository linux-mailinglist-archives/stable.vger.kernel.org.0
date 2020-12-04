Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0A82CF04D
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 16:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgLDPEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 10:04:47 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48004 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgLDPEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 10:04:47 -0500
Date:   Fri, 04 Dec 2020 15:04:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607094243;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WK6yQ0ETpTXOcfcKm3j4ut1/3jj2CRIU3T+yNA2mHnk=;
        b=gIZ7alKs2MLloe+wRlBSiVe7VKp4P9Alnctx4NqAnh/YGp/nlZl8iMkcvmT51f4128OJeQ
        5hau0V9Isz7EZvF0xDPN4UtfHJpXg0m0xjJ2BPsQg3BrSMIToB7X5xGlw4E0FwSyWOWnha
        I6W3oOFIwmaNzZJuI3dY+32ZjefD5O+LFletJLoH2S1XEJ7gJg6BBwNpd01RMbgHSIdcXY
        SAX8s4R/ozr3HbzDK+LOYFzHokqa9FGkc3rR9lyxK6Gc9++QIs58fDYMPBKS2FwwYlA+Kz
        QhjpHWG6XmZqMz3G9doLwWULXK4aFClb40odkzhjEJjlJ+zpXTmqR7BiDekMOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607094243;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WK6yQ0ETpTXOcfcKm3j4ut1/3jj2CRIU3T+yNA2mHnk=;
        b=QyyYHBSVbfckUmR3pJJ8bsr1+HbZtrbVK19RvMZJUrg++oBSZYTtRWem6mvjuwQBMQ4sBI
        BVOmKD5S6zj06zAA==
From:   "tip-bot2 for Masami Hiramatsu" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/uprobes: Do not use prefixes.nbytes when
 looping over prefixes.bytes
Cc:     syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <160697103739.3146288.7437620795200799020.stgit@devnote2>
References: <160697103739.3146288.7437620795200799020.stgit@devnote2>
MIME-Version: 1.0
Message-ID: <160709424307.3364.5849503551045240938.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     9dc23f960adb9ce410ef835b32a2398fdb09c828
Gitweb:        https://git.kernel.org/tip/9dc23f960adb9ce410ef835b32a2398fdb09c828
Author:        Masami Hiramatsu <mhiramat@kernel.org>
AuthorDate:    Thu, 03 Dec 2020 13:50:37 +09:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 04 Dec 2020 14:32:57 +01:00

x86/uprobes: Do not use prefixes.nbytes when looping over prefixes.bytes

Since insn.prefixes.nbytes can be bigger than the size of
insn.prefixes.bytes[] when a prefix is repeated, the proper check must
be

  insn.prefixes.bytes[i] != 0 and i < 4

instead of using insn.prefixes.nbytes.

Introduce a for_each_insn_prefix() macro for this purpose. Debugged by
Kees Cook <keescook@chromium.org>.

 [ bp: Massage commit message, sync with the respective header in tools/
   and drop "we". ]

Fixes: 2b1444983508 ("uprobes, mm, x86: Add the ability to install and remove uprobes breakpoints")
Reported-by: syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/160697103739.3146288.7437620795200799020.stgit@devnote2
---
 arch/x86/include/asm/insn.h       | 15 +++++++++++++++
 arch/x86/kernel/uprobes.c         | 10 ++++++----
 tools/arch/x86/include/asm/insn.h | 17 ++++++++++++++++-
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 5c1ae3e..a8c3d28 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -201,6 +201,21 @@ static inline int insn_offset_immediate(struct insn *insn)
 	return insn_offset_displacement(insn) + insn->displacement.nbytes;
 }
 
+/**
+ * for_each_insn_prefix() -- Iterate prefixes in the instruction
+ * @insn: Pointer to struct insn.
+ * @idx:  Index storage.
+ * @prefix: Prefix byte.
+ *
+ * Iterate prefix bytes of given @insn. Each prefix byte is stored in @prefix
+ * and the index is stored in @idx (note that this @idx is just for a cursor,
+ * do not change it.)
+ * Since prefixes.nbytes can be bigger than 4 if some prefixes
+ * are repeated, it cannot be used for looping over the prefixes.
+ */
+#define for_each_insn_prefix(insn, idx, prefix)	\
+	for (idx = 0; idx < ARRAY_SIZE(insn->prefixes.bytes) && (prefix = insn->prefixes.bytes[idx]) != 0; idx++)
+
 #define POP_SS_OPCODE 0x1f
 #define MOV_SREG_OPCODE 0x8e
 
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 3fdaa04..138bdb1 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -255,12 +255,13 @@ static volatile u32 good_2byte_insns[256 / 32] = {
 
 static bool is_prefix_bad(struct insn *insn)
 {
+	insn_byte_t p;
 	int i;
 
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
+	for_each_insn_prefix(insn, i, p) {
 		insn_attr_t attr;
 
-		attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
+		attr = inat_get_opcode_attribute(p);
 		switch (attr) {
 		case INAT_MAKE_PREFIX(INAT_PFX_ES):
 		case INAT_MAKE_PREFIX(INAT_PFX_CS):
@@ -715,6 +716,7 @@ static const struct uprobe_xol_ops push_xol_ops = {
 static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 opc1 = OPCODE1(insn);
+	insn_byte_t p;
 	int i;
 
 	switch (opc1) {
@@ -746,8 +748,8 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	 * Intel and AMD behavior differ in 64-bit mode: Intel ignores 66 prefix.
 	 * No one uses these insns, reject any branch insns with such prefix.
 	 */
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
-		if (insn->prefixes.bytes[i] == 0x66)
+	for_each_insn_prefix(insn, i, p) {
+		if (p == 0x66)
 			return -ENOTSUPP;
 	}
 
diff --git a/tools/arch/x86/include/asm/insn.h b/tools/arch/x86/include/asm/insn.h
index 568854b..a8c3d28 100644
--- a/tools/arch/x86/include/asm/insn.h
+++ b/tools/arch/x86/include/asm/insn.h
@@ -8,7 +8,7 @@
  */
 
 /* insn_attr_t is defined in inat.h */
-#include "inat.h"
+#include <asm/inat.h>
 
 struct insn_field {
 	union {
@@ -201,6 +201,21 @@ static inline int insn_offset_immediate(struct insn *insn)
 	return insn_offset_displacement(insn) + insn->displacement.nbytes;
 }
 
+/**
+ * for_each_insn_prefix() -- Iterate prefixes in the instruction
+ * @insn: Pointer to struct insn.
+ * @idx:  Index storage.
+ * @prefix: Prefix byte.
+ *
+ * Iterate prefix bytes of given @insn. Each prefix byte is stored in @prefix
+ * and the index is stored in @idx (note that this @idx is just for a cursor,
+ * do not change it.)
+ * Since prefixes.nbytes can be bigger than 4 if some prefixes
+ * are repeated, it cannot be used for looping over the prefixes.
+ */
+#define for_each_insn_prefix(insn, idx, prefix)	\
+	for (idx = 0; idx < ARRAY_SIZE(insn->prefixes.bytes) && (prefix = insn->prefixes.bytes[idx]) != 0; idx++)
+
 #define POP_SS_OPCODE 0x1f
 #define MOV_SREG_OPCODE 0x8e
 
