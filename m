Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E056A3D7257
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 11:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbhG0Jun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 05:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235950AbhG0Jum (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 05:50:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C779C613A1;
        Tue, 27 Jul 2021 09:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627379442;
        bh=v5/2yWp+5jt6Xy8JjqpzlOuAA6t3QI1oC1F5fwO35gU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IeeD9YZMBTMTi2s2SOaYZBiW/e3CvDlZYRy84JUCBAZMceIZppjsZGfo+HFUKJNyc
         ZLDHm2vd6fO3/nJVb899lrk157oMD8c8nYYzSZ1xUH5qiiKQqqhvQtpoWEGS2Ivpdl
         ZEBA7VUjajM0Q2/TuW8KHtBKpoVHZvv+2RkdWw4Q=
Date:   Tue, 27 Jul 2021 11:50:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Lobakin <alobakin@pm.me>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 029/167] net: do not reuse skbuff allocated from
 skbuff_fclone_cache in the skb cache
Message-ID: <YP/W8EYi86Oi56Kh@kroah.com>
References: <20210726153839.371771838@linuxfoundation.org>
 <20210726153840.350300456@linuxfoundation.org>
 <20210727082238.GA10177@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727082238.GA10177@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 10:22:38AM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 28b34f01a73435a754956ebae826e728c03ffa38 ]
> 
> Mainline is significantly different here. Patch makes no sense in
> 5.10, as both branches of if are same.
> 
> Best regards,
> 								Pavel
> 
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6100,6 +6100,8 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
> >  	case GRO_MERGED_FREE:
> >  		if (NAPI_GRO_CB(skb)->free == NAPI_GRO_FREE_STOLEN_HEAD)
> >  			napi_skb_free_stolen_head(skb);
> > +		else if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
> > +			__kfree_skb(skb);
> >  		else
> >  			__kfree_skb(skb);
> >  		break;
> 

You are right, I'll go drop this patch from the queue now, thanks.

greg k-h
