Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D4320C67
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfEPP6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42338 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726441AbfEPP6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0006ym-Uw; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001Ms-Gm; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.735418432@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 07/86] s390/jump label: use different nop instruction
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit d5caa4dbf9bd2ad8cd7f6be0ca76722be947182b upstream.

Use a brcl 0,2 instruction for jump label nops during compile time,
so we don't mix up the different nops during mcount/hotpatch call
site detection.
The initial jump label code instruction replacement will exchange
these instructions with either a branch or a brcl 0,0 instruction.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/include/asm/jump_label.h |  7 ++++++-
 arch/s390/kernel/jump_label.c      | 19 +++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 
 #define JUMP_LABEL_NOP_SIZE 6
+#define JUMP_LABEL_NOP_OFFSET 2
 
 #ifdef CONFIG_64BIT
 #define ASM_PTR ".quad"
@@ -13,9 +14,13 @@
 #define ASM_ALIGN ".balign 4"
 #endif
 
+/*
+ * We use a brcl 0,2 instruction for jump labels at compile time so it
+ * can be easily distinguished from a hotpatch generated instruction.
+ */
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm_volatile_goto("0:	brcl 0,0\n"
+	asm_volatile_goto("0:	brcl 0,"__stringify(JUMP_LABEL_NOP_OFFSET)"\n"
 		".pushsection __jump_table, \"aw\"\n"
 		ASM_ALIGN "\n"
 		ASM_PTR " 0b, %l[label], %0\n"
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -49,6 +49,11 @@ static void jump_label_bug(struct jump_e
 	panic("Corrupted kernel text");
 }
 
+static struct insn orignop = {
+	.opcode = 0xc004,
+	.offset = JUMP_LABEL_NOP_OFFSET >> 1,
+};
+
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
 				   int init)
@@ -59,14 +64,16 @@ static void __jump_label_transform(struc
 		jump_label_make_nop(entry, &old);
 		jump_label_make_branch(entry, &new);
 	} else {
-		if (init)
-			jump_label_make_nop(entry, &old);
-		else
-			jump_label_make_branch(entry, &old);
+		jump_label_make_branch(entry, &old);
 		jump_label_make_nop(entry, &new);
 	}
-	if (memcmp((void *)entry->code, &old, sizeof(old)))
-		jump_label_bug(entry, &old);
+	if (init) {
+		if (memcmp((void *)entry->code, &orignop, sizeof(orignop)))
+			jump_label_bug(entry, &old);
+	} else {
+		if (memcmp((void *)entry->code, &old, sizeof(old)))
+			jump_label_bug(entry, &old);
+	}
 	probe_kernel_write((void *)entry->code, &new, sizeof(new));
 }
 

