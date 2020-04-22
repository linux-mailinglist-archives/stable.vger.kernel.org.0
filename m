Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD2B1B41FB
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgDVKFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728176AbgDVKFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:05:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB5720774;
        Wed, 22 Apr 2020 10:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549923;
        bh=1wBsX03h36FiQnS3XC1J8G/JuRtRGfhMB4qHM++zCQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSBcaCHSsOtCv6UCd3aroKyjBw7l0b/A7wldVS/YVD0ihuoaCISQPFa6XRFHdOjKp
         8szKwutqJ66KBNw6ZZ/BpKIyLsp0nefJsemRgXhdSCBBnvgq18DOKnE0eAZ9uEFmhm
         gnYpboKGWbhejw8+p+xIlmpVWE7cPpmGafUoC3/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Scott Wood <oss@buserror.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 063/125] powerpc/fsl_booke: Avoid creating duplicate tlb1 entry
Date:   Wed, 22 Apr 2020 11:56:20 +0200
Message-Id: <20200422095043.529126957@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

[ Upstream commit aa4113340ae6c2811e046f08c2bc21011d20a072 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/tlb_nohash_low.S | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/tlb_nohash_low.S b/arch/powerpc/mm/tlb_nohash_low.S
index eabecfcaef7cf..204b4d9c44248 100644
--- a/arch/powerpc/mm/tlb_nohash_low.S
+++ b/arch/powerpc/mm/tlb_nohash_low.S
@@ -400,7 +400,7 @@ _GLOBAL(set_context)
  * extern void loadcam_entry(unsigned int index)
  *
  * Load TLBCAM[index] entry in to the L2 CAM MMU
- * Must preserve r7, r8, r9, and r10
+ * Must preserve r7, r8, r9, r10 and r11
  */
 _GLOBAL(loadcam_entry)
 	mflr	r5
@@ -436,6 +436,10 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_BIG_PHYS)
  */
 _GLOBAL(loadcam_multi)
 	mflr	r8
+	/* Don't switch to AS=1 if already there */
+	mfmsr	r11
+	andi.	r11,r11,MSR_IS
+	bne	10f
 
 	/*
 	 * Set up temporary TLB entry that is the same as what we're
@@ -461,6 +465,7 @@ _GLOBAL(loadcam_multi)
 	mtmsr	r6
 	isync
 
+10:
 	mr	r9,r3
 	add	r10,r3,r4
 2:	bl	loadcam_entry
@@ -469,6 +474,10 @@ _GLOBAL(loadcam_multi)
 	mr	r3,r9
 	blt	2b
 
+	/* Don't return to AS=0 if we were in AS=1 at function start */
+	andi.	r11,r11,MSR_IS
+	bne	3f
+
 	/* Return to AS=0 and clear the temporary entry */
 	mfmsr	r6
 	rlwinm.	r6,r6,0,~(MSR_IS|MSR_DS)
@@ -484,6 +493,7 @@ _GLOBAL(loadcam_multi)
 	tlbwe
 	isync
 
+3:
 	mtlr	r8
 	blr
 #endif
-- 
2.20.1



