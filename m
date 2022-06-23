Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A045557EC8
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiFWPnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 11:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiFWPnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 11:43:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6999FDA
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 08:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D83AB82452
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 15:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31074C3411B;
        Thu, 23 Jun 2022 15:42:56 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH stable-5.4] arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer
Date:   Thu, 23 Jun 2022 16:42:53 +0100
Message-Id: <20220623154253.1116556-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit c50f11c6196f45c92ca48b16a5071615d4ae0572 upstream.

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
---
 arch/arm64/mm/cache.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index db767b072601..7b054c67acd8 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -228,8 +228,6 @@ ENDPIPROC(__dma_flush_area)
  *	- dir	- DMA direction
  */
 ENTRY(__dma_map_area)
-	cmp	w2, #DMA_FROM_DEVICE
-	b.eq	__dma_inv_area
 	b	__dma_clean_area
 ENDPIPROC(__dma_map_area)
 
