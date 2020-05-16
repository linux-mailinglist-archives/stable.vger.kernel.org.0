Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6521D5EF1
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 07:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgEPFu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 May 2020 01:50:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23025 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725807AbgEPFu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 May 2020 01:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589608227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1U+2TT+KSyuB8+J8otdmfu38tcV5l3t0X/8rEiqc8FA=;
        b=es/d3cvjLJiqYI62pP314BgiyN3B3BCsS+1tOs+xl5uy8Bs51MKewI0gTxryjjBQz1sAqe
        C2gmOtQtojVJqvyXL52YvvIBOW48U5YhMI8gjg8gKdqAJhdumQuYBAp3+XizHsNs0ihT++
        dXQSL23Xh/zZ/vgFUOr6I4pnPUn2QWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-O9lTJ3GLPui2cZwHYbKFlA-1; Sat, 16 May 2020 01:50:23 -0400
X-MC-Unique: O9lTJ3GLPui2cZwHYbKFlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FCCA805721;
        Sat, 16 May 2020 05:50:22 +0000 (UTC)
Received: from T590 (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D48067053C;
        Sat, 16 May 2020 05:50:16 +0000 (UTC)
Date:   Sat, 16 May 2020 13:50:12 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH 4/5] block: Fix zero_fill_bio()
Message-ID: <20200516055012.GA3393@T590>
References: <20200516001914.17138-1-bvanassche@acm.org>
 <20200516001914.17138-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516001914.17138-5-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 05:19:13PM -0700, Bart Van Assche wrote:
> Multiple block drivers use zero_fill_bio() to zero-initialize the data
> buffer used for read operations. Make sure that all pages are zeroed
> instead of only the first if one or more multi-page bvecs are used to
> describe the data buffer.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/bio.c         | 27 ++++++++++++++++++++++-----
>  include/linux/bio.h |  1 +
>  2 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 1594804fe8bc..48fcafbdae70 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -527,17 +527,34 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
>  }
>  EXPORT_SYMBOL(bio_alloc_bioset);
>  
> +void zero_fill_bvec(const struct bio_vec *bvec)
> +{
> +	struct page *page = bvec->bv_page;
> +	u32 offset = bvec->bv_offset;
> +	u32 left = bvec->bv_len;
> +
> +	while (left) {
> +		u32 len = min_t(u32, left, PAGE_SIZE - offset);
> +		void *kaddr;
> +
> +		kaddr = kmap_atomic(page);
> +		memset(kaddr + offset, 0, len);
> +		flush_dcache_page(page);
> +		kunmap_atomic(kaddr);
> +		page++;
> +		left -= len;
> +		offset = 0;
> +	}
> +}
> +EXPORT_SYMBOL(zero_fill_bvec);
> +
>  void zero_fill_bio_iter(struct bio *bio, struct bvec_iter start)
>  {
> -	unsigned long flags;
>  	struct bio_vec bv;
>  	struct bvec_iter iter;
>  
>  	__bio_for_each_segment(bv, bio, iter, start) {

The 'bv' from __bio_for_each_segment() is single page bvec, and so far
only [__]bio_for_each_bvec iterates over multi-page bvec.

So nothing to be fixed and this patch isn't necessary.

Thanks, 
Ming

