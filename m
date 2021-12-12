Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357E3471A5E
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 14:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhLLNUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 08:20:31 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49436 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhLLNUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 08:20:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 66FCCCE0B16
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB906C341C5;
        Sun, 12 Dec 2021 13:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639315227;
        bh=fLKOWxFUOcNIL62kYCpWTg7U4RURJqQ9zh9VEyWk/HA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XPXipdkjeRFOdbq4IWdtCHCeOzPcil0yugeZXOwnOmSbmkmINgpFWK/CJBrbiqcVm
         AFwgkiVNTNdmrfUXgh6QZD0FSgqUxBLNZ2vf3kffQVbGnzU+MS2PSBG+T3ufQ2rBYI
         6JQtD7i05Z6t00LcCZ4wbXDd+uGMyVzBNsu3hue8=
Date:   Sun, 12 Dec 2021 14:20:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted
Message-ID: <YbX3GGdl+muJBWsY@kroah.com>
References: <2e06a99ba4c4b1bc6663605414f7518e4c43d188.1639243140.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e06a99ba4c4b1bc6663605414f7518e4c43d188.1639243140.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 11, 2021 at 11:19:00AM -0600, Tom Lendacky wrote:
> commit 1ff2fc02862d52e18fd3daabcfe840ec27e920a8 upstream
> to be applied to 4.14, 4.19 and 5.4.
> 
> Reserving memory using efi_mem_reserve() calls into the x86
> efi_arch_mem_reserve() function. This function will insert a new EFI
> memory descriptor into the EFI memory map representing the area of
> memory to be reserved and marking it as EFI runtime memory. As part
> of adding this new entry, a new EFI memory map is allocated and mapped.
> The mapping is where a problem can occur. This new memory map is mapped
> using early_memremap() and generally mapped encrypted, unless the new
> memory for the mapping happens to come from an area of memory that is
> marked as EFI_BOOT_SERVICES_DATA memory. In this case, the new memory will
> be mapped unencrypted. However, during replacement of the old memory map,
> efi_mem_type() is disabled, so the new memory map will now be long-term
> mapped encrypted (in efi.memmap), resulting in the map containing invalid
> data and causing the kernel boot to crash.
> 
> Since it is known that the area will be mapped encrypted going forward,
> explicitly map the new memory map as encrypted using early_memremap_prot().
> 
> Cc: <stable@vger.kernel.org> # 4.14.x
> Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
> Link: https://lore.kernel.org/all/ebf1eb2940405438a09d51d121ec0d02c8755558.1634752931.git.thomas.lendacky@amd.com/
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ardb: incorporate Kconfig fix by Arnd]
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/Kconfig               | 1 +
>  arch/x86/platform/efi/quirks.c | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
