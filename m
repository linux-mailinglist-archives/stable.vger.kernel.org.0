Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E560C3A63D8
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbhFNLRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:17:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234811AbhFNLPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:15:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F9EF61966;
        Mon, 14 Jun 2021 10:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667780;
        bh=mJJ/5SCkJChGGI6AraCu3UY/QcZ/ikzCh8b74OvBGPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFHUSkG2LZep0V3klJdPpQAiRXVhgmFfNyKQmwqbig8YdMNWTd6m+bNhVIGPmyibI
         PdMqdU5+LpzqZK/FMFt00Qg1eDmKzJInBgEuDrc/AfEADBX5uW5+lcnl4OP+09rMrS
         p0japHDrohtb1CoudTehgB2b2XSSuu7vAPzqkWUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Ullrich <ealex1979@gmail.com>,
        Diego Ercolani <diego.ercolani@gmail.com>,
        Jan Szubiak <jan.szubiak@linuxpolska.pl>,
        Marco Rebhan <me@dblsaiko.net>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Victor Westerhuis <victor@westerhu.is>,
        Vojtech Pavlik <vojtech@suse.cz>, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>, Takashi Iwai <tiwai@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        Rolf Fokkens <rolf@rolffokkens.nl>,
        Thorsten Knabe <linux@thorsten-knabe.de>
Subject: [PATCH 5.12 072/173] bcache: avoid oversized read request in cache missing code path
Date:   Mon, 14 Jun 2021 12:26:44 +0200
Message-Id: <20210614102700.554734764@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 41fe8d088e96472f63164e213de44ec77be69478 upstream.

In the cache missing code path of cached device, if a proper location
from the internal B+ tree is matched for a cache miss range, function
cached_dev_cache_miss() will be called in cache_lookup_fn() in the
following code block,
[code block 1]
  526         unsigned int sectors = KEY_INODE(k) == s->iop.inode
  527                 ? min_t(uint64_t, INT_MAX,
  528                         KEY_START(k) - bio->bi_iter.bi_sector)
  529                 : INT_MAX;
  530         int ret = s->d->cache_miss(b, s, bio, sectors);

Here s->d->cache_miss() is the call backfunction pointer initialized as
cached_dev_cache_miss(), the last parameter 'sectors' is an important
hint to calculate the size of read request to backing device of the
missing cache data.

Current calculation in above code block may generate oversized value of
'sectors', which consequently may trigger 2 different potential kernel
panics by BUG() or BUG_ON() as listed below,

1) BUG_ON() inside bch_btree_insert_key(),
[code block 2]
   886         BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
2) BUG() inside biovec_slab(),
[code block 3]
   51         default:
   52                 BUG();
   53                 return NULL;

All the above panics are original from cached_dev_cache_miss() by the
oversized parameter 'sectors'.

Inside cached_dev_cache_miss(), parameter 'sectors' is used to calculate
the size of data read from backing device for the cache missing. This
size is stored in s->insert_bio_sectors by the following lines of code,
[code block 4]
  909    s->insert_bio_sectors = min(sectors, bio_sectors(bio) + reada);

Then the actual key inserting to the internal B+ tree is generated and
stored in s->iop.replace_key by the following lines of code,
[code block 5]
  911   s->iop.replace_key = KEY(s->iop.inode,
  912                    bio->bi_iter.bi_sector + s->insert_bio_sectors,
  913                    s->insert_bio_sectors);
The oversized parameter 'sectors' may trigger panic 1) by BUG_ON() from
the above code block.

And the bio sending to backing device for the missing data is allocated
with hint from s->insert_bio_sectors by the following lines of code,
[code block 6]
  926    cache_bio = bio_alloc_bioset(GFP_NOWAIT,
  927                 DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS),
  928                 &dc->disk.bio_split);
The oversized parameter 'sectors' may trigger panic 2) by BUG() from the
agove code block.

Now let me explain how the panics happen with the oversized 'sectors'.
In code block 5, replace_key is generated by macro KEY(). From the
definition of macro KEY(),
[code block 7]
  71 #define KEY(inode, offset, size)                                  \
  72 ((struct bkey) {                                                  \
  73      .high = (1ULL << 63) | ((__u64) (size) << 20) | (inode),     \
  74      .low = (offset)                                              \
  75 })

Here 'size' is 16bits width embedded in 64bits member 'high' of struct
bkey. But in code block 1, if "KEY_START(k) - bio->bi_iter.bi_sector" is
very probably to be larger than (1<<16) - 1, which makes the bkey size
calculation in code block 5 is overflowed. In one bug report the value
of parameter 'sectors' is 131072 (= 1 << 17), the overflowed 'sectors'
results the overflowed s->insert_bio_sectors in code block 4, then makes
size field of s->iop.replace_key to be 0 in code block 5. Then the 0-
sized s->iop.replace_key is inserted into the internal B+ tree as cache
missing check key (a special key to detect and avoid a racing between
normal write request and cache missing read request) as,
[code block 8]
  915   ret = bch_btree_insert_check_key(b, &s->op, &s->iop.replace_key);

Then the 0-sized s->iop.replace_key as 3rd parameter triggers the bkey
size check BUG_ON() in code block 2, and causes the kernel panic 1).

Another kernel panic is from code block 6, is by the bvecs number
oversized value s->insert_bio_sectors from code block 4,
        min(sectors, bio_sectors(bio) + reada)
There are two possibility for oversized reresult,
- bio_sectors(bio) is valid, but bio_sectors(bio) + reada is oversized.
- sectors < bio_sectors(bio) + reada, but sectors is oversized.

>From a bug report the result of "DIV_ROUND_UP(s->insert_bio_sectors,
PAGE_SECTORS)" from code block 6 can be 344, 282, 946, 342 and many
other values which larther than BIO_MAX_VECS (a.k.a 256). When calling
bio_alloc_bioset() with such larger-than-256 value as the 2nd parameter,
this value will eventually be sent to biovec_slab() as parameter
'nr_vecs' in following code path,
   bio_alloc_bioset() ==> bvec_alloc() ==> biovec_slab()
Because parameter 'nr_vecs' is larger-than-256 value, the panic by BUG()
in code block 3 is triggered inside biovec_slab().

>From the above analysis, we know that the 4th parameter 'sector' sent
into cached_dev_cache_miss() may cause overflow in code block 5 and 6,
and finally cause kernel panic in code block 2 and 3. And if result of
bio_sectors(bio) + reada exceeds valid bvecs number, it may also trigger
kernel panic in code block 3 from code block 6.

Now the almost-useless readahead size for cache missing request back to
backing device is removed, this patch can fix the oversized issue with
more simpler method.
- add a local variable size_limit,  set it by the minimum value from
  the max bkey size and max bio bvecs number.
- set s->insert_bio_sectors by the minimum value from size_limit,
  sectors, and the sectors size of bio.
- replace sectors by s->insert_bio_sectors to do bio_next_split.

By the above method with size_limit, s->insert_bio_sectors will never
result oversized replace_key size or bio bvecs number. And split bio
'miss' from bio_next_split() will always match the size of 'cache_bio',
that is the current maximum bio size we can sent to backing device for
fetching the cache missing data.

Current problmatic code can be partially found since Linux v3.13-rc1,
therefore all maintained stable kernels should try to apply this fix.

Reported-by: Alexander Ullrich <ealex1979@gmail.com>
Reported-by: Diego Ercolani <diego.ercolani@gmail.com>
Reported-by: Jan Szubiak <jan.szubiak@linuxpolska.pl>
Reported-by: Marco Rebhan <me@dblsaiko.net>
Reported-by: Matthias Ferdinand <bcache@mfedv.net>
Reported-by: Victor Westerhuis <victor@westerhu.is>
Reported-by: Vojtech Pavlik <vojtech@suse.cz>
Reported-and-tested-by: Rolf Fokkens <rolf@rolffokkens.nl>
Reported-and-tested-by: Thorsten Knabe <linux@thorsten-knabe.de>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Nix <nix@esperi.org.uk>
Cc: Takashi Iwai <tiwai@suse.com>
Link: https://lore.kernel.org/r/20210607125052.21277-3-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/request.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -882,6 +882,7 @@ static int cached_dev_cache_miss(struct
 	int ret = MAP_CONTINUE;
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 	struct bio *miss, *cache_bio;
+	unsigned int size_limit;
 
 	s->cache_missed = 1;
 
@@ -891,7 +892,10 @@ static int cached_dev_cache_miss(struct
 		goto out_submit;
 	}
 
-	s->insert_bio_sectors = min(sectors, bio_sectors(bio));
+	/* Limitation for valid replace key size and cache_bio bvecs number */
+	size_limit = min_t(unsigned int, BIO_MAX_VECS * PAGE_SECTORS,
+			   (1 << KEY_SIZE_BITS) - 1);
+	s->insert_bio_sectors = min3(size_limit, sectors, bio_sectors(bio));
 
 	s->iop.replace_key = KEY(s->iop.inode,
 				 bio->bi_iter.bi_sector + s->insert_bio_sectors,
@@ -903,7 +907,8 @@ static int cached_dev_cache_miss(struct
 
 	s->iop.replace = true;
 
-	miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
+	miss = bio_next_split(bio, s->insert_bio_sectors, GFP_NOIO,
+			      &s->d->bio_split);
 
 	/* btree_search_recurse()'s btree iterator is no good anymore */
 	ret = miss == bio ? MAP_DONE : -EINTR;


