Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1E053B456
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 09:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiFBHav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 03:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiFBHau (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 03:30:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEAD235B2C;
        Thu,  2 Jun 2022 00:30:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AB6CA21B21;
        Thu,  2 Jun 2022 07:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654155047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uSdg+yWYbbjwTkWdTUxdBe3ogemj31IMyfeUn+WjAp8=;
        b=VKaGDwBGAfWTA9JxymucUlxI6nys+Qrwu8jJElz0z8s06d5dFgLucetqfViVTE3mK1KceB
        6vhwEwlKn1go1ISyMTSOprMOazmXqKs9TPSHC46IB29LHcd4YI1cXhh+Fgs5mR8YWzkyU1
        5XS3ar0M1ToQolFHCtorBBh9jex6U7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654155047;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uSdg+yWYbbjwTkWdTUxdBe3ogemj31IMyfeUn+WjAp8=;
        b=QbzTtPxzHN258STKd/R+QvqZLQHParpnhaKBQg/mYKl+cx23QZ4urWazbzBNim8qrSoEYY
        uTIlzztyP4llZUAw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 605D22C141;
        Thu,  2 Jun 2022 07:30:47 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 14EA2A0633; Thu,  2 Jun 2022 09:30:47 +0200 (CEST)
Date:   Thu, 2 Jun 2022 09:30:47 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>, stable@vger.kernel.org
Subject: Re: [PATCH] block: fix bio_clone_blkg_association() to associate
 with proper blkcg_gq
Message-ID: <20220602073047.2utry7gvjlu2xoyh@quack3.lan>
References: <20220601163405.29478-1-jack@suse.cz>
 <YpelCJ66S9KaYg+0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpelCJ66S9KaYg+0@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 01-06-22 10:42:32, Christoph Hellwig wrote:
> On Wed, Jun 01, 2022 at 06:34:05PM +0200, Jan Kara wrote:
> > --- a/block/blk-cgroup.c
> > +++ b/block/blk-cgroup.c
> > @@ -1975,10 +1975,9 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
> >  void bio_clone_blkg_association(struct bio *dst, struct bio *src)
> >  {
> >  	if (src->bi_blkg) {
> > +		rcu_read_lock();
> > +		bio_associate_blkg_from_css(dst, bio_blkcg_css(src));
> > +		rcu_read_unlock();
> 
> What do we even need the rcu critical section here?

Good question. I've just blindly copied it from bio_associate_blkg() but
bio_blkcg_css(src) is safe without RCU (we hold object references for all
the dereferences) and bio_associate_blkg_from_css() takes RCU lock in
blkg_tryget_closest() which is the only place where it needs it. So no, we
don't need the RCU lock there. Thanks for noticing. I'll send V2 shortly
with your change and the added tags.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for review!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
