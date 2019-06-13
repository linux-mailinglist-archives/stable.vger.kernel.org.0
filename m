Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E2744418
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731707AbfFMQet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:34:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730749AbfFMHs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 03:48:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D55DD20851;
        Thu, 13 Jun 2019 07:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560412137;
        bh=4oibSd/hOVJ9jNfjNkvQoKaJ6NBnt6A6nhhP+JTFih0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xbmtwmg5PhGIlI/T/RZiXJ3dDJN4Sagw78LSlDhMD4llh0ZiBhHlc/60rA9oZ2H6d
         W08M5cGpgnMUOdxVutY/x9No1x9W73N1gIY0AXxvAETr9SI3KZT95wvVWO5mM9RjQM
         naL/IeZmsJj5WjIbZJiLJEzncJ9HCZz0MAjkfILU=
Date:   Thu, 13 Jun 2019 09:48:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: Patch "ovl: fix missing upper fs freeze protection on copy up
 for ioctl" has been added to the 4.19-stable tree
Message-ID: <20190613074854.GC19685@kroah.com>
References: <1558603746191117@kroah.com>
 <CAOQ4uxip8H45S-UmWhNowv9sQUTYzcDMVCZxw=6AvFN-4c1Uvw@mail.gmail.com>
 <20190523195741.GA4436@kroah.com>
 <CAOQ4uxjKKJduAkomNHxo=T1i4-FVUJ_JABkXfpjz2qt=DAHTZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjKKJduAkomNHxo=T1i4-FVUJ_JABkXfpjz2qt=DAHTZA@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 11:28:46PM +0300, Amir Goldstein wrote:
> > > This patch is fine for stable, but I have a process question.
> > > All these patches from overlayfs 5.2-rc1 are also v4.9 stable candidates:
> > >
> > > 1. acf3062a7e1c - ovl: relax WARN_ON() for overlapping layers use case
> > > 2. 98487de318a6 - ovl: check the capability before cred overridden
> > > 3. d989903058a8 - ovl: do not generate duplicate fsnotify events for "fake" path
> > > 4. 9e46b840c705 - ovl: support stacked SEEK_HOLE/SEEK_DATA
> > >
> > > #2 wasn't properly marked for stable, but the other are marked with
> > > Fixes: and Reported-by:
> > >
> > > Are those marks not sufficient to get selected for stable trees these days?
> >
> > Not by default, no.  Sometimes they might get picked up if we get bored,
> > or the auto-bot notices them.
> >
> > > I must admit that #1 in borderline stable. Not sure if eliminating an unjust
> > > WARN_ON qualified, but syzbot did report a bug..
> >
> > syzbot things are good to fix in stable kernels, so that syzbot can
> > continue to find real things in stable kernels.  So yes, that is fine to
> > backport.
> >
> > > Just asking in order to improve the process, but in any case,
> > > please pick those patches for v4.9+ (unless anyone objects?)
> > > They all already have LTP/xfstests/syzkaller tests that cover them.
> >
> > I'll queue them up for the next round after this, thanks.
> >
> 
> Hi Greg,
> 
> I forgot to follow up on those patches.
> Now I look at linux-4.19.y, I only see patch #1 (ovl: relax WARN_ON()..)
> and not the 3 other patches I listed as stable candidates.
> Was there any issue with those patches?

Sorry, didn't get to them.

I did now, and they all do not apply to all kernel versions.  Most of
them do not go back to 4.14 or 4.9 as the code just isn't there.

So, after this next round of kernel releases, can you send backported
versions of any missing patches so that we are sure to apply them
correctly?

thanks,

greg k-h
