Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED16B83F6
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 22:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCMV0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 17:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCMV0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 17:26:52 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0390884F59
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 14:26:47 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l12so4325139wrm.10
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 14:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678742806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s15Olw145Z4FO4sJQbn04iS8rc4A9F0RRMP8zoY3AG4=;
        b=Dj+OadbgSZ40SGxBNfv3esbcqm0c7MMatXy7VjnNjwla00odXbiumbSrs+aAAyTLid
         WQ8eT233AHca0GqfwA7VzjwO9OfbYwlg9inefEs6o1UUCSo6teYv4MNAP9bG/pSFrIEl
         YGk5GsWAxAZoVndetTEYpJ5FEwHyDnKEk5Fv29ZZjFmBTkqK6hNEbnQz6iIafN4ZhRux
         Vba7RxFSTbUMXflwcLP5SwcWSxNZKJAU+jFnq41xzNz99UXOoHGFf90hh8pj+FYe1dJs
         3Vwc2aZKZ3wWTX0u3SHq8jyth/QfIbK475V3MBYeZaEgKZU+3i8rMQl4jTLixMQCVz/E
         uDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678742806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s15Olw145Z4FO4sJQbn04iS8rc4A9F0RRMP8zoY3AG4=;
        b=FHlBocX/pStcDcJRD8uEcKACU7t7lY9QQ2d+S1x/w6SX3JmTMXcw66mGADoZrLyl9V
         yyvcq6JxVfPWHaZNiqLjD6/6mRRFHK2LTKQV82r4rkZGEtUNL8RyumBTH3bV85K4EJVC
         oqdgtNf1P2bmSfVHFsJHTWm1KcZ10w3gPJDXJUrgkAkrCjh5/5WwOtzIoiy15ACspusT
         e4SsbryOG/C6q1k5QwYclkk9IDVqw5CbcjEFG2AmoGJv3m3ZObMhIX22ywzBhJjAYu6m
         iLqlhezPVpvrx5E0n0PBGn7FG/w8V/71qqpr54OzllQiFf2ZrAeBysseWQGxhxkuqps4
         Ns3g==
X-Gm-Message-State: AO0yUKXJcPOgZn6E/8s+gvVgiWpZL68875AafZg7Pr3KeKnrjaw+2k86
        0/HEuKc7hZTxslpkFvyTOi4F5gVQ6y64j0FbM6ohQA==
X-Google-Smtp-Source: AK7set/zbCALuj05w9+p7BPnzm7X9DKsWzxMFIYzWjEQQWyYvQWX2aEOk7lpqzYSSNiGefNnjwV2SKycoVrOsz53+qQ=
X-Received: by 2002:a5d:62d0:0:b0:2ce:a8d6:570f with SMTP id
 o16-20020a5d62d0000000b002cea8d6570fmr1418584wrv.4.1678742806297; Mon, 13 Mar
 2023 14:26:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230308193645.114069-1-ebiggers@kernel.org> <20230308193645.114069-2-ebiggers@kernel.org>
In-Reply-To: <20230308193645.114069-2-ebiggers@kernel.org>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Mon, 13 Mar 2023 14:26:00 -0700
Message-ID: <CAJkfWY76-fUf92YZid3bOPrufXwCzM-q9L1ezqkLZ+WJiWL3jQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] blk-mq: release crypto keyslot before reporting
 I/O complete
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

On Wed, Mar 8, 2023 at 11:39=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
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
>  block/blk-crypto-internal.h | 25 +++++++++++++++++++++----
>  block/blk-crypto.c          | 24 ++++++++++++------------
>  block/blk-merge.c           |  2 ++
>  block/blk-mq.c              | 15 ++++++++++++++-
>  4 files changed, 49 insertions(+), 17 deletions(-)
>
> diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
> index a8cdaf26851e..4f1de2495f0c 100644
> --- a/block/blk-crypto-internal.h
> +++ b/block/blk-crypto-internal.h
> @@ -65,6 +65,11 @@ static inline bool blk_crypto_rq_is_encrypted(struct r=
equest *rq)
>         return rq->crypt_ctx;
>  }
>
> +static inline bool blk_crypto_rq_has_keyslot(struct request *rq)
> +{
> +       return rq->crypt_keyslot;
> +}
> +
>  blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
>                                     const struct blk_crypto_key *key,
>                                     struct blk_crypto_keyslot **slot_ptr)=
;
> @@ -119,6 +124,11 @@ static inline bool blk_crypto_rq_is_encrypted(struct=
 request *rq)
>         return false;
>  }
>
> +static inline bool blk_crypto_rq_has_keyslot(struct request *rq)
> +{
> +       return false;
> +}
> +
>  #endif /* CONFIG_BLK_INLINE_ENCRYPTION */
>
>  void __bio_crypt_advance(struct bio *bio, unsigned int bytes);
> @@ -153,14 +163,21 @@ static inline bool blk_crypto_bio_prep(struct bio *=
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
> +       if (blk_crypto_rq_has_keyslot(rq))
> +               __blk_crypto_rq_put_keyslot(rq);
> +}
> +
>  void __blk_crypto_free_request(struct request *rq);
>  static inline void blk_crypto_free_request(struct request *rq)
>  {
> @@ -199,7 +216,7 @@ static inline blk_status_t blk_crypto_insert_cloned_r=
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
> index 45378586151f..d0c7feb447e9 100644
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
> +       /* The keyslot, if one was needed, should have been released earl=
ier. */
> +       if (WARN_ON_ONCE(rq->crypt_keyslot))
> +               __blk_crypto_rq_put_keyslot(rq);
> +
>         mempool_free(rq->crypt_ctx, bio_crypt_ctx_pool);
> -       blk_crypto_rq_set_defaults(rq);
> +       rq->crypt_ctx =3D NULL;
>  }
>
>  /**
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 6460abdb2426..65e75efa9bd3 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -867,6 +867,8 @@ static struct request *attempt_merge(struct request_q=
ueue *q,
>         if (!blk_discard_mergable(req))
>                 elv_merge_requests(q, req, next);
>
> +       blk_crypto_rq_put_keyslot(next);
> +

This looks good to me, but it looks like there was a pre-existing bug
in the blk-merge code. The elv_merged_request function is only called
when the request does not merge. Does anyone know if that behavior is
correct?

>         /*
>          * 'next' is going away, so update stats accordingly
>          */
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index d0cb2ef18fe2..49825538d932 100644
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
> +       if (blk_crypto_rq_has_keyslot(req) && nr_bytes >=3D blk_rq_bytes(=
req))
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

This patch itself looks good to me.

Reviewed-by: Nathan Huckleberry <nhuck@google.com>
