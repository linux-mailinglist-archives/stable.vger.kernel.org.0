Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87785EBADD
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 08:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiI0Gmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 02:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiI0Gmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 02:42:43 -0400
X-Greylist: delayed 443 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Sep 2022 23:42:42 PDT
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E838C937AE
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 23:42:42 -0700 (PDT)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id C6814201327;
        Tue, 27 Sep 2022 06:35:17 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 0FD2E80536; Tue, 27 Sep 2022 08:35:10 +0200 (CEST)
Date:   Tue, 27 Sep 2022 08:35:10 +0200
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kasan-dev@googlegroups.com, Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] random: split initialization into early step and
 later step
Message-ID: <YzKZnkwCi0UwY/4Q@owl.dominikbrodowski.net>
References: <20220926213130.1508261-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926213130.1508261-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Mon, Sep 26, 2022 at 11:31:29PM +0200 schrieb Jason A. Donenfeld:
> The full RNG initialization relies on some timestamps, made possible
> with general functions like time_init() and timekeeping_init(). However,
> these are only available rather late in initialization. Meanwhile, other
> things, such as memory allocator functions, make use of the RNG much
> earlier.
> 
> So split RNG initialization into two phases. We can give arch randomness
> very early on, and then later, after timekeeping and such are available,
> initialize the rest.
> 
> This ensures that, for example, slabs are properly randomized if RDRAND
> is available. Without this, CONFIG_SLAB_FREELIST_RANDOM=y loses a degree
> of its security, because its random seed is potentially deterministic,
> since it hasn't yet incorporated RDRAND. It also makes it possible to
> use a better seed in kfence, which currently relies on only the cycle
> counter.
> 
> Another positive consequence is that on systems with RDRAND, running
> with CONFIG_WARN_ALL_UNSEEDED_RANDOM=y results in no warnings at all.

Nice improvement. One question, though:

>  #if defined(LATENT_ENTROPY_PLUGIN)
>  	static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
> @@ -803,34 +798,46 @@ int __init random_init(const char *command_line)
>  			i += longs;
>  			continue;
>  		}
> -		entropy[0] = random_get_entropy();
> -		_mix_pool_bytes(entropy, sizeof(*entropy));
>  		arch_bits -= sizeof(*entropy) * 8;
>  		++i;
>  	}


Previously, random_get_entropy() was mixed into the pool ARRAY_SIZE(entropy)
times.

> +/*
> + * This is called a little bit after the prior function, and now there is
> + * access to timestamps counters. Interrupts are not yet enabled.
> + */
> +void __init random_init(void)
> +{
> +	unsigned long entropy = random_get_entropy();
> +	ktime_t now = ktime_get_real();
> +
> +	_mix_pool_bytes(utsname(), sizeof(*(utsname())));

But now, it's only mixed into the pool once. Is this change on purpose?

Thanks,
	Dominik
