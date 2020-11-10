Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173212ACDDA
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732121AbgKJDyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732343AbgKJDyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4475B20E65;
        Tue, 10 Nov 2020 03:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980440;
        bh=7ztnYkMLU7W1/hYN9RH7Mo/BzV5XRX/k8BGYnIAvE5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQI18QboP1syENeLqHdJ2nopNCVVOJMbyL+4ohkezbk/wqubQybEwXjSXfNynfUcD
         tRq0XP5Yzxg82JjKYgIZu0U8wvqsjhDUaW+7K5EpiBmNx26tRlCOjMXcVvb3MwesmV
         wLk+4HYnM0Nv7loi2wg0td+rZ098WN5eFbfoyxH4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 29/55] ARC: [plat-hsdk] Remap CCMs super early in asm boot trampoline
Date:   Mon,  9 Nov 2020 22:52:52 -0500
Message-Id: <20201110035318.423757-29-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

