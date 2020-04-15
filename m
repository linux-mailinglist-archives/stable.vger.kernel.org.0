Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91BD1AA427
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370780AbgDONSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:18:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54829 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506235AbgDONQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:16:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 8CF595C0165;
        Wed, 15 Apr 2020 09:16:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 09:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OWclCD
        n7NVtAEbVY3uRNg2Z7rhTLZl1Uq2awO5IHvtg=; b=sz6XaQOf4LrWRz5yg0+z5o
        Ji2GdTmwjAGgCygwgLcGMS0FcR7EAzaxvKyAsAJyiCqfjVj70bwUIFiWjkXEAUJ2
        l6+fVyJ762W8emtjDjlge7K+l0YKnN4CQQYXIPbBhgdktjLSmWDxGZ/M0IRYKHTj
        c2x1dmxwnfDtGoUP9JrsCGqg/PIKwuaMnflohnBlJ1p+yxwWmszjtTuqZh20YLNj
        jGyZi9K4GmyWFDdQonP2npgGCfjCg8fcBqLO47rLtowKATTkMeX5W3saH8pDuV6d
        NO698AmRjTWmUNTxz6W2wRFXKzyheeXuEmHWRzHfoOtZ06OJP2GJyElcLYrd6TgQ
        ==
X-ME-Sender: <xms:NwmXXgmpb2sk1HjUIstzSz9mMJLRMs2FHAtqhhzuut9FTfXkBSFGqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhlohifrdhssgenucfkphepkeefrd
    ekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:NwmXXk2s2vhfvLE9Yy-UHCFPBMhDwKcWbEYDM57SrhudIj-N9jP66w>
    <xmx:NwmXXvhRUSTZvfN3WBCo5KbROomL7yrKt_AvZqhujS-gOWeLY3z6Lw>
    <xmx:NwmXXiX6ovufZEbZYPgEN2McU83hFQR82O84EhXbd-dUVd8u3KRdWw>
    <xmx:NwmXXnN3KMNl8U8s023Geb-R-2hNFuad6GdztTADZNCkNaOuf4M-VA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E0173060064;
        Wed, 15 Apr 2020 09:16:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/fsl_booke: Avoid creating duplicate tlb1 entry" failed to apply to 4.9-stable tree
To:     laurentiu.tudor@nxp.com, mpe@ellerman.id.au, oss@buserror.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 15:16:28 +0200
Message-ID: <158695658816283@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa4113340ae6c2811e046f08c2bc21011d20a072 Mon Sep 17 00:00:00 2001
From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Date: Thu, 23 Jan 2020 11:19:25 +0000
Subject: [PATCH] powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

In the current implementation, the call to loadcam_multi() is wrapped
between switch_to_as1() and restore_to_as0() calls so, when it tries
to create its own temporary AS=1 TLB1 entry, it ends up duplicating
the existing one created by switch_to_as1(). Add a check to skip
creating the temporary entry if already running in AS=1.

Fixes: d9e1831a4202 ("powerpc/85xx: Load all early TLB entries at once")
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Acked-by: Scott Wood <oss@buserror.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200123111914.2565-1-laurentiu.tudor@nxp.com

diff --git a/arch/powerpc/mm/nohash/tlb_low.S b/arch/powerpc/mm/nohash/tlb_low.S
index 2ca407cedbe7..eaeee402f96e 100644
--- a/arch/powerpc/mm/nohash/tlb_low.S
+++ b/arch/powerpc/mm/nohash/tlb_low.S
@@ -397,7 +397,7 @@ _GLOBAL(set_context)
  * extern void loadcam_entry(unsigned int index)
  *
  * Load TLBCAM[index] entry in to the L2 CAM MMU
- * Must preserve r7, r8, r9, and r10
+ * Must preserve r7, r8, r9, r10 and r11
  */
 _GLOBAL(loadcam_entry)
 	mflr	r5
@@ -433,6 +433,10 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_BIG_PHYS)
  */
 _GLOBAL(loadcam_multi)
 	mflr	r8
+	/* Don't switch to AS=1 if already there */
+	mfmsr	r11
+	andi.	r11,r11,MSR_IS
+	bne	10f
 
 	/*
 	 * Set up temporary TLB entry that is the same as what we're
@@ -458,6 +462,7 @@ _GLOBAL(loadcam_multi)
 	mtmsr	r6
 	isync
 
+10:
 	mr	r9,r3
 	add	r10,r3,r4
 2:	bl	loadcam_entry
@@ -466,6 +471,10 @@ _GLOBAL(loadcam_multi)
 	mr	r3,r9
 	blt	2b
 
+	/* Don't return to AS=0 if we were in AS=1 at function start */
+	andi.	r11,r11,MSR_IS
+	bne	3f
+
 	/* Return to AS=0 and clear the temporary entry */
 	mfmsr	r6
 	rlwinm.	r6,r6,0,~(MSR_IS|MSR_DS)
@@ -481,6 +490,7 @@ _GLOBAL(loadcam_multi)
 	tlbwe
 	isync
 
+3:
 	mtlr	r8
 	blr
 #endif

