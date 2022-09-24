Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBEA5E8A33
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 10:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIXIi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 04:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiIXIi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 04:38:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D0713F12
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 01:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D45B60ADF
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 08:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412EAC433D6;
        Sat, 24 Sep 2022 08:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664008736;
        bh=DNjKoLJ9/G0vC0Yqyrqnfi/MrL2AWl1bfawhg4ZotF4=;
        h=Subject:To:Cc:From:Date:From;
        b=F2dwLZlpHf49chDL8jwn+1Smtvwb0MBHoVld2X4+ykBEVmsEKOAFICYYFg7uoRTSh
         RmfolEqz+LgzTQdtT3DKnYIA3gIu7ibuQOmBEQ0Uq8/z6U56tW+bEgM91MHOICykgb
         AYjSj8Osc7WIJOMmy/hAO0zHLo37mhNIkFKyhI68=
Subject: FAILED: patch "[PATCH] RISC-V: Clean up the Zicbom block size probing" failed to apply to 5.19-stable tree
To:     palmer@rivosinc.com, ajones@ventanamicro.com, atishp@rivosinc.com,
        conor.dooley@microchip.com, heiko@sntech.de, lkp@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Sep 2022 10:38:53 +0200
Message-ID: <1664008733441@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8f7e001e0325 ("RISC-V: Clean up the Zicbom block size probing")
3aefb2ee5bdd ("riscv: implement Zicbom-based CMO instructions + the t-head variant")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8f7e001e0325de63a42f23342ac3b8139150c5cf Mon Sep 17 00:00:00 2001
From: Palmer Dabbelt <palmer@rivosinc.com>
Date: Mon, 12 Sep 2022 23:48:01 +0100
Subject: [PATCH] RISC-V: Clean up the Zicbom block size probing

This fixes two issues: I truncated the warning's hart ID when porting to
the 64-bit hart ID code, and the original code's warning handling could
fire on an uninitialized hart ID.

The biggest change here is that riscv_cbom_block_size is no longer
initialized, as IMO the default isn't sane: there's nothing in the ISA
that mandates any specific cache block size, so falling back to one will
just silently produce the wrong answer on some systems.  This also
changes the probing order so the cache block size is known before
enabling Zicbom support.

CC: stable@vger.kernel.org
CC: Andrew Jones <ajones@ventanamicro.com>
CC: Heiko Stuebner <heiko@sntech.de>
CC: Atish Patra <atishp@rivosinc.com>
Fixes: 3aefb2ee5bdd ("riscv: implement Zicbom-based CMO instructions + the t-head variant")
Fixes: 1631ba1259d6 ("riscv: Add support for non-coherent devices using zicbom extension")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
[Conor: fixed the redefinition errors]
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220912224800.998121-1-mail@conchuod.ie
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
index 202c83f677b2..96648c176f37 100644
--- a/arch/riscv/errata/thead/errata.c
+++ b/arch/riscv/errata/thead/errata.c
@@ -37,6 +37,7 @@ static bool errata_probe_cmo(unsigned int stage,
 	if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
 		return false;
 
+	riscv_cbom_block_size = L1_CACHE_BYTES;
 	riscv_noncoherent_supported();
 	return true;
 #else
diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index a60acaecfeda..a89c005b4bbf 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -43,6 +43,7 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_RISCV_ISA_ZICBOM
+extern unsigned int riscv_cbom_block_size;
 void riscv_init_cbom_blocksize(void);
 #else
 static inline void riscv_init_cbom_blocksize(void) { }
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 95ef6e2bf45c..2dfc463b86bb 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -296,8 +296,8 @@ void __init setup_arch(char **cmdline_p)
 	setup_smp();
 #endif
 
-	riscv_fill_hwcap();
 	riscv_init_cbom_blocksize();
+	riscv_fill_hwcap();
 	apply_boot_alternatives();
 }
 
diff --git a/arch/riscv/mm/dma-noncoherent.c b/arch/riscv/mm/dma-noncoherent.c
index cd2225304c82..e3f9bdf47c5f 100644
--- a/arch/riscv/mm/dma-noncoherent.c
+++ b/arch/riscv/mm/dma-noncoherent.c
@@ -12,7 +12,7 @@
 #include <linux/of_device.h>
 #include <asm/cacheflush.h>
 
-static unsigned int riscv_cbom_block_size = L1_CACHE_BYTES;
+unsigned int riscv_cbom_block_size;
 static bool noncoherent_supported;
 
 void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
@@ -79,38 +79,41 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 void riscv_init_cbom_blocksize(void)
 {
 	struct device_node *node;
+	unsigned long cbom_hartid;
+	u32 val, probed_block_size;
 	int ret;
-	u32 val;
 
+	probed_block_size = 0;
 	for_each_of_cpu_node(node) {
 		unsigned long hartid;
-		int cbom_hartid;
 
 		ret = riscv_of_processor_hartid(node, &hartid);
 		if (ret)
 			continue;
 
-		if (hartid < 0)
-			continue;
-
 		/* set block-size for cbom extension if available */
 		ret = of_property_read_u32(node, "riscv,cbom-block-size", &val);
 		if (ret)
 			continue;
 
-		if (!riscv_cbom_block_size) {
-			riscv_cbom_block_size = val;
+		if (!probed_block_size) {
+			probed_block_size = val;
 			cbom_hartid = hartid;
 		} else {
-			if (riscv_cbom_block_size != val)
-				pr_warn("cbom-block-size mismatched between harts %d and %lu\n",
+			if (probed_block_size != val)
+				pr_warn("cbom-block-size mismatched between harts %lu and %lu\n",
 					cbom_hartid, hartid);
 		}
 	}
+
+	if (probed_block_size)
+		riscv_cbom_block_size = probed_block_size;
 }
 #endif
 
 void riscv_noncoherent_supported(void)
 {
+	WARN(!riscv_cbom_block_size,
+	     "Non-coherent DMA support enabled without a block size\n");
 	noncoherent_supported = true;
 }

