Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE6E5362CD
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbiE0Mmz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 27 May 2022 08:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352871AbiE0Mms (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:42:48 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AB6563A6
        for <stable@vger.kernel.org>; Fri, 27 May 2022 05:36:11 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-21-pgJYEnaQNtSr16gYUgWBNw-1; Fri, 27 May 2022 13:36:08 +0100
X-MC-Unique: pgJYEnaQNtSr16gYUgWBNw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 27 May 2022 13:36:07 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 27 May 2022 13:36:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     gaochao <gaochao49@huawei.com>, Eric Biggers <ebiggers@kernel.org>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH crypto v2] crypto: blake2s - remove shash module
Thread-Topic: [PATCH crypto v2] crypto: blake2s - remove shash module
Thread-Index: AQHYcaF6P7gQRKQBI0K/b88268hXeq0ypNwg
Date:   Fri, 27 May 2022 12:36:07 +0000
Message-ID: <ffa404b7427043fda4b9f4a20ea0f068@AcuMS.aculab.com>
References: <YpCGQvpirQWaAiRF@zx2c4.com>
 <20220527081106.63227-1-Jason@zx2c4.com>
In-Reply-To: <20220527081106.63227-1-Jason@zx2c4.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld
> Sent: 27 May 2022 09:11
> 
> BLAKE2s has no use as an shash, with no users of it. Just remove all of
> this unnecessary plumbing. Removing this shash was something we talked
> about back when we were making BLAKE2s a built-in, but I simply never
> got around to doing it. So this completes that project.
...
> diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
> index c71c09621c09..716da32cf4dc 100644
> --- a/lib/crypto/blake2s.c
> +++ b/lib/crypto/blake2s.c
> @@ -16,16 +16,43 @@
>  #include <linux/init.h>
>  #include <linux/bug.h>
> 
> +static inline void blake2s_set_lastblock(struct blake2s_state *state)
> +{
> +	state->f[0] = -1;
> +}
> +
>  void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
>  {
> -	__blake2s_update(state, in, inlen, false);
> +	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
> +
> +	if (unlikely(!inlen))
> +		return;

Does this happen often enough to optimise for?
The zero length memcpy() should be fine.
(though pedants might worry about in == NULL)

> +	if (inlen > fill) {

Testing inlen >= fill will be better.
You also don't need the code below in the (probably) likely
case that state->buflen == 0.

> +		memcpy(state->buf + state->buflen, in, fill);
> +		blake2s_compress(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
> +		state->buflen = 0;
> +		in += fill;
> +		inlen -= fill;

an 'if (!inlen) return' check here may be a cheap optimisation.

> +	}
> +	if (inlen > BLAKE2S_BLOCK_SIZE) {

This test only needs to be inside the earlier inlen > fill condition.
The compiler may not be able to assume so.

> +		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);

Why not inlen/BLAKE2S_BLOCK_SIZE and remove all the '- 1'.
Looping inside blakes2s_compress() has to be better than
doing an extra call when processing the next data block.

> +		blake2s_compress(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
> +		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
> +		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
> +	}
> +	memcpy(state->buf + state->buflen, in, inlen);
> +	state->buflen += inlen;
>  }
>  EXPORT_SYMBOL(blake2s_update);
> 
>  void blake2s_final(struct blake2s_state *state, u8 *out)
>  {
>  	WARN_ON(IS_ENABLED(DEBUG) && !out);
> -	__blake2s_final(state, out, false);
> +	blake2s_set_lastblock(state);
> +	memset(state->buf + state->buflen, 0, BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
> +	blake2s_compress(state, state->buf, 1, state->buflen);
> +	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
> +	memcpy(out, state->h, state->outlen);
>  	memzero_explicit(state, sizeof(*state));
>  }
>  EXPORT_SYMBOL(blake2s_final);
> @@ -38,12 +65,7 @@ static int __init blake2s_mod_init(void)
>  	return 0;
>  }

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

