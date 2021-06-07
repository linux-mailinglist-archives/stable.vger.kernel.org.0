Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853CD39D596
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 09:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhFGHLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 03:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGHLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 03:11:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2C2C061766;
        Mon,  7 Jun 2021 00:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TuqDyFF8ffS2jCcc39LRp7FhGd3Sbm44R1NXmZ9SKuU=; b=H3Es/7FrTJ7eDudl/jWxe5zNO/
        1At0Lm3R4OdtBubx7/5X8RZRmenGJ/p7mLSFKYzxP8i0kYg58VMARJW3lFwMexyFZ6ebE3QBXcxnB
        WbQRWEV8ztXgEI6mTTFU+xihOHQ2VyMMGXdUilyKYXDrk18Myjv2OBtvI36Ba9a8o4U4DAgikUrrs
        RfaIXFHsIwzDraLHgxsDe1htFrd8S0kjWbv1Rb580TM9UorUSUCt81SkGPsuR44EjyUFY6G/VSewu
        DZtvPiq8XehZI0brOQAVen7CrJiwu3VePu11Pz92+P7JP3dQXawzj20eqirawZ+TGjPKDTZ0sRgka
        JWm72ahg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lq9Nc-00FTGd-GQ; Mon, 07 Jun 2021 07:09:02 +0000
Date:   Mon, 7 Jun 2021 08:09:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     longli@linuxonhyperv.com
Cc:     linux-block@vger.kernel.org, Long Li <longli@microsoft.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Patch v2] block: return the correct bvec when checking for gaps
Message-ID: <YL3GDF5KiM9e69eW@infradead.org>
References: <1622849839-5407-1-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622849839-5407-1-git-send-email-longli@linuxonhyperv.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 04, 2021 at 04:37:19PM -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> After commit 07173c3ec276 ("block: enable multipage bvecs"), a bvec can
> have multiple pages. But bio_will_gap() still assumes one page bvec while
> checking for merging. If the pages in the bvec go across the
> seg_boundary_mask, this check for merging can potentially succeed if only
> the 1st page is tested, and can fail if all the pages are tested.
> 
> Later, when SCSI builds the SG list the same check for merging is done in
> __blk_segment_map_sg_merge() with all the pages in the bvec tested. This
> time the check may fail if the pages in bvec go across the
> seg_boundary_mask (but tested okay in bio_will_gap() earlier, so those
> BIOs were merged). If this check fails, we end up with a broken SG list
> for drivers assuming the SG list not having offsets in intermediate pages.
> This results in incorrect pages written to the disk.
> 
> Fix this by returning the multi-page bvec when testing gaps for merging.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Fixes: 07173c3ec276 ("block: enable multipage bvecs")
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
> Change from v1: add commit details on how data corruption happens
> 
>  include/linux/bio.h | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index a0b4cfdf62a4..6b2f609ccfbf 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -44,9 +44,6 @@ static inline unsigned int bio_max_segs(unsigned int nr_segs)
>  #define bio_offset(bio)		bio_iter_offset((bio), (bio)->bi_iter)
>  #define bio_iovec(bio)		bio_iter_iovec((bio), (bio)->bi_iter)
>  
> -#define bio_multiple_segments(bio)				\
> -	((bio)->bi_iter.bi_size != bio_iovec(bio).bv_len)
> -
>  #define bvec_iter_sectors(iter)	((iter).bi_size >> 9)
>  #define bvec_iter_end_sector(iter) ((iter).bi_sector + bvec_iter_sectors((iter)))
>  
> @@ -271,7 +268,7 @@ static inline void bio_clear_flag(struct bio *bio, unsigned int bit)
>  
>  static inline void bio_get_first_bvec(struct bio *bio, struct bio_vec *bv)
>  {
> -	*bv = bio_iovec(bio);
> +	*bv = mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
>  }
>  
>  static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
> @@ -279,10 +276,10 @@ static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
>  	struct bvec_iter iter = bio->bi_iter;
>  	int idx;
>  
> -	if (unlikely(!bio_multiple_segments(bio))) {
> -		*bv = bio_iovec(bio);
> +	/* this bio has only one bvec */
> +	*bv = mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> +	if (bv->bv_len == bio->bi_iter.bi_size)
>  		return;

Nit: I'd move the comment a bit as the current placement confused me at
first.  Also maybe use bio_get_first_bvec here to make it even more
obvious:

	bio_get_first_bvec(bio, bv);
	if (bv->bv_len == bio->bi_iter.bi_size)
		return;		/* this bio only has a single bvec */
