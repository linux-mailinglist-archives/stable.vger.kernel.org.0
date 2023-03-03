Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491E56AA050
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 20:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjCCTuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 14:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjCCTuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 14:50:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC29584BD;
        Fri,  3 Mar 2023 11:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B472EB819A2;
        Fri,  3 Mar 2023 19:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD9BC433EF;
        Fri,  3 Mar 2023 19:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677873010;
        bh=IydYjsOOx10J1b/B6kDx8Y4eevWR1c1/dChRcu7QEws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g4yBryozmEmQ46nrauBa8nJdUS+M3JMB6tXnJnXKBD5j8ZXcF74d++G25I+z2C2eF
         Tsy1dHFyGDH4H9kB6+Az/8m57EaMJIzyVRD3bqp7NFfQDbLPFCdyjac9QLk8ZWSJML
         4Kp7j3922225BRy5bk702GbdOzUjPximYLRrSPQqqCTIk/p4jiTSpjv1xqgCyIKBlz
         ItFv8r9SDEVSt6MsWo8Be54k7JbcCcnbJhnu5i5Oum9Nf5xSrb4/EER4ElHMN+GUOJ
         uRd755h6PuEPOsKBhwFJKwacTOI6sRoUR3JctZQbH8qLCzvL8tSC69S4GduZIwoU1P
         V4Gq/U2zxuW7w==
Date:   Fri, 3 Mar 2023 19:50:08 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] blk-crypto: make blk_crypto_evict_key() more robust
Message-ID: <ZAJPcMibOQ9DARmp@gmail.com>
References: <20230303071959.144604-1-ebiggers@kernel.org>
 <20230303071959.144604-3-ebiggers@kernel.org>
 <CAJkfWY7KNcJwLKST6TefRZ6TyFNd6C1LXo_tD2yWGdVMjmsOtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJkfWY7KNcJwLKST6TefRZ6TyFNd6C1LXo_tD2yWGdVMjmsOtA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 11:45:00AM -0800, Nathan Huckleberry wrote:
> >  int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
> >                            const struct blk_crypto_key *key)
> > @@ -389,22 +377,22 @@ int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
> >
> >         blk_crypto_hw_enter(profile);
> >         slot = blk_crypto_find_keyslot(profile, key);
> > -       if (!slot)
> > -               goto out_unlock;
> > -
> > -       if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)) {
> > -               err = -EBUSY;
> > -               goto out_unlock;
> > +       if (slot) {
> > +               if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)) {
> > +                       /* BUG: key is still in use by I/O */
> > +                       err = -EBUSY;
> > +               } else {
> > +                       err = profile->ll_ops.keyslot_evict(
> > +                                       profile, key,
> > +                                       blk_crypto_keyslot_index(slot));
> > +               }
> > +               /*
> > +                * Callers may free the key even on error, so unlink the key
> > +                * from the hash table and clear slot->key even on error.
> > +                */
> > +               hlist_del(&slot->hash_node);
> > +               slot->key = NULL;
> >         }
> 
> The !slot case still needs to be handled. If profile->num_slots != 0
> and !slot, we'll get an invalid index from blk_crypto_keyslot_index.
> 
> With that change,
> Reviewed-by: Nathan Huckleberry <nhuck@google.com>
> 
> Thanks,
> Huck
> 
> > -       err = profile->ll_ops.keyslot_evict(profile, key,
> > -                                           blk_crypto_keyslot_index(slot));
> > -       if (err)
> > -               goto out_unlock;
> > -
> > -       hlist_del(&slot->hash_node);
> > -       slot->key = NULL;
> > -       err = 0;
> > -out_unlock:
> >         blk_crypto_hw_exit(profile);
> >         return err;
> >  }

I'm not sure what you're referring to.  The !slot case is handled correctly, and
it's the same as before.

- Eric
