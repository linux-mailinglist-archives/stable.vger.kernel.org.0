Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402D155199E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243780AbiFTNES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244350AbiFTNDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:03:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0001E3D2;
        Mon, 20 Jun 2022 05:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81ED4B811A0;
        Mon, 20 Jun 2022 12:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94840C3411B;
        Mon, 20 Jun 2022 12:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729887;
        bh=GCtSDrZL6nWMsE7xon+QL1MQ8Yl7NvnYp4rWylqCoIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCUJGHDDK37iSZgYKphCmlX/yEf9T9faWSN0y8FjgYFPwPnzXLzx9HiwXThbH6pr1
         JgZJu5sDUD6GEYks6ndhKjktxAjoMSEg19ElLllMy62/38UfVZePnwPgGWZaMw+zcj
         v/CNQG+i/LmYaqn+7x1Gha+AFdkrqbD0TeVj7Xzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.18 106/141] arm64: mm: Dont invalidate FROM_DEVICE buffers at start of DMA transfer
Date:   Mon, 20 Jun 2022 14:50:44 +0200
Message-Id: <20220620124732.676698576@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/cache.S |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -218,8 +218,6 @@ SYM_FUNC_ALIAS(__dma_flush_area, __pi___
  */
 SYM_FUNC_START(__pi___dma_map_area)
 	add	x1, x0, x1
-	cmp	w2, #DMA_FROM_DEVICE
-	b.eq	__pi_dcache_inval_poc
 	b	__pi_dcache_clean_poc
 SYM_FUNC_END(__pi___dma_map_area)
 SYM_FUNC_ALIAS(__dma_map_area, __pi___dma_map_area)


