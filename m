Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB32A566E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388110AbgKCV2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730638AbgKCVA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:00:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D740322226;
        Tue,  3 Nov 2020 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437225;
        bh=tyT+9KtALDmDCNBfaegf02PsUy4jq+TDq24kxtafaIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1TD2Apn5Eab0KzmsJeYsBmNqc8l7Fd8HCMwIKun3TtVcePVYjfys/FfMKPDsjXeA
         N2k9kg20zpMmr8tfNN5dZEVC2wlD8eP9bFMOilWEMZlEij2E76POYy50fio3/A+eo8
         ohBSmaya9m0Yz41OksP2E2LpkKByn3lP8LoYoIsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 162/214] powerpc/powermac: Fix low_sleep_handler with KUAP and KUEP
Date:   Tue,  3 Nov 2020 21:36:50 +0100
Message-Id: <20201103203305.958952009@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 2c637d2df4ee4830e9d3eb2bd5412250522ce96e upstream.

low_sleep_handler() has an hardcoded restore of segment registers
that doesn't take KUAP and KUEP into account.

Use head_32's load_segment_registers() routine instead.

Fixes: a68c31fc01ef ("powerpc/32s: Implement Kernel Userspace Access Protection")
Fixes: 31ed2b13c48d ("powerpc/32s: Implement Kernel Userspace Execution Prevention.")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/21b05f7298c1b18f73e6e5b4cd5005aafa24b6da.1599820109.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_32.S           |    2 +-
 arch/powerpc/platforms/powermac/sleep.S |    9 +--------
 2 files changed, 2 insertions(+), 9 deletions(-)

--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -843,7 +843,7 @@ BEGIN_MMU_FTR_SECTION
 END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
 	blr
 
-load_segment_registers:
+_GLOBAL(load_segment_registers)
 	li	r0, NUM_USER_SEGMENTS /* load up user segment register values */
 	mtctr	r0		/* for context 0 */
 	li	r3, 0		/* Kp = 0, Ks = 0, VSID = 0 */
--- a/arch/powerpc/platforms/powermac/sleep.S
+++ b/arch/powerpc/platforms/powermac/sleep.S
@@ -293,14 +293,7 @@ grackle_wake_up:
 	 * we do any r1 memory access as we are not sure they
 	 * are in a sane state above the first 256Mb region
 	 */
-	li	r0,16		/* load up segment register values */
-	mtctr	r0		/* for context 0 */
-	lis	r3,0x2000	/* Ku = 1, VSID = 0 */
-	li	r4,0
-3:	mtsrin	r3,r4
-	addi	r3,r3,0x111	/* increment VSID */
-	addis	r4,r4,0x1000	/* address of next segment */
-	bdnz	3b
+	bl	load_segment_registers
 	sync
 	isync
 


