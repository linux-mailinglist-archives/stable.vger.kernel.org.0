Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143FB39B00D
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 03:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFDBzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 21:55:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230025AbhFDBzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 21:55:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622771612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vqFUmniCC488GUpp4xBAu68FfZpCcKh9+CsQQqre8x4=;
        b=Z5OELY6q6sRMO8EWcOxVcLTipq7ubdhzwyIAN6/+jwjQnrBczC+8/L9MuEkGy01fGjazNc
        oWjN7fGjJZwzimjGHSK9Npf5MDv9pfZsj6kPRAztGv955zAc/Epzng5RNwD+qQh3MR8H8J
        A89m2zRFuPVJkcVcHbXPHZ5Ijbh0ByI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-J9nU4BbfOg6zaCj2GQz7qw-1; Thu, 03 Jun 2021 21:53:30 -0400
X-MC-Unique: J9nU4BbfOg6zaCj2GQz7qw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 357EE3FD4;
        Fri,  4 Jun 2021 01:53:28 +0000 (UTC)
Received: from T590 (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5276460C17;
        Fri,  4 Jun 2021 01:53:18 +0000 (UTC)
Date:   Fri, 4 Jun 2021 09:53:15 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     longli@linuxonhyperv.com
Cc:     linux-block@vger.kernel.org, Long Li <longli@microsoft.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] block: return the correct bvec when checking for gaps
Message-ID: <YLmHi27PT5LAwJji@T590>
References: <1622759671-14059-1-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622759671-14059-1-git-send-email-longli@linuxonhyperv.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Long,

On Thu, Jun 03, 2021 at 03:34:31PM -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> After commit 07173c3ec276 ("block: enable multipage bvecs"), a bvec can
> have multiple pages. But bio_will_gap() still assumes one page bvec while
> checking for merging. This causes data corruption on drivers relying on
> the correct merging on virt_boundary_mask.

Can you explain the data corruption a bit? 

IMO, either single page bvec or multipage bvec should be fine, because
bio_will_gap() just checks if the last bvec of prev bio and the 1st bvec
of next bio can be merged.

> 
> Fix this by returning the multi-page bvec for testing gaps for merging.
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
> -	}
>  
>  	bio_advance_iter(bio, &iter, iter.bi_size);

The patch itself looks fine, given both bio_get_first_bvec() and bio_get_last_bvec()
are used in bio_will_gap() only.


Thanks,
Ming

