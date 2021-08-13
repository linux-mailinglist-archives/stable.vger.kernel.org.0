Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53343EB455
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 13:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbhHMLDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 07:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:32902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239145AbhHMLDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 07:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 723C360E78;
        Fri, 13 Aug 2021 11:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628852566;
        bh=4jX0ZBL163ha/Viu6f+bGzDg7RCQSwgVkHF7VTiUdOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=InH3OMHSUQkOAwE2VhoLr3tCt2SdnCT94hQszDWJ4tvbhnMgR2gDPd1/zYpl3Cncu
         FECFSlETfkKqHXsIRdBRdNkXx2yKATDwO+VxAsBMk8WyBrd7bcbplUbA0lpGsANsbp
         hRlgC/sZW8cYSFElQ5kEz/5r9Ciw18LAc/raRd1s=
Date:   Fri, 13 Aug 2021 13:02:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jason@jlekstrand.net,
        Jonathan Gray <jsg@jsg.id.au>
Subject: Re: Determining corresponding mainline patch for stable patches Re:
 [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Message-ID: <YRZRU4JIh5LQjDfE@kroah.com>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.050147269@linuxfoundation.org>
 <20210811072843.GC10829@duo.ucw.cz>
 <YROARN2fMPzhFMNg@kroah.com>
 <20210811122702.GA8045@duo.ucw.cz>
 <YRPLbV+Dq2xTnv2e@kroah.com>
 <20210813093104.GA20799@duo.ucw.cz>
 <20210813095429.GA21912@1wt.eu>
 <20210813102429.GA28610@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813102429.GA28610@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 12:24:29PM +0200, Pavel Machek wrote:
> On Fri 2021-08-13 11:54:29, Willy Tarreau wrote:
> > Hi Pavel,
> > 
> > On Fri, Aug 13, 2021 at 11:31:04AM +0200, Pavel Machek wrote:
> > > > > If we could agree on
> > > > > 
> > > > > Commit: (SHA)
> > > > > 
> > > > > in the beggining of body, that would be great.
> > > > > 
> > > > > Upstream: (SHA)
> > > > > 
> > > > > in sign-off area would be even better.
> > > > 
> > > > What exactly are you trying to do when you find a sha1?  For some reason
> > > > my scripts work just fine with a semi-free-form way that we currently
> > > > have been doing this for the past 17+ years.  What are you attempting to
> > > > do that requires such a fixed format?
> > > 
> > > Is there any problem having a fixed format? You are producing -stable
> > > kernels, so you are not the one needing such functionality.
> > 
> > When I was doing extended LTS in the past, I used to restart from
> > Greg's closest branch (e.g. 4.4.y for latest 3.10.y) and needed
> > exactly that. It was pretty easy in the end, as you'll essentially
> > find two formats (one form from net and the other for the rest of
> > the patches):
> > 
> >   - commit XXXX upstream
> >   - [ Upstream commit XXXX ]
> > 
> > I ended up writing this trivial script that did the job well for me
> > and also supported the "git cherry-pick -x" format that I was using
> > a lot. Feel free to reuse that as a starting point, here it comes, a
> > bit covered in dust :-)
> 
> Please see previous discussion. Yes, I have my regexps, too, but there
> are variations, and there were even false positives.. One of them is
> in this email thread.
> 
> Greg suggests to simply ignore context and look for SHA1 sum; that
> does not work, either.

The number of patches that your regex does not work on is a very tiny %,
right?  Can't you just handle those "by hand"?

> So what I'm asking is for single, easy to parse format. I don't quite
> care what it is, but

As long as people end up sending us patches as backports, they will get
the format wrong in odd ways over time.  Heck, we can't even all get a
simple signed-off-by: right all the time, look at the kernel logs for
loads of issues where long-time developers mess that one up.

The phrase "perfect is the enemy of good" or something like that applies
here.  I'm giving you backported patches "for free", the number of ones
that someone messes up the text on is so small it should be lost in the
noise...

thanks,

greg k-h
