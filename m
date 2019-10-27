Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D595E62C1
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfJ0Nxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:53:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33763 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfJ0Nxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 09:53:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 04A4421C47;
        Sun, 27 Oct 2019 09:53:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 09:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZKE146
        UcM3hJ+b05UCrBYW4ifE1bRvWBk6Q37nDCSvA=; b=SfvwgKygGwBqgtIeYOrqax
        iarg6jCy5xeTMrVRMio3vvD4/V/w8vckMJRY206xO931O8raKwOhAuBvFdH+fkr7
        R8WMj1lLsCNRrOZQh5y6Whn4TRlR8bnUGcGkNr4gmWQd2+sCdOWJIxR9a0yLcgWh
        8a6PPuwURypyPCyUHQS/agJSaOKoMg+Mz6Txgcu5yt75BAwEpFEIPa7T6X1Rm5xk
        rcUJKcu9Rhxf/+d8O0lpmuA7WVSO8/MQFqykf4JhbfPlR/FHlzoNwmtUiBwGNLVQ
        VI1Kx1CHYwkLT6zC7EdTq+xGusFIqIPyL9AyUYF3ShaRl5R0Gig8euChHt2hBrfg
        ==
X-ME-Sender: <xms:aKG1XRbKG1lK7lEv6fyszt8QCMmB3SiCrI5lyKPYhYw10lGxqlx7_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepvghnthhrhidrshgsnecukfhppeejjedrvdeguddrvddvledrvd
    efvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:aKG1XYL6e92DSXQVGo01yyST7DxUI7frL7MJDxzBvyYoN4kXnKbWoA>
    <xmx:aKG1XWcZ-rgro-KY5bR4BM9ocExzYD41TSAABBrmLw9rFrPeR_dA4w>
    <xmx:aKG1Xe9c6QiTx7_jApM-WBjvf8xqxgsM41BPHm9r-UlOReZlg77TLA>
    <xmx:aaG1XfFb9x9glMHj3bk0PCD0GGZz1k6pSZVf2TFQ2_wfwkwSC6sPXQ>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2989D6005B;
        Sun, 27 Oct 2019 09:53:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Avoid Cavium TX2 erratum 219 when switching TTBR" failed to apply to 4.9-stable tree
To:     maz@kernel.org, marc.zyngier@arm.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 14:53:34 +0100
Message-ID: <157218441453131@kroah.com>
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

