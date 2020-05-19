Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA261D98E8
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgESOGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 10:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbgESOGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 10:06:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A428D20823;
        Tue, 19 May 2020 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589897174;
        bh=virwAIdLbLEajI0gSP1GCDMEsxsYgKyP41qGyLBhdao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hozkobn+i0JT+9evBYfyDvFFM8Lqn6WQcTg46946E9lb/FW7RbBGHZAS9J8iOOfTg
         HlGttRqZ4Aily2R9ZQLaEi+WdpJm38MtR8RI4SerwR8tbQLNzNkDOI5CNcXWeblF/O
         ZgRMYD7W/lBfA69U4l/s4xvf60cGepWqn/EfhXWU=
Date:   Tue, 19 May 2020 16:06:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 4.19 41/80] netfilter: nft_set_rbtree: Introduce and use
 nft_rbtree_interval_start()
Message-ID: <20200519140611.GA521153@kroah.com>
References: <20200518173450.097837707@linuxfoundation.org>
 <20200518173458.612903024@linuxfoundation.org>
 <20200519120625.GA8342@amd>
 <20200519121356.GA354164@kroah.com>
 <20200519121907.GA9158@amd>
 <20200519125113.GA376546@kroah.com>
 <20200519155300.3560394f@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200519155300.3560394f@elisabeth>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 03:53:00PM +0200, Stefano Brivio wrote:
> On Tue, 19 May 2020 14:51:13 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, May 19, 2020 at 02:19:07PM +0200, Pavel Machek wrote:
> > > On Tue 2020-05-19 14:13:56, Greg Kroah-Hartman wrote:  
> > > > On Tue, May 19, 2020 at 02:06:25PM +0200, Pavel Machek wrote:  
> > > > > Hi!
> > > > >   
> > > > > > [ Upstream commit 6f7c9caf017be8ab0fe3b99509580d0793bf0833 ]
> > > > > > 
> > > > > > Replace negations of nft_rbtree_interval_end() with a new helper,
> > > > > > nft_rbtree_interval_start(), wherever this helps to visualise the
> > > > > > problem at hand, that is, for all the occurrences except for the
> > > > > > comparison against given flags in __nft_rbtree_get().
> > > > > > 
> > > > > > This gets especially useful in the next patch.  
> > > > > 
> > > > > This looks like cleanup in preparation for the next patch. Next patch
> > > > > is there for some series, but not for 4.19.124. Should this be in
> > > > > 4.19, then?  
> > > > 
> > > > What is the "next patch" in this situation?  
> > > 
> > > In 5.4 you have:
> > > 
> > > 9956 O   Greg Kroah ├─>[PATCH 5.4 082/147] netfilter: nft_set_rbtree: Introduce and use nft
> > > 9957     Greg Kroah ├─>[PATCH 5.4 083/147] netfilter: nft_set_rbtree: Add missing expired c
> > > 
> > > In 4.19 you have:
> > > 
> > > 10373 r   Greg Kroah ├─>[PATCH 4.19 41/80] netfilter: nft_set_rbtree: Introduce and use nft
> > > 10376 O   Greg Kroah ├─>[PATCH 4.19 42/80] IB/mlx4: Test return value of calls to ib_get_ca
> > > 
> > > I believe 41/80 can be dropped from 4.19 series, as it is just a
> > > preparation for 083/147... which is not queued for 4.19.  
> > 
> > I've queued it up for 4.19 now, thanks.
> 
> Wait, wait, sorry. I thought you were queuing this up as a missing
> dependency or something, but I see it's not the case. That patch is
> *not* the preparation for:
> 
>   340eaff65116 netfilter: nft_set_rbtree: Add missing expired checks
> 
> ...but rather preparation for:
> 
>   7c84d41416d8 netfilter: nft_set_rbtree: Detect partial overlaps on insertion
> 
> whose fix-up:
> 
>   72239f2795fa netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion
> 
> was queued for 5.6.x (see <20200421131431.GA793882@kroah.com>).
> 
> Now, if you want to backport "Add missing expired checks", it *might* be
> more convenient to also backport:
> 
>   6f7c9caf017b netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
> 
> and, perhaps (I haven't tried to actually cherry-pick) also:
> 
>   7c84d41416d8 netfilter: nft_set_rbtree: Detect partial overlaps on insertion
>   72239f2795fa netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion
> 
> and it's safe to either:
> 
> - backport only 6f7c9caf017b
> - backport the three of them
> 
> but other than avoiding conflicts, there should be no reason to do that.
> Sasha had already queued them up for 4.19 and 5.4, then dropped them as
> they weren't needed, see <20200413163900.GO27528@sasha-vm>.

Ok, I'll go drop the patch I just added, thanks for clearing this up.


greg k-h
