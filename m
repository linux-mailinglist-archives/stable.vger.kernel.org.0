Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3911117385E
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 14:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgB1Naj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 08:30:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgB1Naj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 08:30:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13F3D2469D;
        Fri, 28 Feb 2020 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582896638;
        bh=53oCsur/c2ZxKBhkRNnzQEppXhuuy+9+hAg0PfAHndc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FkJYHhdeolWLtiYAGUPfgv89vtSOHwEeK5vwuh2v3+G7gXm3RLhrmsCE1oFQtDWwq
         A8XFh7mw2AOW6rXaGPBY7r5tjbhffNUlDuzDyrGuxNWzf1x8JFd7ZwBAsNsgovMfBQ
         cLnWz9guSmC5cJeRdSFGTIsDYjGPOKaz7p+7SzHc=
Date:   Fri, 28 Feb 2020 14:30:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miles Chen <miles.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 60/97] lib/stackdepot: Fix outdated comments
Message-ID: <20200228133036.GB3021902@kroah.com>
References: <20200227132214.553656188@linuxfoundation.org>
 <20200227132224.337663006@linuxfoundation.org>
 <20200228130532.GA2979@duo.ucw.cz>
 <20200228132455.GA3021902@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228132455.GA3021902@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 02:24:55PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 28, 2020 at 02:05:33PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > [ Upstream commit ee050dc83bc326ad5ef8ee93bca344819371e7a5 ]
> > > 
> > > Replace "depot_save_stack" with "stack_depot_save" in code comments because
> > > depot_save_stack() was replaced in commit c0cfc337264c ("lib/stackdepot:
> > > Provide functions which operate on plain storage arrays") and removed in
> > > commit 56d8f079c51a ("lib/stackdepot: Remove obsolete functions")
> > 
> > This is wrong.
> > 
> > > +++ b/lib/stackdepot.c
> > > @@ -96,7 +96,7 @@ static bool init_stack_slab(void **prealloc)
> > >  		stack_slabs[depot_index + 1] = *prealloc;
> > >  		/*
> > >  		 * This smp_store_release pairs with smp_load_acquire() from
> > > -		 * |next_slab_inited| above and in depot_save_stack().
> > > +		 * |next_slab_inited| above and in stack_depot_save().
> > >  		 */
> > >  		smp_store_release(&next_slab_inited, 1);
> > >  	}
> > 
> > May have been outdated for mainline, but they are actually okay for
> > 4.19.
> 
> Good catch, I'll go drop this from the stable queues (4.14, 4.9, and 4.19).

Ah, nope, this patch is needed for the "real" patch here, 305e519ce48e
("lib/stackdepot.c: fix global out-of-bounds in stack_slabs")

Hm, it's not that big of a deal, I'll go fix that up by hand...

But that explains why it is included here.

thanks,

greg k-h
