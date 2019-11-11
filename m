Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEFFF70E6
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 10:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfKKJgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 04:36:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbfKKJgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 04:36:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A8502075B;
        Mon, 11 Nov 2019 09:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573465001;
        bh=10fPEu9FZrhk6J1j7t879mqhJ3XB2/xSo4oLnUX/mUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cIXR3fs4XsjhXq1ExFdK/YS942Ly/v7iv6y3lZoG2sCdymoknCYpZodIN9yBO8sct
         n86fPGr6jHtPg5rt4BrMUoth0beZsKKi8leZs2pHOQi1NRoY29PB8hgv5jQ2DBBetL
         UsGekVUimWIBOrYqHjF7nJjxcGDxvm7GoPxs0sJU=
Date:   Mon, 11 Nov 2019 10:36:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.19 114/149] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
Message-ID: <20191111093638.GD4139389@kroah.com>
References: <1573396023.2662.4.camel@suse.com>
 <Pine.LNX.4.44L0.1911101028430.29192-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1911101028430.29192-100000@netrider.rowland.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 10, 2019 at 10:34:02AM -0500, Alan Stern wrote:
> On Sun, 10 Nov 2019, Oliver Neukum wrote:
> 
> > Am Freitag, den 08.11.2019, 10:35 -0500 schrieb Alan Stern:
> > > On Fri, 8 Nov 2019, Greg Kroah-Hartman wrote:
> > > 
> > > > On Thu, Nov 07, 2019 at 12:32:45PM +0100, Oliver Neukum wrote:
> > > > > Am Dienstag, den 05.11.2019, 17:38 +0100 schrieb Greg Kroah-Hartman:
> > > > > > > > Given this information, perhaps you will decide that the revert is 
> > > > > > > > worthwhile.
> > > > > > > 
> > > > > > > Damned if I do, damned if I do not.
> > > > > > > Check for usbip and special case it?
> > > > > > 
> > > > > > We should be able to do that in the host controller driver for usbip,
> > > > > > right?  What is the symptom if you use a UAS device with usbip and this
> > > > > > commit?
> > > > > 
> > > > > Yes, that patch should then also be applied. Then it will work.
> > > > > Without it, commands will fail, as transfers will end prematurely.
> > > > 
> > > > Ok, I'm confused now.  I just checked, and I really have no idea what
> > > > needs to be backported anymore.  3ae62a42090f ("UAS: fix alignment of
> > > > scatter/gather segments") was backported to all of the stable kernels,
> > > > and now we reverted it.
> > > > 
> > > > So what else needs to be done here?
> > > 
> > > In one sense, nothing needs to be done.  3ae62a42090f was intended to
> > > fix a long-standing problem with USBIP, but people reported a
> > 
> > OK, now I am a bit confused. AFAICT 3ae62a42090f actually did fix the
> > issue. So if you simply revert it, the issue will reappear.
> 
> Correct.  I think.
> 
> > > regression in performance.  (Admittedly, the report was about the
> > > correponding change to usb-storage, not the change to uas, but it's
> > > reasonable to think the effect would be the same.)  So in line with the
> > 
> > Yes.
> > 
> > > no-regressions policy, we only need to revert the commit -- which you 
> > > have already done.
> > 
> > But that breaks UAS over USBIP, doesn't it?
> 
> It was already broken to start with.  The attempted fix caused a
> regression, so the fix must be reverted.
> 
> > > On the other hand, the long-standing problem in USBIP can be fixed by
> > > back-porting commit ea44d190764b.  But since that commit isn't a
> > > bug-fix (and since it's rather large), you may question whether it is
> > > appropriate for the -stable kernel series.
> > 
> > It certainly is large. But without it UAS won't work over USBIP, will
> > it? I think that is the central question we need to answer here.
> 
> You are right.  If Greg is okay with porting ea44d190764b to the stable 
> kernels, I won't object.

Ok, I've backported this to 4.14.y, 4.19.y, and 5.3.y.  As superspeed
support was not added to vhci until the 4.13 release, I don't think that
UAS will be an issue on those older kernels.

thanks,

greg k-h
