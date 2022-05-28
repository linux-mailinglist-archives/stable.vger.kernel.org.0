Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E968536A7D
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 05:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354947AbiE1D7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 23:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiE1D7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 23:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0629C62BEF;
        Fri, 27 May 2022 20:59:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 971DD61C19;
        Sat, 28 May 2022 03:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADED1C34100;
        Sat, 28 May 2022 03:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653710372;
        bh=hzVHSh4zr2vcIAinWH7zTymLIFQZIDTSRvcZXhAJ7Fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sOlksaREXBsfBPvs4hqb11pZ8Um6NmMrLFPvrzu3BYFO8jXRWYiQH5QpAMBayUbt2
         j3fTCF//XRZeQ5OZp6wMUuNSfRxavj4Db8dOrwmBVasa7+eoWdVcSWLudkXlYTtKbu
         5evGnCX6n3p3bZhw5m+8V+icPgVmmnxgNJyaQPKkEzc+CSqBZa/Mw6ZXcX8C8amxcB
         iEsPRo8sYLB3vg9SWTEu8s4PNIgttSwJDfrEfXupl5YC7EKsd0tucsuRQxkSG51IIE
         +WRFhzHCdjEbZbCvNqT28wi1ASbrBfAhQvT+sNBkWOO07wBB0fl4hco7zMFYaGrRe9
         m/SuOQB7NO9Tg==
Date:   Fri, 27 May 2022 20:59:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, gaochao <gaochao49@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH crypto v2] crypto: blake2s - remove shash module
Message-ID: <YpGeIT1KHv9QwF4X@sol.localdomain>
References: <YpCGQvpirQWaAiRF@zx2c4.com>
 <20220527081106.63227-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527081106.63227-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 10:11:06AM +0200, Jason A. Donenfeld wrote:
> BLAKE2s has no use as an shash, with no users of it.

"no use" => "no known current use".

> diff --git a/lib/crypto/blake2s-selftest.c b/lib/crypto/blake2s-selftest.c
> index 409e4b728770..38996ee73a64 100644
> --- a/lib/crypto/blake2s-selftest.c
> +++ b/lib/crypto/blake2s-selftest.c
> @@ -4,6 +4,8 @@
>   */
>  
>  #include <crypto/internal/blake2s.h>
> +#include <linux/kernel.h>
> +#include <linux/random.h>
>  #include <linux/string.h>
>  
>  /*
> @@ -548,7 +550,8 @@ bool __init blake2s_selftest(void)
>  	u8 key[BLAKE2S_KEY_SIZE];
>  	u8 buf[ARRAY_SIZE(blake2s_testvecs)];
>  	u8 hash[BLAKE2S_HASH_SIZE];
> -	struct blake2s_state state;
> +	u8 blocks[BLAKE2S_BLOCK_SIZE * 4];
> +	struct blake2s_state state, state1, state2;
>  	bool success = true;
>  	int i, l;
>  
> @@ -587,5 +590,32 @@ bool __init blake2s_selftest(void)
>  		}
>  	}
>  
> +	for (i = 0; i < 2048; ++i) {
> +		get_random_bytes(blocks, sizeof(blocks));
> +		get_random_bytes(&state, sizeof(state));
> +
> +		memcpy(&state1, &state, sizeof(state1));
> +		memcpy(&state2, &state, sizeof(state2));
> +		blake2s_compress(&state1, blocks, 4, sizeof(blocks));
> +		blake2s_compress_generic(&state2, blocks, 4, sizeof(blocks));
> +		if (memcmp(&state1, &state2, sizeof(state1))) {
> +			pr_err("blake2s random compress self-test %d: FAIL\n",
> +			       i + 1);
> +			success = false;
> +		}
> +
> +		for (l = 1; l < 8; ++l) {
> +			memcpy(&state1, &state, sizeof(state1));
> +			memcpy(&state2, &state, sizeof(state2));
> +			blake2s_compress(&state1, blocks + l, 3, sizeof(blocks) - BLAKE2S_BLOCK_SIZE);
> +			blake2s_compress_generic(&state2, blocks + l, 3, sizeof(blocks) - BLAKE2S_BLOCK_SIZE);
> +			if (memcmp(&state1, &state2, sizeof(state1))) {
> +				pr_err("blake2s random compress align %d self-test %d: FAIL\n",
> +				       l, i + 1);
> +				success = false;
> +			}
> +		}
> +	}

This doesn't compile on arm, since blake2s_compress_generic() isn't defined.

Also, the wrong value is being passed for the 'inc' argument.

2048 iterations is also a lot.  Doing a lot of iterations here doesn't
meaningfully increase the test coverage.

And please run checkpatch; those are some very long lines :-(

- Eric
