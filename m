Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF286A8BCF
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 23:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjCBW2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 17:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCBW2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 17:28:47 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F25830D6
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 14:28:45 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id az36so568872wmb.1
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 14:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677796124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Vj3n17J4UgdgxdunAMrzoJFevXXkcwx5YlIl5ZnJ9Y=;
        b=hPeceQkjhxoONPAmn50T52d0isnq2oM5FHnMniCmafyx09keh8bwHTtc0DXPSf9ND0
         Enw4Z3Re3sZ71ajskh1HeAblgir/N44DTLJWJoVScXmhPG8NARglRsl4XBlpNxwV65fF
         dVZ/MNpcPVC5knCRr9A4XGlioKzxTv+P9q8KqxQq/0wnvJ9aynvSV38VsnVSvqlPvVVZ
         b6Iz/221kK3a13zLCdKMZ92qwUycU19azHksH2x47ijbdzDRRuiDwY8tMEWQu0GX1NH3
         uVr1aJan8+nHfYnHfS32sdqMQIsNSWRl7ClyWulY3YnaVfqyFH/dzmFwUhrjWt14Rp4S
         fq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677796124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Vj3n17J4UgdgxdunAMrzoJFevXXkcwx5YlIl5ZnJ9Y=;
        b=1HnlWpIvUYXu4bcjuIfxS4fdDZh15QISK78oMc+HjfPC88bfDeDxxI1ubeqsohgq2Y
         2+Onblj+ZP614wkT2le6AbGm4H8RtEfRxtYoVvKfPCuSIfrnumTzbojqc23Rdu23njVQ
         6hdfwcgOMAJ6XCU/lQEnagkKAu+Lw3enqTTZzBl8ICzcaQWRkWXG63cwid1U/A+UVT82
         YjmRU88vUZ9FZfLIVlrHanqdf8ajkshBDdkmZXvN4YHnRHOPmkVEfgv60HM0sQ4eadlI
         iLwmrUbUwELx6jv2rMcC922Xv0LJ1TvcXpQEwYvck1ld+epoh20lty8NIZiu4Nw1pTCq
         5Aiw==
X-Gm-Message-State: AO0yUKWz/BRq12XX9EFIuFwOHZaYiN46tklot50HfueIf5DoJdpN41hD
        rKrqY8xmGvMCRpt2NZPKiyIpWYDyJjPtVrE+wPf5Hg==
X-Google-Smtp-Source: AK7set9AK8tEjRaK45N3D28GJWdddaSrpNHG9WlN2hjy/6tNB9GLpHORVy0vGU9zd0OeZjGlYT8zF2XeiVpozat2OeA=
X-Received: by 2002:a05:600c:1f06:b0:3eb:5a1e:d52c with SMTP id
 bd6-20020a05600c1f0600b003eb5a1ed52cmr2111323wmb.2.1677796123880; Thu, 02 Mar
 2023 14:28:43 -0800 (PST)
MIME-Version: 1.0
References: <20230226203816.207449-1-ebiggers@kernel.org>
In-Reply-To: <20230226203816.207449-1-ebiggers@kernel.org>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Thu, 2 Mar 2023 14:28:00 -0800
Message-ID: <CAJkfWY4UOmizG=gm4+Zob7PhwMcmDe7mEviTb-hULT7ByCuqew@mail.gmail.com>
Subject: Re: [PATCH] blk-crypto: make blk_crypto_evict_key() always try to evict
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Eric,

On Sun, Feb 26, 2023 at 12:43=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Once all I/O using a blk_crypto_key has completed, filesystems can call
> blk_crypto_evict_key().  However, the block layer doesn't call
> blk_crypto_put_keyslot() until the request is being cleaned up, which
> happens after upper layers have been told (via bio_endio()) the I/O has
> completed.  This causes a race condition where blk_crypto_evict_key()
> can see 'slot_refs > 0' without there being an actual bug.
>
> This makes __blk_crypto_evict_key() hit the
> 'WARN_ON_ONCE(atomic_read(&slot->slot_refs) !=3D 0)' and return without
> doing anything, eventually causing a use-after-free in
> blk_crypto_reprogram_all_keys().  (This is a very rare bug and has only
> been seen when per-file keys are being used with fscrypt.)
>
> There are two options to fix this: either release the keyslot in
> blk_update_request() just before bio_endio() is called on the request's
> last bio, or just make __blk_crypto_evict_key() ignore slot_refs.  Let's
> go with the latter solution for now, since it avoids adding overhead to
> the loop in blk_update_request().  (It does have the disadvantage that
> hypothetical bugs where a key is evicted while still in-use become
> harder to detect.  But so far there haven't been any such bugs anyway.)

I disagree with the proposal to ignore the race condition in
blk_crypto_evict_key(). As you said, ignoring the error could lead to
undetected bugs in the future. Instead, I think we should focus on
fixing the function ordering so that blk_crypto_put_keyslot() is
called before blk_crypto_evict_key().

I think the overhead is a necessary trade-off to ensure correctness.

Thanks,
Huck

>
> A related issue with __blk_crypto_evict_key() is that ->keyslot_evict
> failing would cause the same use-after-free as well.  Fix this by always
> removing the key from the keyslot management structures.
>
> Update the function documentation to properly document the semantics.
>
> Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/blk-crypto-profile.c | 52 +++++++++++++++-----------------------
>  block/blk-crypto.c         | 24 +++++++++++-------
>  2 files changed, 36 insertions(+), 40 deletions(-)
>
> diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
> index 0307fb0d95d3..29b4148cc50d 100644
> --- a/block/blk-crypto-profile.c
> +++ b/block/blk-crypto-profile.c
> @@ -354,22 +354,11 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_p=
rofile *profile,
>         return true;
>  }
>
> -/**
> - * __blk_crypto_evict_key() - Evict a key from a device.
> - * @profile: the crypto profile of the device
> - * @key: the key to evict.  It must not still be used in any I/O.
> - *
> - * If the device has keyslots, this finds the keyslot (if any) that cont=
ains the
> - * specified key and calls the driver's keyslot_evict function to evict =
it.
> - *
> - * Otherwise, this just calls the driver's keyslot_evict function if it =
is
> - * implemented, passing just the key (without any particular keyslot).  =
This
> - * allows layered devices to evict the key from their underlying devices=
.
> - *
> - * Context: Process context. Takes and releases profile->lock.
> - * Return: 0 on success or if there's no keyslot with the specified key,=
 -EBUSY
> - *        if the keyslot is still in use, or another -errno value on oth=
er
> - *        error.
> +/*
> + * This is an internal function that evicts a key from an inline encrypt=
ion
> + * device that can be either a real device or the blk-crypto-fallback "d=
evice".
> + * It is used only for blk_crypto_evict_key().  For details on what this=
 does,
> + * see the documentation for blk_crypto_evict_key().
>   */
>  int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
>                            const struct blk_crypto_key *key)
> @@ -389,22 +378,23 @@ int __blk_crypto_evict_key(struct blk_crypto_profil=
e *profile,
>
>         blk_crypto_hw_enter(profile);
>         slot =3D blk_crypto_find_keyslot(profile, key);
> -       if (!slot)
> -               goto out_unlock;
> -
> -       if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) !=3D 0)) {
> -               err =3D -EBUSY;
> -               goto out_unlock;
> +       if (slot) {
> +               /*
> +                * Note: it is a bug if the key is still in use by I/O he=
re.
> +                * But 'slot_refs > 0' can't be used to detect such bugs =
here,
> +                * since the keyslot isn't released until after upper lay=
ers
> +                * have already been told the I/O is complete.
> +                */
> +               err =3D profile->ll_ops.keyslot_evict(
> +                               profile, key, blk_crypto_keyslot_index(sl=
ot));
> +               /*
> +                * Even on ->keyslot_evict failure, we must remove the
> +                * blk_crypto_key from the keyslot management structures,=
 since
> +                * the caller is allowed to free it regardless.
> +                */
> +               hlist_del(&slot->hash_node);
> +               slot->key =3D NULL;
>         }
> -       err =3D profile->ll_ops.keyslot_evict(profile, key,
> -                                           blk_crypto_keyslot_index(slot=
));
> -       if (err)
> -               goto out_unlock;
> -
> -       hlist_del(&slot->hash_node);
> -       slot->key =3D NULL;
> -       err =3D 0;
> -out_unlock:
>         blk_crypto_hw_exit(profile);
>         return err;
>  }
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index 45378586151f..3dcbe578beb2 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -399,17 +399,23 @@ int blk_crypto_start_using_key(struct block_device =
*bdev,
>  }
>
>  /**
> - * blk_crypto_evict_key() - Evict a key from any inline encryption hardw=
are
> - *                         it may have been programmed into
> - * @bdev: The block_device who's associated inline encryption hardware t=
his key
> - *     might have been programmed into
> - * @key: The key to evict
> + * blk_crypto_evict_key() - Evict a blk_crypto_key from a block_device
> + * @bdev: a block_device on which I/O using the key may have been done
> + * @key: the key to evict
>   *
> - * Upper layers (filesystems) must call this function to ensure that a k=
ey is
> - * evicted from any hardware that it might have been programmed into.  T=
he key
> - * must not be in use by any in-flight IO when this function is called.
> + * For a given block_device, this function removes the given blk_crypto_=
key from
> + * the keyslot management structures and evicts it from any underlying h=
ardware
> + * or fallback keyslot(s) it may have been programmed into.
>   *
> - * Return: 0 on success or if the key wasn't in any keyslot; -errno on e=
rror.
> + * Upper layers must call this before freeing the blk_crypto_key.  It mu=
st be
> + * called for every block_device the key may have been used on.  The key=
 must no
> + * longer be in use by any I/O when this function is called.
> + *
> + * Context: May sleep.
> + * Return: 0 on success or if the key wasn't in any keyslot; -errno if t=
he key
> + *        failed to be evicted from a hardware keyslot.  Even in the -er=
rno
> + *        case, the key is removed from the keyslot management structure=
s and
> + *        the caller is allowed (and expected) to free the blk_crypto_ke=
y.
>   */
>  int blk_crypto_evict_key(struct block_device *bdev,
>                          const struct blk_crypto_key *key)
>
> base-commit: 489fa31ea873282b41046d412ec741f93946fc2d
> --
> 2.39.2
>
