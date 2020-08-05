Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D8523CC57
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgHEQiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 12:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgHEQgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:36:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D1023139;
        Wed,  5 Aug 2020 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596637917;
        bh=4l6PzSylny4AqO/Nz3Y+KnLCPnwMAkHpLaLWiehwhIw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BePY22krm9TUenyQaTu7sjfk+iLSWQ/n3Fxy4sLiFC41NpXJkG3iNUuJOtNqQkE/Z
         xkygmG5nRTMmFzDf/rWIXjuw+t8EDKoveniyZdWd+SIU4PhE30hpP+Ti3W8k8dlYnW
         vlBoMElh6zceLfDGYgKnbQ+AqZI9SFkwLQ3txlb8=
Date:   Wed, 5 Aug 2020 16:32:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Donnelly <john.p.donnelly@oracle.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4: {linux-4.14.y} ] dm cache: submit writethrough writes
 in parallel to origin and cache
Message-ID: <20200805143214.GB2154236@kroah.com>
References: <20200805000746.53112-1-john.p.donnelly@oracle.com>
 <0FFD1933-FB8F-4628-BAE6-1754E5A818BF@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0FFD1933-FB8F-4628-BAE6-1754E5A818BF@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 07:12:46PM -0500, John Donnelly wrote:
> 
> 
> > On Aug 4, 2020, at 7:07 PM, john.p.donnelly@oracle.com wrote:
> > 
> > From: Mike Snitzer <snitzer@redhat.com>
> > 
> > Discontinue issuing writethrough write IO in series to the origin and
> > then cache.
> > 
> > Use bio_clone_fast() to create a new origin clone bio that will be
> > mapped to the origin device and then bio_chain() it to the bio that gets
> > remapped to the cache device.  The origin clone bio does _not_ have a
> > copy of the per_bio_data -- as such check_if_tick_bio_needed() will not
> > be called.
> > 
> > The cache bio (parent bio) will not complete until the origin bio has
> > completed -- this fulfills bio_clone_fast()'s requirements as well as
> > the requirement to not complete the original IO until the write IO has
> > completed to both the origin and cache device.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > (cherry picked from commit 2df3bae9a6543e90042291707b8db0cbfbae9ee9)
> > 
> > Fixes: 4ec34f2196d125ff781170ddc6c3058c08ec5e73 (dm bio record:
> > save/restore bi_end_io and bi_integrity )
> > 
> > 4ec34f21 introduced a mkfs.ext4 hang on a LVM device that has been
> > modified with lvconvert --cachemode=writethrough.
> > 
> > CC:stable@vger.kernel.org for 4.14.y
> > 
> > Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> > Reviewed-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
> > ---
> > drivers/md/dm-cache-target.c | 92 ++++++++++++++++++--------------------------
> > 1 file changed, 37 insertions(+), 55 deletions(-)
> > 
> > diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> > index 69cdb29ef6be..2732d1df05fa 100644
> > --- a/drivers/md/dm-cache-target.c
> > +++ b/drivers/md/dm-cache-target.c
> > @@ -450,6 +450,7 @@ struct cache {
> > 	struct work_struct migration_worker;
> > 	struct delayed_work waker;
> > 	struct dm_bio_prison_v2 *prison;
> > +	struct bio_set *bs;
> > 
> > 	mempool_t *migration_pool;
> > 
> > @@ -537,11 +538,6 @@ static void wake_deferred_bio_worker(struct cache *cache)
> > 	queue_work(cache->wq, &cache->deferred_bio_worker);
> > }
> > 
> > -static void wake_deferred_writethrough_worker(struct cache *cache)
> > -{
> > -	queue_work(cache->wq, &cache->deferred_writethrough_worker);
> > -}
> > -
> > static void wake_migration_worker(struct cache *cache)
> > {
> > 	if (passthrough_mode(&cache->features))
> > @@ -868,16 +864,23 @@ static void check_if_tick_bio_needed(struct cache *cache, struct bio *bio)
> > 	spin_unlock_irqrestore(&cache->lock, flags);
> > }
> > 
> > -static void remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
> > -					  dm_oblock_t oblock)
> > +static void __remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
> > +					    dm_oblock_t oblock, bool bio_has_pbd)
> > {
> > -	// FIXME: this is called way too much.
> > -	check_if_tick_bio_needed(cache, bio);
> > +	if (bio_has_pbd)
> > +		check_if_tick_bio_needed(cache, bio);
> > 	remap_to_origin(cache, bio);
> > 	if (bio_data_dir(bio) == WRITE)
> > 		clear_discard(cache, oblock_to_dblock(cache, oblock));
> > }
> > 
> > +static void remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
> > +					  dm_oblock_t oblock)
> > +{
> > +	// FIXME: check_if_tick_bio_needed() is called way too much through this interface
> > +	__remap_to_origin_clear_discard(cache, bio, oblock, true);
> > +}
> > +
> > static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
> > 				 dm_oblock_t oblock, dm_cblock_t cblock)
> > {
> > @@ -937,57 +940,26 @@ static void issue_op(struct bio *bio, void *context)
> > 	accounted_request(cache, bio);
> > }
> > 
> > -static void defer_writethrough_bio(struct cache *cache, struct bio *bio)
> > -{
> > -	unsigned long flags;
> > -
> > -	spin_lock_irqsave(&cache->lock, flags);
> > -	bio_list_add(&cache->deferred_writethrough_bios, bio);
> > -	spin_unlock_irqrestore(&cache->lock, flags);
> > -
> > -	wake_deferred_writethrough_worker(cache);
> > -}
> > -
> > -static void writethrough_endio(struct bio *bio)
> > -{
> > -	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
> > -
> > -	dm_unhook_bio(&pb->hook_info, bio);
> > -
> > -	if (bio->bi_status) {
> > -		bio_endio(bio);
> > -		return;
> > -	}
> > -
> > -	dm_bio_restore(&pb->bio_details, bio);
> > -	remap_to_cache(pb->cache, bio, pb->cblock);
> > -
> > -	/*
> > -	 * We can't issue this bio directly, since we're in interrupt
> > -	 * context.  So it gets put on a bio list for processing by the
> > -	 * worker thread.
> > -	 */
> > -	defer_writethrough_bio(pb->cache, bio);
> > -}
> > -
> > /*
> > - * FIXME: send in parallel, huge latency as is.
> >  * When running in writethrough mode we need to send writes to clean blocks
> > - * to both the cache and origin devices.  In future we'd like to clone the
> > - * bio and send them in parallel, but for now we're doing them in
> > - * series as this is easier.
> > + * to both the cache and origin devices.  Clone the bio and send them in parallel.
> >  */
> > -static void remap_to_origin_then_cache(struct cache *cache, struct bio *bio,
> > -				       dm_oblock_t oblock, dm_cblock_t cblock)
> > +static void remap_to_origin_and_cache(struct cache *cache, struct bio *bio,
> > +				      dm_oblock_t oblock, dm_cblock_t cblock)
> > {
> > -	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
> > +	struct bio *origin_bio = bio_clone_fast(bio, GFP_NOIO, cache->bs);
> > +
> > +	BUG_ON(!origin_bio);
> > 
> > -	pb->cache = cache;
> > -	pb->cblock = cblock;
> > -	dm_hook_bio(&pb->hook_info, bio, writethrough_endio, NULL);
> > -	dm_bio_record(&pb->bio_details, bio);
> > +	bio_chain(origin_bio, bio);
> > +	/*
> > +	 * Passing false to __remap_to_origin_clear_discard() skips
> > +	 * all code that might use per_bio_data (since clone doesn't have it)
> > +	 */
> > +	__remap_to_origin_clear_discard(cache, origin_bio, oblock, false);
> > +	submit_bio(origin_bio);
> > 
> > -	remap_to_origin_clear_discard(pb->cache, bio, oblock);
> > +	remap_to_cache(cache, bio, cblock);
> > }
> > 
> > /*----------------------------------------------------------------
> > @@ -1873,7 +1845,7 @@ static int map_bio(struct cache *cache, struct bio *bio, dm_oblock_t block,
> > 		} else {
> > 			if (bio_data_dir(bio) == WRITE && writethrough_mode(&cache->features) &&
> > 			    !is_dirty(cache, cblock)) {
> > -				remap_to_origin_then_cache(cache, bio, block, cblock);
> > +				remap_to_origin_and_cache(cache, bio, block, cblock);
> > 				accounted_begin(cache, bio);
> > 			} else
> > 				remap_to_cache_dirty(cache, bio, block, cblock);
> > @@ -2132,6 +2104,9 @@ static void destroy(struct cache *cache)
> > 		kfree(cache->ctr_args[i]);
> > 	kfree(cache->ctr_args);
> > 
> > +	if (cache->bs)
> > +		bioset_free(cache->bs);
> > +
> > 	kfree(cache);
> > }
> > 
> > @@ -2589,6 +2564,13 @@ static int cache_create(struct cache_args *ca, struct cache **result)
> > 	cache->features = ca->features;
> > 	ti->per_io_data_size = get_per_bio_data_size(cache);
> > 
> > +	if (writethrough_mode(&cache->features)) {
> > +		/* Create bioset for writethrough bios issued to origin */
> > +		cache->bs = bioset_create(BIO_POOL_SIZE, 0, 0);
> > +		if (!cache->bs)
> > +			goto bad;
> > +	}
> > +
> > 	cache->callbacks.congested_fn = cache_is_congested;
> > 	dm_table_add_target_callbacks(ti->table, &cache->callbacks);
> > 
> > -- 
> > 1.8.3.1
> > 
> 
> Hi Greg,
> 
> I was working out my sendmail setup   

Dude, we got 5 different copies of this.  Try testing email setups on a
non-globally-distributed mailing list first, otherwise it just looks
like spam...

greg k-h
