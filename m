Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA70B33027D
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCGPL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:11:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhCGPLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 10:11:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9071E64FC2;
        Sun,  7 Mar 2021 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615129874;
        bh=l1MDKkXQnLWGv2FtyNBqSGpJGVOBn8h/aIFfjh54Ol8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rrpFoy7XsS3x3LwOIhbANhKYvUpJejLlblfK3fnlG2rNHc3iL4hIAuRV8HFblfotT
         0zPAFeGrJqFUyS6I0yPyHHi7qwwK7Hdvmhr4BSGCFDmOASPNNecAcD5PYimt52U8g8
         QmSNLL2lroQQpdnCbLl5aFcEyZRSoFw++E83LN4k=
Date:   Sun, 7 Mar 2021 16:11:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
Subject: Re: [PATCH 5.4.y 1/4] dm table: fix iterate_devices based device
 capability checks
Message-ID: <YETtDtigG1L4d6iQ@kroah.com>
References: <161460625264244@kroah.com>
 <20210305065722.73504-1-jefflexu@linux.alibaba.com>
 <20210305065722.73504-2-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305065722.73504-2-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 02:57:19PM +0800, Jeffle Xu wrote:
> commit a4c8dd9c2d0987cf542a2a0c42684c9c6d78a04e upstream.
> 
> According to the definition of dm_iterate_devices_fn:
>  * This function must iterate through each section of device used by the
>  * target until it encounters a non-zero return code, which it then returns.
>  * Returns zero if no callout returned non-zero.
> 
> For some target type (e.g. dm-stripe), one call of iterate_devices() may
> iterate multiple underlying devices internally, in which case a non-zero
> return code returned by iterate_devices_callout_fn will stop the iteration
> in advance. No iterate_devices_callout_fn should return non-zero unless
> device iteration should stop.
> 
> Rename dm_table_requires_stable_pages() to dm_table_any_dev_attr() and
> elevate it for reuse to stop iterating (and return non-zero) on the
> first device that causes iterate_devices_callout_fn to return non-zero.
> Use dm_table_any_dev_attr() to properly iterate through devices.
> 
> Rename device_is_nonrot() to device_is_rotational() and invert logic
> accordingly to fix improper disposition.
> 
> Fixes: c3c4555edd10 ("dm table: clear add_random unless all devices have it set")
> Fixes: 4693c9668fdc ("dm table: propagate non rotational flag")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-table.c | 97 +++++++++++++++++++++++--------------------
>  1 file changed, 51 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 98be040cf958..bf704d238662 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1376,6 +1376,46 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
>  	return &t->targets[(KEYS_PER_NODE * n) + k];
>  }
>  
> +/*
> + * type->iterate_devices() should be called when the sanity check needs to
> + * iterate and check all underlying data devices. iterate_devices() will
> + * iterate all underlying data devices until it encounters a non-zero return
> + * code, returned by whether the input iterate_devices_callout_fn, or
> + * iterate_devices() itself internally.
> + *
> + * For some target type (e.g. dm-stripe), one call of iterate_devices() may
> + * iterate multiple underlying devices internally, in which case a non-zero
> + * return code returned by iterate_devices_callout_fn will stop the iteration
> + * in advance.
> + *
> + * Cases requiring _any_ underlying device supporting some kind of attribute,
> + * should use the iteration structure like dm_table_any_dev_attr(), or call
> + * it directly. @func should handle semantics of positive examples, e.g.
> + * capable of something.
> + *
> + * Cases requiring _all_ underlying devices supporting some kind of attribute,
> + * should use the iteration structure like dm_table_supports_nowait() or
> + * dm_table_supports_discards(). Or introduce dm_table_all_devs_attr() that
> + * uses an @anti_func that handle semantics of counter examples, e.g. not
> + * capable of something. So: return !dm_table_any_dev_attr(t, anti_func);
> + */
> +static bool dm_table_any_dev_attr(struct dm_table *t,
> +				  iterate_devices_callout_fn func)
> +{
> +	struct dm_target *ti;
> +	unsigned int i;
> +
> +	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> +		ti = dm_table_get_target(t, i);
> +
> +		if (ti->type->iterate_devices &&
> +		    ti->type->iterate_devices(ti, func, NULL))
> +			return true;
> +        }
> +
> +	return false;
> +}
> +
>  static int count_device(struct dm_target *ti, struct dm_dev *dev,
>  			sector_t start, sector_t len, void *data)
>  {
> @@ -1692,12 +1732,12 @@ static int dm_table_supports_dax_write_cache(struct dm_table *t)
>  	return false;
>  }
>  
> -static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
> -			    sector_t start, sector_t len, void *data)
> +static int device_is_rotational(struct dm_target *ti, struct dm_dev *dev,
> +				sector_t start, sector_t len, void *data)
>  {
>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>  
> -	return q && blk_queue_nonrot(q);
> +	return q && !blk_queue_nonrot(q);
>  }
>  
>  static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
> @@ -1708,23 +1748,6 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
>  	return q && !blk_queue_add_random(q);
>  }
>  
> -static bool dm_table_all_devices_attribute(struct dm_table *t,
> -					   iterate_devices_callout_fn func)
> -{
> -	struct dm_target *ti;
> -	unsigned i;
> -
> -	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> -		ti = dm_table_get_target(t, i);
> -
> -		if (!ti->type->iterate_devices ||
> -		    !ti->type->iterate_devices(ti, func, NULL))
> -			return false;
> -	}
> -
> -	return true;
> -}
> -
>  static int device_no_partial_completion(struct dm_target *ti, struct dm_dev *dev,
>  					sector_t start, sector_t len, void *data)
>  {
> @@ -1863,27 +1886,6 @@ static int device_requires_stable_pages(struct dm_target *ti,
>  	return q && bdi_cap_stable_pages_required(q->backing_dev_info);
>  }
>  
> -/*
> - * If any underlying device requires stable pages, a table must require
> - * them as well.  Only targets that support iterate_devices are considered:
> - * don't want error, zero, etc to require stable pages.
> - */
> -static bool dm_table_requires_stable_pages(struct dm_table *t)
> -{
> -	struct dm_target *ti;
> -	unsigned i;
> -
> -	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> -		ti = dm_table_get_target(t, i);
> -
> -		if (ti->type->iterate_devices &&
> -		    ti->type->iterate_devices(ti, device_requires_stable_pages, NULL))
> -			return true;
> -	}
> -
> -	return false;
> -}
> -
>  void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  			       struct queue_limits *limits)
>  {
> @@ -1928,10 +1930,10 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  		dax_write_cache(t->md->dax_dev, true);
>  
>  	/* Ensure that all underlying devices are non-rotational. */
> -	if (dm_table_all_devices_attribute(t, device_is_nonrot))
> -		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> -	else
> +	if (dm_table_any_dev_attr(t, device_is_rotational))
>  		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
> +	else
> +		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>  
>  	if (!dm_table_supports_write_same(t))
>  		q->limits.max_write_same_sectors = 0;
> @@ -1943,8 +1945,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	/*
>  	 * Some devices don't use blk_integrity but still want stable pages
>  	 * because they do their own checksumming.
> +	 * If any underlying device requires stable pages, a table must require
> +	 * them as well.  Only targets that support iterate_devices are considered:
> +	 * don't want error, zero, etc to require stable pages.
>  	 */
> -	if (dm_table_requires_stable_pages(t))
> +	if (dm_table_any_dev_attr(t, device_requires_stable_pages))
>  		q->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
>  	else
>  		q->backing_dev_info->capabilities &= ~BDI_CAP_STABLE_WRITES;
> @@ -1955,7 +1960,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
>  	 * have it set.
>  	 */
> -	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_is_not_random))
> +	if (blk_queue_add_random(q) && dm_table_any_dev_attr(t, device_is_not_random))
>  		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
>  
>  	/*
> -- 
> 2.27.0
> 

This patch breaks the build, how did you test it???
