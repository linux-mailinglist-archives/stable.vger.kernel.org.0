Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16F8325ED9
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 09:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhBZIXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 03:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhBZIXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 03:23:09 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E78AC06174A;
        Fri, 26 Feb 2021 00:22:29 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id e9so2890442pjs.2;
        Fri, 26 Feb 2021 00:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lf0RP6AWNkPsAQL2oVEp2TVD1wy1RanwfgCPUOayM4c=;
        b=WKwkhyilQl5a9kG7HMphFNeig60dCMgmpHKLWrlXVfCzatiOlKxm0F021oFRNuVWb/
         kiCIjl95ej7pQJkubLQhPb4OMIbqQEfOFhSdGS2k9ZFy8sMZc5yQ98w1NFGJVGyZGshp
         PXQSDP3brGIDyklcO0uxBtuGFbwiMAmfXOs2cSw8PRQBN5NWikRKG8Ep/OfvTgN0Boua
         NA7Xvvc8B+IB6EnCPy8nPiNaLpz0EJS962UUotRwLPLZvTjbxkkhn1dUv2IQN35GkCpb
         HMnqHTRwXh8Wts2GCH/3QgxKdTPvvpBKpo1s+5T7BkVp1z756HHOTUFRyfZ7btUMdQz1
         +VqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lf0RP6AWNkPsAQL2oVEp2TVD1wy1RanwfgCPUOayM4c=;
        b=KHqe1VzeWEfaQxy7RIIjkNjVg1Wxx0pO1ABYPIwTiN1tTaRFsVHVN/fANCd5BCWGg6
         pYEtbE7PtzmDLObxv/0/awbEXjF128hk7R0YQ2W5J860WBFJkRC6BFSmY6hhe7I2nuHB
         MPPnNpI8MAhYfREc3MH6KfRixml9bmZOG25k/7tQbpodJBG+IvRE58yYKmk7jMpxD26T
         wztqtsi12QU3q1D5ROrSDLj4vDgOAKqLC4Zo76unvA7Zyxza+8xurnk/gO+FL9p3q0d6
         gqzWVe8qnefLoqTzIPY0cXgjID3KXIVlJ1S5E1k8isiobt0iQeHcIqYtjDvibTkL1CWn
         oaQg==
X-Gm-Message-State: AOAM532XPvLDDyOwRfii1MfiRiR4uTNpb79ozV3pmgoCmWlYrsDdRQ39
        3FBCd1vMtvq2ounORd1zO58=
X-Google-Smtp-Source: ABdhPJwmYYiFXfn3Bh/XIs5iYnRmfPWYauleaeHa5rh2vi33lsGkIC+YLcNfpzIC8wr2qDgAcmLIFg==
X-Received: by 2002:a17:90a:df12:: with SMTP id gp18mr2294256pjb.25.1614327748552;
        Fri, 26 Feb 2021 00:22:28 -0800 (PST)
Received: from octofox.hsd1.ca.comcast.net (c-24-130-92-200.hsd1.ca.comcast.net. [24.130.92.200])
        by smtp.gmail.com with ESMTPSA id c6sm9020138pfc.94.2021.02.26.00.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 00:22:27 -0800 (PST)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] xtensa: move coprocessor_flush to the .text section
Date:   Fri, 26 Feb 2021 00:22:19 -0800
Message-Id: <20210226082219.8224-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/xtensa/kernel/coprocessor.S | 64 ++++++++++++++++----------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/arch/xtensa/kernel/coprocessor.S b/arch/xtensa/kernel/coprocessor.S
index c426b846beef..45cc0ae0af6f 100644
--- a/arch/xtensa/kernel/coprocessor.S
+++ b/arch/xtensa/kernel/coprocessor.S
@@ -99,37 +99,6 @@
 	LOAD_CP_REGS_TAB(6)
 	LOAD_CP_REGS_TAB(7)
 
-/*
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
 /*
  * Entry condition:
  *
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
-- 
2.20.1

