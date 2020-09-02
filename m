Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FD225A280
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 03:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIBBG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 21:06:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57016 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726167AbgIBBG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 21:06:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599008787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zsRdbWM7f98X5EgxemT6G330tQwn+fiPlPc5hDyvjCw=;
        b=K/81SfPborkkXs4nH2qPSZ0n7fL3KJsEDz00yx/nUnZG/KiYYRvRHJ2jNDvIdeU3rL3/F6
        DNZcb9l/E4Taa53fSSIw+u0GpPAtTu5jmJomd2zZ+76wBSmQwStrirXpERgTnFSOoG6d5H
        vqcNvzFkeKqAXpKb2svtqSvbK1okRwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-vccdlPmRN7-vEc3WmZS7rA-1; Tue, 01 Sep 2020 21:06:23 -0400
X-MC-Unique: vccdlPmRN7-vEc3WmZS7rA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 051251888A24;
        Wed,  2 Sep 2020 01:06:21 +0000 (UTC)
Received: from T590 (ovpn-12-189.pek2.redhat.com [10.72.12.189])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23B1A7C584;
        Wed,  2 Sep 2020 01:06:13 +0000 (UTC)
Date:   Wed, 2 Sep 2020 09:06:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        syzbot <syzbot+61acc40a49a3e46e25ea@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH V2] block: allow for_each_bvec to support zero len bvec
Message-ID: <20200902010609.GA317674@T590>
References: <20200817100055.2495905-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817100055.2495905-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:00:55PM +0800, Ming Lei wrote:
> Block layer usually doesn't support or allow zero-length bvec. Since
> commit 1bdc76aea115 ("iov_iter: use bvec iterator to implement
> iterate_bvec()"), iterate_bvec() switches to bvec iterator. However,
> Al mentioned that 'Zero-length segments are not disallowed' in iov_iter.
> 
> Fixes for_each_bvec() so that it can move on after seeing one zero
> length bvec.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Link: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2262077.html
> Fixes: 1bdc76aea115 ("iov_iter: use bvec iterator to implement iterate_bvec()")
> Reported-by: syzbot <syzbot+61acc40a49a3e46e25ea@syzkaller.appspotmail.com>
> Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: <stable@vger.kernel.org>
> ---
> V2:
> 	- fix reported-by tag
> 
>  include/linux/bvec.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index ac0c7299d5b8..9c4fab5f22a7 100644
> --- a/include/linux/bvec.h
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
>  /* for iterating one bio from start to end */
>  #define BVEC_ITER_ALL_INIT (struct bvec_iter)				\
> -- 
> 2.25.2
> 

Hello Jens,

Looks at least two reports can be fixed by this patch, so could you
take a look?

Thanks,
Ming

