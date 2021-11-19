Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F694570A1
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 15:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbhKSOaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 09:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:32992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232080AbhKSOaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 09:30:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B0E361213;
        Fri, 19 Nov 2021 14:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637332040;
        bh=+sNI6WuXi70Crpmp6YjIDfof/GBt7NzOTisTzBIuPKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gbunad/rfcENCC3vwCMDnwCEAV4R3VDLEdL9mBdPkB/VNdlzyGyOTaO4B+T43Szkf
         ZSnB6MGDwHGOUofmwZkAsOQ6EMWak9D6sZAorHD80voFWVDBMsCGI5SQcL9IAO8Y/t
         aQJ5ZNa6sGj1Iw9yDbhIMNFQMPWUEE5TnbwdAszg=
Date:   Fri, 19 Nov 2021 15:27:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     stable@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        Yue Hu <huyue2@yulong.com>, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH 5.10.y 1/2] erofs: remove the occupied parameter from
 z_erofs_pagevec_enqueue()
Message-ID: <YZe0RBWxactlMaN0@kroah.com>
References: <16369834628252@kroah.com>
 <20211116010819.122905-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116010819.122905-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 09:08:18AM +0800, Gao Xiang wrote:
> From: Yue Hu <huyue2@yulong.com>
> 
> commit 7dea3de7d384f4c8156e8bd93112ba6db1eb276c upstream.
> 
> No any behavior to variable occupied in z_erofs_attach_page() which
> is only caller to z_erofs_pagevec_enqueue().
> 
> Link: https://lore.kernel.org/r/20210419102623.2015-1-zbestahu@gmail.com
> Signed-off-by: Yue Hu <huyue2@yulong.com>
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> Signed-off-by: Gao Xiang <xiang@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> Gao Xiang: Apply this trivial cleanup (no behavior change) for easier
>            backporting.
> 
>  fs/erofs/zdata.c | 4 +---
>  fs/erofs/zpvec.h | 5 +----
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 86fd3bf62af6..ca27d3e47857 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -282,7 +282,6 @@ static int z_erofs_attach_page(struct z_erofs_collector *clt,
>  			       enum z_erofs_page_type type)
>  {
>  	int ret;
> -	bool occupied;
>  
>  	/* give priority for inplaceio */
>  	if (clt->mode >= COLLECT_PRIMARY &&
> @@ -290,8 +289,7 @@ static int z_erofs_attach_page(struct z_erofs_collector *clt,
>  	    z_erofs_try_inplace_io(clt, page))
>  		return 0;
>  
> -	ret = z_erofs_pagevec_enqueue(&clt->vector,
> -				      page, type, &occupied);
> +	ret = z_erofs_pagevec_enqueue(&clt->vector, page, type);
>  	clt->cl->vcnt += (unsigned int)ret;
>  
>  	return ret ? 0 : -EAGAIN;
> diff --git a/fs/erofs/zpvec.h b/fs/erofs/zpvec.h
> index 1d67cbd38704..95a620739e6a 100644
> --- a/fs/erofs/zpvec.h
> +++ b/fs/erofs/zpvec.h
> @@ -107,10 +107,8 @@ static inline void z_erofs_pagevec_ctor_init(struct z_erofs_pagevec_ctor *ctor,
>  
>  static inline bool z_erofs_pagevec_enqueue(struct z_erofs_pagevec_ctor *ctor,
>  					   struct page *page,
> -					   enum z_erofs_page_type type,
> -					   bool *occupied)
> +					   enum z_erofs_page_type type)
>  {
> -	*occupied = false;
>  	if (!ctor->next && type)
>  		if (ctor->index + 1 == ctor->nr)
>  			return false;
> @@ -125,7 +123,6 @@ static inline bool z_erofs_pagevec_enqueue(struct z_erofs_pagevec_ctor *ctor,
>  	/* should remind that collector->next never equal to 1, 2 */
>  	if (type == (uintptr_t)ctor->next) {
>  		ctor->next = page;
> -		*occupied = true;
>  	}
>  	ctor->pages[ctor->index++] = tagptr_fold(erofs_vtptr_t, page, type);
>  	return true;
> -- 
> 2.24.4
> 

All now queued up, thanks.

greg k-h
