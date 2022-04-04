Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8B14F1B06
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379396AbiDDVT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380063AbiDDSvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 14:51:50 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D953137D
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 11:49:52 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w7so9783702pfu.11
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 11:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OgBmai9kBCjlr9aFO4p03+ZvCT3qEl4N4BMmkwU41WQ=;
        b=LTyjDcUYrrGKFD7zBZax9Kejc3M/VxotNH1SBr++BxXDPlIByWs5a8wElJ4CvLKUjn
         JyRCaI0dzCSpvP/ALFTbNMuJKz1OE+gnZT2yLPLFrixzAKAECrJRPEHlCeASyItdvWGg
         5xsPixVA5PWT4eWxCZ6OapeXiV8KI2KpoPsxA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OgBmai9kBCjlr9aFO4p03+ZvCT3qEl4N4BMmkwU41WQ=;
        b=TJ8aOVb/1x0f07HOBgDXq35vJnuvrXhvF1Ca0CZ3Xr2IuY0jVx99tiUSaqRFmsKW8i
         Xnq7EtRUsyyyUxluIkfdRALPUrAtl3CGEJ9H4h3CixP6NT82NrPRO9r1zxHQjKiaKR1D
         KUB6prBM7yXcyx8JzD99Wp/CYbX8Cougsqx1YbF+9h9QB7wTnJPiESdDcM8MrUuymrAM
         OWCoB20YXuQNWRcvUlqGK2zpnuH7ac5uNpVZyECUqKE/ZbwMUu2pNp4H6Xi361NazQnH
         CBwKPURoLdri7T5hVGK+gNic/xHiWpJFrwhwzNdDuOwhkvsAzGbG5Pe+9gnQWyQ8U/p/
         7iDQ==
X-Gm-Message-State: AOAM531+97gr06H7iMwF8JA5d4PJO7hLizQrHUt7EJs7NahEIB1EZJjy
        BcsgnBil2Y1u3wgkfPyL4S8pdQ==
X-Google-Smtp-Source: ABdhPJy+Asj1IhIbA7G/rhnlb2Kxzq17/p8QVmR/14Zr/TJmyt+KN+/Wq9xSl0Xoz+XlLAUuAApNng==
X-Received: by 2002:a63:5756:0:b0:36c:67bc:7f3f with SMTP id h22-20020a635756000000b0036c67bc7f3fmr1042587pgm.389.1649098191979;
        Mon, 04 Apr 2022 11:49:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c63-20020a624e42000000b004fa9ee41b7bsm12701353pfb.217.2022.04.04.11.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 11:49:51 -0700 (PDT)
Date:   Mon, 4 Apr 2022 11:49:50 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH v2] gcc-plugins: latent_entropy: use /dev/urandom
Message-ID: <202204041144.96FC64A8@keescook>
References: <CAHmME9otYi4pCzZwSGnK40dp1QMRVPxp+DBysVuLXUKkXinAxg@mail.gmail.com>
 <20220403204036.1269562-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403204036.1269562-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 03, 2022 at 10:40:36PM +0200, Jason A. Donenfeld wrote:
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

This mixes two changes: the pRNG change and the "use urandom if
non-deterministic" change. I think these should be split, so the pRNG
change can be explicitly justified.

More notes below...

> 
> Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
> Cc: stable@vger.kernel.org
> Cc: PaX Team <pageexec@freemail.hu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v1->v2:
> - Pipacs pointed out that using /dev/urandom unconditionally would break
>   the use of -frandom-seed, so now we check for that and keep with
>   something deterministic in that case.
> 
> I'm not super familiar with this plugin or its conventions, so pointers
> would be most welcome if something here looks amiss. The decision to
> buffer 2k at a time is pretty arbitrary too; I haven't measured usage.
> 
>  scripts/gcc-plugins/latent_entropy_plugin.c | 48 +++++++++++++--------
>  1 file changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
> index 589454bce930..042442013ae1 100644
> --- a/scripts/gcc-plugins/latent_entropy_plugin.c
> +++ b/scripts/gcc-plugins/latent_entropy_plugin.c
> @@ -82,29 +82,37 @@ __visible int plugin_is_GPL_compatible;
>  static GTY(()) tree latent_entropy_decl;
>  
>  static struct plugin_info latent_entropy_plugin_info = {
> -	.version	= "201606141920vanilla",
> +	.version	= "202203311920vanilla",

This doesn't really need to be versioned. We can change this to just
"vanilla", IMO.

>  	.help		= "disable\tturn off latent entropy instrumentation\n",
>  };
>  
> -static unsigned HOST_WIDE_INT seed;
> -/*
> - * get_random_seed() (this is a GCC function) generates the seed.
> - * This is a simple random generator without any cryptographic security because
> - * the entropy doesn't come from here.
> - */
> +static unsigned HOST_WIDE_INT deterministic_seed;
> +static unsigned HOST_WIDE_INT rnd_buf[256];
> +static size_t rnd_idx = ARRAY_SIZE(rnd_buf);
> +static int urandom_fd = -1;
> +
>  static unsigned HOST_WIDE_INT get_random_const(void)
>  {
> -	unsigned int i;
> -	unsigned HOST_WIDE_INT ret = 0;
> -
> -	for (i = 0; i < 8 * sizeof(ret); i++) {
> -		ret = (ret << 1) | (seed & 1);
> -		seed >>= 1;
> -		if (ret & 1)
> -			seed ^= 0xD800000000000000ULL;
> +	if (deterministic_seed) {
> +		unsigned HOST_WIDE_INT w = deterministic_seed;
> +		w ^= w << 13;
> +		w ^= w >> 7;
> +		w ^= w << 17;
> +		deterministic_seed = w;
> +		return deterministic_seed;

While seemingly impossible, perhaps don't reset "deterministic_seed",
and just continue to use "seed", so that it can never become "0" again.

>  	}
>  
> -	return ret;
> +	if (urandom_fd < 0) {
> +		urandom_fd = open("/dev/urandom", O_RDONLY);
> +		if (urandom_fd < 0)
> +			abort();
> +	}
> +	if (rnd_idx >= ARRAY_SIZE(rnd_buf)) {
> +		if (read(urandom_fd, rnd_buf, sizeof(rnd_buf)) != sizeof(rnd_buf))
> +			abort();
> +		rnd_idx = 0;
> +	}
> +	return rnd_buf[rnd_idx++];
>  }
>  
>  static tree tree_get_random_const(tree type)
> @@ -537,8 +545,6 @@ static void latent_entropy_start_unit(void *gcc_data __unused,
>  	tree type, id;
>  	int quals;
>  
> -	seed = get_random_seed(false);
> -
>  	if (in_lto_p)
>  		return;
>  
> @@ -573,6 +579,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
>  	const struct plugin_argument * const argv = plugin_info->argv;
>  	int i;
>  
> +	/*
> +	 * Call get_random_seed() with noinit=true, so that this returns
> +	 * 0 in the case where no seed has been passed via -frandom-seed.
> +	 */
> +	deterministic_seed = get_random_seed(true);

i.e. have this be:

	deterministic_seed = get_random_seed(true);
	if (deterministic_seed)
		seed = get_random_seed(false);

> +
>  	static const struct ggc_root_tab gt_ggc_r_gt_latent_entropy[] = {
>  		{
>  			.base = &latent_entropy_decl,
> -- 
> 2.35.1
> 

-- 
Kees Cook
