Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA1E4445CB
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 17:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhKCQWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 12:22:35 -0400
Received: from verein.lst.de ([213.95.11.211]:60202 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232644AbhKCQWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 12:22:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 22EE868AA6; Wed,  3 Nov 2021 17:19:56 +0100 (CET)
Date:   Wed, 3 Nov 2021 17:19:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] bcache: Revert "bcache: use bvec_virt"
Message-ID: <20211103161955.GA394@lst.de>
References: <20211103151041.70516-1-colyli@suse.de> <20211103154644.GA30686@lst.de> <1d1180e0-32bc-e571-3252-ce496508d2b5@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d1180e0-32bc-e571-3252-ce496508d2b5@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 12:11:45AM +0800, Coly Li wrote:
>> fresh page for each vec, and bio_for_each_segment_all iterates page
>> by page.  IFF there is an offset there is proble in the surrounding
>> code as bch_bio_alloc_pages assumes that it is called on a freshly
>> allocate and initialized bio.
>
> Yes, the offset is modified in bch_bio_alloc_pages().

Where?   In my upstream copy of bch_bio_alloc_pages there is no bv_offset
manipulation, and I could not see how such a manipulation would make
sense.

> Normally the bcache 
> defined block size is 4KB so the issue was not triggered frequently. I 
> found it during testing my nvdimm enabling code for bcache, where I happen 
> to make the bcache defined block size to non-4KB. The offset is from the 
> previous written bkey set, which the minimized unit size is 1 
> bcache-defined-block-size.

So you have some out of tree changes here?  Copying a PAGE_SIZE into
a 'segment' bvec just does not make any sense if there is an offset,
as segments are defined as bvecs that do not span page boundaries.

I suspect the best thing to do in do_btree_node_write would be something
like the patch below instead of poking into the internals here, but I'd
also really like to understand the root cause as it does point to a bug
somewhere else.


diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 93b67b8d31c3d..f69914848f32f 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -378,8 +378,8 @@ static void do_btree_node_write(struct btree *b)
 		struct bvec_iter_all iter_all;
 
 		bio_for_each_segment_all(bv, b->bio, iter_all) {
-			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
-			addr += PAGE_SIZE;
+			memcpy_to_bvec(bvec_virt(bv), addr);
+			addr += bv->bv_len;
 		}
 
 		bch_submit_bbio(b->bio, b->c, &k.key, 0);

