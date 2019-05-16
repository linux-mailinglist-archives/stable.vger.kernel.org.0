Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBD920C64
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfEPP6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42340 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbfEPP6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0006yl-Us; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001Mk-Fa; Thu, 16 May 2019 16:58:36 +0100
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
Message-ID: <lsq.1558022132.722749453@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 06/86] s390/jump label: add sanity checks
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

commit 5c6497c50f8d809eac6d01512c291a1f67382abd upstream.

Add sanity checks to verify that only expected code will be replaced.
If the code patterns do not match print the code patterns and panic,
since something went terribly wrong.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/kernel/jump_label.c | 56 ++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 14 deletions(-)

--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -22,31 +22,59 @@ struct insn_args {
 	enum jump_label_type type;
 };
 
+static void jump_label_make_nop(struct jump_entry *entry, struct insn *insn)
+{
+	/* brcl 0,0 */
+	insn->opcode = 0xc004;
+	insn->offset = 0;
+}
+
+static void jump_label_make_branch(struct jump_entry *entry, struct insn *insn)
+{
+	/* brcl 15,offset */
+	insn->opcode = 0xc0f4;
+	insn->offset = (entry->target - entry->code) >> 1;
+}
+
+static void jump_label_bug(struct jump_entry *entry, struct insn *insn)
+{
+	unsigned char *ipc = (unsigned char *)entry->code;
+	unsigned char *ipe = (unsigned char *)insn;
+
+	pr_emerg("Jump label code mismatch at %pS [%p]\n", ipc, ipc);
+	pr_emerg("Found:    %02x %02x %02x %02x %02x %02x\n",
+		 ipc[0], ipc[1], ipc[2], ipc[3], ipc[4], ipc[5]);
+	pr_emerg("Expected: %02x %02x %02x %02x %02x %02x\n",
+		 ipe[0], ipe[1], ipe[2], ipe[3], ipe[4], ipe[5]);
+	panic("Corrupted kernel text");
+}
+
 static void __jump_label_transform(struct jump_entry *entry,
-				   enum jump_label_type type)
+				   enum jump_label_type type,
+				   int init)
 {
-	struct insn insn;
-	int rc;
+	struct insn old, new;
 
 	if (type == JUMP_LABEL_ENABLE) {
-		/* brcl 15,offset */
-		insn.opcode = 0xc0f4;
-		insn.offset = (entry->target - entry->code) >> 1;
+		jump_label_make_nop(entry, &old);
+		jump_label_make_branch(entry, &new);
 	} else {
-		/* brcl 0,0 */
-		insn.opcode = 0xc004;
-		insn.offset = 0;
+		if (init)
+			jump_label_make_nop(entry, &old);
+		else
+			jump_label_make_branch(entry, &old);
+		jump_label_make_nop(entry, &new);
 	}
-
-	rc = probe_kernel_write((void *)entry->code, &insn, JUMP_LABEL_NOP_SIZE);
-	WARN_ON_ONCE(rc < 0);
+	if (memcmp((void *)entry->code, &old, sizeof(old)))
+		jump_label_bug(entry, &old);
+	probe_kernel_write((void *)entry->code, &new, sizeof(new));
 }
 
 static int __sm_arch_jump_label_transform(void *data)
 {
 	struct insn_args *args = data;
 
-	__jump_label_transform(args->entry, args->type);
+	__jump_label_transform(args->entry, args->type, 0);
 	return 0;
 }
 
@@ -64,7 +92,7 @@ void arch_jump_label_transform(struct ju
 void arch_jump_label_transform_static(struct jump_entry *entry,
 				      enum jump_label_type type)
 {
-	__jump_label_transform(entry, type);
+	__jump_label_transform(entry, type, 1);
 }
 
 #endif

