Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0FA61FA28
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiKGQmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiKGQmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:42:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8002F634B
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DA5F611BD
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370D6C433C1;
        Mon,  7 Nov 2022 16:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839324;
        bh=yaISBTWMlzIW8+DVIQUWtbHlscPMQmS+jEsx0pV1JA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z3yT7TiELmV4by0EoJoe4fLwNg2pr4WEunzq6ERkQoPZ3SjH8HMd6bJxGCqNlo9vu
         tMeJX+dF8YvRr4Rc4P/cH8PfSmQtitreQegvLqdindUA+BK+fwARbEzoYw5qc5Rv0C
         oBGWDLxcKcncj4gNHRQI5KSh/vRPPEee37duakYo=
Date:   Mon, 7 Nov 2022 17:42:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH 4.14.y] efi: random: reduce seed size to 32 bytes
Message-ID: <Y2k1WbGHIdvJxfnu@kroah.com>
References: <16678349111147@kroah.com>
 <20221107153552.21981-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107153552.21981-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 04:35:52PM +0100, Jason A. Donenfeld wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> commit 161a438d730dade2ba2b1bf8785f0759aba4ca5f upstream.
> 
> We no longer need at least 64 bytes of random seed to permit the early
> crng init to complete. The RNG is now based on Blake2s, so reduce the
> EFI seed size to the Blake2s hash size, which is sufficient for our
> purposes.
> 
> While at it, drop the READ_ONCE(), which was supposed to prevent size
> from being evaluated after seed was unmapped. However, this cannot
> actually happen, so READ_ONCE() is unnecessary here. [stable:
> READ_ONCE() wasn't backported in the first place.]
> 
> Cc: <stable@vger.kernel.org> # v4.14+
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/firmware/efi/efi.c | 2 +-
>  include/linux/efi.h        | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Both backports now queued up, thanks.

greg k-h
