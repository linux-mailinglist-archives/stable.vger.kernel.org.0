Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC0D446E15
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 14:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhKFNjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 09:39:31 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49378 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbhKFNjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 09:39:31 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9AE131FCA3;
        Sat,  6 Nov 2021 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636205808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0rtgsCaOVRPZv4CmwUM3QqDKLFu8YHJy4eFGY1FzM7k=;
        b=kLHpvV8zmDT18tHChV0MlSe/KxtL1bp15681LCNKtN7SUl93sY+DlUJCqvo6ZFX/8ldUaj
        1KCFDBsjezsdyCLW0hFsLMM6SDusbCXuqFatiE383DvtZNMncbpQrUBLE6kXGXZRh75MtP
        75wxBz6XC/iaKfXcYYaGOzdRz37fM3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636205808;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0rtgsCaOVRPZv4CmwUM3QqDKLFu8YHJy4eFGY1FzM7k=;
        b=qLp7p8NHVJFuaocPONJ7i6fzqp47iTndh67MuvS+q7snCb/XW3eShgiZywm42Ve7t/xq8b
        DGmtGr1dT4n8tYDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5BEE013ABE;
        Sat,  6 Nov 2021 13:36:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JRt3Cu6EhmH6TwAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 06 Nov 2021 13:36:46 +0000
Message-ID: <4f893b6d-527e-d266-6bd7-9e7590100bb9@suse.de>
Date:   Sat, 6 Nov 2021 21:36:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH] bcache: Revert "bcache: use bvec_virt"
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, stable@vger.kernel.org
References: <20211103151041.70516-1-colyli@suse.de>
 <20211103154644.GA30686@lst.de>
 <1d1180e0-32bc-e571-3252-ce496508d2b5@suse.de> <20211103161955.GA394@lst.de>
 <9e23e103-40ff-963f-739f-730da4d5fe3f@suse.de> <20211104202358.GA4264@lst.de>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211104202358.GA4264@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/5/21 4:23 AM, Christoph Hellwig wrote:
> Ok, because it takes the offset away we're not aligned any more.
> I think the right fix is to fix this properly and stop poking into
> the bio internals.  The patch below has surived and xfstests quick
> run on two bcache devices:
>
> ---
>  From 3bf1068e2dc6a75442513e8f9f64055740c0b507 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 4 Nov 2021 10:40:37 +0100
> Subject: bcache: lift bvec mapping into bch_bio_alloc_pages
>
> Use the proper block APIs to add pages to the bio and remove the need
> for the extra call to bch_bio_map and the open coded data copy for the
> write case.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hmm, I apply this patch on Linux v5.15 (commit 8bb7eca972ad), still 
happen to observe panic on my system.

How about let's revert the original patch firstly, then I'd like to test 
your further patch for the 5.17 merge window? I have report from 
community user for the regression already.

There is the panic message I observed,

[  655.974283] BUG: kernel NULL pointer dereference, address: 
0000000000000800
[  656.057593] #PF: supervisor read access in kernel mode
[  656.119062] #PF: error_code(0x0000) - not-present page
[  656.180532] PGD 0 P4D 0
[  656.210804] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
[  656.271231] CPU: 31 PID: 7728 Comm: systemd-udevd Kdump: loaded 
Tainted: G            E     5.15.0-59.27-default+ #14
[  656.398220] Hardware name: Lenovo ThinkSystem SR650 
-[7X05CTO1WW]-/-[7X05CTO1WW]-, BIOS -[IVE164L-2.80]- 10/23/2020
[  656.523129] RIP: 0010:bch_bio_alloc_pages+0xd0/0x1e0 [bcache]
[  656.591900] Code: 89 c6 48 89 ef e8 90 96 ec df 48 98 48 39 d8 75 61 
49 01 df 49 29 dc 0f 85 72 ff ff ff 5b 31 c0 5d 41 5c 41 5d 41 5e 41 5f 
c3 <49> 8b 37 48 89 31 89 de 49 8b 7c 37 f8 48 89 7c 31 f8 48 8d 79 08
[  656.816646] RSP: 0018:ffffacc78728b730 EFLAGS: 00010216
[  656.879156] RAX: fffff4d02d1aee40 RBX: 00000000000001c0 RCX: 
ffffa120c6bb9e40
[  656.964546] RDX: 0000000000000e40 RSI: 0000000000000e40 RDI: 
0000000000001000
[  657.049932] RBP: ffffa122417e2d60 R08: 0000000000000001 R09: 
0000000000000000
[  657.135322] R10: ffffacc78728b528 R11: 0000000000000000 R12: 
0000000000000800
[  657.220713] R13: 0000000000002c00 R14: 0000000000001000 R15: 
0000000000000800
[  657.306102] FS:  00007f140222d980(0000) GS:ffffa1305fc00000(0000) 
knlGS:0000000000000000
[  657.402931] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  657.471680] CR2: 0000000000000800 CR3: 0000004ba1188002 CR4: 
00000000007706e0
[  657.557070] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  657.642457] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  657.727848] PKRU: 55555554
[  657.760197] Call Trace:
[  657.789431]  ? detached_dev_end_io+0x60/0x60 [bcache]
[  657.849870]  cached_dev_cache_miss+0x1a1/0x290 [bcache]
[  657.912389]  ? request_endio+0x30/0x30 [bcache]
[  657.966584]  cache_lookup_fn+0x99/0x310 [bcache]
[  658.021820]  ? request_endio+0x30/0x30 [bcache]
[  658.076016]  ? bch_btree_iter_next_filter+0x1b3/0x320 [bcache]
[  658.145811]  ? request_endio+0x30/0x30 [bcache]
[  658.200007]  bch_btree_map_keys_recurse+0xf1/0x180 [bcache]
[  658.266685]  ? lock_acquire+0x1df/0x300
[  658.312554]  ? rcu_read_lock_sched_held+0x23/0x80
[  658.368825]  ? lock_acquired+0x183/0x350
[  658.415734]  bch_btree_map_keys+0xf4/0x150 [bcache]
[  658.474088]  ? request_endio+0x30/0x30 [bcache]
[  658.528286]  cache_lookup+0xb9/0x1a0 [bcache]
[  658.580403]  cached_dev_submit_bio+0x7e2/0x1030 [bcache]
[  658.643959]  ? submit_bio_checks+0x596/0x670
[  658.695037]  __submit_bio+0x1bf/0x320
[  658.738830]  ? do_mpage_readpage+0x58f/0x800
[  658.789900]  submit_bio_noacct+0xfe/0x2d0
[  658.837851]  ? submit_bio+0x42/0x130
[  658.880599]  submit_bio+0x42/0x130
[  658.921269]  mpage_readahead+0x163/0x1b0
[  658.968182]  ? blkdev_direct_IO+0x4c0/0x4c0
[  659.018217]  read_pages+0x9f/0x2f0
[  659.058894]  ? page_cache_ra_unbounded+0x162/0x240
[  659.116203]  page_cache_ra_unbounded+0x162/0x240
[  659.171434]  filemap_get_pages+0xd3/0x640
[  659.219389]  ? atime_needs_update+0x89/0xf0
[  659.269419]  filemap_read+0xc2/0x370
[  659.312166]  ? rcu_read_lock_held_common+0xe/0x40
[  659.368438]  ? rcu_read_lock_sched_held+0x23/0x80
[  659.424708]  ? print_usage_bug+0x190/0x1d0
[  659.473697]  ? aa_file_perm+0x1ba/0x7a0
[  659.519567]  ? rcu_read_lock_sched_held+0x23/0x80
[  659.575837]  blkdev_read_iter+0x41/0x50
[  659.621707]  new_sync_read+0x11e/0x1b0
[  659.666539]  vfs_read+0x1a2/0x1d0
[  659.706167]  ksys_read+0xa7/0xe0
[  659.744756]  do_syscall_64+0x3a/0x80
[  659.787507]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  659.847935] RIP: 0033:0x7f1401328ffe
[  659.890684] Code: 48 8b 15 d5 7f 20 00 f7 d8 64 89 02 48 c7 c0 ff ff 
ff ff eb b6 0f 1f 80 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 
05 <48> 3d 00 f0 ff ff 77 5a f3 c3 0f 1f 84 00 00 00 00 00 41 54 55 49
[  660.115432] RSP: 002b:00007ffda20256c8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[  660.206023] RAX: ffffffffffffffda RBX: 000055bd9e8816d0 RCX: 
00007f1401328ffe
[  660.291409] RDX: 0000000000000200 RSI: 000055bd9e700c08 RDI: 
000000000000000f
[  660.376800] RBP: 0000000000200000 R08: 000055bd9e700be0 R09: 
0000000000000000
[  660.462190] R10: 000055bd9e6b4010 R11: 0000000000000246 R12: 
0000000000000200
[  660.547577] R13: 000055bd9e881720 R14: 000055bd9e700bf8 R15: 
000055bd9e700be0


Coly Li

> ---
>   drivers/md/bcache/btree.c     | 31 ++++++++------------------
>   drivers/md/bcache/debug.c     |  4 +---
>   drivers/md/bcache/movinggc.c  |  7 +++---
>   drivers/md/bcache/request.c   |  5 ++---
>   drivers/md/bcache/util.c      | 41 +++++++++++++++++++++++------------
>   drivers/md/bcache/util.h      |  2 +-
>   drivers/md/bcache/writeback.c |  7 +++---
>   7 files changed, 48 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 93b67b8d31c3d..c435b8f2bca04 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -339,6 +339,7 @@ static void do_btree_node_write(struct btree *b)
>   {
>   	struct closure *cl = &b->io;
>   	struct bset *i = btree_bset_last(b);
> +	size_t size;
>   	BKEY_PADDED(key) k;
>   
>   	i->version	= BCACHE_BSET_VERSION;
> @@ -349,9 +350,7 @@ static void do_btree_node_write(struct btree *b)
>   
>   	b->bio->bi_end_io	= btree_node_write_endio;
>   	b->bio->bi_private	= cl;
> -	b->bio->bi_iter.bi_size	= roundup(set_bytes(i), block_bytes(b->c->cache));
>   	b->bio->bi_opf		= REQ_OP_WRITE | REQ_META | REQ_FUA;
> -	bch_bio_map(b->bio, i);
>   
>   	/*
>   	 * If we're appending to a leaf node, we don't technically need FUA -
> @@ -372,32 +371,20 @@ static void do_btree_node_write(struct btree *b)
>   	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) +
>   		       bset_sector_offset(&b->keys, i));
>   
> -	if (!bch_bio_alloc_pages(b->bio, __GFP_NOWARN|GFP_NOWAIT)) {
> -		struct bio_vec *bv;
> -		void *addr = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
> -		struct bvec_iter_all iter_all;
> -
> -		bio_for_each_segment_all(bv, b->bio, iter_all) {
> -			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
> -			addr += PAGE_SIZE;
> -		}
> -
> -		bch_submit_bbio(b->bio, b->c, &k.key, 0);
> -
> -		continue_at(cl, btree_node_write_done, NULL);
> -	} else {
> -		/*
> -		 * No problem for multipage bvec since the bio is
> -		 * just allocated
> -		 */
> -		b->bio->bi_vcnt = 0;
> +	size = roundup(set_bytes(i), block_bytes(b->c->cache));
> +	if (bch_bio_alloc_pages(b->bio, i, size,
> +			__GFP_NOWARN | GFP_NOWAIT) < 0) {
> +		b->bio->bi_iter.bi_size	= size;
>   		bch_bio_map(b->bio, i);
> -
>   		bch_submit_bbio(b->bio, b->c, &k.key, 0);
>   
>   		closure_sync(cl);
>   		continue_at_nobarrier(cl, __btree_node_write_done, NULL);
> +		return;
>   	}
> +
> +	bch_submit_bbio(b->bio, b->c, &k.key, 0);
> +	continue_at(cl, btree_node_write_done, NULL);
>   }
>   
>   void __bch_btree_node_write(struct btree *b, struct closure *parent)
> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> index 6230dfdd9286e..ef8ec8090d579 100644
> --- a/drivers/md/bcache/debug.c
> +++ b/drivers/md/bcache/debug.c
> @@ -117,10 +117,8 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>   	bio_set_dev(check, bio->bi_bdev);
>   	check->bi_opf = REQ_OP_READ;
>   	check->bi_iter.bi_sector = bio->bi_iter.bi_sector;
> -	check->bi_iter.bi_size = bio->bi_iter.bi_size;
>   
> -	bch_bio_map(check, NULL);
> -	if (bch_bio_alloc_pages(check, GFP_NOIO))
> +	if (bch_bio_alloc_pages(check, NULL, bio->bi_iter.bi_size, GFP_NOIO))
>   		goto out_put;
>   
>   	submit_bio_wait(check);
> diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
> index b9c3d27ec093a..7d94e2ec562a4 100644
> --- a/drivers/md/bcache/movinggc.c
> +++ b/drivers/md/bcache/movinggc.c
> @@ -84,9 +84,7 @@ static void moving_init(struct moving_io *io)
>   	bio_get(bio);
>   	bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
>   
> -	bio->bi_iter.bi_size	= KEY_SIZE(&io->w->key) << 9;
>   	bio->bi_private		= &io->cl;
> -	bch_bio_map(bio, NULL);
>   }
>   
>   static void write_moving(struct closure *cl)
> @@ -97,6 +95,8 @@ static void write_moving(struct closure *cl)
>   	if (!op->status) {
>   		moving_init(io);
>   
> +		io->bio.bio.bi_iter.bi_size = KEY_SIZE(&io->w->key) << 9;
> +		bch_bio_map(&io->bio.bio, NULL);
>   		io->bio.bio.bi_iter.bi_sector = KEY_START(&io->w->key);
>   		op->write_prio		= 1;
>   		op->bio			= &io->bio.bio;
> @@ -163,7 +163,8 @@ static void read_moving(struct cache_set *c)
>   		bio_set_op_attrs(bio, REQ_OP_READ, 0);
>   		bio->bi_end_io	= read_moving_endio;
>   
> -		if (bch_bio_alloc_pages(bio, GFP_KERNEL))
> +		if (bch_bio_alloc_pages(bio, NULL, KEY_SIZE(&io->w->key) << 9,
> +				GFP_KERNEL))
>   			goto err;
>   
>   		trace_bcache_gc_copy(&w->key);
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index d15aae6c51c13..faa89410c7470 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -921,13 +921,12 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
>   
>   	cache_bio->bi_iter.bi_sector	= miss->bi_iter.bi_sector;
>   	bio_copy_dev(cache_bio, miss);
> -	cache_bio->bi_iter.bi_size	= s->insert_bio_sectors << 9;
>   
>   	cache_bio->bi_end_io	= backing_request_endio;
>   	cache_bio->bi_private	= &s->cl;
>   
> -	bch_bio_map(cache_bio, NULL);
> -	if (bch_bio_alloc_pages(cache_bio, __GFP_NOWARN|GFP_NOIO))
> +	if (bch_bio_alloc_pages(cache_bio, NULL, s->insert_bio_sectors << 9,
> +			__GFP_NOWARN | GFP_NOIO))
>   		goto out_put;
>   
>   	s->cache_miss	= miss;
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index ae380bc3992e3..cf627e7eadc10 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -258,6 +258,8 @@ start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
>   /**
>    * bch_bio_alloc_pages - allocates a single page for each bvec in a bio
>    * @bio: bio to allocate pages for
> + * @data: if non-NULL copy data from here into the newly allocate pages
> + * @size: size to allocate
>    * @gfp_mask: flags for allocation
>    *
>    * Allocates pages up to @bio->bi_vcnt.
> @@ -265,23 +267,34 @@ start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
>    * Returns 0 on success, -ENOMEM on failure. On failure, any allocated pages are
>    * freed.
>    */
> -int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
> +int bch_bio_alloc_pages(struct bio *bio, void *data, size_t size, gfp_t gfp)
>   {
> -	int i;
> -	struct bio_vec *bv;
> +	struct bvec_iter iter;
> +	struct bio_vec bv;
>   
> -	/*
> -	 * This is called on freshly new bio, so it is safe to access the
> -	 * bvec table directly.
> -	 */
> -	for (i = 0, bv = bio->bi_io_vec; i < bio->bi_vcnt; bv++, i++) {
> -		bv->bv_page = alloc_page(gfp_mask);
> -		if (!bv->bv_page) {
> -			while (--bv >= bio->bi_io_vec)
> -				__free_page(bv->bv_page);
> -			return -ENOMEM;
> -		}
> +	BUG_ON(bio->bi_vcnt);
> +
> +	while (size) {
> +		struct page *page = alloc_page(gfp);
> +		unsigned int offset = offset_in_page(page);
> +		size_t len = min(size, PAGE_SIZE - offset);
> +
> +		if (!page)
> +			goto unwind;
> +		if (data)
> +			memcpy_to_page(page, offset, data, len);
> +		if (bio_add_page(bio, page, offset, len) != len)
> +			goto unwind;
> +
> +		size -= len;
> +		data += len;
>   	}
>   
>   	return 0;
> +
> +unwind:
> +	bio_for_each_segment(bv, bio, iter)
> +		__free_page(bv.bv_page);
> +	bio->bi_vcnt = 0;
> +	return -ENOMEM;
>   }
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index 6f3cb7c921303..131d5e874231f 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -557,6 +557,6 @@ static inline unsigned int fract_exp_two(unsigned int x,
>   }
>   
>   void bch_bio_map(struct bio *bio, void *base);
> -int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask);
> +int bch_bio_alloc_pages(struct bio *bio, void *data, size_t size, gfp_t gfp);
>   
>   #endif /* _BCACHE_UTIL_H */
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index c7560f66dca88..a153e3a1b3b87 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -297,9 +297,7 @@ static void dirty_init(struct keybuf_key *w)
>   	if (!io->dc->writeback_percent)
>   		bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
>   
> -	bio->bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
>   	bio->bi_private		= w;
> -	bch_bio_map(bio, NULL);
>   }
>   
>   static void dirty_io_destructor(struct closure *cl)
> @@ -395,6 +393,8 @@ static void write_dirty(struct closure *cl)
>   	 */
>   	if (KEY_DIRTY(&w->key)) {
>   		dirty_init(w);
> +		io->bio.bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
> +		bch_bio_map(&io->bio, NULL);
>   		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
>   		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
>   		bio_set_dev(&io->bio, io->dc->bdev);
> @@ -513,7 +513,8 @@ static void read_dirty(struct cached_dev *dc)
>   			bio_set_dev(&io->bio, dc->disk.c->cache->bdev);
>   			io->bio.bi_end_io	= read_dirty_endio;
>   
> -			if (bch_bio_alloc_pages(&io->bio, GFP_KERNEL))
> +			if (bch_bio_alloc_pages(&io->bio, NULL,
> +					KEY_SIZE(&w->key) << 9, GFP_KERNEL))
>   				goto err_free;
>   
>   			trace_bcache_writeback(&w->key);

