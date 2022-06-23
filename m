Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9BE5584DD
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiFWRuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbiFWRtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25C69E355;
        Thu, 23 Jun 2022 10:11:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D84DF61DB3;
        Thu, 23 Jun 2022 17:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AA6C341C4;
        Thu, 23 Jun 2022 17:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004310;
        bh=c9tV+XAW1U7gLTUoTDUTdUivRWmlSoKf2p+/DeF7wLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUtMlxPEYTI2attWflo9c/DgDoAwpFjqHBl8aJSaAiUV4zAJNBPKHKnN9lxH7bHZz
         Xf8+Z0km0ZKWwMTdj2btIty9GCAvjNJfPuVf1YIyjLQ9RQcN0qLdYOFohmpWuQdFvo
         0rsVKvyWwhqpax/kT2CNPPuLvPe6f0tJCnxUjBv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 11/11] arm64: mm: Dont invalidate FROM_DEVICE buffers at start of DMA transfer
Date:   Thu, 23 Jun 2022 18:44:44 +0200
Message-Id: <20220623164322.628022749@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.296526800@linuxfoundation.org>
References: <20220623164322.296526800@linuxfoundation.org>
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
@@ -228,8 +228,6 @@ SYM_FUNC_END_PI(__dma_flush_area)
  *	- dir	- DMA direction
  */
 SYM_FUNC_START_PI(__dma_map_area)
-	cmp	w2, #DMA_FROM_DEVICE
-	b.eq	__dma_inv_area
 	b	__dma_clean_area
 SYM_FUNC_END_PI(__dma_map_area)
 


