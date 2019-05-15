Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638441F3FF
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfEOMRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbfEOLCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B542B216FD;
        Wed, 15 May 2019 11:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918121;
        bh=XQ6YMVEwxo4AuGx4pvzc/jL8vhLnlvmpr3oyBoBsxXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5m97R7CGqXMCCuuL5SgJwmTR8XrEr+DJA5w/k8tBeZQvzWd+Rf3bVjUtIbGa99Kz
         MbySLI0VdFdcvBnTkbloCnlYJ+3vlW2URlNHeoGbKTq79RRnbrCUIon++lSnV2P8Ej
         ph4seJPDQVNIvu+b77iPGmhwvhMwxz/DNSNY2bHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 014/266] powerpc/64s: Improve RFI L1-D cache flush fallback
Date:   Wed, 15 May 2019 12:52:01 +0200
Message-Id: <20190515090723.113364799@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit bdcb1aefc5b3f7d0f1dc8b02673602bca2ff7a4b upstream.

The fallback RFI flush is used when firmware does not provide a way
to flush the cache. It's a "displacement flush" that evicts useful
data by displacing it with an uninteresting buffer.

The flush has to take care to work with implementation specific cache
replacment policies, so the recipe has been in flux. The initial
slow but conservative approach is to touch all lines of a congruence
class, with dependencies between each load. It has since been
determined that a linear pattern of loads without dependencies is
sufficient, and is significantly faster.

Measuring the speed of a null syscall with RFI fallback flush enabled
gives the relative improvement:

P8 - 1.83x
P9 - 1.75x

The flush also becomes simpler and more adaptable to different cache
geometries.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/paca.h      |    3 -
 arch/powerpc/kernel/asm-offsets.c    |    3 -
 arch/powerpc/kernel/exceptions-64s.S |   76 ++++++++++++++++-------------------
 arch/powerpc/kernel/setup_64.c       |   13 -----
 arch/powerpc/xmon/xmon.c             |    2 
 5 files changed, 39 insertions(+), 58 deletions(-)

--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -199,8 +199,7 @@ struct paca_struct {
 	 */
 	u64 exrfi[13] __aligned(0x80);
 	void *rfi_flush_fallback_area;
-	u64 l1d_flush_congruence;
-	u64 l1d_flush_sets;
+	u64 l1d_flush_size;
 #endif
 };
 
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -245,8 +245,7 @@ int main(void)
 	DEFINE(PACA_IN_MCE, offsetof(struct paca_struct, in_mce));
 	DEFINE(PACA_RFI_FLUSH_FALLBACK_AREA, offsetof(struct paca_struct, rfi_flush_fallback_area));
 	DEFINE(PACA_EXRFI, offsetof(struct paca_struct, exrfi));
-	DEFINE(PACA_L1D_FLUSH_CONGRUENCE, offsetof(struct paca_struct, l1d_flush_congruence));
-	DEFINE(PACA_L1D_FLUSH_SETS, offsetof(struct paca_struct, l1d_flush_sets));
+	DEFINE(PACA_L1D_FLUSH_SIZE, offsetof(struct paca_struct, l1d_flush_size));
 #endif
 	DEFINE(PACAHWCPUID, offsetof(struct paca_struct, hw_cpu_id));
 	DEFINE(PACAKEXECSTATE, offsetof(struct paca_struct, kexec_state));
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1571,39 +1571,37 @@ rfi_flush_fallback:
 	std	r9,PACA_EXRFI+EX_R9(r13)
 	std	r10,PACA_EXRFI+EX_R10(r13)
 	std	r11,PACA_EXRFI+EX_R11(r13)
-	std	r12,PACA_EXRFI+EX_R12(r13)
-	std	r8,PACA_EXRFI+EX_R13(r13)
 	mfctr	r9
 	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
-	ld	r11,PACA_L1D_FLUSH_SETS(r13)
-	ld	r12,PACA_L1D_FLUSH_CONGRUENCE(r13)
-	/*
-	 * The load adresses are at staggered offsets within cachelines,
-	 * which suits some pipelines better (on others it should not
-	 * hurt).
-	 */
-	addi	r12,r12,8
+	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
+	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
 	mtctr	r11
 	DCBT_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */
 
 	/* order ld/st prior to dcbt stop all streams with flushing */
 	sync
-1:	li	r8,0
-	.rept	8 /* 8-way set associative */
-	ldx	r11,r10,r8
-	add	r8,r8,r12
-	xor	r11,r11,r11	// Ensure r11 is 0 even if fallback area is not
-	add	r8,r8,r11	// Add 0, this creates a dependency on the ldx
-	.endr
-	addi	r10,r10,128 /* 128 byte cache line */
+
+	/*
+	 * The load adresses are at staggered offsets within cachelines,
+	 * which suits some pipelines better (on others it should not
+	 * hurt).
+	 */
+1:
+	ld	r11,(0x80 + 8)*0(r10)
+	ld	r11,(0x80 + 8)*1(r10)
+	ld	r11,(0x80 + 8)*2(r10)
+	ld	r11,(0x80 + 8)*3(r10)
+	ld	r11,(0x80 + 8)*4(r10)
+	ld	r11,(0x80 + 8)*5(r10)
+	ld	r11,(0x80 + 8)*6(r10)
+	ld	r11,(0x80 + 8)*7(r10)
+	addi	r10,r10,0x80*8
 	bdnz	1b
 
 	mtctr	r9
 	ld	r9,PACA_EXRFI+EX_R9(r13)
 	ld	r10,PACA_EXRFI+EX_R10(r13)
 	ld	r11,PACA_EXRFI+EX_R11(r13)
-	ld	r12,PACA_EXRFI+EX_R12(r13)
-	ld	r8,PACA_EXRFI+EX_R13(r13)
 	GET_SCRATCH0(r13);
 	rfid
 
@@ -1614,39 +1612,37 @@ hrfi_flush_fallback:
 	std	r9,PACA_EXRFI+EX_R9(r13)
 	std	r10,PACA_EXRFI+EX_R10(r13)
 	std	r11,PACA_EXRFI+EX_R11(r13)
-	std	r12,PACA_EXRFI+EX_R12(r13)
-	std	r8,PACA_EXRFI+EX_R13(r13)
 	mfctr	r9
 	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
-	ld	r11,PACA_L1D_FLUSH_SETS(r13)
-	ld	r12,PACA_L1D_FLUSH_CONGRUENCE(r13)
-	/*
-	 * The load adresses are at staggered offsets within cachelines,
-	 * which suits some pipelines better (on others it should not
-	 * hurt).
-	 */
-	addi	r12,r12,8
+	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
+	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
 	mtctr	r11
 	DCBT_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */
 
 	/* order ld/st prior to dcbt stop all streams with flushing */
 	sync
-1:	li	r8,0
-	.rept	8 /* 8-way set associative */
-	ldx	r11,r10,r8
-	add	r8,r8,r12
-	xor	r11,r11,r11	// Ensure r11 is 0 even if fallback area is not
-	add	r8,r8,r11	// Add 0, this creates a dependency on the ldx
-	.endr
-	addi	r10,r10,128 /* 128 byte cache line */
+
+	/*
+	 * The load adresses are at staggered offsets within cachelines,
+	 * which suits some pipelines better (on others it should not
+	 * hurt).
+	 */
+1:
+	ld	r11,(0x80 + 8)*0(r10)
+	ld	r11,(0x80 + 8)*1(r10)
+	ld	r11,(0x80 + 8)*2(r10)
+	ld	r11,(0x80 + 8)*3(r10)
+	ld	r11,(0x80 + 8)*4(r10)
+	ld	r11,(0x80 + 8)*5(r10)
+	ld	r11,(0x80 + 8)*6(r10)
+	ld	r11,(0x80 + 8)*7(r10)
+	addi	r10,r10,0x80*8
 	bdnz	1b
 
 	mtctr	r9
 	ld	r9,PACA_EXRFI+EX_R9(r13)
 	ld	r10,PACA_EXRFI+EX_R10(r13)
 	ld	r11,PACA_EXRFI+EX_R11(r13)
-	ld	r12,PACA_EXRFI+EX_R12(r13)
-	ld	r8,PACA_EXRFI+EX_R13(r13)
 	GET_SCRATCH0(r13);
 	hrfid
 
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -902,19 +902,8 @@ static void init_fallback_flush(void)
 	memset(l1d_flush_fallback_area, 0, l1d_size * 2);
 
 	for_each_possible_cpu(cpu) {
-		/*
-		 * The fallback flush is currently coded for 8-way
-		 * associativity. Different associativity is possible, but it
-		 * will be treated as 8-way and may not evict the lines as
-		 * effectively.
-		 *
-		 * 128 byte lines are mandatory.
-		 */
-		u64 c = l1d_size / 8;
-
 		paca[cpu].rfi_flush_fallback_area = l1d_flush_fallback_area;
-		paca[cpu].l1d_flush_congruence = c;
-		paca[cpu].l1d_flush_sets = c / 128;
+		paca[cpu].l1d_flush_size = l1d_size;
 	}
 }
 
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -2146,8 +2146,6 @@ static void dump_one_paca(int cpu)
 		printf(" slb_cache[%d]:        = 0x%016lx\n", i, p->slb_cache[i]);
 
 	DUMP(p, rfi_flush_fallback_area, "px");
-	DUMP(p, l1d_flush_congruence, "llx");
-	DUMP(p, l1d_flush_sets, "llx");
 #endif
 	DUMP(p, dscr_default, "llx");
 #ifdef CONFIG_PPC_BOOK3E


