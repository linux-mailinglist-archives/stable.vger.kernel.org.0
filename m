Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D9B6646B0
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbjAJQ4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238165AbjAJQ4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:56:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAD8CE01
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:56:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23B28B81891
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 16:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161BCC433F0;
        Tue, 10 Jan 2023 16:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673369807;
        bh=P7Il/kvj9Yg6T1GzmYZFK6QBKFye28F0IdN0PglIjd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2Ax1LslCMNPxUzMlxlD39bigJWp0Ktzj2RlllmBZlG+gS6pm/tn05UYJBgb63CUKt
         /1aLUim48UD8MmeqdqMUgb0FzB5ombjoTHnUmyOq3TtmKJBuW4OPdaUOqoq3AULfna
         Kx9HdLKQnDoIklD9uIxDpJ6xa8p2QlmLcWeGAZok=
Date:   Tue, 10 Jan 2023 17:56:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH stable] efi: random: combine bootloader provided RNG seed
 with RNG protocol output
Message-ID: <Y72YyXw5HcsbDac1@kroah.com>
References: <20230110160416.2590-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110160416.2590-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 05:04:16PM +0100, Jason A. Donenfeld wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> commit 196dff2712ca5a2e651977bb2fe6b05474111a83 upstream.
> 
> Instead of blindly creating the EFI random seed configuration table if
> the RNG protocol is implemented and works, check whether such a EFI
> configuration table was provided by an earlier boot stage and if so,
> concatenate the existing and the new seeds, leaving it up to the core
> code to mix it in and credit it the way it sees fit.
> 
> This can be used for, e.g., systemd-boot, to pass an additional seed to
> Linux in a way that can be consumed by the kernel very early. In that
> case, the following definitions should be used to pass the seed to the
> EFI stub:
> 
> struct linux_efi_random_seed {
>       u32     size; // of the 'seed' array in bytes
>       u8      seed[];
> };
> 
> The memory for the struct must be allocated as EFI_ACPI_RECLAIM_MEMORY
> pool memory, and the address of the struct in memory should be installed
> as a EFI configuration table using the following GUID:
> 
> LINUX_EFI_RANDOM_SEED_TABLE_GUID        1ce1e5bc-7ceb-42f2-81e5-8aadf180f57b
> 
> Note that doing so is safe even on kernels that were built without this
> patch applied, but the seed will simply be overwritten with a seed
> derived from the EFI RNG protocol, if available. The recommended seed
> size is 32 bytes, and seeds larger than 512 bytes are considered
> corrupted and ignored entirely.
> 
> In order to preserve forward secrecy, seeds from previous bootloaders
> are memzero'd out, and in order to preserve memory, those older seeds
> are also freed from memory. Freeing from memory without first memzeroing
> is not safe to do, as it's possible that nothing else will ever
> overwrite those pages used by EFI.
> 
> Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> [ardb: incorporate Jason's followup changes to extend the maximum seed
>        size on the consumer end, memzero() it and drop a needless printk]
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/firmware/efi/efi.c             |  4 +--
>  drivers/firmware/efi/libstub/efistub.h |  2 ++
>  drivers/firmware/efi/libstub/random.c  | 42 ++++++++++++++++++++++----
>  include/linux/efi.h                    |  2 --
>  4 files changed, 40 insertions(+), 10 deletions(-)

Now queued up, thanks.

greg k-h
