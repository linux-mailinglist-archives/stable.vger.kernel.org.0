Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7023323C286
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 02:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHEAMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 20:12:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbgHEAMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 20:12:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07503jao067558;
        Wed, 5 Aug 2020 00:12:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=AHJJXeuHkhgl/4LqOEmxD+0ZvDPyh6o56reVYYJkbZU=;
 b=LOFVc1QvyS8bBTS8YV12NW2BjObrgOr+XEnPTlTHjz+B90M7hPleq71UkoGQoXegNKvI
 sauX5xurdWzsz5wBBWYQP7ulq8sWDV28+hlG1DVr858kZKtggoFhHE+vP/h+1XxDMYuT
 o84ORDuwPyfwvbVMveVN5sCPoCFPOrHbppaJMztPdkMDkGIrWoYe5HV/JBhW4TWkabDh
 Pd2QiOI3o2LD7COJihGMWSqvFvb++o2LN0alc6YCo3UO5Bp42gAnZu45Xxa6VyiGk/pE
 Um2shuwxnEVzYVk5TyG2FWz59/ngAG4IL13u8W/uGruOq1wHSQ56O5bv6xxSO1ydydIf 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32pdnqahjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 00:12:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 075098Fs076273;
        Wed, 5 Aug 2020 00:12:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32p5gsyj34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 00:12:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0750CmWQ017862;
        Wed, 5 Aug 2020 00:12:48 GMT
Received: from dhcp-10-154-160-148.vpn.oracle.com (/10.154.160.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 17:12:48 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.5\))
Subject: Re: [PATCH v4: {linux-4.14.y} ] dm cache: submit writethrough writes
 in parallel to origin and cache
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <20200805000746.53112-1-john.p.donnelly@oracle.com>
Date:   Tue, 4 Aug 2020 19:12:46 -0500
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0FFD1933-FB8F-4628-BAE6-1754E5A818BF@oracle.com>
References: <20200805000746.53112-1-john.p.donnelly@oracle.com>
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.3445.9.5)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=11 mlxlogscore=991
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008040168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=11 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008040167
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 4, 2020, at 7:07 PM, john.p.donnelly@oracle.com wrote:
>=20
> From: Mike Snitzer <snitzer@redhat.com>
>=20
> Discontinue issuing writethrough write IO in series to the origin and
> then cache.
>=20
> Use bio_clone_fast() to create a new origin clone bio that will be
> mapped to the origin device and then bio_chain() it to the bio that =
gets
> remapped to the cache device.  The origin clone bio does _not_ have a
> copy of the per_bio_data -- as such check_if_tick_bio_needed() will =
not
> be called.
>=20
> The cache bio (parent bio) will not complete until the origin bio has
> completed -- this fulfills bio_clone_fast()'s requirements as well as
> the requirement to not complete the original IO until the write IO has
> completed to both the origin and cache device.
>=20
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>=20
> (cherry picked from commit 2df3bae9a6543e90042291707b8db0cbfbae9ee9)
>=20
> Fixes: 4ec34f2196d125ff781170ddc6c3058c08ec5e73 (dm bio record:
> save/restore bi_end_io and bi_integrity )
>=20
> 4ec34f21 introduced a mkfs.ext4 hang on a LVM device that has been
> modified with lvconvert --cachemode=3Dwritethrough.
>=20
> CC:stable@vger.kernel.org for 4.14.y
>=20
> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> Reviewed-by: Somasundaram Krishnasamy =
<somasundaram.krishnasamy@oracle.com>
> ---
> drivers/md/dm-cache-target.c | 92 =
++++++++++++++++++--------------------------
> 1 file changed, 37 insertions(+), 55 deletions(-)
>=20
> diff --git a/drivers/md/dm-cache-target.c =
b/drivers/md/dm-cache-target.c
> index 69cdb29ef6be..2732d1df05fa 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -450,6 +450,7 @@ struct cache {
> 	struct work_struct migration_worker;
> 	struct delayed_work waker;
> 	struct dm_bio_prison_v2 *prison;
> +	struct bio_set *bs;
>=20
> 	mempool_t *migration_pool;
>=20
> @@ -537,11 +538,6 @@ static void wake_deferred_bio_worker(struct cache =
*cache)
> 	queue_work(cache->wq, &cache->deferred_bio_worker);
> }
>=20
> -static void wake_deferred_writethrough_worker(struct cache *cache)
> -{
> -	queue_work(cache->wq, &cache->deferred_writethrough_worker);
> -}
> -
> static void wake_migration_worker(struct cache *cache)
> {
> 	if (passthrough_mode(&cache->features))
> @@ -868,16 +864,23 @@ static void check_if_tick_bio_needed(struct =
cache *cache, struct bio *bio)
> 	spin_unlock_irqrestore(&cache->lock, flags);
> }
>=20
> -static void remap_to_origin_clear_discard(struct cache *cache, struct =
bio *bio,
> -					  dm_oblock_t oblock)
> +static void __remap_to_origin_clear_discard(struct cache *cache, =
struct bio *bio,
> +					    dm_oblock_t oblock, bool =
bio_has_pbd)
> {
> -	// FIXME: this is called way too much.
> -	check_if_tick_bio_needed(cache, bio);
> +	if (bio_has_pbd)
> +		check_if_tick_bio_needed(cache, bio);
> 	remap_to_origin(cache, bio);
> 	if (bio_data_dir(bio) =3D=3D WRITE)
> 		clear_discard(cache, oblock_to_dblock(cache, oblock));
> }
>=20
> +static void remap_to_origin_clear_discard(struct cache *cache, struct =
bio *bio,
> +					  dm_oblock_t oblock)
> +{
> +	// FIXME: check_if_tick_bio_needed() is called way too much =
through this interface
> +	__remap_to_origin_clear_discard(cache, bio, oblock, true);
> +}
> +
> static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
> 				 dm_oblock_t oblock, dm_cblock_t cblock)
> {
> @@ -937,57 +940,26 @@ static void issue_op(struct bio *bio, void =
*context)
> 	accounted_request(cache, bio);
> }
>=20
> -static void defer_writethrough_bio(struct cache *cache, struct bio =
*bio)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&cache->lock, flags);
> -	bio_list_add(&cache->deferred_writethrough_bios, bio);
> -	spin_unlock_irqrestore(&cache->lock, flags);
> -
> -	wake_deferred_writethrough_worker(cache);
> -}
> -
> -static void writethrough_endio(struct bio *bio)
> -{
> -	struct per_bio_data *pb =3D get_per_bio_data(bio, =
PB_DATA_SIZE_WT);
> -
> -	dm_unhook_bio(&pb->hook_info, bio);
> -
> -	if (bio->bi_status) {
> -		bio_endio(bio);
> -		return;
> -	}
> -
> -	dm_bio_restore(&pb->bio_details, bio);
> -	remap_to_cache(pb->cache, bio, pb->cblock);
> -
> -	/*
> -	 * We can't issue this bio directly, since we're in interrupt
> -	 * context.  So it gets put on a bio list for processing by the
> -	 * worker thread.
> -	 */
> -	defer_writethrough_bio(pb->cache, bio);
> -}
> -
> /*
> - * FIXME: send in parallel, huge latency as is.
>  * When running in writethrough mode we need to send writes to clean =
blocks
> - * to both the cache and origin devices.  In future we'd like to =
clone the
> - * bio and send them in parallel, but for now we're doing them in
> - * series as this is easier.
> + * to both the cache and origin devices.  Clone the bio and send them =
in parallel.
>  */
> -static void remap_to_origin_then_cache(struct cache *cache, struct =
bio *bio,
> -				       dm_oblock_t oblock, dm_cblock_t =
cblock)
> +static void remap_to_origin_and_cache(struct cache *cache, struct bio =
*bio,
> +				      dm_oblock_t oblock, dm_cblock_t =
cblock)
> {
> -	struct per_bio_data *pb =3D get_per_bio_data(bio, =
PB_DATA_SIZE_WT);
> +	struct bio *origin_bio =3D bio_clone_fast(bio, GFP_NOIO, =
cache->bs);
> +
> +	BUG_ON(!origin_bio);
>=20
> -	pb->cache =3D cache;
> -	pb->cblock =3D cblock;
> -	dm_hook_bio(&pb->hook_info, bio, writethrough_endio, NULL);
> -	dm_bio_record(&pb->bio_details, bio);
> +	bio_chain(origin_bio, bio);
> +	/*
> +	 * Passing false to __remap_to_origin_clear_discard() skips
> +	 * all code that might use per_bio_data (since clone doesn't =
have it)
> +	 */
> +	__remap_to_origin_clear_discard(cache, origin_bio, oblock, =
false);
> +	submit_bio(origin_bio);
>=20
> -	remap_to_origin_clear_discard(pb->cache, bio, oblock);
> +	remap_to_cache(cache, bio, cblock);
> }
>=20
> /*----------------------------------------------------------------
> @@ -1873,7 +1845,7 @@ static int map_bio(struct cache *cache, struct =
bio *bio, dm_oblock_t block,
> 		} else {
> 			if (bio_data_dir(bio) =3D=3D WRITE && =
writethrough_mode(&cache->features) &&
> 			    !is_dirty(cache, cblock)) {
> -				remap_to_origin_then_cache(cache, bio, =
block, cblock);
> +				remap_to_origin_and_cache(cache, bio, =
block, cblock);
> 				accounted_begin(cache, bio);
> 			} else
> 				remap_to_cache_dirty(cache, bio, block, =
cblock);
> @@ -2132,6 +2104,9 @@ static void destroy(struct cache *cache)
> 		kfree(cache->ctr_args[i]);
> 	kfree(cache->ctr_args);
>=20
> +	if (cache->bs)
> +		bioset_free(cache->bs);
> +
> 	kfree(cache);
> }
>=20
> @@ -2589,6 +2564,13 @@ static int cache_create(struct cache_args *ca, =
struct cache **result)
> 	cache->features =3D ca->features;
> 	ti->per_io_data_size =3D get_per_bio_data_size(cache);
>=20
> +	if (writethrough_mode(&cache->features)) {
> +		/* Create bioset for writethrough bios issued to origin =
*/
> +		cache->bs =3D bioset_create(BIO_POOL_SIZE, 0, 0);
> +		if (!cache->bs)
> +			goto bad;
> +	}
> +
> 	cache->callbacks.congested_fn =3D cache_is_congested;
> 	dm_table_add_target_callbacks(ti->table, &cache->callbacks);
>=20
> --=20
> 1.8.3.1
>=20

Hi Greg,

I was working out my sendmail setup  =20

Hopefully this is better

JD


