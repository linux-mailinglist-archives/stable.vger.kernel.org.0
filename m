Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762B3387073
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 06:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240079AbhEREEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 00:04:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:57456 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230378AbhEREEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 00:04:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4998AB007;
        Tue, 18 May 2021 04:03:17 +0000 (UTC)
Subject: Re: [PATCH] bcache: avoid oversized read request in cache missing
 code path
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Diego Ercolani <diego.ercolani@gmail.com>,
        Jan Szubiak <jan.szubiak@linuxpolska.pl>,
        Marco Rebhan <me@dblsaiko.net>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Thorsten Knabe <linux@thorsten-knabe.de>,
        Victor Westerhuis <victor@westerhu.is>,
        Vojtech Pavlik <vojtech@suse.cz>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.com>,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <20210517162256.128236-1-colyli@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <36999d42-d70e-04a3-fd56-30a560a05b53@suse.de>
Date:   Tue, 18 May 2021 12:03:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517162256.128236-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi folks,

Please hold on, this patch fails on a large size read test case this
morning. I will post a new version after the issue fixed.

Thanks.

Coly Li

On 5/18/21 12:22 AM, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> In the cache missing code path of cached device, if a proper location
> from the internal B+ tree is matched for a cache miss range, function
> cached_dev_cache_miss() will be called in cache_lookup_fn() in the
> following code block,
> [code block 1]
>   526         unsigned int sectors = KEY_INODE(k) == s->iop.inode
>   527                 ? min_t(uint64_t, INT_MAX,
>   528                         KEY_START(k) - bio->bi_iter.bi_sector)
>   529                 : INT_MAX;
>   530         int ret = s->d->cache_miss(b, s, bio, sectors);
> 
> Here s->d->cache_miss() is the call backfunction pointer initialized as
> cached_dev_cache_miss(), the last parameter 'sectors' is an important
> hint to calculate the size of read request to backing device of the
> missing cache data.
> 
> Current calculation in above code block may generate oversized value of
> 'sectors', which consequently may trigger 2 different potential kernel
> panics by BUG() or BUG_ON() as listed below,
> 
> 1) BUG_ON() inside bch_btree_insert_key(),
> [code block 2]
>    886         BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
> 2) BUG() inside biovec_slab(),
> [code block 3]
>    51         default:
>    52                 BUG();
>    53                 return NULL;
> 
> All the above panics are original from cached_dev_cache_miss() by the
> oversized parameter 'sectors'.
> 
> Inside cached_dev_cache_miss(), parameter 'sectors' is used to calculate
> the size of data read from backing device for the cache missing. This
> size is stored in s->insert_bio_sectors by the following lines of code,
> [code block 4]
>   909    s->insert_bio_sectors = min(sectors, bio_sectors(bio) + reada);
> 
> Then the actual key inserting to the internal B+ tree is generated and
> stored in s->iop.replace_key by the following lines of code,
> [code block 5]
>   911   s->iop.replace_key = KEY(s->iop.inode,
>   912                    bio->bi_iter.bi_sector + s->insert_bio_sectors,
>   913                    s->insert_bio_sectors);
> The oversized parameter 'sectors' may trigger panic 1) by BUG_ON() from
> the above code block.
> 
> And the bio sending to backing device for the missing data is allocated
> with hint from s->insert_bio_sectors by the following lines of code,
> [code block 6]
>   926    cache_bio = bio_alloc_bioset(GFP_NOWAIT,
>   927                 DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS),
>   928                 &dc->disk.bio_split);
> The oversized parameter 'sectors' may trigger panic 2) by BUG() from the
> agove code block.
> 
> Now let me explain how the panics happen with the oversized 'sectors'.
> In code block 5, replace_key is generated by macro KEY(). From the
> definition of macro KEY(),
> [code block 7]
>   71 #define KEY(inode, offset, size)                                  \
>   72 ((struct bkey) {                                                  \
>   73      .high = (1ULL << 63) | ((__u64) (size) << 20) | (inode),     \
>   74      .low = (offset)                                              \
>   75 })
> 
> Here 'size' is 16bits width embedded in 64bits member 'high' of struct
> bkey. But in code block 1, if "KEY_START(k) - bio->bi_iter.bi_sector" is
> very probably to be larger than (1<<16) - 1, which makes the bkey size
> calculation in code block 5 is overflowed. In one bug report the value
> of parameter 'sectors' is 131072 (= 1 << 17), the overflowed 'sectors'
> results the overflowed s->insert_bio_sectors in code block 4, then makes
> size field of s->iop.replace_key to be 0 in code block 5. Then the 0-
> sized s->iop.replace_key is inserted into the internal B+ tree as cache
> missing check key (a special key to detect and avoid a racing between
> normal write request and cache missing read request) as,
> [code block 8]
>   915   ret = bch_btree_insert_check_key(b, &s->op, &s->iop.replace_key);
> 
> Then the 0-sized s->iop.replace_key as 3rd parameter triggers the bkey
> size check BUG_ON() in code block 2, and causes the kernel panic 1).
> 
> Another kernel panic is from code block 6, is from the oversized value
> s->insert_bio_sectors resulted by the oversized 'sectors'. From a bug
> report the result of "DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS)"
> from code block 6 can be 344, 282, 946, 342 and many other values which
> larther than BIO_MAX_VECS (a.k.a 256). When calling bio_alloc_bioset()
> with such larger-than-256 value as the 2nd parameter, this value will
> eventually be sent to biovec_slab() as parameter 'nr_vecs' in following
> code path,
>    bio_alloc_bioset() ==> bvec_alloc() ==> biovec_slab()
> 
> Because parameter 'nr_vecs' is larger-than-256 value, the panic by BUG()
> in code block 3 is triggered inside biovec_slab().
> 
> From the above analysis, it is obvious that in order to avoid the kernel
> panics in code block 2 and code block 3, the calculated 'sectors' in
> code block 1 should not generate overflowed value in code block 5 and
> code block 6.
> 
> To avoid overflow in code block 5, the maximum 'sectors' value should be
> equal or less than (1 << KEY_SIZE_BITS) - 1. And to avoid overflow in
> code block 6, the maximum 'sectors' value should be euqal or less than
> BIO_MAX_VECS * PAGE_SECTORS. Considering the kernel page size can be
> variable, a reasonable maximum limitation of 'sectors' in code block 1
> should be smaller on from "(1 << KEY_SIZE_BITS) - 1" and "BIO_MAX_VECS *
> PAGE_SECTORS".
> 
> In this patch, a local variable inside cache_lookup_fn() is added as,
>      max_cache_miss_size = min_t(uint32_t,
> 		(1 << KEY_SIZE_BITS) - 1, BIO_MAX_VECS * PAGE_SECTORS);
> Then code block 1 uses max_cache_miss_size to limit the maximum value of
> 'sectors' calculation as,
>   533        unsigned int sectors = KEY_INODE(k) == s->iop.inode
>   534                 ? min_t(uint64_t, max_cache_miss_size,
>   535                         KEY_START(k) - bio->bi_iter.bi_sector)
>   536                 : max_cache_miss_size;
> 
> Now the calculated 'sectors' value sent into cached_dev_cache_miss()
> won't trigger neither of the above kernel panics.
> 
> Current problmatic code can be partially found since Linux v5.13-rc1,
> therefore all maintained stable kernels should try to apply this fix.
> 
> Reported-by: Diego Ercolani <diego.ercolani@gmail.com>
> Reported-by: Jan Szubiak <jan.szubiak@linuxpolska.pl>
> Reported-by: Marco Rebhan <me@dblsaiko.net>
> Reported-by: Matthias Ferdinand <bcache@mfedv.net>
> Reported-by: Thorsten Knabe <linux@thorsten-knabe.de>
> Reported-by: Victor Westerhuis <victor@westerhu.is>
> Reported-by: Vojtech Pavlik <vojtech@suse.cz>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: stable@vger.kernel.org
> Cc: Takashi Iwai <tiwai@suse.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  drivers/md/bcache/request.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 29c231758293..90fa9ac47661 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -515,18 +515,25 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
>  	struct search *s = container_of(op, struct search, op);
>  	struct bio *n, *bio = &s->bio.bio;
>  	struct bkey *bio_key;
> -	unsigned int ptr;
> +	unsigned int ptr, max_cache_miss_size;
>  
>  	if (bkey_cmp(k, &KEY(s->iop.inode, bio->bi_iter.bi_sector, 0)) <= 0)
>  		return MAP_CONTINUE;
>  
> +	/*
> +	 * Make sure the cache missing size won't exceed the restrictions of
> +	 * max bkey size and max bio's bi_max_vecs.
> +	 */
> +	max_cache_miss_size = min_t(uint32_t,
> +		(1 << KEY_SIZE_BITS) - 1, BIO_MAX_VECS * PAGE_SECTORS);
> +
>  	if (KEY_INODE(k) != s->iop.inode ||
>  	    KEY_START(k) > bio->bi_iter.bi_sector) {
>  		unsigned int bio_sectors = bio_sectors(bio);
>  		unsigned int sectors = KEY_INODE(k) == s->iop.inode
> -			? min_t(uint64_t, INT_MAX,
> +			? min_t(uint64_t, max_cache_miss_size,
>  				KEY_START(k) - bio->bi_iter.bi_sector)
> -			: INT_MAX;
> +			: max_cache_miss_size;
>  		int ret = s->d->cache_miss(b, s, bio, sectors);
>  
>  		if (ret != MAP_CONTINUE)
> @@ -547,7 +554,7 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
>  	if (KEY_DIRTY(k))
>  		s->read_dirty_data = true;
>  
> -	n = bio_next_split(bio, min_t(uint64_t, INT_MAX,
> +	n = bio_next_split(bio, min_t(uint64_t, max_cache_miss_size,
>  				      KEY_OFFSET(k) - bio->bi_iter.bi_sector),
>  			   GFP_NOIO, &s->d->bio_split);
>  
> 

