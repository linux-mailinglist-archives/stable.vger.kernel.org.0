Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DCA240131
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 05:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHJDdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 23:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgHJDdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Aug 2020 23:33:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097EDC061756;
        Sun,  9 Aug 2020 20:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bnjds8mzMbvLMRp+TUi2KuIrfCsl0UNInymGxiP/wQg=; b=CGgNyBVk2s82Q7v81hPjYkWHfa
        vaQ0JRMObLYP9EosJmEkY6uWvdefe1rqtK58cBaONumBucT3lDJG6Cc86CETBHcEdJKSZdY94PAeX
        DWhOUXkvl1RAWTYIZ2/Gv+lTQKCRuOFAoX7Eo5bgqkLbZPhlb2PNktaBBS0g9GKA+dJsYJMj+P77P
        5D3KY9esqsgSzQ9lKFfzOcv2a7debmxcGXb+H2qZbm41wBAWqN/rNj+ZnP8nBUebGhnnw8MHWqLka
        ES4NuXCnlWQ4omnH8neUP3Gy7XNHr/UzqC2FlSx5CzaP7OAuuG+wSwxdbd6cFNn/7xG6nPms55F5T
        t94vUGyg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k4yYf-0007Pu-8n; Mon, 10 Aug 2020 03:33:09 +0000
Date:   Mon, 10 Aug 2020 04:33:09 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] block: allow for_each_bvec to support zero len bvec
Message-ID: <20200810033309.GK17456@casper.infradead.org>
References: <20200810031915.2209658-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810031915.2209658-1-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 11:19:15AM +0800, Ming Lei wrote:
> +++ b/include/linux/bvec.h
> @@ -117,11 +117,18 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
>  	return true;
>  }
>  
> +static inline void bvec_iter_skip_zero_bvec(struct bvec_iter *iter)
> +{
> +	iter->bi_bvec_done = 0;
> +	iter->bi_idx++;
> +}
> +
>  #define for_each_bvec(bvl, bio_vec, iter, start)			\
>  	for (iter = (start);						\
>  	     (iter).bi_size &&						\
>  		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
> -	     bvec_iter_advance((bio_vec), &(iter), (bvl).bv_len))
> +	     (bvl).bv_len ? bvec_iter_advance((bio_vec), &(iter),	\
> +		     (bvl).bv_len) : bvec_iter_skip_zero_bvec(&(iter)))
>  

What if you have two zero-length bvecs in a row?  Won't this just skip
the first one?

It would seem better to me to put the bv_len test in bvec_iter_advance()
instead of making the macro more complicated.
