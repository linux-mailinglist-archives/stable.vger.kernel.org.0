Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB246A4A7F
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 20:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjB0TBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 14:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjB0TBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 14:01:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4496027985;
        Mon, 27 Feb 2023 11:01:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBB5F60F14;
        Mon, 27 Feb 2023 19:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC58C433EF;
        Mon, 27 Feb 2023 19:01:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ForJk8pE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1677524464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=322t8w2/T/pMjXanjU567VPH9jSO2LxtW52q1BIcOVo=;
        b=ForJk8pE/y97fOUIZ79FUgCkhhkzVCt3Yeu4HxpNe1kF+3cqiDqPVjV1B654KD2Vs56JWq
        6dl7ahFyzXw7rcK/YtLfDDYHohczmSuuc4J+++HWvF2vpvwl95EsXt78iPq+oNgBScyfJ3
        r7nHvTtdR7h9LS0ExlcdsC7iZWyj7U0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7fc70003 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 27 Feb 2023 19:01:03 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-536be69eadfso204743077b3.1;
        Mon, 27 Feb 2023 11:01:03 -0800 (PST)
X-Gm-Message-State: AO0yUKXkIxw02Ddk1p7DAMgEbcz5Ch81LasnW/t0WbrLbyuJRXZLOyDi
        1h5/CBWvbDjNIJevcRPsCATUVe5ZSDd7piQTs34=
X-Google-Smtp-Source: AK7set+6ksPgnUWtMel2Ev0OC6WgL3ILLxwBxskYj2tYdY0zf8jB0YaZZpSsHZfW2IdVIwCg7Js9q7L9solP9+oKcPM=
X-Received: by 2002:a81:b661:0:b0:534:eef8:caa9 with SMTP id
 h33-20020a81b661000000b00534eef8caa9mr10808377ywk.8.1677524462200; Mon, 27
 Feb 2023 11:01:02 -0800 (PST)
MIME-Version: 1.0
References: <20230227182947.61733-1-ebiggers@kernel.org>
In-Reply-To: <20230227182947.61733-1-ebiggers@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Feb 2023 20:00:51 +0100
X-Gmail-Original-Message-ID: <CAHmME9r9y+A89+=ErYDYOfRkGD2=GZaik57PMaV_MHwKzJwDzw@mail.gmail.com>
Message-ID: <CAHmME9r9y+A89+=ErYDYOfRkGD2=GZaik57PMaV_MHwKzJwDzw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: testmgr - fix RNG performance in fuzz tests
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 7:30=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The performance of the crypto fuzz tests has greatly regressed since
> v5.18.  When booting a kernel on an arm64 dev board with all software
> crypto algorithms and CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled, the
> fuzz tests now take about 200 seconds to run, or about 325 seconds with
> lockdep enabled, compared to about 5 seconds before.
>
> The root cause is that the random number generation has become much
> slower due to commit d4150779e60f ("random32: use real rng for
> non-deterministic randomness").  On my same arm64 dev board, at the time
> the fuzz tests are run, get_random_u8() is about 345x slower than
> prandom_u32_state(), or about 469x if lockdep is enabled.
>
> Lockdep makes a big difference, but much of the rest comes from the
> get_random_*() functions taking a *very* slow path when the CRNG is not
> yet initialized.  Since the crypto self-tests run early during boot,
> even having a hardware RNG driver enabled (CONFIG_CRYPTO_DEV_QCOM_RNG in
> my case) doesn't prevent this.  x86 systems don't have this issue, but
> they still see a significant regression if lockdep is enabled.
>
> Converting the "Fully random bytes" case in generate_random_bytes() to
> use get_random_bytes() helps significantly, improving the test time to
> about 27 seconds.  But that's still over 5x slower than before.
>
> This is all a bit silly, though, since the fuzz tests don't actually
> need cryptographically secure random numbers.  So let's just make them
> use a non-cryptographically-secure RNG as they did before.  The original
> prandom_u32() is gone now, so let's use prandom_u32_state() instead,
> with an explicitly managed state, like various other self-tests in the
> kernel source tree (rbtree_test.c, test_scanf.c, etc.) already do.  This
> also has the benefit that no locking is required anymore, so performance
> should be even better than the original version that used prandom_u32().
>
> Fixes: d4150779e60f ("random32: use real rng for non-deterministic random=
ness")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>
> v2: made init_rnd_state() use get_random_u64()
>
>  crypto/testmgr.c | 266 ++++++++++++++++++++++++++++++-----------------
>  1 file changed, 169 insertions(+), 97 deletions(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index c91e93ece20b..b160eeb12c8e 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -860,12 +860,50 @@ static int prepare_keybuf(const u8 *key, unsigned i=
nt ksize,
>
>  #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
>
> +/*
> + * The fuzz tests use prandom instead of the normal Linux RNG since they=
 don't
> + * need cryptographically secure random numbers.  This greatly improves =
the
> + * performance of these tests, especially if they are run before the Lin=
ux RNG
> + * has been initialized or if they are run on a lockdep-enabled kernel.
> + */
> +
> +static inline void init_rnd_state(struct rnd_state *rng)
> +{
> +       prandom_seed_state(rng, get_random_u64());

i915 does something similar and prints it out with `kunit_info(suite,
"Testing DRM buddy manager, with random_seed=3D0x%x\n", random_seed);`,
so that you can repeat the test if necessary. Not saying you have to
do this now, but it may be a cool feature to keep in mind for the
future.

Jason
