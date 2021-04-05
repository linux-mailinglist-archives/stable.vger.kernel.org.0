Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF228354014
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbhDEJPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240150AbhDEJOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:14:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26DEA611C1;
        Mon,  5 Apr 2021 09:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614083;
        bh=VmbfD/sW3PbcnzlK0CAiDiO0oijK/xUFWNYbsKk/sX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXwJ4abRGKlRaB9kVwBtoWWW6D1XSqJ5HBG8StmQB0W+G3R13bETYuIgrEsYptrN3
         zgLXeBfKQXPHCuJ/eJgYRpSjQePnza130V1gtt/o6Md8HCgrhOiD266rsKmd9wzaNb
         bwjbQ2coHztuZstFFd5kePA+jOt2rD/o2pz7040E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.11 078/152] xtensa: move coprocessor_flush to the .text section
Date:   Mon,  5 Apr 2021 10:53:47 +0200
Message-Id: <20210405085036.796747972@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit ab5eb336411f18fd449a1fb37d36a55ec422603f upstream.

coprocessor_flush is not a part of fast exception handlers, but it uses
parts of fast coprocessor handling code that's why it's in the same
source file. It uses call0 opcode to invoke those parts so there are no
limitations on their relative location, but the rest of the code calls
coprocessor_flush with call8 and that doesn't work when vectors are
placed in a different gigabyte-aligned area than the rest of the kernel.

Move coprocessor_flush from the .exception.text section to the .text so
that it's reachable from the rest of the kernel with call8.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/coprocessor.S |   64 ++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

--- a/arch/xtensa/kernel/coprocessor.S
+++ b/arch/xtensa/kernel/coprocessor.S
@@ -100,37 +100,6 @@
 	LOAD_CP_REGS_TAB(7)
 
 /*
- * coprocessor_flush(struct thread_info*, index)
- *                             a2        a3
- *
- * Save coprocessor registers for coprocessor 'index'.
- * The register values are saved to or loaded from the coprocessor area 
- * inside the task_info structure.
- *
- * Note that this function doesn't update the coprocessor_owner information!
- *
- */
-
-ENTRY(coprocessor_flush)
-
-	/* reserve 4 bytes on stack to save a0 */
-	abi_entry(4)
-
-	s32i	a0, a1, 0
-	movi	a0, .Lsave_cp_regs_jump_table
-	addx8	a3, a3, a0
-	l32i	a4, a3, 4
-	l32i	a3, a3, 0
-	add	a2, a2, a4
-	beqz	a3, 1f
-	callx0	a3
-1:	l32i	a0, a1, 0
-
-	abi_ret(4)
-
-ENDPROC(coprocessor_flush)
-
-/*
  * Entry condition:
  *
  *   a0:	trashed, original value saved on stack (PT_AREG0)
@@ -245,6 +214,39 @@ ENTRY(fast_coprocessor)
 
 ENDPROC(fast_coprocessor)
 
+	.text
+
+/*
+ * coprocessor_flush(struct thread_info*, index)
+ *                             a2        a3
+ *
+ * Save coprocessor registers for coprocessor 'index'.
+ * The register values are saved to or loaded from the coprocessor area
+ * inside the task_info structure.
+ *
+ * Note that this function doesn't update the coprocessor_owner information!
+ *
+ */
+
+ENTRY(coprocessor_flush)
+
+	/* reserve 4 bytes on stack to save a0 */
+	abi_entry(4)
+
+	s32i	a0, a1, 0
+	movi	a0, .Lsave_cp_regs_jump_table
+	addx8	a3, a3, a0
+	l32i	a4, a3, 4
+	l32i	a3, a3, 0
+	add	a2, a2, a4
+	beqz	a3, 1f
+	callx0	a3
+1:	l32i	a0, a1, 0
+
+	abi_ret(4)
+
+ENDPROC(coprocessor_flush)
+
 	.data
 
 ENTRY(coprocessor_owner)


