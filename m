Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3C2234CD8
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 23:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgGaVUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 17:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgGaVUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 17:20:32 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D98C061574;
        Fri, 31 Jul 2020 14:20:32 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l2so8741869pff.0;
        Fri, 31 Jul 2020 14:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6huKTddjtAjrZ/iwRFjM+2AULsbiPYjTMrOwzG3sgfE=;
        b=BREcwqEOTjsBQUAipx7bV4+HTi3foe1OxegRgGmMPapX6mED1n8qS4/3saXXj37b7p
         SP+YUhZnEeCjWCg32Wl2s/yI976/UAJ+kosL4yPJQr6WccuTRjUpgZ3Ng3r3BKM9eFZi
         alYcmW84eGjNXIbTdK7KxmmMxhFKBSJCmg+X0SgRf56Wata50NZ8CSlrOk+1v+rg2vB+
         zNnuXQvBwHMqt+GhGeKOOCc+4HSc6kxabBhJkzbOXQY5toHO59xSx8Js6lFHJND7LIlO
         b3iavsrfBQs07BTrlOd4iAKOsFj1webFzeLx6alFaR7NydCNZnXIOHttxk19q/H7jMuU
         cqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6huKTddjtAjrZ/iwRFjM+2AULsbiPYjTMrOwzG3sgfE=;
        b=rmQo2yz4Mkyu80Fg4Qx/s0ILnpuccT1ralSmRyd4JVRuMoigUElri34ikYw1RY7E2l
         iqSmMTgS11liuOqVU3zGSdpGOqUk+c49OD/lBZcNtG+ilc9zhvzKuDqQ4Den4MwVpuMx
         SjJ+ttxbGZ6g5YCACiyWNYqka5FWm2lhKDkmZAqeCZuVpPKWXDHwnfIkfFQz3NiLqhhL
         iYu8A0mtl6CgHu9Evwe2Eg2V1EeDsLWeb33XL/RC5rRcDZTmMQzSRzHykn0+BYwlItaV
         efeO3mxF+Xb7aUXMoGrZEe1d9wVO4jHdImiGXyvY5B+uZyEaqZbwqHqHrsDpLu7dcBbs
         IACQ==
X-Gm-Message-State: AOAM5333jqtSlBwoCwqaL2zLLohctn9BzPef/iflR3DKFs26YIv5o0CV
        D/UyMtNzCSAV31mDWLuTzLE=
X-Google-Smtp-Source: ABdhPJyt/di1ICCZrqqjM7cJwVLyYlymB8Td3iv6afRKt9ktK5weCZ+Hw5PQt4s3Kp+sDPtGpEhWfw==
X-Received: by 2002:aa7:952d:: with SMTP id c13mr5713978pfp.198.1596230432315;
        Fri, 31 Jul 2020 14:20:32 -0700 (PDT)
Received: from octofox.cadence.com ([2601:641:400:e00:19b7:f650:7bbe:a7fb])
        by smtp.gmail.com with ESMTPSA id g23sm11163855pfo.95.2020.07.31.14.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 14:20:31 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] xtensa: add missing exclusive access state management
Date:   Fri, 31 Jul 2020 14:20:17 -0700
Message-Id: <20200731212017.26851-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The result of the s32ex opcode is recorded in the ATOMCTL special
register and must be retrieved with the getex opcode. Context switch
between s32ex and getex may trash the ATOMCTL register and result in
duplicate update or missing update of the atomic variable.
Add atomctl8 field to the struct thread_info and use getex to swap
ATOMCTL bit 8 as a part of context switch.
Clear exclusive access monitor on kernel entry.

Cc: stable@vger.kernel.org
Fixes: f7c34874f04a ("xtensa: add exclusive atomics support")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/asm/thread_info.h |  4 ++++
 arch/xtensa/kernel/asm-offsets.c      |  3 +++
 arch/xtensa/kernel/entry.S            | 11 +++++++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/xtensa/include/asm/thread_info.h b/arch/xtensa/include/asm/thread_info.h
index 8918f0f20c53..6acbbe0d87d3 100644
--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -55,6 +55,10 @@ struct thread_info {
 	mm_segment_t		addr_limit;	/* thread address space */
 
 	unsigned long		cpenable;
+#if XCHAL_HAVE_EXCLUSIVE
+	/* result of the most recent exclusive store */
+	unsigned long		atomctl8;
+#endif
 
 	/* Allocate storage for extra user states and coprocessor states. */
 #if XTENSA_HAVE_COPROCESSORS
diff --git a/arch/xtensa/kernel/asm-offsets.c b/arch/xtensa/kernel/asm-offsets.c
index 33a257b33723..dc5c83cad9be 100644
--- a/arch/xtensa/kernel/asm-offsets.c
+++ b/arch/xtensa/kernel/asm-offsets.c
@@ -93,6 +93,9 @@ int main(void)
 	DEFINE(THREAD_RA, offsetof (struct task_struct, thread.ra));
 	DEFINE(THREAD_SP, offsetof (struct task_struct, thread.sp));
 	DEFINE(THREAD_CPENABLE, offsetof (struct thread_info, cpenable));
+#if XCHAL_HAVE_EXCLUSIVE
+	DEFINE(THREAD_ATOMCTL8, offsetof (struct thread_info, atomctl8));
+#endif
 #if XTENSA_HAVE_COPROCESSORS
 	DEFINE(THREAD_XTREGS_CP0, offsetof(struct thread_info, xtregs_cp.cp0));
 	DEFINE(THREAD_XTREGS_CP1, offsetof(struct thread_info, xtregs_cp.cp1));
diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index 98515c24d9b2..703cf6205efe 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -374,6 +374,11 @@ common_exception:
 	s32i	a2, a1, PT_LCOUNT
 #endif
 
+#if XCHAL_HAVE_EXCLUSIVE
+	/* Clear exclusive access monitor set by interrupted code */
+	clrex
+#endif
+
 	/* It is now save to restore the EXC_TABLE_FIXUP variable. */
 
 	rsr	a2, exccause
@@ -2020,6 +2025,12 @@ ENTRY(_switch_to)
 	s32i	a3, a4, THREAD_CPENABLE
 #endif
 
+#if XCHAL_HAVE_EXCLUSIVE
+	l32i	a3, a5, THREAD_ATOMCTL8
+	getex	a3
+	s32i	a3, a4, THREAD_ATOMCTL8
+#endif
+
 	/* Flush register file. */
 
 	spill_registers_kernel
-- 
2.20.1

