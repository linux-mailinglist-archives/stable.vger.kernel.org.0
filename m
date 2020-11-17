Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740AD2B64BC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbgKQNs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:48:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731678AbgKQNev (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 736A22467A;
        Tue, 17 Nov 2020 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620090;
        bh=7ztnYkMLU7W1/hYN9RH7Mo/BzV5XRX/k8BGYnIAvE5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBXgzqVLeh4FpoJRGx1soQeaYrcDea4HQfsvrMk3IQNt6zV8DlHNhz5pEUn+tJGJM
         w6poV44o0rYEsDDkf950KL3DADMRKK8IF/53QO1LQuWdPdE1XN1xcuFmPNv8janf/h
         fXZHXssVjTeIPlg386+Ywur0+rndanqNAQsQ5UkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        linux-mm@kvack.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 104/255] ARC: [plat-hsdk] Remap CCMs super early in asm boot trampoline
Date:   Tue, 17 Nov 2020 14:04:04 +0100
Message-Id: <20201117122144.020937696@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit 3b57533b460c8dc22a432684b7e8d22571f34d2e ]

ARC HSDK platform stopped booting on released v5.10-rc1, getting stuck
in startup of non master SMP cores.

This was bisected to upstream commit 7fef431be9c9ac25
"(mm/page_alloc: place pages to tail in __free_pages_core())"
That commit itself is harmless, it just exposed a subtle assumption in
our platform code (hence CC'ing linux-mm just as FYI in case some other
arches / platforms trip on it).

The upstream commit is semantically disruptive as it reverses the order
of page allocations (actually it can be good test for hardware
verification to exercise different memory patterns altogether).
For ARC HSDK platform that meant a remapped memory region (pertaining to
unused Closely Coupled Memory) started getting used early for dynamice
allocations, while not effectively remapped on all the cores, triggering
memory error exception on those cores.

The fix is to move the CCM remapping from early platform code to to early core
boot code. And while it is undesirable to riddle common boot code with
platform quirks, there is no other way to do this since the faltering code
involves setting up stack itself so even function calls are not allowed at
that point.

If anyone is interested, all the gory details can be found at Link below.

Link: https://github.com/foss-for-synopsys-dwc-arc-processors/linux/issues/32
Cc: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/kernel/head.S        | 17 ++++++++++++++++-
 arch/arc/plat-hsdk/platform.c | 17 -----------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arc/kernel/head.S b/arch/arc/kernel/head.S
index 17fd1ed700cca..9152782444b55 100644
--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -67,7 +67,22 @@
 	sr	r5, [ARC_REG_LPB_CTRL]
 1:
 #endif /* CONFIG_ARC_LPB_DISABLE */
-#endif
+
+	/* On HSDK, CCMs need to remapped super early */
+#ifdef CONFIG_ARC_SOC_HSDK
+	mov	r6, 0x60000000
+	lr	r5, [ARC_REG_ICCM_BUILD]
+	breq	r5, 0, 1f
+	sr	r6, [ARC_REG_AUX_ICCM]
+1:
+	lr	r5, [ARC_REG_DCCM_BUILD]
+	breq	r5, 0, 2f
+	sr	r6, [ARC_REG_AUX_DCCM]
+2:
+#endif	/* CONFIG_ARC_SOC_HSDK */
+
+#endif	/* CONFIG_ISA_ARCV2 */
+
 	; Config DSP_CTRL properly, so kernel may use integer multiply,
 	; multiply-accumulate, and divide operations
 	DSP_EARLY_INIT
diff --git a/arch/arc/plat-hsdk/platform.c b/arch/arc/plat-hsdk/platform.c
index 0b961a2a10b8e..22c9e2c9c0283 100644
--- a/arch/arc/plat-hsdk/platform.c
+++ b/arch/arc/plat-hsdk/platform.c
@@ -17,22 +17,6 @@ int arc_hsdk_axi_dmac_coherent __section(.data) = 0;
 
 #define ARC_CCM_UNUSED_ADDR	0x60000000
 
-static void __init hsdk_init_per_cpu(unsigned int cpu)
-{
-	/*
-	 * By default ICCM is mapped to 0x7z while this area is used for
-	 * kernel virtual mappings, so move it to currently unused area.
-	 */
-	if (cpuinfo_arc700[cpu].iccm.sz)
-		write_aux_reg(ARC_REG_AUX_ICCM, ARC_CCM_UNUSED_ADDR);
-
-	/*
-	 * By default DCCM is mapped to 0x8z while this area is used by kernel,
-	 * so move it to currently unused area.
-	 */
-	if (cpuinfo_arc700[cpu].dccm.sz)
-		write_aux_reg(ARC_REG_AUX_DCCM, ARC_CCM_UNUSED_ADDR);
-}
 
 #define ARC_PERIPHERAL_BASE	0xf0000000
 #define CREG_BASE		(ARC_PERIPHERAL_BASE + 0x1000)
@@ -339,5 +323,4 @@ static const char *hsdk_compat[] __initconst = {
 MACHINE_START(SIMULATION, "hsdk")
 	.dt_compat	= hsdk_compat,
 	.init_early     = hsdk_init_early,
-	.init_per_cpu	= hsdk_init_per_cpu,
 MACHINE_END
-- 
2.27.0



