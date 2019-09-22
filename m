Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2597CBA17F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 10:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfIVIaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 04:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbfIVIaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 04:30:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6F220820;
        Sun, 22 Sep 2019 08:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569141007;
        bh=N5M3bZB2ghdYkBfCMLA5K09s+IwMF8I5eMYFoxafSQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zTWX4XAx8vCjAiXSdG18ckB+C4mvrcPwaHvCA2loxtCRcD9fJxcNejYXsB6A7TCuG
         8dyqoM5d8wXqOY9pzn4GUUTpKMU8CcqXULvHqMupEF7dh34/aGpuBV0ZoBAffYA4A6
         aj7OH/7s+uCUm6YKX53nqi2uA3H2TqL5Ww1AJmYI=
Date:   Sun, 22 Sep 2019 10:30:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Yossi Itigin <yosefe@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Subject: Re: [PATCH 4.19 03/79] RDMA/restrack: Release task struct which was
 hold by CM_ID object
Message-ID: <20190922083004.GA2654133@kroah.com>
References: <20190919214807.612593061@linuxfoundation.org>
 <20190919214808.101726182@linuxfoundation.org>
 <20190921202209.GA14868@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190921202209.GA14868@amd>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 21, 2019 at 10:22:10PM +0200, Pavel Machek wrote:
> Hi!
> 
> > commit ed7a01fd3fd77f40b4ef2562b966a5decd8928d2 upstream.
> > 
> > Tracking CM_ID resource is performed in two stages: creation of cm_id
> > and connecting it to the cma_dev. It is needed because rdma-cm protocol
> > exports two separate user-visible calls rdma_create_id and
> > rdma_accept.
> ...
> 
> Mainline says this needs additional fix, fe9bc1644918aa1d, see below.
> 
> > --- a/drivers/infiniband/core/restrack.c
> > +++ b/drivers/infiniband/core/restrack.c
> > @@ -209,7 +209,7 @@ void rdma_restrack_del(struct rdma_restr
> >  	struct ib_device *dev;
> >  
> >  	if (!res->valid)
> > -		return;
> > +		goto out;
> >  
> >  	dev = res_to_dev(res);
> >  	if (!dev)
> #                 return;
> 
> This test does return, does it need to go through 'goto out', too? (I
> see it should not happen, but...)
> 
> > @@ -222,8 +222,10 @@ void rdma_restrack_del(struct rdma_restr
> >  	down_write(&dev->res.rwsem);
> >  	hash_del(&res->node);
> >  	res->valid = false;
> > +	up_write(&dev->res.rwsem);
> > +
> > +out:
> >  	if (res->task)
> >  		put_task_struct(res->task);
> > -	up_write(&dev->res.rwsem);
> >  }
> 
> Mainline says res->task = NULL is needed there, see fe9bc1644918aa1d.

Good catch, now queued up, thanks!

greg k-h
