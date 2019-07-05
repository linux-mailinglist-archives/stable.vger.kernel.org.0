Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185AF602AF
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 10:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfGEIyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 04:54:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56943 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbfGEIyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 04:54:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E5AF020931;
        Fri,  5 Jul 2019 04:54:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 05 Jul 2019 04:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=U6WXOW
        O9CjfQK+2mpr1/1T7i04uIL1Bk6Bm4mnLnRE0=; b=Z4yMAiijCatUXYuVrmAjB1
        h+HMxjU5A5KAYVPEFC111ycb7IHEkuM/UHj+B/sUUS2Or2BIKIrs2QXfFdJf0+nU
        nu/CNxN3YuFUbsjHzbsMYT6ecCNDRr7a5/grCO77HdItulfaSdRG62WjvZiQmvyj
        xnCNoN96mTuZOZuE1vFXP7SvX5p7rSOyKMqL3NcIvMtdO5W5iBXvtrRFDvQHTxLM
        dfmArcZF64JEkKETeIR20wwFmsv5v7UjQyH9ypMqt3At88YD9WuXcpRaM4GyROsa
        guDgSO6s056Hh3y4GVubHFdRl6WK7etmmUTCJSaLdLSeMXMWzgiC3J7Kan7rGc3g
        ==
X-ME-Sender: <xms:PhAfXbBt_YZXd-2gU524nUuNxOk9KxEPxo9LHswLFZsaVEIvHo-t1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeeggddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekgedruddviedrvdegvdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:PhAfXdIK1eVIExtoOqq3R0-7VF9Op1WmOzZ5Qfou20H8zgkZlTlBOQ>
    <xmx:PhAfXRC-6PNpvvU-Xd_rb2PyWfBgR5X-TqIFYydXor7T3fvGi-I5tg>
    <xmx:PhAfXbplCm8T-nf60LrLV9ECakpeQtGDN_skxxtI0I9EwrLjyj2-lQ>
    <xmx:PhAfXWdKOQNTSf-qPGuIbrG6_VszpnYyAjOLXsabASzf8hYtrWYgMA>
Received: from localhost (83-84-126-242.cable.dynamic.v4.ziggo.nl [83.84.126.242])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5704A380076;
        Fri,  5 Jul 2019 04:54:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: kaslr: keep modules inside module region when KASAN is" failed to apply to 4.9-stable tree
To:     ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        stable@vger.kernel.org, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 05 Jul 2019 10:54:20 +0200
Message-ID: <1562316860240248@kroah.com>
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

From 6f496a555d93db7a11d4860b9220d904822f586a Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 25 Jun 2019 19:08:54 +0200
Subject: [PATCH] arm64: kaslr: keep modules inside module region when KASAN is
 enabled

When KASLR and KASAN are both enabled, we keep the modules where they
are, and randomize the placement of the kernel so it is within 2 GB
of the module region. The reason for this is that putting modules in
the vmalloc region (like we normally do when KASLR is enabled) is not
possible in this case, given that the entire vmalloc region is already
backed by KASAN zero shadow pages, and so allocating dedicated KASAN
shadow space as required by loaded modules is not possible.

The default module allocation window is set to [_etext - 128MB, _etext]
in kaslr.c, which is appropriate for KASLR kernels booted without a
seed or with 'nokaslr' on the command line. However, as it turns out,
it is not quite correct for the KASAN case, since it still intersects
the vmalloc region at the top, where attempts to allocate shadow pages
will collide with the KASAN zero shadow pages, causing a WARN() and all
kinds of other trouble. So cap the top end to MODULES_END explicitly
when running with KASAN.

Cc: <stable@vger.kernel.org> # 4.9+
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index dd080837e6a9..ed3706d6b3a0 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -32,6 +32,7 @@
 
 void *module_alloc(unsigned long size)
 {
+	u64 module_alloc_end = module_alloc_base + MODULES_VSIZE;
 	gfp_t gfp_mask = GFP_KERNEL;
 	void *p;
 
@@ -39,9 +40,12 @@ void *module_alloc(unsigned long size)
 	if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
 		gfp_mask |= __GFP_NOWARN;
 
+	if (IS_ENABLED(CONFIG_KASAN))
+		/* don't exceed the static module region - see below */
+		module_alloc_end = MODULES_END;
+
 	p = __vmalloc_node_range(size, MODULE_ALIGN, module_alloc_base,
-				module_alloc_base + MODULES_VSIZE,
-				gfp_mask, PAGE_KERNEL_EXEC, 0,
+				module_alloc_end, gfp_mask, PAGE_KERNEL_EXEC, 0,
 				NUMA_NO_NODE, __builtin_return_address(0));
 
 	if (!p && IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&

