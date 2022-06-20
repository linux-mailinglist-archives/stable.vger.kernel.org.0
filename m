Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D84551273
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbiFTISi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239858AbiFTISg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:18:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F73D11A1F
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 01:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52E81612A0
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 08:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9CFC3411B;
        Mon, 20 Jun 2022 08:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655713113;
        bh=+C8DL/vM9Po+r7qqrnftap4ZHGbQKAuitpk9S92j6ww=;
        h=Subject:To:Cc:From:Date:From;
        b=OfwWyChAo/da6tow4dPl+vcIBg7K3dQVQoeCFwAM/G5970iWAORPH1WduJegpW/mw
         Md7BTgBfVxFMYCyGJIMXnP0LIoJJ1QZKKUiyXiO61C69HKXGRR3+0crRiW6h+UaYQd
         C4e0Wux8mqqKMhJzHDTBxzYxtnO3Ys/7r/YG/ZkY=
Subject: FAILED: patch "[PATCH] arm64: mm: Don't invalidate FROM_DEVICE buffers at start of" failed to apply to 5.4-stable tree
To:     will@kernel.org, ardb@kernel.org, catalin.marinas@arm.com,
        hch@lst.de, linux@armlinux.org.uk, robin.murphy@arm.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 10:18:20 +0200
Message-ID: <1655713100183167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c50f11c6196f45c92ca48b16a5071615d4ae0572 Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Fri, 10 Jun 2022 16:12:27 +0100
Subject: [PATCH] arm64: mm: Don't invalidate FROM_DEVICE buffers at start of
 DMA transfer

Invalidating the buffer memory in arch_sync_dma_for_device() for
FROM_DEVICE transfers

When using the streaming DMA API to map a buffer prior to inbound
non-coherent DMA (i.e. DMA_FROM_DEVICE), we invalidate any dirty CPU
cachelines so that they will not be written back during the transfer and
corrupt the buffer contents written by the DMA. This, however, poses two
potential problems:

  (1) If the DMA transfer does not write to every byte in the buffer,
      then the unwritten bytes will contain stale data once the transfer
      has completed.

  (2) If the buffer has a virtual alias in userspace, then stale data
      may be visible via this alias during the period between performing
      the cache invalidation and the DMA writes landing in memory.

Address both of these issues by cleaning (aka writing-back) the dirty
lines in arch_sync_dma_for_device(DMA_FROM_DEVICE) instead of discarding
them using invalidation.

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220606152150.GA31568@willie-the-truck
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20220610151228.4562-2-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 0ea6cc25dc66..21c907987080 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -218,8 +218,6 @@ SYM_FUNC_ALIAS(__dma_flush_area, __pi___dma_flush_area)
  */
 SYM_FUNC_START(__pi___dma_map_area)
 	add	x1, x0, x1
-	cmp	w2, #DMA_FROM_DEVICE
-	b.eq	__pi_dcache_inval_poc
 	b	__pi_dcache_clean_poc
 SYM_FUNC_END(__pi___dma_map_area)
 SYM_FUNC_ALIAS(__dma_map_area, __pi___dma_map_area)

