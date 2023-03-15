Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5BF6BBC03
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjCOS1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCOS1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:27:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2542B9DE;
        Wed, 15 Mar 2023 11:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45002B81ECC;
        Wed, 15 Mar 2023 18:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1C2C4339B;
        Wed, 15 Mar 2023 18:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678904820;
        bh=qRA32Ck8SnanqXkULNiubOSomcNgiM+++fkxIPwPbEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JbQV7smNIvX3vE2a1G5RMRov2APzjmvL0pTykVR1NTmVDfr1f8nSVYhr9dHznGcuB
         HWFf8JALw0ca8GQL8L9DEz3D/Unrh6VuvhCXHEciUEBUkOhsMWZenz4A9gX1z8DoeW
         a4m03BjFXpfPb3peRRvNyG386knQohGxSCh7Rd2bbg7RirJs/47HMqsmUKpNTfwh4I
         Dz2npTb+cQSTFtG0w6tgheW499MI87cXAS1MuSOXiZhRxi63mHqIpCulDmxdaTxvT+
         MLMK9umJl14Q56k68TVZ1WOL5UjYm+gtPDSpmI9rPbCanY2Gp09YibKQydo7yVAfpu
         IRTnmMuv+kojg==
Date:   Wed, 15 Mar 2023 11:26:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] blk-crypto: make blk_crypto_evict_key() more
 robust
Message-ID: <20230315182658.GB975@sol.localdomain>
References: <20230308193645.114069-1-ebiggers@kernel.org>
 <20230308193645.114069-3-ebiggers@kernel.org>
 <ZBHw8DteTQq6p97i@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBHw8DteTQq6p97i@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 09:23:12AM -0700, Christoph Hellwig wrote:
> On Wed, Mar 08, 2023 at 11:36:43AM -0800, Eric Biggers wrote:
> >  			   const struct blk_crypto_key *key)
> > @@ -389,22 +377,22 @@ int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
> >  
> >  	blk_crypto_hw_enter(profile);
> >  	slot = blk_crypto_find_keyslot(profile, key);
> > +	if (slot) {
> 
> Isn't !slot also an error condition that we should warn on?

No, definitely not.  Keys are not guaranteed to be in a keyslot.  I'll add a
comment here.

> 
> > +		if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)) {
> > +			/* BUG: key is still in use by I/O */
> > +			err = -EBUSY;
> 
> Either way two gotos to jump forward for the error case would improve
> the readability of the code a fair bit I think.

I slightly prefer it without the gotos, but sure I'll do it that way.

> > +		} else {
> > +			err = profile->ll_ops.keyslot_evict(
> > +					profile, key,
> > +					blk_crypto_keyslot_index(slot));
> > +		}
> > +		/*
> > +		 * Callers may free the key even on error, so unlink the key
> > +		 * from the hash table and clear slot->key even on error.
> > +		 */
> > +		hlist_del(&slot->hash_node);
> > +		slot->key = NULL;
> >  	}
> >  	blk_crypto_hw_exit(profile);
> >  	return err;
> 
> Also given your above accurate description of the calling context,
> what is the point of even returning an error here vs just logging
> an error message?

Yes, I was thinking about that too.  I'll add a patch that makes
blk_crypto_evict_key() log errors and return void.

- Eric
