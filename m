Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446C6546933
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiFJPNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiFJPNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 11:13:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5969C5B
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54A0B61F7C
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 15:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251D6C341C0;
        Fri, 10 Jun 2022 15:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654873979;
        bh=/N4kt8tL+7p6YrFOAl4Ta619t84QRyVreBncJO9IHaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oW0O7dtjGOZ4Kgw1KnlEd60hohaAmJItETFUBcdckHmjbPqJhxtit6o2ifYuWaNpL
         n78zcSqaSlKIyhjtEZkShLNHak5dzge+3Jc75lsVKnrAEN32kzS4XU4jiZ4FQa8ua9
         mcGb/lIVtPRDAOLUo4KurOl1w9bij1U5r1UkHbWHAW7fFiFT1emFIZLp03Y36EA1Xy
         xbV55eJABbVxS8+qKeZlbi0M6bKbp3OBIG1ZUfkYY/b/vwnE7O1Gv7ja1cA4nfOnMv
         7MmSghTa/cFEACowJkm04GWzofrZJouWTRqdae4/cLLY1vut5r5ZcJKaJgxeXdMqQH
         W/P5ot7rro5/w==
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Russell King <linux@armlinux.org.uk>, stable@vger.kernel.org
Subject: [PATCH 1/2] arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer
Date:   Fri, 10 Jun 2022 16:12:27 +0100
Message-Id: <20220610151228.4562-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220610151228.4562-1-will@kernel.org>
References: <20220610151228.4562-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220606152150.GA31568@willie-the-truck
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/mm/cache.S | 2 --
 1 file changed, 2 deletions(-)

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
-- 
2.36.1.476.g0c4daa206d-goog

