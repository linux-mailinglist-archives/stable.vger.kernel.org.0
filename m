Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034EA6BB994
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 17:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjCOQXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 12:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjCOQXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 12:23:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897BF149A3;
        Wed, 15 Mar 2023 09:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wvMynr2VWlIto3th1e64QJ0ma0iuT+GT7tW+Vqjfsds=; b=K8yVqOs0pjsAaGgPzYYCw538Ob
        Pba0j65JqXVvMGpc639dvYt33nMYdhxlEceILXPTEGOOW34gox593dcrtHGUlXwuJ5oyJ1EqpOPX9
        dvrOZw9kS3E4M7JbV9nbui+fzJ1I8nFBvj9n/aUYuVYcQq3sG6zVy3FF885e1Co9LSBXi5MW/a8Qc
        lPSW/cADyzEaAqrWTuouKfewPQyGGco5HnbPA0ygxsCI9wVFw+iGShhlA/8pTjKtdP1mx9g+ygJOc
        NTl+dt8hWlw2BB8hOvCUmNbiOwitH66IV6NGWAahvlSNPi+R/UZNcb4SN7qnGf6K9DL6FXAzGQbgh
        PuZ7S/PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pcTuC-00E32v-0q;
        Wed, 15 Mar 2023 16:23:12 +0000
Date:   Wed, 15 Mar 2023 09:23:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] blk-crypto: make blk_crypto_evict_key() more
 robust
Message-ID: <ZBHw8DteTQq6p97i@infradead.org>
References: <20230308193645.114069-1-ebiggers@kernel.org>
 <20230308193645.114069-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308193645.114069-3-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 11:36:43AM -0800, Eric Biggers wrote:
>  			   const struct blk_crypto_key *key)
> @@ -389,22 +377,22 @@ int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
>  
>  	blk_crypto_hw_enter(profile);
>  	slot = blk_crypto_find_keyslot(profile, key);
> +	if (slot) {

Isn't !slot also an error condition that we should warn on?

> +		if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)) {
> +			/* BUG: key is still in use by I/O */
> +			err = -EBUSY;

Either way two gotos to jump forward for the error case would improve
the readability of the code a fair bit I think.

> +		} else {
> +			err = profile->ll_ops.keyslot_evict(
> +					profile, key,
> +					blk_crypto_keyslot_index(slot));
> +		}
> +		/*
> +		 * Callers may free the key even on error, so unlink the key
> +		 * from the hash table and clear slot->key even on error.
> +		 */
> +		hlist_del(&slot->hash_node);
> +		slot->key = NULL;
>  	}
>  	blk_crypto_hw_exit(profile);
>  	return err;

Also given your above accurate description of the calling context,
what is the point of even returning an error here vs just logging
an error message?

