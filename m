Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BB248DDE1
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 19:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237657AbiAMSxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 13:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiAMSxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 13:53:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755AAC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3098FB80934
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 18:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECC8C36AEB;
        Thu, 13 Jan 2022 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642099988;
        bh=QbPONFd4/wl1krIhWJYSOMYXqc/jsOzlpVijrwdwoig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KWhG6GFQ2mG0Q+Up6JjlL0sjquxY5ruZiYnBXpvR5GMT1DsX346cXnJjXtEgNfc0C
         rCB0o5JrTmq7wMHGlvD49QVy+oxEcOqTPBOF5WsOyl0fGE/PnMh7ImV+B1KwtVKt++
         mknKyAOsY6WMk3thbar8yl/5Xoef8EesKwTZwLtY=
Date:   Thu, 13 Jan 2022 19:53:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux@dominikbrodowski.net, iivanov@suse.de, stable@vger.kernel.org
Subject: Re: [PATCH stable 5.4.y] random: fix crash on multiple early calls
 to add_bootloader_randomness()
Message-ID: <YeB1EssPxuFBw7n7@kroah.com>
References: <164209692229178@kroah.com>
 <20220113181329.69371-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113181329.69371-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 07:13:29PM +0100, Jason A. Donenfeld wrote:
> From: Dominik Brodowski <linux@dominikbrodowski.net>
> 
> commit f7e67b8e803185d0aabe7f29d25a35c8be724a78 upstream.
> 
> Currently, if CONFIG_RANDOM_TRUST_BOOTLOADER is enabled, multiple calls
> to add_bootloader_randomness() are broken and can cause a NULL pointer
> dereference, as noted by Ivan T. Ivanov. This is not only a hypothetical
> problem, as qemu on arm64 may provide bootloader entropy via EFI and via
> devicetree.
> 
> On the first call to add_hwgenerator_randomness(), crng_fast_load() is
> executed, and if the seed is long enough, crng_init will be set to 1.
> On subsequent calls to add_bootloader_randomness() and then to
> add_hwgenerator_randomness(), crng_fast_load() will be skipped. Instead,
> wait_event_interruptible() and then credit_entropy_bits() will be called.
> If the entropy count for that second seed is large enough, that proceeds
> to crng_reseed().
> 
> However, both wait_event_interruptible() and crng_reseed() depends
> (at least in numa_crng_init()) on workqueues. Therefore, test whether
> system_wq is already initialized, which is a sufficient indicator that
> workqueue_init_early() has progressed far enough.
> 
> If we wind up hitting the !system_wq case, we later want to do what
> would have been done there when wqs are up, so set a flag, and do that
> work later from the rand_initialize() call.
> 
> Reported-by: Ivan T. Ivanov <iivanov@suse.de>
> Fixes: 18b915ac6b0a ("efi/random: Treat EFI_RNG_PROTOCOL output as bootloader randomness")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> [Jason: added crng_need_done state and related logic.]
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/random.c | 59 ++++++++++++++++++++++++++++---------------
>  1 file changed, 38 insertions(+), 21 deletions(-)

Now queued up, thanks!

greg k-h
