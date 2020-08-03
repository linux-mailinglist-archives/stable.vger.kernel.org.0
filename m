Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788AA23ABB7
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgHCRe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 13:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbgHCRe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 13:34:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FAEF20792;
        Mon,  3 Aug 2020 17:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596476064;
        bh=8qhgGcjUGGQVPeTwcxPq6dlQrUZ46RsvbHJ1V629W2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bJcL8ebCodkSrY0t/NQnASc0W/+RC0yt3SkPlWPkn8Xp4iV77pdxCqnIlFyGqIIRw
         tvcowQyY0PSz3Agy1G70EMgqCxgKhARLnDejxoMobyguJfQLbN2DtOC8YZLTmL97h2
         9BM+A6jbhNeono/kjKRkPelWYhG/vcS6uSJW0VEE=
Date:   Mon, 3 Aug 2020 19:34:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Donnelly <John.P.donnelly@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3: {linux-4.14.y} ] dm cache: submit writethrough writes
 in parallel to origin and cache
Message-ID: <20200803173407.GB1186998@kroah.com>
References: <572f607f-be07-9dc5-fc80-b33a2653683a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <572f607f-be07-9dc5-fc80-b33a2653683a@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 12:27:31PM -0500, John Donnelly wrote:
> From: Mike Snitzer <snitzer@redhat.com>
> 
> Discontinue issuing writethrough write IO in series to the origin and
> then cache.
> 
> Use bio_clone_fast() to create a new origin clone bio that will be
> mapped to the origin device and then bio_chain() it to the bio that gets
> remapped to the cache device.  The origin clone bio does _not_ have a
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
> Fixes: 4ec34f2196d125ff781170ddc6c3058c08ec5e73 (dm bio record:
> save/restore bi_end_io and bi_integrity )
> 
> 4ec34f21 introduced a mkfs.ext4 hang on a LVM device that has been
> modified with lvconvert --cachemode=writethrough.
> 
> CC:stable@vger.kernel.org for 4.14.y
> 
> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> Reviewed-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
> 
> conflicts:
> 	drivers/md/dm-cache-target.c. -  Corrected usage of
> 	writethrough_mode(&cache->feature) that was caught by
> 	compiler, and removed unused static functions : writethrough_endio(),
> 	defer_writethrough_bio(), wake_deferred_writethrough_worker()
> 	that generated warnings.
> ---
>  drivers/md/dm-cache-target.c | 92
> ++++++++++++++++++--------------------------
>  1 file changed, 37 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 69cdb29ef6be..2732d1df05fa 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -450,6 +450,7 @@ struct cache {
>  	struct work_struct migration_worker;
>  	struct delayed_work waker;
>  	struct dm_bio_prison_v2 *prison;
> +	struct bio_set *bs;
>   	mempool_t *migration_pool;
>  @@ -537,11 +538,6 @@ static void wake_deferred_bio_worker(struct cache
> *cache)

Line-wrapped and unable to apply :(

