Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB14B322FA2
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhBWRau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 12:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhBWRat (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 12:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B85C264E85;
        Tue, 23 Feb 2021 17:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614101408;
        bh=0sov8GotWsBDdlLayNbjA2epe830T2G9FtT8QS8zYxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UX492ZtzutLmQXcQymKcC+ZlGihNg9kUBARJmIwwfVTRXEuflcUwn/rpCL6vWAG8d
         rnt04Q6rCx8qCf5NsDLtGcY8i3eHPqVD3JGmm2w5F2cl84qYvRnmTCYV+LdpiddEnH
         BLFQAujOP0PZbTfpXu6XAsfMYWY6qd3GbFVnFmYk=
Date:   Tue, 23 Feb 2021 18:30:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Takashi Iwai <tiwai@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        airlied@linux.ie,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>, hdegoede@redhat.com,
        Christoph Hellwig <hch@lst.de>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        sean@poorly.run, christian.koenig@amd.com
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <YDU7naIDtg5IM0Sz@kroah.com>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <s5hh7m2vqyd.wl-tiwai@suse.de>
 <f4452070-bab1-35ad-69aa-d020a4a3a5b7@suse.de>
 <20210223160054.GC1261797@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223160054.GC1261797@rowland.harvard.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 11:00:54AM -0500, Alan Stern wrote:
> On Tue, Feb 23, 2021 at 03:06:07PM +0100, Thomas Zimmermann wrote:
> > Hi
> > 
> > Am 23.02.21 um 14:44 schrieb Takashi Iwai:
> 
> > > Aside from the discussion whether this "workaround" is needed, the use
> > > of udev->bus->controller here looks a bit suspicious.  As the old USB
> > > code (before the commit 6eb0233ec2d0) indicated, it was rather
> > > usb->bus->sysdev that was used for the DMA mask, and it's also the one
> > > most of USB core code refers to.  A similar question came up while
> > > fixing the same kind of bug in the media subsystem, and we concluded
> > > that bus->sysdev is a better choice.
> > 
> > Good to hear that we're not the only ones affected by this. Wrt the original
> > code, using sysdev makes even more sense.
> 
> Hmmm, I had forgotten about this.  So DMA masks aren't inherited after 
> all, thanks to commit 6eb0233ec2d0.  That leas me to wonder how well 
> usb-storage is really working these days...
> 
> The impression I get is that Greg would like the USB core to export a 
> function which takes struct usb_interface * as argument and returns the 
> appropriate DMA mask value.  Then instead of messing around with USB 
> internals, drm_gem_prime_import_usb could just call this new function.
> 
> Adding such a utility function would be a sufficiently small change that 
> it could go into the -stable kernels with no trouble.

Yes, sorry for not being clear, that is what I think would make the most
sense, then all USB drivers could use it easily and it can be changed in
one location if the DMA logic ever changes.

thanks,

greg k-h
