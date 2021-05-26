Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B104391B6B
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 17:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbhEZPQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 11:16:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:52776 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235223AbhEZPQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 11:16:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622042100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=84Awo9QiSUfGV4Ojnvze3ojF0GValm1K/C8M/ACw/W4=;
        b=fjJHxht5IAPoARxHwu2FdkBbgq0leUL+3cFH3lMrDRPLg46oQruD9PBbaR7MoOQC4yRRqI
        lIhpBfL736bTDXHDVDz/TCdFfeeY3VMZskkFIhcHrlK/R7VKIlad1VOp5F5xpbfdZy+Y8N
        wNFvIT2S9CgRl0Po1s+GWpeuZzn7968=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622042100;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=84Awo9QiSUfGV4Ojnvze3ojF0GValm1K/C8M/ACw/W4=;
        b=XIzejofgtGhNyJlPnjrXH4JZnFsGsHnbjgz7SeIlDKBmkRacpA0sofckCvx5VwpE5IDdDK
        J4mXDltjP6h+91AQ==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9770BAEE7;
        Wed, 26 May 2021 15:15:00 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coly Li <colyli@suse.de>,
        Diego Ercolani <diego.ercolani@gmail.com>,
        Jan Szubiak <jan.szubiak@linuxpolska.pl>,
        Marco Rebhan <me@dblsaiko.net>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Thorsten Knabe <linux@thorsten-knabe.de>,
        Victor Westerhuis <victor@westerhu.is>,
        Vojtech Pavlik <vojtech@suse.cz>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Takashi Iwai <tiwai@suse.com>
Subject: [PATCH v4] bcache: avoid oversized read request in cache missing code path
Date:   Wed, 26 May 2021 23:14:50 +0800
Message-Id: <20210526151450.45211-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

From a bug report the result of "DIV_ROUND_UP(s->insert_bio_sectors,
PAGE_SECTORS)" from code block 6 can be 344, 282, 946, 342 and many
other values which larther than BIO_MAX_VECS (a.k.a 256). When calling
bio_alloc_bioset() with such larger-than-256 value as the 2nd parameter,
this value will eventually be sent to biovec_slab() as parameter
'nr_vecs' in following code path,
   bio_alloc_bioset() ==> bvec_alloc() ==> biovec_slab()
Because parameter 'nr_vecs' is larger-than-256 value, the panic by BUG()
in code block 3 is triggered inside biovec_slab().

From the above analysis, we know that the 4th parameter 'sector' sent
into cached_dev_cache_miss() may cause overflow in code block 5 and 6,
and finally cause kernel panic in code block 2 and 3. And if result of
bio_sectors(bio) + reada exceeds valid bvecs number, it may also trigger
kernel panic in code block 3 from code block 6.

In this patch, the above two panics are avoided by the following
changes,
- If DIV_ROUND_UP(bio_sectors(bio) + reada, PAGE_SECTORS) exceeds the
  maximum bvecs counter, reduce reada to make sure the DIV_ROUND_UP()
  result won't generate a oversized s->insert_bio_sectors to cause
  invalid bvecs number to cache_bio.
- If sectors exceeds the maximum bkey size, then set the maximum valid
  bkey size to sectors.

By the above changes, in code block 5 the size value in KEY() macro will
always be in valid range. As well in code block 6, the nr_iovecs
parameter of bio_alloc_bioset() calculated by
DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS) will always be a valid
bvecs number. Now both panics won't happen anymore.

Current problmatic code can be partially found since Linux v5.13-rc1,
therefore all maintained stable kernels should try to apply this fix.

Reported-by: Diego Ercolani <diego.ercolani@gmail.com>
Reported-by: Jan Szubiak <jan.szubiak@linuxpolska.pl>
Reported-by: Marco Rebhan <me@dblsaiko.net>
Reported-by: Matthias Ferdinand <bcache@mfedv.net>
Reported-by: Thorsten Knabe <linux@thorsten-knabe.de>
Reported-by: Victor Westerhuis <victor@westerhu.is>
Reported-by: Vojtech Pavlik <vojtech@suse.cz>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Takashi Iwai <tiwai@suse.com>
---
Changelog:
v4, not directly access BIO_MAX_VECS and reduce reada value to avoid
    oversized bvecs number, by hint from Christoph Hellwig. 
v3, fix typo in v2.
v2, fix the bypass bio size calculation in v1.
v1, the initial version

 drivers/md/bcache/request.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 29c231758293..054948f037ed 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -883,6 +883,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	unsigned int reada = 0;
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 	struct bio *miss, *cache_bio;
+	unsigned int nr_bvecs, max_segs;
 
 	s->cache_missed = 1;
 
@@ -899,6 +900,24 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 			      get_capacity(bio->bi_bdev->bd_disk) -
 			      bio_end_sector(bio));
 
+	/*
+	 * If "bio_sectors(bio) + reada" may causes an oversized bio bvecs
+	 * number, reada size must be deducted to make sure the following
+	 * calculated s->insert_bio_sectors won't cause oversized bvecs number
+	 * to cache_bio.
+	 */
+	nr_bvecs = DIV_ROUND_UP(bio_sectors(bio) + reada, PAGE_SECTORS);
+	max_segs = bio_max_segs(nr_bvecs);
+	if (nr_bvecs > max_segs)
+		reada = max_segs * PAGE_SECTORS - bio_sectors(bio);
+
+	/*
+	 * Make sure sectors won't exceed (1 << KEY_SIZE_BITS) - 1, which is
+	 * the maximum bkey size in unit of sector. Then s->insert_bio_sectors
+	 * will always be a valid bio in valid bkey size range.
+	 */
+	if (sectors > ((1 << KEY_SIZE_BITS) - 1))
+		sectors = (1 << KEY_SIZE_BITS) - 1;
 	s->insert_bio_sectors = min(sectors, bio_sectors(bio) + reada);
 
 	s->iop.replace_key = KEY(s->iop.inode,
-- 
2.26.2

