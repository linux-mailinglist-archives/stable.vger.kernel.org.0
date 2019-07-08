Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B5E61E97
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 14:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfGHMlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 08:41:35 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57607 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727375AbfGHMlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 08:41:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CDD2721B84;
        Mon,  8 Jul 2019 08:41:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 08 Jul 2019 08:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eHyDeZ
        ypM0lMBgtsYGkqzvrox+XrruVcmuDJqg7EjMc=; b=TrDVKjiCBUNhh0R7d/l8Fb
        aneVWtUQ9KQsBNZCK9opGweviF9dbSvvta1xRgG3k7gyMffYm+VeD3vQPZpjKdMA
        goqJOODoY+XVj7WzgMKxPRFm8GCB+2OB6zdO0vD0McfwowzZVTgp41+03jQxZ1PI
        sHfzT2KrOmAs1O5JftAUMlrIG7VJDxpK5Auy6bN7txvDVhr4MrT9Q8jdxt8dLb9h
        IAOga0Ta5JqXHAMZoj0dHyfDR2GVcpLhJGXceC3cohgO+RoynzhSecTgPPTWYR+r
        zEgdvddevI9vV/jYx0ZPTPOJwcm5iH7GJdjE+nTgk8Ma1tr1Gzosflsd31+f8gZQ
        ==
X-ME-Sender: <xms:_TkjXa_0tY7Ozmd8dIpKVGH9vQrzpnaMsr63aJ-iBTBSHdRBsl7UXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedtgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:_TkjXV3LDBheY7OV66vvcyDc0NQC7pjc24IYLhODy8k-Nn76NZcFHg>
    <xmx:_TkjXfZovTAm2vTSa62rzAvY80QTI_JMmRfkRGt4cjxsGNldUvGMxw>
    <xmx:_TkjXRujTPqOvVEQ5XMi3oA7_ZQyWaLHtEv7IvKHqTng0DSl9yr2Ig>
    <xmx:_TkjXd1y124zgeKanNFvwclwQ4OVjXj63cGvpTFqiVDWMcA5sQLQBw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18A0F380079;
        Mon,  8 Jul 2019 08:41:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] MIPS: Add missing EHB in mtc0 -> mfc0 sequence." failed to apply to 4.4-stable tree
To:     dkorotin@wavecomp.com, paul.burton@mips.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jul 2019 14:41:31 +0200
Message-ID: <1562589691144251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0b24cae4d535045f4c9e177aa228d4e97bad212c Mon Sep 17 00:00:00 2001
From: Dmitry Korotin <dkorotin@wavecomp.com>
Date: Mon, 24 Jun 2019 19:05:27 +0000
Subject: [PATCH] MIPS: Add missing EHB in mtc0 -> mfc0 sequence.

Add a missing EHB (Execution Hazard Barrier) in mtc0 -> mfc0 sequence.
Without this execution hazard barrier it's possible for the value read
back from the KScratch register to be the value from before the mtc0.

Reproducible on P5600 & P6600.

The hazard is documented in the MIPS Architecture Reference Manual Vol.
III: MIPS32/microMIPS32 Privileged Resource Architecture (MD00088), rev
6.03 table 8.1 which includes:

   Producer | Consumer | Hazard
  ----------|----------|----------------------------
   mtc0     | mfc0     | any coprocessor 0 register

Signed-off-by: Dmitry Korotin <dkorotin@wavecomp.com>
[paul.burton@mips.com:
  - Commit message tweaks.
  - Add Fixes tags.
  - Mark for stable back to v3.15 where P5600 support was introduced.]
Signed-off-by: Paul Burton <paul.burton@mips.com>
Fixes: 3d8bfdd03072 ("MIPS: Use C0_KScratch (if present) to hold PGD pointer.")
Fixes: 829dcc0a956a ("MIPS: Add MIPS P5600 probe support")
Cc: linux-mips@vger.kernel.org
Cc: stable@vger.kernel.org # v3.15+

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 65b6e85447b1..144ceb0fba88 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -391,6 +391,7 @@ static struct work_registers build_get_work_registers(u32 **p)
 static void build_restore_work_registers(u32 **p)
 {
 	if (scratch_reg >= 0) {
+		uasm_i_ehb(p);
 		UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
 		return;
 	}
@@ -668,10 +669,12 @@ static void build_restore_pagemask(u32 **p, struct uasm_reloc **r,
 			uasm_i_mtc0(p, 0, C0_PAGEMASK);
 			uasm_il_b(p, r, lid);
 		}
-		if (scratch_reg >= 0)
+		if (scratch_reg >= 0) {
+			uasm_i_ehb(p);
 			UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-		else
+		} else {
 			UASM_i_LW(p, 1, scratchpad_offset(0), 0);
+		}
 	} else {
 		/* Reset default page size */
 		if (PM_DEFAULT_MASK >> 16) {
@@ -938,10 +941,12 @@ build_get_pgd_vmalloc64(u32 **p, struct uasm_label **l, struct uasm_reloc **r,
 		uasm_i_jr(p, ptr);
 
 		if (mode == refill_scratch) {
-			if (scratch_reg >= 0)
+			if (scratch_reg >= 0) {
+				uasm_i_ehb(p);
 				UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-			else
+			} else {
 				UASM_i_LW(p, 1, scratchpad_offset(0), 0);
+			}
 		} else {
 			uasm_i_nop(p);
 		}
@@ -1258,6 +1263,7 @@ build_fast_tlb_refill_handler (u32 **p, struct uasm_label **l,
 	UASM_i_MTC0(p, odd, C0_ENTRYLO1); /* load it */
 
 	if (c0_scratch_reg >= 0) {
+		uasm_i_ehb(p);
 		UASM_i_MFC0(p, scratch, c0_kscratch(), c0_scratch_reg);
 		build_tlb_write_entry(p, l, r, tlb_random);
 		uasm_l_leave(l, *p);
@@ -1603,15 +1609,17 @@ static void build_setup_pgd(void)
 		uasm_i_dinsm(&p, a0, 0, 29, 64 - 29);
 		uasm_l_tlbl_goaround1(&l, p);
 		UASM_i_SLL(&p, a0, a0, 11);
-		uasm_i_jr(&p, 31);
 		UASM_i_MTC0(&p, a0, C0_CONTEXT);
+		uasm_i_jr(&p, 31);
+		uasm_i_ehb(&p);
 	} else {
 		/* PGD in c0_KScratch */
-		uasm_i_jr(&p, 31);
 		if (cpu_has_ldpte)
 			UASM_i_MTC0(&p, a0, C0_PWBASE);
 		else
 			UASM_i_MTC0(&p, a0, c0_kscratch(), pgd_reg);
+		uasm_i_jr(&p, 31);
+		uasm_i_ehb(&p);
 	}
 #else
 #ifdef CONFIG_SMP
@@ -1625,13 +1633,16 @@ static void build_setup_pgd(void)
 	UASM_i_LA_mostly(&p, a2, pgdc);
 	UASM_i_SW(&p, a0, uasm_rel_lo(pgdc), a2);
 #endif /* SMP */
-	uasm_i_jr(&p, 31);
 
 	/* if pgd_reg is allocated, save PGD also to scratch register */
-	if (pgd_reg != -1)
+	if (pgd_reg != -1) {
 		UASM_i_MTC0(&p, a0, c0_kscratch(), pgd_reg);
-	else
+		uasm_i_jr(&p, 31);
+		uasm_i_ehb(&p);
+	} else {
+		uasm_i_jr(&p, 31);
 		uasm_i_nop(&p);
+	}
 #endif
 	if (p >= (u32 *)tlbmiss_handler_setup_pgd_end)
 		panic("tlbmiss_handler_setup_pgd space exceeded");

