Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79371EF38
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbfEOLbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732894AbfEOLbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A7C120818;
        Wed, 15 May 2019 11:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919884;
        bh=vUQzSnELn00Y8vO8upYf8r+N3HxY9LCoXUePa8jzX6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/gAaghPym6cTm621NQr/0YwQPgoQUwZHJIWMJzOXztGS/ZWTi4vOViAiuKCiyKcW
         7/4LeDGib8pn9YWdyZZArT/fEcsAQb+HeAmfA0ekFDvE0HqiWB+XGzw3lVWm9TUJsY
         QJ1ft7KFeNZ+ftTL1r2TpFAgaetUH1FDGunUZmnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell Currey <ruscur@russell.cc>,
        Akshay Adiga <akshay.adiga@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.0 131/137] powerpc/powernv/idle: Restore IAMR after idle
Date:   Wed, 15 May 2019 12:56:52 +0200
Message-Id: <20190515090703.387592033@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell Currey <ruscur@russell.cc>

commit a3f3072db6cad40895c585dce65e36aab997f042 upstream.

Without restoring the IAMR after idle, execution prevention on POWER9
with Radix MMU is overwritten and the kernel can freely execute
userspace without faulting.

This is necessary when returning from any stop state that modifies
user state, as well as hypervisor state.

To test how this fails without this patch, load the lkdtm driver and
do the following:

  $ echo EXEC_USERSPACE > /sys/kernel/debug/provoke-crash/DIRECT

which won't fault, then boot the kernel with powersave=off, where it
will fault. Applying this patch will fix this.

Fixes: 3b10d0095a1e ("powerpc/mm/radix: Prevent kernel execution of user space")
Cc: stable@vger.kernel.org # v4.10+
Signed-off-by: Russell Currey <ruscur@russell.cc>
Reviewed-by: Akshay Adiga <akshay.adiga@linux.vnet.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/idle_book3s.S |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/arch/powerpc/kernel/idle_book3s.S
+++ b/arch/powerpc/kernel/idle_book3s.S
@@ -170,6 +170,9 @@ core_idle_lock_held:
 	bne-	core_idle_lock_held
 	blr
 
+/* Reuse an unused pt_regs slot for IAMR */
+#define PNV_POWERSAVE_IAMR	_DAR
+
 /*
  * Pass requested state in r3:
  *	r3 - PNV_THREAD_NAP/SLEEP/WINKLE in POWER8
@@ -200,6 +203,12 @@ pnv_powersave_common:
 	/* Continue saving state */
 	SAVE_GPR(2, r1)
 	SAVE_NVGPRS(r1)
+
+BEGIN_FTR_SECTION
+	mfspr	r5, SPRN_IAMR
+	std	r5, PNV_POWERSAVE_IAMR(r1)
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
+
 	mfcr	r5
 	std	r5,_CCR(r1)
 	std	r1,PACAR1(r13)
@@ -924,6 +933,17 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
 	REST_NVGPRS(r1)
 	REST_GPR(2, r1)
+
+BEGIN_FTR_SECTION
+	/* IAMR was saved in pnv_powersave_common() */
+	ld	r5, PNV_POWERSAVE_IAMR(r1)
+	mtspr	SPRN_IAMR, r5
+	/*
+	 * We don't need an isync here because the upcoming mtmsrd is
+	 * execution synchronizing.
+	 */
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
+
 	ld	r4,PACAKMSR(r13)
 	ld	r5,_LINK(r1)
 	ld	r6,_CCR(r1)


