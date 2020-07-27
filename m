Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6796122F33A
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 17:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgG0PAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 11:00:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgG0PAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 11:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595862018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wnitoymfQEUjS6w0iAPbQqMgOxxH+kRHvYNw3Wi9zi4=;
        b=AcdJ50hWcUZOoES6C2LV+IqNBG/8QGmbqZDor+eepcL9wPnSj4G4beNNdCUT06Iife/2+w
        gFODeszZWtknoF0dcox34Bmjel4Eazd5cMq000NLEcW68FcHLeU0ZEBWdxdYj2VOM19o37
        vg8qTt1bbhJPemhyA833hOibS7kU6Qg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-JakRd3drOWSbfKceE5wqqQ-1; Mon, 27 Jul 2020 11:00:16 -0400
X-MC-Unique: JakRd3drOWSbfKceE5wqqQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AF6879ED0;
        Mon, 27 Jul 2020 15:00:15 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B6CD70BB9;
        Mon, 27 Jul 2020 15:00:15 +0000 (UTC)
Date:   Mon, 27 Jul 2020 11:00:14 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     John Donnelly <John.P.donnelly@oracle.com>, stable@vger.kernel.org
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
Message-ID: <20200727150014.GA27472@redhat.com>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This mail needs to be saent to stable@vger.kernel.org (now cc'd).

Greg et al: please backport 2df3bae9a6543e90042291707b8db0cbfbae9ee9

Thanks,
Mike

On Mon, Jul 27 2020 at  9:40am -0400,
John Donnelly <John.P.donnelly@oracle.com> wrote:

> From: Mike Snitzer <snitzer@redhat.com>
> 
> Discontinue issuing writethrough write IO in series to the origin and
> then cache.
> 
> Use bio_clone_fast() to create a new origin clone bio that will be
> mapped to the origin device and then bio_chain() it to the bio that gets
> remapped to the cache device. The origin clone bio does _not_ have a
> copy of the per_bio_data -- as such check_if_tick_bio_needed() will not
> be called.
> 
> The cache bio (parent bio) will not complete until the origin bio has
> completed -- this fulfills bio_clone_fast()'s requirements as well as
> the requirement to not complete the original IO until the write IO has
> completed to both the origin and cache device.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> (cherry picked from commit 2df3bae9a6543e90042291707b8db0cbfbae9ee9)
> 
> Fixes: 705559706d62038b74c5088114c1799cf2c9dce8 (dm bio record:
> save/restore bi_end_io and bi_integrity, version 4.14.188)
> 
> 70555970 introduced a mkfs.ext4 hang on a LVM device that has been
> modified with lvconvert --cachemode=writethrough.
> 
> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> Tested-by: John Donnelly <john.p.donnelly@oracle.com>
> Reviewed-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
> 
> conflict: drivers/md/dm-cache-target.c - Corrected syntax of
> writethrough_mode(&cache->feature) that was caught by
> arm compiler.
> 
> cc: stable@vger.kernel.org
> cc: snitzer@redhat.com
> ---
> drivers/md/dm-cache-target.c | 54 ++++++++++++++++++++++++------------
> 1 file changed, 37 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 69cdb29ef6be..8241b7c36655 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -450,6 +450,7 @@ struct cache {
> struct work_struct migration_worker;
> struct delayed_work waker;
> struct dm_bio_prison_v2 *prison;
> + struct bio_set *bs;
> mempool_t *migration_pool;
> @@ -868,16 +869,23 @@ static void check_if_tick_bio_needed(struct
> cache *cache, struct bio *bio)
> spin_unlock_irqrestore(&cache->lock, flags);
> }
> -static void remap_to_origin_clear_discard(struct cache *cache,
> struct bio *bio,
> - dm_oblock_t oblock)
> +static void __remap_to_origin_clear_discard(struct cache *cache,
> struct bio *bio,
> + dm_oblock_t oblock, bool bio_has_pbd)
> {
> - // FIXME: this is called way too much.
> - check_if_tick_bio_needed(cache, bio);
> + if (bio_has_pbd)
> + check_if_tick_bio_needed(cache, bio);
> remap_to_origin(cache, bio);
> if (bio_data_dir(bio) == WRITE)
> clear_discard(cache, oblock_to_dblock(cache, oblock));
> }
> +static void remap_to_origin_clear_discard(struct cache *cache,
> struct bio *bio,
> + dm_oblock_t oblock)
> +{
> + // FIXME: check_if_tick_bio_needed() is called way too much
> through this interface
> + __remap_to_origin_clear_discard(cache, bio, oblock, true);
> +}
> +
> static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
> dm_oblock_t oblock, dm_cblock_t cblock)
> {
> @@ -971,23 +979,25 @@ static void writethrough_endio(struct bio *bio)
> }
> /*
> - * FIXME: send in parallel, huge latency as is.
> * When running in writethrough mode we need to send writes to clean blocks
> - * to both the cache and origin devices. In future we'd like to clone the
> - * bio and send them in parallel, but for now we're doing them in
> - * series as this is easier.
> + * to both the cache and origin devices. Clone the bio and send
> them in parallel.
> */
> -static void remap_to_origin_then_cache(struct cache *cache, struct
> bio *bio,
> - dm_oblock_t oblock, dm_cblock_t cblock)
> +static void remap_to_origin_and_cache(struct cache *cache, struct bio *bio,
> + dm_oblock_t oblock, dm_cblock_t cblock)
> {
> - struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
> + struct bio *origin_bio = bio_clone_fast(bio, GFP_NOIO, cache->bs);
> - pb->cache = cache;
> - pb->cblock = cblock;
> - dm_hook_bio(&pb->hook_info, bio, writethrough_endio, NULL);
> - dm_bio_record(&pb->bio_details, bio);
> + BUG_ON(!origin_bio);
> - remap_to_origin_clear_discard(pb->cache, bio, oblock);
> + bio_chain(origin_bio, bio);
> + /*
> + * Passing false to __remap_to_origin_clear_discard() skips
> + * all code that might use per_bio_data (since clone doesn't have it)
> + */
> + __remap_to_origin_clear_discard(cache, origin_bio, oblock, false);
> + submit_bio(origin_bio);
> +
> + remap_to_cache(cache, bio, cblock);
> }
> /*----------------------------------------------------------------
> @@ -1873,7 +1883,7 @@ static int map_bio(struct cache *cache, struct
> bio *bio, dm_oblock_t block,
> } else {
> if (bio_data_dir(bio) == WRITE && writethrough_mode(&cache->features) &&
> !is_dirty(cache, cblock)) {
> - remap_to_origin_then_cache(cache, bio, block, cblock);
> + remap_to_origin_and_cache(cache, bio, block, cblock);
> accounted_begin(cache, bio);
> } else
> remap_to_cache_dirty(cache, bio, block, cblock);
> @@ -2132,6 +2142,9 @@ static void destroy(struct cache *cache)
> kfree(cache->ctr_args[i]);
> kfree(cache->ctr_args);
> + if (cache->bs)
> + bioset_free(cache->bs);
> +
> kfree(cache);
> }
> @@ -2589,6 +2602,13 @@ static int cache_create(struct cache_args
> *ca, struct cache **result)
> cache->features = ca->features;
> ti->per_io_data_size = get_per_bio_data_size(cache);
> + if (writethrough_mode(&cache->features)) {
> + /* Create bioset for writethrough bios issued to origin */
> + cache->bs = bioset_create(BIO_POOL_SIZE, 0, 0);
> + if (!cache->bs)
> + goto bad;
> + }
> +
> cache->callbacks.congested_fn = cache_is_congested;
> dm_table_add_target_callbacks(ti->table, &cache->callbacks);
> 
> -- 
> 2.26.2
> 

