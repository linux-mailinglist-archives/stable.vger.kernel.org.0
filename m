Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1293A23DC
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 07:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhFJFY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 01:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230154AbhFJFY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 01:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72635613E1;
        Thu, 10 Jun 2021 05:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623302566;
        bh=kKp8oU7QwWVcxL3bQAssMPPgzG6/DfWTtdrYTafZCoc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R6Ye10hhufA/hdgGi3PrCWos3nqsMj0z2K+vp2phrtLj+tKIkHYnbxMRIjBcbcixv
         L2ZXSltM7yJcJFb8uo4Pf+jk3XqMH3DvP1qzY5W/o5ZXcF650En0iIfHsEslM3O6lQ
         FWSQycXuLbFhHSEKWkpbSS6I//mdskUeQgBj66PQ=
Date:   Thu, 10 Jun 2021 07:22:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pascal Giard <pascal.giard@etsmtl.ca>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Nguyen <daniel.nguyen.1@ens.etsmtl.ca>
Subject: Re: [PATCH] HID: sony: fix freeze when inserting ghlive ps3/wii
 dongles
Message-ID: <YMGhotmI1kHFe3gL@kroah.com>
References: <20210604161023.1498582-1-pascal.giard@etsmtl.ca>
 <YLsdEtbAWJxLB+GF@kroah.com>
 <CAJNNDmk7z=aJtx00C+8kpBOk0j_XVOk2fDMG9Xf9Na_ChXM2OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJNNDmk7z=aJtx00C+8kpBOk0j_XVOk2fDMG9Xf9Na_ChXM2OA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 08:25:47PM -0400, Pascal Giard wrote:
> On Sat, Jun 5, 2021 at 2:44 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jun 04, 2021 at 12:10:23PM -0400, Pascal Giard wrote:
> > > This commit fixes a freeze on insertion of a Guitar Hero Live PS3/WiiU
> > > USB dongle. Indeed, with the current implementation, inserting one of
> > > those USB dongles will lead to a hard freeze. I apologize for not
> > > catching this earlier, it didn't occur on my old laptop.
> > >
> > > While the issue was isolated to memory alloc/free, I could not figure
> > > out why it causes a freeze. So this patch fixes this issue by
> > > simplifying memory allocation and usage.
> > >
> > > We remind that for the dongle to work properly, a control URB needs to
> > > be sent periodically. We used to alloc/free the URB each time this URB
> > > needed to be sent.
> > >
> > > With this patch, the memory for the URB is allocated on the probe, reused
> > > for as long as the dongle is plugged in, and freed once the dongle is
> > > unplugged.
> > >
> > > Signed-off-by: Pascal Giard <pascal.giard@etsmtl.ca>
> > > ---
> > >  drivers/hid/hid-sony.c | 98 +++++++++++++++++++++---------------------
> > >  1 file changed, 49 insertions(+), 49 deletions(-)
> >
> > <formletter>
> >
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> >
> > </formletter>
> 
> Dear Greg,
> 
> I apologize for failing to follow the procedure. I had already read
> these guidelines, and I actually thought I was following Option 1 :-/

Is this commit already in Linus's tree?  If so then we just need a git
commit id and we can queue it up.

> I thought that I had to get my patch merged into next first (patch
> against dtor's git) and that by adding stable@ as CC, it would
> automatically get considered for inclusion into stable once merged
> into Linus' tree. Based on your email, I got that wrong...

It will, but you need to add that to the signed-off-by: area, as the
document says.

thanks,

greg k-h
