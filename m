Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC5AC17F98F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgCJM5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729832AbgCJM5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:57:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8C292467D;
        Tue, 10 Mar 2020 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845073;
        bh=nRO455Vq+s6RfjtfOB2yl+aWuz2EYmxn6affqv+/Knc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=turwDV0BizA0IwJOxTEycSVFMLrKBgmsxN9NAv1sN4G7/r3mnWIYl1W43XJ6M1ThZ
         KT5/wyXZm4XV0a4qlxW4Er+WeHlIWugSfZWhlgRh9Hlw9BF41uZCROYXE3Aw9eGATz
         SyqrKrAAvUB+u7cKcKrwqL8Y5KxKnfW22fPMQEsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 052/189] csky: Set regs->usp to kernel sp, when the exception is from kernel
Date:   Tue, 10 Mar 2020 13:38:09 +0100
Message-Id: <20200310123644.776690416@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit f8e17c17b81070f38062dce79ca7f4541851dadd ]

In the past, we didn't care about kernel sp when saving pt_reg. But in some
cases, we still need pt_reg->usp to represent the kernel stack before enter
exception.

For cmpxhg in atomic.S, we need save and restore usp for above.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/abiv1/inc/abi/entry.h | 19 ++++++++++++++-----
 arch/csky/abiv2/inc/abi/entry.h | 11 +++++++++++
 arch/csky/kernel/atomic.S       |  8 ++++++--
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/csky/abiv1/inc/abi/entry.h b/arch/csky/abiv1/inc/abi/entry.h
index 7ab78bd0f3b13..f35a9f3315ee6 100644
--- a/arch/csky/abiv1/inc/abi/entry.h
+++ b/arch/csky/abiv1/inc/abi/entry.h
@@ -16,14 +16,16 @@
 #define LSAVE_A4	40
 #define LSAVE_A5	44
 
+#define usp ss1
+
 .macro USPTOKSP
-	mtcr	sp, ss1
+	mtcr	sp, usp
 	mfcr	sp, ss0
 .endm
 
 .macro KSPTOUSP
 	mtcr	sp, ss0
-	mfcr	sp, ss1
+	mfcr	sp, usp
 .endm
 
 .macro	SAVE_ALL epc_inc
@@ -45,7 +47,13 @@
 	add	lr, r13
 	stw     lr, (sp, 8)
 
+	mov	lr, sp
+	addi	lr, 32
+	addi	lr, 32
+	addi	lr, 16
+	bt	2f
 	mfcr	lr, ss1
+2:
 	stw     lr, (sp, 16)
 
 	stw     a0, (sp, 20)
@@ -79,9 +87,10 @@
 	ldw     a0, (sp, 12)
 	mtcr    a0, epsr
 	btsti   a0, 31
+	bt      1f
 	ldw     a0, (sp, 16)
 	mtcr	a0, ss1
-
+1:
 	ldw     a0, (sp, 24)
 	ldw     a1, (sp, 28)
 	ldw     a2, (sp, 32)
@@ -102,9 +111,9 @@
 	addi	sp, 32
 	addi	sp, 8
 
-	bt      1f
+	bt      2f
 	KSPTOUSP
-1:
+2:
 	rte
 .endm
 
diff --git a/arch/csky/abiv2/inc/abi/entry.h b/arch/csky/abiv2/inc/abi/entry.h
index 9897a16b45e5d..94a7a58765dff 100644
--- a/arch/csky/abiv2/inc/abi/entry.h
+++ b/arch/csky/abiv2/inc/abi/entry.h
@@ -31,7 +31,13 @@
 
 	mfcr	lr, epsr
 	stw	lr, (sp, 12)
+	btsti   lr, 31
+	bf      1f
+	addi    lr, sp, 152
+	br	2f
+1:
 	mfcr	lr, usp
+2:
 	stw	lr, (sp, 16)
 
 	stw     a0, (sp, 20)
@@ -64,8 +70,10 @@
 	mtcr	a0, epc
 	ldw	a0, (sp, 12)
 	mtcr	a0, epsr
+	btsti   a0, 31
 	ldw	a0, (sp, 16)
 	mtcr	a0, usp
+	mtcr	a0, ss0
 
 #ifdef CONFIG_CPU_HAS_HILO
 	ldw	a0, (sp, 140)
@@ -86,6 +94,9 @@
 	addi    sp, 40
 	ldm     r16-r30, (sp)
 	addi    sp, 72
+	bf	1f
+	mfcr	sp, ss0
+1:
 	rte
 .endm
 
diff --git a/arch/csky/kernel/atomic.S b/arch/csky/kernel/atomic.S
index 5b84f11485aeb..3821ef9b75672 100644
--- a/arch/csky/kernel/atomic.S
+++ b/arch/csky/kernel/atomic.S
@@ -17,10 +17,12 @@ ENTRY(csky_cmpxchg)
 	mfcr	a3, epc
 	addi	a3, TRAP0_SIZE
 
-	subi    sp, 8
+	subi    sp, 16
 	stw     a3, (sp, 0)
 	mfcr    a3, epsr
 	stw     a3, (sp, 4)
+	mfcr	a3, usp
+	stw     a3, (sp, 8)
 
 	psrset	ee
 #ifdef CONFIG_CPU_HAS_LDSTEX
@@ -47,7 +49,9 @@ ENTRY(csky_cmpxchg)
 	mtcr	a3, epc
 	ldw     a3, (sp, 4)
 	mtcr	a3, epsr
-	addi	sp, 8
+	ldw     a3, (sp, 8)
+	mtcr	a3, usp
+	addi	sp, 16
 	KSPTOUSP
 	rte
 END(csky_cmpxchg)
-- 
2.20.1



