Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE454F237E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 08:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiDEGop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 02:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiDEGop (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 02:44:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C054F53E13
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 23:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51A9361581
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 06:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F85C340F3;
        Tue,  5 Apr 2022 06:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649140966;
        bh=EitArPRowMsbnmF5bG5CUtWBcuBPX3OPGby+2lgYVd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PNHdn73VkVweDIqxONSv0R39eHYc1OZPPwPQOQmgQtBYgDMlvSKNc4UOVV1EHLFL3
         tQMbSHPaF+OILT/JxThwRm6bdcD7dt+jRwCDAfLttLMWKfcfTe2hgQzfRtHes/enD1
         VU849I3L/SAnFb8BmhgsIWqufCKX5d4bJu6O1xYQ=
Date:   Tue, 5 Apr 2022 08:42:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vijay Balakrishna <vijayb@linux.microsoft.com>
Cc:     stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [PATCH 5.10] arm64: Do not defer reserve_crashkernel() for
 platforms with no DMA memory zones
Message-ID: <Ykvk5CtXRzxZnyJM@kroah.com>
References: <1649119570-26089-1-git-send-email-vijayb@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1649119570-26089-1-git-send-email-vijayb@linux.microsoft.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 05:46:10PM -0700, Vijay Balakrishna wrote:
> commit 031495635b4668f94e964e037ca93d0d38bfde58 upstream.
> 
> The following patches resulted in deferring crash kernel reservation to
> mem_init(), mainly aimed at platforms with DMA memory zones (no IOMMU),
> in particular Raspberry Pi 4.
> 
> commit 1a8e1cef7603 ("arm64: use both ZONE_DMA and ZONE_DMA32")
> commit 8424ecdde7df ("arm64: mm: Set ZONE_DMA size based on devicetree's dma-ranges")
> commit 0a30c53573b0 ("arm64: mm: Move reserve_crashkernel() into mem_init()")
> commit 2687275a5843 ("arm64: Force NO_BLOCK_MAPPINGS if crashkernel reservation is required")
> 
> Above changes introduced boot slowdown due to linear map creation for
> all the memory banks with NO_BLOCK_MAPPINGS, see discussion[1].  The proposed
> changes restore crash kernel reservation to earlier behavior thus avoids
> slow boot, particularly for platforms with IOMMU (no DMA memory zones).
> 
> Tested changes to confirm no ~150ms boot slowdown on our SoC with IOMMU
> and 8GB memory.  Also tested with ZONE_DMA and/or ZONE_DMA32 configs to confirm
> no regression to deferring scheme of crash kernel memory reservation.
> In both cases successfully collected kernel crash dump.
> 
> [1] https://lore.kernel.org/all/9436d033-579b-55fa-9b00-6f4b661c2dd7@linux.microsoft.com/
> 
> Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Link: https://lore.kernel.org/r/1646242689-20744-1-git-send-email-vijayb@linux.microsoft.com
> [will: Add #ifdef CONFIG_KEXEC_CORE guards to fix 'crashk_res' references in allnoconfig build]
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/mm/init.c | 36 ++++++++++++++++++++++++++++++++----
>  arch/arm64/mm/mmu.c  | 32 +++++++++++++++++++++++++++++++-
>  2 files changed, 63 insertions(+), 5 deletions(-)

Now queued up, thanks.

greg k-h
