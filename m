Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB84E62C3
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfJ0Nxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:53:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57419 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfJ0Nxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 09:53:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 373D121C47;
        Sun, 27 Oct 2019 09:53:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 09:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4OC1RA
        LAR43N1os1NYrIThL24RQf7a0mxruzZQBgUok=; b=xpEb926IfyAcLgtyPrAaRd
        OfJFM2oBLObquh7piFQ0M1JwwJRSxvvwu8MGdD0w2JpJnIxG8U6ALUlRCVkESQ0W
        KOYhj/QZWoKZt10NriXYRpnp3W9nkciiL8YlN/fANmOntlsIZY8ivzrK5va01CLZ
        9Pq9Kqu22YEidXhy0Wzi2icbaYDbJrd257bbJAjIBAVgUDtuE69H2p/NTvzcBbcP
        NbAai4lL0P07RqRlthhNUIZed+xgvOlk9qlyC4DgBduQZzjeZewhjRRuu8cFgacM
        nRT0I3FrIH2lvF2LA4p4oS+LvV7LE+jWqL4EghAg6/gxE+Ulgmibnc+ljYNaT5Mw
        ==
X-ME-Sender: <xms:a6G1XTiv1IArH3hyKwoHuNb0LB6MIC25VUl2v8lzr6nSRfdKT-ODFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepvghnthhrhidrshgsnecukfhppeejjedrvdeguddrvddvledrvd
    efvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:a6G1XXsBPPouxy3x3xWV5YCJL8iw9k3AGTnstIGQwBcVBDZ-kTKsDw>
    <xmx:a6G1XVQz895KbeNnE23znTDM5imhK_Sd_VwkUmNllOrViF7S1k3Urw>
    <xmx:a6G1Xe_Xw19WFzCuVB-5NaNosM8jvQWfZgcvacuErrv7m7MwUJZ3fw>
    <xmx:a6G1XVOmSJbCH4U-8feXy9u_aZ5B1uF_IxphqChmIQisoOOPQFTmZQ>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id E7A98D6005B;
        Sun, 27 Oct 2019 09:53:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Avoid Cavium TX2 erratum 219 when switching TTBR" failed to apply to 4.14-stable tree
To:     maz@kernel.org, marc.zyngier@arm.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 14:53:34 +0100
Message-ID: <15721844147973@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9405447ef79bc93101373e130f72e9e6cbf17dbb Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Tue, 9 Apr 2019 16:22:24 +0100
Subject: [PATCH] arm64: Avoid Cavium TX2 erratum 219 when switching TTBR

As a PRFM instruction racing against a TTBR update can have undesirable
effects on TX2, NOP-out such PRFM on cores that are affected by
the TX2-219 erratum.

Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index e81e0cbd728f..ac1dbca3d0cd 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -53,7 +53,8 @@
 #define ARM64_HAS_DCPODP			43
 #define ARM64_WORKAROUND_1463225		44
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_TVM	45
+#define ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM	46
 
-#define ARM64_NCAPS				46
+#define ARM64_NCAPS				47
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index d999ca2dd760..a19bb3e4bcfb 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -884,6 +884,11 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(tx2_family_cpus),
 		.matches = needs_tx2_tvm_workaround,
 	},
+	{
+		.desc = "Cavium ThunderX2 erratum 219 (PRFM removal)",
+		.capability = ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM,
+		ERRATA_MIDR_RANGE_LIST(tx2_family_cpus),
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 84a822748c84..109894bd3194 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1070,7 +1070,9 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 #else
 	ldr	x30, =vectors
 #endif
+alternative_if_not ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM
 	prfm	plil1strm, [x30, #(1b - tramp_vectors)]
+alternative_else_nop_endif
 	msr	vbar_el1, x30
 	add	x30, x30, #(1b - tramp_vectors)
 	isb

