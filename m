Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233631A4F90
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 13:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgDKLk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 07:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgDKLk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 07:40:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D65CD20673;
        Sat, 11 Apr 2020 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586605254;
        bh=0hqthX4ZQuVKvIIygQ1q8gib8slwFI0Ft6NypT/lDe4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jp4xlb+HBnHTfbPbu1owXKye5X383kgiOc3QR26yzujt2bAoDJeiKRzpoR1CyZWH7
         l8ru6x/rOgqs6tCYxPIpKOi5PM/6JQ+uvwpcxjpA35pXgxfLJJmE4r+EzKOTrXteQV
         VN7hnMZMW7sTSkDVsJQULlgNo0moNFBEJ+AWZsi0=
Date:   Sat, 11 Apr 2020 13:40:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.6 14/68] driver core: Reevaluate
 dev->links.need_for_probe as suppliers are added
Message-ID: <20200411114052.GC2606747@kroah.com>
References: <20200410034634.7731-1-sashal@kernel.org>
 <20200410034634.7731-14-sashal@kernel.org>
 <20200410062931.GD1663372@kroah.com>
 <CAGETcx9Kp6JvuyF770XKsMTCY6=rC2zuBTG07oB18bya0owgWw@mail.gmail.com>
 <20200410065227.GA1665508@kroah.com>
 <CAGETcx8RBjr6rzR7=m6LuA=OQOT2Hh4ioPndUP8mkpYLve+6yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8RBjr6rzR7=m6LuA=OQOT2Hh4ioPndUP8mkpYLve+6yw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 10, 2020 at 09:25:51AM -0700, Saravana Kannan wrote:
> On Thu, Apr 9, 2020 at 11:52 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Apr 09, 2020 at 11:39:55PM -0700, Saravana Kannan wrote:
> > > On Thu, Apr 9, 2020 at 11:29 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Thu, Apr 09, 2020 at 11:45:39PM -0400, Sasha Levin wrote:
> > > > > From: Saravana Kannan <saravanak@google.com>
> > > > >
> > > > > [ Upstream commit 1745d299af5b373abad08fa29bff0d31dc6aff21 ]
> > > > >
> > > > > A previous patch 03324507e66c ("driver core: Allow
> > > > > fwnode_operations.add_links to differentiate errors") forgot to update
> > > > > all call sites to fwnode_operations.add_links. This patch fixes that.
> > > > >
> > > > > Legend:
> > > > > -> Denotes RHS is an optional/potential supplier for LHS
> > > > > => Denotes RHS is a mandatory supplier for LHS
> > > > >
> > > > > Example:
> > > > >
> > > > > Device A => Device X
> > > > > Device A -> Device Y
> > > > >
> > > > > Before this patch:
> > > > > 1. Device A is added.
> > > > > 2. Device A is marked as waiting for mandatory suppliers
> > > > > 3. Device X is added
> > > > > 4. Device A is left marked as waiting for mandatory suppliers
> > > > >
> > > > > Step 4 is wrong since all mandatory suppliers of Device A have been
> > > > > added.
> > > > >
> > > > > After this patch:
> > > > > 1. Device A is added.
> > > > > 2. Device A is marked as waiting for mandatory suppliers
> > > > > 3. Device X is added
> > > > > 4. Device A is no longer considered as waiting for mandatory suppliers
> > > > >
> > > > > This is the correct behavior.
> > > > >
> > > > > Fixes: 03324507e66c ("driver core: Allow fwnode_operations.add_links to differentiate errors")
> > > > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > > > > Link: https://lore.kernel.org/r/20200222014038.180923-2-saravanak@google.com
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > > >  drivers/base/core.c | 8 ++++++--
> > > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > > > > index dbb0f9130f42d..d32a3aefff32f 100644
> > > > > --- a/drivers/base/core.c
> > > > > +++ b/drivers/base/core.c
> > > > > @@ -523,9 +523,13 @@ static void device_link_add_missing_supplier_links(void)
> > > > >
> > > > >       mutex_lock(&wfs_lock);
> > > > >       list_for_each_entry_safe(dev, tmp, &wait_for_suppliers,
> > > > > -                              links.needs_suppliers)
> > > > > -             if (!fwnode_call_int_op(dev->fwnode, add_links, dev))
> > > > > +                              links.needs_suppliers) {
> > > > > +             int ret = fwnode_call_int_op(dev->fwnode, add_links, dev);
> > > > > +             if (!ret)
> > > > >                       list_del_init(&dev->links.needs_suppliers);
> > > > > +             else if (ret != -ENODEV)
> > > > > +                     dev->links.need_for_probe = false;
> > > > > +     }
> > > > >       mutex_unlock(&wfs_lock);
> > > > >  }
> > > >
> > > > For some reason this wasn't for stable kernels, but I can't remember.
> > >
> > > It *is* for stable kernels too. It is an actual bug that's fixable in
> > > stable kernels. I think this might have been the one patch that I
> > > bundled into an unrelated series, but called it out as an unrelated
> > > bug. Maybe my wording in that email threw you off?
> >
> > I think it did, sorry.  So no problem adding this to the stable trees so
> > I can go add it right now?
> 
> Yes, please do.

Thanks, now queued up.

greg k-h
