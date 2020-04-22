Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9E1B4133
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgDVKu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbgDVKLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:11:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A444D20575;
        Wed, 22 Apr 2020 10:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550295;
        bh=zyPS6kOD0ZGSj23nfYcTdMdRa2bkl3iBr+TWjFANl3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TbnEjv69cOTdcld8eo9CI2+97gcILFIuMn68YC221pyzBX3+jaaE1ZcWYt7gMqKl
         x8Ev4a1aujBEynqv+Gf2JrzQ6QNQUSfL+gEOi6s5ySpbi1nwLqUTuwFK98zJJ9ajBY
         fzLXiaE45uwHX34PONRpeH0gwR45Fb4YAs9DrDJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 4.14 087/199] powerpc/powernv/idle: Restore AMR/UAMOR/AMOR after idle
Date:   Wed, 22 Apr 2020 11:56:53 +0200
Message-Id: <20200422095106.805295217@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 53a712bae5dd919521a58d7bad773b949358add0 upstream.

In order to implement KUAP (Kernel Userspace Access Protection) on
Power9 we will be using the AMR, and therefore indirectly the
UAMOR/AMOR.

So save/restore these regs in the idle code.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[ajd: Backport to 4.14 tree, CVE-2020-11669]
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/idle_book3s.S |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/idle_book3s.S
+++ b/arch/powerpc/kernel/idle_book3s.S
@@ -163,8 +163,11 @@ core_idle_lock_held:
 	bne-	core_idle_lock_held
 	blr
 
-/* Reuse an unused pt_regs slot for IAMR */
+/* Reuse some unused pt_regs slots for AMR/IAMR/UAMOR/UAMOR */
+#define PNV_POWERSAVE_AMR	_TRAP
 #define PNV_POWERSAVE_IAMR	_DAR
+#define PNV_POWERSAVE_UAMOR	_DSISR
+#define PNV_POWERSAVE_AMOR	RESULT
 
 /*
  * Pass requested state in r3:
@@ -198,8 +201,16 @@ pnv_powersave_common:
 	SAVE_NVGPRS(r1)
 
 BEGIN_FTR_SECTION
+	mfspr	r4, SPRN_AMR
 	mfspr	r5, SPRN_IAMR
+	mfspr	r6, SPRN_UAMOR
+	std	r4, PNV_POWERSAVE_AMR(r1)
 	std	r5, PNV_POWERSAVE_IAMR(r1)
+	std	r6, PNV_POWERSAVE_UAMOR(r1)
+BEGIN_FTR_SECTION_NESTED(42)
+	mfspr	r7, SPRN_AMOR
+	std	r7, PNV_POWERSAVE_AMOR(r1)
+END_FTR_SECTION_NESTED_IFSET(CPU_FTR_HVMODE, 42)
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 
 	mfcr	r5
@@ -951,12 +962,20 @@ END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
 	REST_GPR(2, r1)
 
 BEGIN_FTR_SECTION
-	/* IAMR was saved in pnv_powersave_common() */
+	/* These regs were saved in pnv_powersave_common() */
+	ld	r4, PNV_POWERSAVE_AMR(r1)
 	ld	r5, PNV_POWERSAVE_IAMR(r1)
+	ld	r6, PNV_POWERSAVE_UAMOR(r1)
+	mtspr	SPRN_AMR, r4
 	mtspr	SPRN_IAMR, r5
+	mtspr	SPRN_UAMOR, r6
+BEGIN_FTR_SECTION_NESTED(42)
+	ld	r7, PNV_POWERSAVE_AMOR(r1)
+	mtspr	SPRN_AMOR, r7
+END_FTR_SECTION_NESTED_IFSET(CPU_FTR_HVMODE, 42)
 	/*
-	 * We don't need an isync here because the upcoming mtmsrd is
-	 * execution synchronizing.
+	 * We don't need an isync here after restoring IAMR because the upcoming
+	 * mtmsrd is execution synchronizing.
 	 */
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 


