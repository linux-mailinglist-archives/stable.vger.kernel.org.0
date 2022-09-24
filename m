Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2A35E8A32
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 10:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiIXIie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 04:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiIXIid (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 04:38:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7B413F12
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 01:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0EF060BED
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 08:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23F7C433C1;
        Sat, 24 Sep 2022 08:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664008712;
        bh=oINJB7TXHwgvWM7AQEPXLYU0EeX37twjqgRXCIXRtyk=;
        h=Subject:To:Cc:From:Date:From;
        b=bKZMcwGtvBZrtLOZY1xsymUvaZf62HADhiMcPSh0++O9blVf2802INI7cXfi4aYGO
         WiGIMF+hH6+6GC1Ys7tJh1PRc1T6O8MXLJ2IGMCbUMClm0y6KqYL9iufJRTaDYJLNl
         l1uLGf49648TzJzyXdEsW+7eQjK8PAt52dq8YHmA=
Subject: FAILED: patch "[PATCH] riscv: make t-head erratas depend on MMU" failed to apply to 5.19-stable tree
To:     heiko@sntech.de, guoren@kernel.org, lkp@intel.com,
        palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Sep 2022 10:38:29 +0200
Message-ID: <1664008709163103@kroah.com>
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

2a2018c3ac84 ("riscv: make t-head erratas depend on MMU")
d20ec7529236 ("riscv: implement cache-management errata for T-Head SoCs")
1631ba1259d6 ("riscv: Add support for non-coherent devices using zicbom extension")
1771c8c9e65a ("riscv: remove usage of function-pointers from cpufeatures and t-head errata")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2a2018c3ac84c2dc7cfbad117ce9339ea0914622 Mon Sep 17 00:00:00 2001
From: Heiko Stuebner <heiko@sntech.de>
Date: Wed, 7 Sep 2022 17:49:32 +0200
Subject: [PATCH] riscv: make t-head erratas depend on MMU

Both basic extensions of SVPBMT and ZICBOM depend on CONFIG_MMU.
Make the T-Head errata implementations of the similar functionality
also depend on it to prevent build errors.

Fixes: a35707c3d850 ("riscv: add memory-type errata for T-Head")
Fixes: d20ec7529236 ("riscv: implement cache-management errata for T-Head SoCs")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Guo Ren <guoren@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220907154932.2858518-1-heiko@sntech.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/Kconfig.erratas b/arch/riscv/Kconfig.erratas
index 6850e9389930..f3623df23b5f 100644
--- a/arch/riscv/Kconfig.erratas
+++ b/arch/riscv/Kconfig.erratas
@@ -46,7 +46,7 @@ config ERRATA_THEAD
 
 config ERRATA_THEAD_PBMT
 	bool "Apply T-Head memory type errata"
-	depends on ERRATA_THEAD && 64BIT
+	depends on ERRATA_THEAD && 64BIT && MMU
 	select RISCV_ALTERNATIVE_EARLY
 	default y
 	help
@@ -57,7 +57,7 @@ config ERRATA_THEAD_PBMT
 
 config ERRATA_THEAD_CMO
 	bool "Apply T-Head cache management errata"
-	depends on ERRATA_THEAD
+	depends on ERRATA_THEAD && MMU
 	select RISCV_DMA_NONCOHERENT
 	default y
 	help

