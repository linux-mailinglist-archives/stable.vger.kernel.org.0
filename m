Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7781DC819
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 10:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgEUIAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 04:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbgEUIAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 04:00:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB7C206B6;
        Thu, 21 May 2020 08:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590048049;
        bh=b4rXZiDYnO4XTY4a5ERzT5K5Vs+qpN0qRLWP/YLMO4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HKUKP9EzKjlAcP38oBYvTFrSs0DZiKhjOA4eX6FAkKa4IgdxHWSCIONa+LouUO00c
         DRE6G5tfo3bbDix2nCMGDDb0DRvaIxRPmO3YMoe/k3EWW1VLRgpiF89SOn6QJR5Z2j
         sw92LBhJj6RkVa/Ku4aI3ArzwvgRmYZz5vzjvl7o=
Date:   Thu, 21 May 2020 10:00:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: Backporting "padata: Remove broken queue flushing"
Message-ID: <20200521080046.GA2615557@kroah.com>
References: <0b158b60fe621552c327e9d822bc3245591a4bd6.camel@decadent.org.uk>
 <20200519200018.5vuyuxmjy5ypgi3w@ca-dmjordan1.us.oracle.com>
 <87267d7217e4a3d58440079c16d313e411eab004.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87267d7217e4a3d58440079c16d313e411eab004.camel@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 03:33:44PM +0100, Ben Hutchings wrote:
> On Tue, 2020-05-19 at 16:00 -0400, Daniel Jordan wrote:
> > Hello Ben,
> > 
> > On Tue, May 19, 2020 at 02:53:05PM +0100, Ben Hutchings wrote:
> > > I noticed that commit 07928d9bfc81 "padata: Remove broken queue
> > > flushing" has been backported to most stable branches, but commit
> > > 6fc4dbcf0276 "padata: Replace delayed timer with immediate workqueue in
> > > padata_reorder" has not.
> > > 
> > > Is this correct?  What prevents the parallel_data ref-count from
> > > dropping to 0 while the timer is scheduled?
> > 
> > Doesn't seem like anything does, looking at 4.19.
> 
> OK, so it looks like the following commits should be backported:
> 
> [3.16-4.9]  119a0798dc42 padata: Remove unused but set variables
> [3.16]      de5540d088fe padata: avoid race in reordering
> [3.16-4.9]  69b348449bda padata: get_next is never NULL
> [3.16-4.14] cf5868c8a22d padata: ensure the reorder timer callback runs on the correct CPU
> [3.16-4.14] 350ef88e7e92 padata: ensure padata_do_serial() runs on the correct CPU

These all applied cleanly to the needed trees, but these:

> [3.16-4.19] 6fc4dbcf0276 padata: Replace delayed timer with immediate workqueue in padata_reorder
> [3.16-4.19] ec9c7d19336e padata: initialize pd->cpu with effective cpumask
> [3.16-4.19] 065cf577135a padata: purge get_cpu and reorder_via_wq from padata_do_serial

Need some non-trivial backporting.  Can you, or someone else do it so I
can queue them up?  I don't have the free time at the moment, sorry.

thanks,

greg k-h
