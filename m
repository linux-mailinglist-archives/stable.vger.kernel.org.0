Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69048557F99
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiFWQRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiFWQRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:17:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AEE457B5
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBC1DB82474
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 16:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D890C3411B;
        Thu, 23 Jun 2022 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656001065;
        bh=w9vssxCnAThHd+BSfh0MhxhvWTeLf0gzQ97pqxEjOn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BlJiREW2V3hHeWtzrlNMeDp/oWNKohPJ+M83xsi5FtaoK3glAnJ53kv4DhFhCF7v1
         DGaT2LqVWn+VOQCv9I06UcdV09IhwDmqfu+95UVMxXevk7Mne/xFXpgTNL1NjjRpVj
         p3HS7CZesPauJ6HzZWzUkZ9wZBLk4yfBbgbAMb18=
Date:   Thu, 23 Jun 2022 18:17:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     stable@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: Re: [PATCH stable-5.15] arm64: mm: Don't invalidate FROM_DEVICE
 buffers at start of DMA transfer
Message-ID: <YrSSJMKL/GL45GA3@kroah.com>
References: <20220623154412.1117070-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623154412.1117070-1-catalin.marinas@arm.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 04:44:12PM +0100, Catalin Marinas wrote:
> From: Will Deacon <will@kernel.org>
> 
> commit c50f11c6196f45c92ca48b16a5071615d4ae0572 upstream.
> 
> Invalidating the buffer memory in arch_sync_dma_for_device() for
> FROM_DEVICE transfers
> 
> When using the streaming DMA API to map a buffer prior to inbound
> non-coherent DMA (i.e. DMA_FROM_DEVICE), we invalidate any dirty CPU
> cachelines so that they will not be written back during the transfer and
> corrupt the buffer contents written by the DMA. This, however, poses two
> potential problems:
> 
>   (1) If the DMA transfer does not write to every byte in the buffer,
>       then the unwritten bytes will contain stale data once the transfer
>       has completed.
> 
>   (2) If the buffer has a virtual alias in userspace, then stale data
>       may be visible via this alias during the period between performing
>       the cache invalidation and the DMA writes landing in memory.
> 
> Address both of these issues by cleaning (aka writing-back) the dirty
> lines in arch_sync_dma_for_device(DMA_FROM_DEVICE) instead of discarding
> them using invalidation.
> 
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20220606152150.GA31568@willie-the-truck
> Signed-off-by: Will Deacon <will@kernel.org>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> Link: https://lore.kernel.org/r/20220610151228.4562-2-will@kernel.org
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/mm/cache.S | 2 --
>  1 file changed, 2 deletions(-)

All now queued up, thanks.

greg k-h
