Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CF61AC2C3
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896620AbgDPNc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896556AbgDPNcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:32:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D020221F9;
        Thu, 16 Apr 2020 13:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043896;
        bh=ZvkWGyVyXoU3fn/f085zajaeF163Rb5c896Mue3TRZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaeZY9qF50Gu2Y+GaoKq4KFknUI9wJocwRt4VWLnV34eJr9Vg9UN8PD6VPJp+qwpm
         at92FmXSL4fRUKnprB8FKwB2CVZxnSQa2nf4f9dZynwrBJpuJEUFn7ByYT26sJbOsw
         aonmo/BgZ0JVLbLQOASv6eMgISaIIgMq1Isgd4/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Scott Wood <oss@buserror.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 144/146] powerpc/fsl_booke: Avoid creating duplicate tlb1 entry
Date:   Thu, 16 Apr 2020 15:24:45 +0200
Message-Id: <20200416131302.052157709@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
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
index e066a658acac6..56f58a362ea56 100644
--- a/arch/powerpc/mm/tlb_nohash_low.S
+++ b/arch/powerpc/mm/tlb_nohash_low.S
@@ -402,7 +402,7 @@ _GLOBAL(set_context)
  * extern void loadcam_entry(unsigned int index)
  *
  * Load TLBCAM[index] entry in to the L2 CAM MMU
- * Must preserve r7, r8, r9, and r10
+ * Must preserve r7, r8, r9, r10 and r11
  */
 _GLOBAL(loadcam_entry)
 	mflr	r5
@@ -438,6 +438,10 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_BIG_PHYS)
  */
 _GLOBAL(loadcam_multi)
 	mflr	r8
+	/* Don't switch to AS=1 if already there */
+	mfmsr	r11
+	andi.	r11,r11,MSR_IS
+	bne	10f
 
 	/*
 	 * Set up temporary TLB entry that is the same as what we're
@@ -463,6 +467,7 @@ _GLOBAL(loadcam_multi)
 	mtmsr	r6
 	isync
 
+10:
 	mr	r9,r3
 	add	r10,r3,r4
 2:	bl	loadcam_entry
@@ -471,6 +476,10 @@ _GLOBAL(loadcam_multi)
 	mr	r3,r9
 	blt	2b
 
+	/* Don't return to AS=0 if we were in AS=1 at function start */
+	andi.	r11,r11,MSR_IS
+	bne	3f
+
 	/* Return to AS=0 and clear the temporary entry */
 	mfmsr	r6
 	rlwinm.	r6,r6,0,~(MSR_IS|MSR_DS)
@@ -486,6 +495,7 @@ _GLOBAL(loadcam_multi)
 	tlbwe
 	isync
 
+3:
 	mtlr	r8
 	blr
 #endif
-- 
2.20.1



