Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACB96AA01D
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 20:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjCCTa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 14:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjCCTa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 14:30:57 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C8E166F5
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 11:30:53 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so4621853wmb.5
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 11:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677871852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOV4QKb+3IqeUiWk+pbO9KTh7zUh9HaOEMSNn1GRC9o=;
        b=NeFtlWUG3VePqIg9OB9iRw/ypPtHyi7jI1mtmxX6iQcXCvaYDe5cy6mPHKm/jpxM8U
         eo6EKExkOZxhtSbmVXJsNyCzq/H2Fws+xQuyPi5m6CYIBE5aALniJHl4cGkTyN9ZOL6u
         wdx8l+vCp3K5TH1AETHDXGx3OZAri3KOwVEPXU45y6F+faj3dCYnLAuLld0OYFdKT23d
         3Pmgs7aAo/J4wel1rahqriu2sMlmz7tfd8XfTzFVTLMdI+5crLN9DtyHHmUAXf3lt6+D
         evpU3dNJM3EYf77qn29yHKp6WkteGP/s9vMxLmbvCqskoic8gNmYAfxbvheh/+rbGOd/
         HI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677871852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOV4QKb+3IqeUiWk+pbO9KTh7zUh9HaOEMSNn1GRC9o=;
        b=fnf4MhAFYY4oSrKAk2JFalJ0d3oQm/gZfqW/Tlf7jQPpGxr7kAqKA4YY4gXPJUChBO
         mxmQzYU+yAlDS9/Mz0IvPT9sDfkiUBGao6970cFSp2L56gIYDVChqm5CUn2P/4TFeyIx
         579rp3/+xlNHD+cUqJsNTvYx4HTs/kJEHYNcKq32Yi/nU6kU52Y9Y51GGp23Mv7Fs3f1
         uTDaTaG5RIgSMxImiyKOqyiea8dNpP9mSv7kVoQo9m1hLmUzCx5xpL0m24wDQY3DZRWw
         zUF9TtyGheyKxNR/YM3R0ZCwU2vFJgNgEBk7tL2J/goQFo6WG5cnCQrHnGdLipcOVd4J
         bqQg==
X-Gm-Message-State: AO0yUKVEhA+ckWwX6ZQ+SWtH7vRy4kCf7xR55tzI7vMBUrPZjfsTvdQI
        l2mBPPBn/J+KWUVFU4h/RY293mNj05/Cum7+e2vaGw==
X-Google-Smtp-Source: AK7set9g/89AfyD2+r/h4zJvd/tucgM448IzSWb8uoT7deO2ni6aBHsfawfbR6VVGlR/Sew+s186w4DUkJYyFchp2zQ=
X-Received: by 2002:a05:600c:42ca:b0:3ea:8ed9:5f3e with SMTP id
 j10-20020a05600c42ca00b003ea8ed95f3emr707369wme.4.1677871851767; Fri, 03 Mar
 2023 11:30:51 -0800 (PST)
MIME-Version: 1.0
References: <20230303071959.144604-1-ebiggers@kernel.org> <20230303071959.144604-2-ebiggers@kernel.org>
In-Reply-To: <20230303071959.144604-2-ebiggers@kernel.org>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Fri, 3 Mar 2023 11:29:00 -0800
Message-ID: <CAJkfWY5Hrg7zPA3Z6581oX1Mn=Qs+V+f+1Q-j5uRkaDGR_jmnw@mail.gmail.com>
Subject: Re: [PATCH 1/3] blk-mq: release crypto keyslot before reporting I/O complete
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On Thu, Mar 2, 2023 at 11:23=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Once all I/O using a blk_crypto_key has completed, filesystems can call
> blk_crypto_evict_key().  However, the block layer currently doesn't call
> blk_crypto_put_keyslot() until the request is being freed, which happens
> after upper layers have been told (via bio_endio()) the I/O has
> completed.  This causes a race condition where blk_crypto_evict_key()
> can see 'slot_refs !=3D 0' without there being an actual bug.
>
> This makes __blk_crypto_evict_key() hit the
> 'WARN_ON_ONCE(atomic_read(&slot->slot_refs) !=3D 0)' and return without
> doing anything, eventually causing a use-after-free in
> blk_crypto_reprogram_all_keys().  (This is a very rare bug and has only
> been seen when per-file keys are being used with fscrypt.)
>
> There are two options to fix this: either release the keyslot before
> bio_endio() is called on the request's last bio, or make
> __blk_crypto_evict_key() ignore slot_refs.  Let's go with the first
> solution, since it preserves the ability to report bugs (via
> WARN_ON_ONCE) where a key is evicted while still in-use.
>
> Fixes: a892c8d52c02 ("block: Inline encryption support for blk-mq")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/blk-crypto-internal.h | 15 +++++++++++----
>  block/blk-crypto.c          | 24 ++++++++++++------------
>  block/blk-mq.c              | 15 ++++++++++++++-
>  3 files changed, 37 insertions(+), 17 deletions(-)
>
> diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
> index a8cdaf26851e1..73609902349b6 100644
> --- a/block/blk-crypto-internal.h
> +++ b/block/blk-crypto-internal.h
> @@ -153,14 +153,21 @@ static inline bool blk_crypto_bio_prep(struct bio *=
*bio_ptr)
>         return true;
>  }
>
> -blk_status_t __blk_crypto_init_request(struct request *rq);
> -static inline blk_status_t blk_crypto_init_request(struct request *rq)
> +blk_status_t __blk_crypto_rq_get_keyslot(struct request *rq);
> +static inline blk_status_t blk_crypto_rq_get_keyslot(struct request *rq)
>  {
>         if (blk_crypto_rq_is_encrypted(rq))
> -               return __blk_crypto_init_request(rq);
> +               return __blk_crypto_rq_get_keyslot(rq);
>         return BLK_STS_OK;
>  }
>
> +void __blk_crypto_rq_put_keyslot(struct request *rq);
> +static inline void blk_crypto_rq_put_keyslot(struct request *rq)
> +{
> +       if (blk_crypto_rq_is_encrypted(rq))
> +               __blk_crypto_rq_put_keyslot(rq);
> +}
> +
>  void __blk_crypto_free_request(struct request *rq);
>  static inline void blk_crypto_free_request(struct request *rq)
>  {
> @@ -199,7 +206,7 @@ static inline blk_status_t blk_crypto_insert_cloned_r=
equest(struct request *rq)
>  {
>
>         if (blk_crypto_rq_is_encrypted(rq))
> -               return blk_crypto_init_request(rq);
> +               return blk_crypto_rq_get_keyslot(rq);
>         return BLK_STS_OK;
>  }
>
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index 45378586151f7..8e5612364c48c 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -224,27 +224,27 @@ static bool bio_crypt_check_alignment(struct bio *b=
io)
>         return true;
>  }
>
> -blk_status_t __blk_crypto_init_request(struct request *rq)
> +blk_status_t __blk_crypto_rq_get_keyslot(struct request *rq)
>  {
>         return blk_crypto_get_keyslot(rq->q->crypto_profile,
>                                       rq->crypt_ctx->bc_key,
>                                       &rq->crypt_keyslot);
>  }
>
> -/**
> - * __blk_crypto_free_request - Uninitialize the crypto fields of a reque=
st.
> - *
> - * @rq: The request whose crypto fields to uninitialize.
> - *
> - * Completely uninitializes the crypto fields of a request. If a keyslot=
 has
> - * been programmed into some inline encryption hardware, that keyslot is
> - * released. The rq->crypt_ctx is also freed.
> - */
> -void __blk_crypto_free_request(struct request *rq)
> +void __blk_crypto_rq_put_keyslot(struct request *rq)
>  {
>         blk_crypto_put_keyslot(rq->crypt_keyslot);
> +       rq->crypt_keyslot =3D NULL;
> +}
> +
> +void __blk_crypto_free_request(struct request *rq)
> +{
>         mempool_free(rq->crypt_ctx, bio_crypt_ctx_pool);
> -       blk_crypto_rq_set_defaults(rq);
> +       rq->crypt_ctx =3D NULL;
> +
> +       /* The keyslot, if one was needed, should have been released earl=
ier. */
> +       if (WARN_ON_ONCE(rq->crypt_keyslot))
> +               __blk_crypto_rq_put_keyslot(rq);
>  }
>
>  /**
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index d3494a796ba80..738e81f518227 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -840,6 +840,12 @@ static void blk_complete_request(struct request *req=
)
>                 req->q->integrity.profile->complete_fn(req, total_bytes);
>  #endif
>
> +       /*
> +        * Upper layers may call blk_crypto_evict_key() anytime after the=
 last
> +        * bio_endio().  Therefore, the keyslot must be released before t=
hat.
> +        */
> +       blk_crypto_rq_put_keyslot(req);
> +
>         blk_account_io_completion(req, total_bytes);
>
>         do {
> @@ -905,6 +911,13 @@ bool blk_update_request(struct request *req, blk_sta=
tus_t error,
>                 req->q->integrity.profile->complete_fn(req, nr_bytes);
>  #endif
>
> +       /*
> +        * Upper layers may call blk_crypto_evict_key() anytime after the=
 last
> +        * bio_endio().  Therefore, the keyslot must be released before t=
hat.
> +        */
> +       if (blk_crypto_rq_is_encrypted(req) && nr_bytes >=3D blk_rq_bytes=
(req))
> +               __blk_crypto_rq_put_keyslot(req);
> +
>         if (unlikely(error && !blk_rq_is_passthrough(req) &&
>                      !(req->rq_flags & RQF_QUIET)) &&
>                      !test_bit(GD_DEAD, &req->q->disk->state)) {
> @@ -2967,7 +2980,7 @@ void blk_mq_submit_bio(struct bio *bio)
>
>         blk_mq_bio_to_request(rq, bio, nr_segs);
>
> -       ret =3D blk_crypto_init_request(rq);
> +       ret =3D blk_crypto_rq_get_keyslot(rq);
>         if (ret !=3D BLK_STS_OK) {
>                 bio->bi_status =3D ret;
>                 bio_endio(bio);
> --
> 2.39.2
>

Thanks for the updated patchset. This patch looks good to me.

Reviewed-by: Nathan Huckleberry <nhuck@google.com>

Thanks,
Huck
