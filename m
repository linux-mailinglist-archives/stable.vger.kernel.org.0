Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA9440D58D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 11:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbhIPJJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 05:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235114AbhIPJJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 05:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCFD060F93;
        Thu, 16 Sep 2021 09:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631783302;
        bh=ZrcY/TjOWX22TTNe924WKtenUn4hAI0AkltICMafb4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bd+Mu7kqg3XZwMGi661qCXVahwFWaTkLlu35HA8fOsiQaXpGV8ZTQvP9FcgKf2hOk
         leEPnUiNyg8N+HAj8vG0GPq0z5nWy4k6gMWj8kuWtNoZU3toYXKJhGvkqDXZSY6WUo
         /FHa+MENLeSWIGvFmSVjevjJMRrCWwzn0vfKxi5E=
Date:   Thu, 16 Sep 2021 11:08:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     stable@vger.kernel.org, David Miller <davem@davemloft.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        stable-commits@vger.kernel.org
Subject: Re: Patch "wwan: core: Fix missing RTM_NEWLINK event for default
 link" has been added to the 5.14-stable tree
Message-ID: <YUMJgwCp6Mn9e0US@kroah.com>
References: <16317104197115@kroah.com>
 <CAHNKnsRRaXzuoiyibMiF9brhhmNJCMKMOxY6K7rcwzQr8M8Htw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHNKnsRRaXzuoiyibMiF9brhhmNJCMKMOxY6K7rcwzQr8M8Htw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 01:54:11AM +0300, Sergey Ryazanov wrote:
> Hello Greg,
> 
> looks like the commit 8cc236db1a91 ("wwan: core: Fix missing
> RTM_NEWLINK event for default link") already included in v5.14, see
> details below the patch.
> 
> On Wed, Sep 15, 2021 at 3:54 PM <gregkh@linuxfoundation.org> wrote:
> > This is a note to let you know that I've just added the patch titled
> >
> >     wwan: core: Fix missing RTM_NEWLINK event for default link
> >
> > to the 5.14-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      wwan-core-fix-missing-rtm_newlink-event-for-default-link.patch
> > and it can be found in the queue-5.14 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> >
> >
> > From 8cc236db1a91d0c91651595ba75942a583008455 Mon Sep 17 00:00:00 2001
> > From: Loic Poulain <loic.poulain@linaro.org>
> > Date: Thu, 22 Jul 2021 20:21:05 +0200
> > Subject: wwan: core: Fix missing RTM_NEWLINK event for default link
> >
> > From: Loic Poulain <loic.poulain@linaro.org>
> >
> > commit 8cc236db1a91d0c91651595ba75942a583008455 upstream.
> >
> > A wwan link created via the wwan_create_default_link procedure is
> > never notified to the user (RTM_NEWLINK), causing issues with user
> > tools relying on such event to track network links (NetworkManager).
> >
> > This is because the procedure misses a call to rtnl_configure_link(),
> > which sets the link as initialized and notifies the new link (cf
> > proper usage in __rtnl_newlink()).
> >
> > Cc: stable@vger.kernel.org
> > Fixes: ca374290aaad ("wwan: core: support default netdev creation")
> > Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/net/wwan/wwan_core.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > --- a/drivers/net/wwan/wwan_core.c
> > +++ b/drivers/net/wwan/wwan_core.c
> > @@ -990,6 +990,8 @@ static void wwan_create_default_link(str
> >
> >         rtnl_configure_link(dev, NULL); /* Link initialized, notify new link */
> >
> > +       rtnl_configure_link(dev, NULL); /* Link initialized, notify new link */
> > +
> >  unlock:
> >         rtnl_unlock();
> 
> This change will duplicate the notification call. Fix already in v5.14:
> 
> $ git log --oneline v5.14 -- drivers/net/wwan/wwan_core.c
> d9d5b8961284 wwan: core: Avoid returning NULL from wwan_create_dev()
> 68d1f1d4af18 wwan: core: Fix missing RTM_NEWLINK event for default link

Ah, thanks for this.  It ended up going into Linus's tree with two
different commit ids.

I'll go drop it now.

greg k-h
