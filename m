Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BED504EA2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 12:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbiDRKH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 06:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbiDRKH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 06:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1A71A6
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:04:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B6DA611B3
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 10:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C94C385A7;
        Mon, 18 Apr 2022 10:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650276287;
        bh=aZ+w/1b7CpTM2FBHXOm6wi7eA1XVR8bBQzB3GlbmMmc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGxPV636aFJnmLoc/ZsGVNv4js0RqueVx2GXxHA7bjbuciFQQ2hkA2s5oY1JheYIH
         4L8MYN2bjuvRrIeUkhJ84hOs+x+lNxu2ZaAS1X/LbjNwV7YDJEJoAyGbv0PcbhD6N9
         C5TYlGV/oQsgrRP9U/Rprj+iVsPhzw27gjbJ0+vU=
Date:   Mon, 18 Apr 2022 12:04:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH stable v4.9.y] gcc-plugins: latent_entropy: use
 /dev/urandom
Message-ID: <Yl03vITb4OSVSjCw@kroah.com>
References: <20220418094241.1484705-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418094241.1484705-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 11:42:41AM +0200, Jason A. Donenfeld wrote:
> commit c40160f2998c897231f8454bf797558d30a20375 upstream.
> 
> While the latent entropy plugin mostly doesn't derive entropy from
> get_random_const() for measuring the call graph, when __latent_entropy is
> applied to a constant, then it's initialized statically to output from
> get_random_const(). In that case, this data is derived from a 64-bit
> seed, which means a buffer of 512 bits doesn't really have that amount
> of compile-time entropy.
> 
> This patch fixes that shortcoming by just buffering chunks of
> /dev/urandom output and doling it out as requested.
> 
> At the same time, it's important that we don't break the use of
> -frandom-seed, for people who want the runtime benefits of the latent
> entropy plugin, while still having compile-time determinism. In that
> case, we detect whether gcc's set_random_seed() has been called by
> making a call to get_random_seed(noinit=true) in the plugin init
> function, which is called after set_random_seed() is called but before
> anything that calls get_random_seed(noinit=false), and seeing if it's
> zero or not. If it's not zero, we're in deterministic mode, and so we
> just generate numbers with a basic xorshift prng.
> 
> Note that we don't detect if -frandom-seed is being used using the
> documented local_tick variable, because it's assigned via:
>    local_tick = (unsigned) tv.tv_sec * 1000 + tv.tv_usec / 1000;
> which may well overflow and become -1 on its own, and so isn't
> reliable: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105171
> 
> [kees: The 256 byte rnd_buf size was chosen based on average (250),
>  median (64), and std deviation (575) bytes of used entropy for a
>  defconfig x86_64 build]
> 
> Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
> Cc: stable@vger.kernel.org
> Cc: PaX Team <pageexec@freemail.hu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: https://lore.kernel.org/r/20220405222815.21155-1-Jason@zx2c4.com
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  scripts/gcc-plugins/latent_entropy_plugin.c | 44 +++++++++++++--------
>  1 file changed, 27 insertions(+), 17 deletions(-)

Queued this one up now instead, thanks for the backport!

greg k-h
