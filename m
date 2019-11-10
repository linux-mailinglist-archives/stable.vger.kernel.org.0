Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990D9F69BC
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 16:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfKJPeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 10:34:04 -0500
Received: from netrider.rowland.org ([192.131.102.5]:46501 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726684AbfKJPeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 10:34:03 -0500
Received: (qmail 29471 invoked by uid 500); 10 Nov 2019 10:34:02 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 10 Nov 2019 10:34:02 -0500
Date:   Sun, 10 Nov 2019 10:34:02 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     Oliver Neukum <oneukum@suse.com>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.19 114/149] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
In-Reply-To: <1573396023.2662.4.camel@suse.com>
Message-ID: <Pine.LNX.4.44L0.1911101028430.29192-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 10 Nov 2019, Oliver Neukum wrote:

> Am Freitag, den 08.11.2019, 10:35 -0500 schrieb Alan Stern:
> > On Fri, 8 Nov 2019, Greg Kroah-Hartman wrote:
> > 
> > > On Thu, Nov 07, 2019 at 12:32:45PM +0100, Oliver Neukum wrote:
> > > > Am Dienstag, den 05.11.2019, 17:38 +0100 schrieb Greg Kroah-Hartman:
> > > > > > > Given this information, perhaps you will decide that the revert is 
> > > > > > > worthwhile.
> > > > > > 
> > > > > > Damned if I do, damned if I do not.
> > > > > > Check for usbip and special case it?
> > > > > 
> > > > > We should be able to do that in the host controller driver for usbip,
> > > > > right?  What is the symptom if you use a UAS device with usbip and this
> > > > > commit?
> > > > 
> > > > Yes, that patch should then also be applied. Then it will work.
> > > > Without it, commands will fail, as transfers will end prematurely.
> > > 
> > > Ok, I'm confused now.  I just checked, and I really have no idea what
> > > needs to be backported anymore.  3ae62a42090f ("UAS: fix alignment of
> > > scatter/gather segments") was backported to all of the stable kernels,
> > > and now we reverted it.
> > > 
> > > So what else needs to be done here?
> > 
> > In one sense, nothing needs to be done.  3ae62a42090f was intended to
> > fix a long-standing problem with USBIP, but people reported a
> 
> OK, now I am a bit confused. AFAICT 3ae62a42090f actually did fix the
> issue. So if you simply revert it, the issue will reappear.

Correct.  I think.

> > regression in performance.  (Admittedly, the report was about the
> > correponding change to usb-storage, not the change to uas, but it's
> > reasonable to think the effect would be the same.)  So in line with the
> 
> Yes.
> 
> > no-regressions policy, we only need to revert the commit -- which you 
> > have already done.
> 
> But that breaks UAS over USBIP, doesn't it?

It was already broken to start with.  The attempted fix caused a
regression, so the fix must be reverted.

> > On the other hand, the long-standing problem in USBIP can be fixed by
> > back-porting commit ea44d190764b.  But since that commit isn't a
> > bug-fix (and since it's rather large), you may question whether it is
> > appropriate for the -stable kernel series.
> 
> It certainly is large. But without it UAS won't work over USBIP, will
> it? I think that is the central question we need to answer here.

You are right.  If Greg is okay with porting ea44d190764b to the stable 
kernels, I won't object.

Alan Stern

