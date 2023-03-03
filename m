Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0336AA03E
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 20:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjCCTqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 14:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjCCTqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 14:46:21 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDE13CE2D
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 11:46:18 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id r18so3374181wrx.1
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 11:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677872776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wiFYmcbjRQCcxu6RfAlmBanvwRYwXaIkO4gT2O+k/o4=;
        b=AI7jDc9ayrlEldLG0OWwztdfpR6wyHQ4Iw72Bsy3Ax7GLmvafHL+EUSArAatXaPsC7
         8DdG8df4mblo84ooFSQ8xwzD9ib4kJS6QPeAEwSgJxv1T7Fbu5MrBAIuxHXe2Rsk2MDO
         N7Zn+fNL+1ccE/KJpwKkjTdTEvFmx3zECKfvBhDoG8+U6MGpQava9qWiKRWDmhSZr7ZN
         Mx/sWylRYNoQq3djej+l4M6qn3+jZRYKqiyZV7cVtud6EDCGWxoAma+6tk6gCw1Tvk4+
         neqZ49PaeeigElx1B78wt5DBY0BTQmOTuM8ub5jLM6Gn5mBSD6hgijSf9cO3nHZJ7c3N
         CUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677872776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wiFYmcbjRQCcxu6RfAlmBanvwRYwXaIkO4gT2O+k/o4=;
        b=pBifEMcyEOv9NJRpeNl5ofnKoIs/4az1lYwsAKR0bt7h0KFFn7PdqKBZaxJfS+8lQn
         W+bd3BaU54x0w4YlNBlvYNb/ho1bQvTZCreLf6vX786fZ+xrtJxuStYhybEgGB/iedON
         lPWfRbeM/lop2JCelWt/q6IAAehCcJLtxv2QWpS0gRQi/gEuq0OMyinkdfvufBgSRzSK
         TAORyPUb9ImmOwaYVp1qc3eql975uN8HdTGB2Jq8O9l6CmyYt6rsCmy9K9HAPCJMiIEP
         G2lJPN68m9X94ytXR9RXSVVGg0B92VA3o9J1x8cApre5kpCgf+bgda6m+T4/Bp5QBw+q
         Xr2A==
X-Gm-Message-State: AO0yUKVk6i7dHxsPAOy3k2YJteBtBCI9GUIQ3AF1NCVJWYOsIM00ueOZ
        yQieP6W70476NUvvOCXZXV/2fjZUP8uCx2BpiLAo5DYV2oglKEHAQ5A=
X-Google-Smtp-Source: AK7set9TYWdbfmd4MD2U4PcEsq6rOFmKMf7FYaq549xaMUSssyLGqjskIEHttQaDCC225QoIy+MR/hl7GI6UNvkPlpw=
X-Received: by 2002:a5d:4146:0:b0:2cb:c072:cf56 with SMTP id
 c6-20020a5d4146000000b002cbc072cf56mr611178wrq.7.1677872776478; Fri, 03 Mar
 2023 11:46:16 -0800 (PST)
MIME-Version: 1.0
References: <20230303071959.144604-1-ebiggers@kernel.org> <20230303071959.144604-3-ebiggers@kernel.org>
In-Reply-To: <20230303071959.144604-3-ebiggers@kernel.org>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Fri, 3 Mar 2023 11:45:00 -0800
Message-ID: <CAJkfWY7KNcJwLKST6TefRZ6TyFNd6C1LXo_tD2yWGdVMjmsOtA@mail.gmail.com>
Subject: Re: [PATCH 2/3] blk-crypto: make blk_crypto_evict_key() more robust
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
> If blk_crypto_evict_key() sees that the key is still in-use (due to a
> bug) or that ->keyslot_evict failed, it currently just returns an error
> while leaving the key linked into the keyslot management structures.
>
> However, blk_crypto_evict_key() is only called in contexts such as inode
> eviction where failure is not an option.  So actually the caller
> proceeds with freeing the blk_crypto_key regardless of the return value
> of blk_crypto_evict_key().
>
> These two assumptions don't match, and the result is that there can be a
> use-after-free in blk_crypto_reprogram_all_keys() after one of these
> errors occurs.  (Note, these errors *shouldn't* happen; we're just
> talking about what happens if they do anyway.)
>
> Fix this by making blk_crypto_evict_key() unlink the key from the
> keyslot management structures even on failure.
>
> Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/blk-crypto-profile.c | 50 +++++++++++++++-----------------------
>  block/blk-crypto.c         | 23 +++++++++++-------
>  2 files changed, 33 insertions(+), 40 deletions(-)
>
> diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
> index 0307fb0d95d34..1b20ead59f39b 100644
> --- a/block/blk-crypto-profile.c
> +++ b/block/blk-crypto-profile.c
> @@ -354,22 +354,10 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_p=
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
> + * It is used only by blk_crypto_evict_key(); see that function for deta=
ils.
>   */
>  int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
>                            const struct blk_crypto_key *key)
> @@ -389,22 +377,22 @@ int __blk_crypto_evict_key(struct blk_crypto_profil=
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
> +               if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) !=3D 0)) {
> +                       /* BUG: key is still in use by I/O */
> +                       err =3D -EBUSY;
> +               } else {
> +                       err =3D profile->ll_ops.keyslot_evict(
> +                                       profile, key,
> +                                       blk_crypto_keyslot_index(slot));
> +               }
> +               /*
> +                * Callers may free the key even on error, so unlink the =
key
> +                * from the hash table and clear slot->key even on error.
> +                */
> +               hlist_del(&slot->hash_node);
> +               slot->key =3D NULL;
>         }

The !slot case still needs to be handled. If profile->num_slots !=3D 0
and !slot, we'll get an invalid index from blk_crypto_keyslot_index.

With that change,
Reviewed-by: Nathan Huckleberry <nhuck@google.com>

Thanks,
Huck

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
> index 8e5612364c48c..caa86a210cb6c 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -399,17 +399,22 @@ int blk_crypto_start_using_key(struct block_device =
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
> + * keyslot(s) or blk-crypto-fallback keyslot it may have been programmed=
 into.
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
> + *        failed to be evicted from a keyslot or is still in-use.  Even =
on
> + *        "failure", the key is removed from the keyslot management stru=
ctures.
>   */
>  int blk_crypto_evict_key(struct block_device *bdev,
>                          const struct blk_crypto_key *key)
> --
> 2.39.2
>
