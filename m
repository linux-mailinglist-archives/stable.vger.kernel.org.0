Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C132891BA7
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 05:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHSD4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 23:56:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfHSD4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 23:56:25 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23E2D3091782;
        Mon, 19 Aug 2019 03:56:25 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E9D61001B11;
        Mon, 19 Aug 2019 03:56:19 +0000 (UTC)
Date:   Mon, 19 Aug 2019 11:56:14 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2] block/bio-integrity: fix mismatched alloc free
Message-ID: <20190819035613.GC3086@ming.t460p>
References: <1566176353-20157-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566176353-20157-1-git-send-email-bianpan2016@163.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 19 Aug 2019 03:56:25 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 08:59:13AM +0800, Pan Bian wrote:
> The function kmalloc rather than mempool_alloc is called to allocate
> memory when the memory pool is unavailable. However, mempool_alloc is
> used to release the memory chunck in both cases when error occurs. This
> patch fixes the bug.
> 
> Fixes: 9f060e2231c ("block: Convert integrity to bvec_alloc_bs()")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> Cc: stable@vger.kernel.org
> ---
> V2: add Fixes and CC tags
> ---
>  block/bio-integrity.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index fb95dbb..011dfc8 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -75,7 +75,10 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
>  
>  	return bip;
>  err:
> -	mempool_free(bip, &bs->bio_integrity_pool);
> +	if (!bs || !mempool_initialized(&bs->bio_integrity_pool))
> +		kfree(bip);
> +	else
> +		mempool_free(bip, &bs->bio_integrity_pool);
>  	return ERR_PTR(-ENOMEM);
>  }
>  EXPORT_SYMBOL(bio_integrity_alloc);

'err' is still reached in case that 'bs' is valid, so fix nothing.


Thanks,
Ming
