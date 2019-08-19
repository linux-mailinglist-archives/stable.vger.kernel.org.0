Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E4891BA2
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 05:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfHSDxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 23:53:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfHSDxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 23:53:49 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A50D811A9;
        Mon, 19 Aug 2019 03:53:49 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C7E084952;
        Mon, 19 Aug 2019 03:53:42 +0000 (UTC)
Date:   Mon, 19 Aug 2019 11:53:38 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2] block: fix a mismatched alloc free in bio_alloc_bioset
Message-ID: <20190819035337.GB3086@ming.t460p>
References: <1566176120-19924-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566176120-19924-1-git-send-email-bianpan2016@163.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 19 Aug 2019 03:53:49 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 08:55:20AM +0800, Pan Bian wrote:
> The function kmalloc is called to allocate memory if bs is NULL.
> However, mempool_free is used to release the memory chunk even if bs is
> NULL in the error hanlding code. This patch checks bs and use the
> correct function to release memory.
> 
> 
> Fixes: 3f86a82aeb ("block: Consolidate bio_alloc_bioset(), bio_kmalloc()")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> Cc: stable@vger.kernel.org
> ---
> V2: add Fixes and Cc tags
> ---
>  block/bio.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 299a0e7..c5f5238 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -515,7 +515,10 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
>  	return bio;
>  
>  err_free:
> -	mempool_free(p, &bs->bio_pool);
> +	if (!bs)
> +		kfree(p);
> +	else
> +		mempool_free(p, &bs->bio_pool);
>  	return NULL;
>  }
>  EXPORT_SYMBOL(bio_alloc_bioset);

'err_free' is only reached in case that 'bs' isn't NULL, so this patch
fixes nothing.


Thanks,
Ming
