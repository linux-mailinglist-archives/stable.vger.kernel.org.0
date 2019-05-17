Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 515322181E
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfEQMZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:25:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41985 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728073AbfEQMZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:25:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AF90424874;
        Fri, 17 May 2019 08:25:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RYQTZF
        OAODq28sDbVfmht3jJtjesuJYIFeGAbVKilS8=; b=nLg+lUYmSGn2HU3q4HIiPo
        gGzITLYoAUQ6C3rbFzxR/RbSc54inbEn38HiwyxEsC0svRqzgeIBC1h1szDrtTeo
        nRQTyD/92GiKrfBg6vKbq+t54OWzWWlw/3WlBlzMLUDk5FqnU/2dm40e+P6YDZMF
        lriKqlpnYjoENV+u7Au14SOzzHIUpA3tf4UUulWiH6chcayErto9IGmLbqIb8iEf
        Q/vRXSe/H0y1gaydG0s2z2rcJRz0c+XazjN6pncHnUc/dQsd8r4ZCcGgSxkp9Wve
        RyU12wDJCKMvQMY7tgSJtlHzgrmEvS71bDBVxV1Ljf8O4ovBBax1pYHPQ38ubPog
        ==
X-ME-Sender: <xms:Q6jeXEvkhfl6ZAOVAmrashiFHunXJlk-xJwWxW82vbuvqK_IBiXNmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehprhhotgdrshgsnecukfhppeekfedrkeeirdekledruddtje
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehl
    uhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Q6jeXEiXtjhXqYzMAOVNfFyflj_Rt7x0dA8WPMFrC3eRxA232-UUbg>
    <xmx:Q6jeXKbxJnTRZnWYbQ3NPlkG-miCsk6pSatZB9l5_XiqLhtHl2yXeg>
    <xmx:Q6jeXDZ_ugMsG3YCaOPSj6tvYgL2Av1vVfi2PsGj4-gy90IjCtmcMA>
    <xmx:Q6jeXMIdrS4bj1fC94biaPAOyH8LwIZySxt0ISEWGSsqj6uf6kL03w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0C0671037C;
        Fri, 17 May 2019 08:25:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Save and restore OSDLR_EL1 across suspend/resume" failed to apply to 4.9-stable tree
To:     jean-philippe.brucker@arm.com, stable@vger.kernel.org,
        will.deacon@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:25:37 +0200
Message-ID: <155809593723029@kroah.com>
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

From 827a108e354db633698f0b4a10c1ffd2b1f8d1d0 Mon Sep 17 00:00:00 2001
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Date: Mon, 8 Apr 2019 18:17:19 +0100
Subject: [PATCH] arm64: Save and restore OSDLR_EL1 across suspend/resume

When the CPU comes out of suspend, the firmware may have modified the OS
Double Lock Register. Save it in an unused slot of cpu_suspend_ctx, and
restore it on resume.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index aa0817c9c4c3..fdd626d34274 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -65,24 +65,25 @@ ENTRY(cpu_do_suspend)
 	mrs	x2, tpidr_el0
 	mrs	x3, tpidrro_el0
 	mrs	x4, contextidr_el1
-	mrs	x5, cpacr_el1
-	mrs	x6, tcr_el1
-	mrs	x7, vbar_el1
-	mrs	x8, mdscr_el1
-	mrs	x9, oslsr_el1
-	mrs	x10, sctlr_el1
+	mrs	x5, osdlr_el1
+	mrs	x6, cpacr_el1
+	mrs	x7, tcr_el1
+	mrs	x8, vbar_el1
+	mrs	x9, mdscr_el1
+	mrs	x10, oslsr_el1
+	mrs	x11, sctlr_el1
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-	mrs	x11, tpidr_el1
+	mrs	x12, tpidr_el1
 alternative_else
-	mrs	x11, tpidr_el2
+	mrs	x12, tpidr_el2
 alternative_endif
-	mrs	x12, sp_el0
+	mrs	x13, sp_el0
 	stp	x2, x3, [x0]
-	stp	x4, xzr, [x0, #16]
-	stp	x5, x6, [x0, #32]
-	stp	x7, x8, [x0, #48]
-	stp	x9, x10, [x0, #64]
-	stp	x11, x12, [x0, #80]
+	stp	x4, x5, [x0, #16]
+	stp	x6, x7, [x0, #32]
+	stp	x8, x9, [x0, #48]
+	stp	x10, x11, [x0, #64]
+	stp	x12, x13, [x0, #80]
 	ret
 ENDPROC(cpu_do_suspend)
 
@@ -105,8 +106,8 @@ ENTRY(cpu_do_resume)
 	msr	cpacr_el1, x6
 
 	/* Don't change t0sz here, mask those bits when restoring */
-	mrs	x5, tcr_el1
-	bfi	x8, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
+	mrs	x7, tcr_el1
+	bfi	x8, x7, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
 
 	msr	tcr_el1, x8
 	msr	vbar_el1, x9
@@ -130,6 +131,7 @@ alternative_endif
 	/*
 	 * Restore oslsr_el1 by writing oslar_el1
 	 */
+	msr	osdlr_el1, x5
 	ubfx	x11, x11, #1, #1
 	msr	oslar_el1, x11
 	reset_pmuserenr_el0 x0			// Disable PMU access from EL0

