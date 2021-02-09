Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1183156E1
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 20:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhBITeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 14:34:44 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.25]:31997 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbhBIT0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 14:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1612898502;
        s=strato-dkim-0002; d=gerhold.net;
        h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
        From:Subject:Sender;
        bh=ZmZAnfRj41c4UrZDu7/hD09Z8UMuYv+IgTaKrMKlKNg=;
        b=lSbCVS0WuyKOyUVdK5UNfgvUCSup+Fz7JGxKHMmd6Ebja3KjLg2mw4S5CmZ7iF4olX
        Xyh4S/GhkpOgtDnlr6eeTr5ubw12NnCxTBj8SCVaiNeMg6a+rV2slAuUjl5XVZsM9WxJ
        WNqDKhpERP1ZTl/aKQVYZIyTKRD4NS2Ca0W31yMcjEGLwgER7GM7+fJIY6CQIpbq4vlD
        iXEsbAWWnm5iM7DErFe/qs26lr1JXkaDZDiREZ90GjRnWHv28MkLALKGanoYFBwQemdA
        CW3JQnwTwgRQRmmCAlFs5AJXhoJQPFkeTYHyXlY1/SLRy9/7G271XXfWIajRhZ1VOdi1
        N11A==
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j9Ic3ABg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
        by smtp.strato.de (RZmta 47.17.1 DYNA|AUTH)
        with ESMTPSA id d09c49x19J4G3Ww
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 9 Feb 2021 20:04:16 +0100 (CET)
Date:   Tue, 9 Feb 2021 20:04:10 +0100
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 4.14 07/15] driver core: Extend device_is_dependent()
Message-ID: <YCLcqvgEB6fVtWMx@gerhold.net>
References: <20210205140649.733510103@linuxfoundation.org>
 <20210205140650.022247260@linuxfoundation.org>
 <CAGETcx8q4WmpF1mT8uLHYQXnioDKFi0PL1wUuVOtCyCnvyvKhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8q4WmpF1mT8uLHYQXnioDKFi0PL1wUuVOtCyCnvyvKhg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 09:52:56AM -0800, Saravana Kannan wrote:
> On Fri, Feb 5, 2021 at 6:14 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> >
> > commit 3d1cf435e201d1fd63e4346b141881aed086effd upstream
> >
> > If the device passed as the target (second argument) to
> > device_is_dependent() is not completely registered (that is, it has
> > been initialized, but not added yet), but the parent pointer of it
> > is set, it may be missing from the list of the parent's children
> > and device_for_each_child() called by device_is_dependent() cannot
> > be relied on to catch that dependency.
> >
> > For this reason, modify device_is_dependent() to check the ancestors
> > of the target device by following its parent pointer in addition to
> > the device_for_each_child() walk.
> >
> > Fixes: 9ed9895370ae ("driver core: Functional dependencies tracking support")
> > Reported-by: Stephan Gerhold <stephan@gerhold.net>
> > Tested-by: Stephan Gerhold <stephan@gerhold.net>
> > Reviewed-by: Saravana Kannan <saravanak@google.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Link: https://lore.kernel.org/r/17705994.d592GUb2YH@kreacher
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/base/core.c |   17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -96,6 +96,16 @@ void device_links_read_unlock(int not_us
> >  }
> >  #endif /* !CONFIG_SRCU */
> >
> > +static bool device_is_ancestor(struct device *dev, struct device *target)
> > +{
> > +       while (target->parent) {
> > +               target = target->parent;
> > +               if (dev == target)
> > +                       return true;
> > +       }
> > +       return false;
> > +}
> > +
> >  /**
> >   * device_is_dependent - Check if one device depends on another one
> >   * @dev: Device to check dependencies for.
> > @@ -109,7 +119,12 @@ static int device_is_dependent(struct de
> >         struct device_link *link;
> >         int ret;
> >
> > -       if (dev == target)
> > +       /*
> > +        * The "ancestors" check is needed to catch the case when the target
> > +        * device has not been completely initialized yet and it is still
> > +        * missing from the list of children of its parent device.
> > +        */
> > +       if (dev == target || device_is_ancestor(dev, target))
> >                 return 1;
> >
> >         ret = device_for_each_child(dev, target, device_is_dependent);
> >
> >
> 
> I think 4.14 device links API is so busted it's not worth patching
> this. It's not a memory leak or any kind of security issue.
> 
> Stephan, are you seeing this issue in 4.14 or even care about it?
> 

I guess I'm too late here (sorry about this), but in any case:

Actually, the issue I had only caused problems in some of the early 5.11
release candidates. The cyclic device link was also created on earlier
kernel versions, but (seemingly) did not cause any issues so far.

I try to stay on RCs/stable kernel versions so as far as
I'm concerned there is no need to backport this to 4.14.

Thanks!
Stephan
