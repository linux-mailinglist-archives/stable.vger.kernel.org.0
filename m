Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DFB322E31
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 17:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhBWQBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 11:01:38 -0500
Received: from netrider.rowland.org ([192.131.102.5]:55785 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S233325AbhBWQBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 11:01:37 -0500
Received: (qmail 1264176 invoked by uid 1000); 23 Feb 2021 11:00:54 -0500
Date:   Tue, 23 Feb 2021 11:00:54 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Takashi Iwai <tiwai@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        airlied@linux.ie, gregkh@linuxfoundation.org,
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
Message-ID: <20210223160054.GC1261797@rowland.harvard.edu>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <s5hh7m2vqyd.wl-tiwai@suse.de>
 <f4452070-bab1-35ad-69aa-d020a4a3a5b7@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4452070-bab1-35ad-69aa-d020a4a3a5b7@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 03:06:07PM +0100, Thomas Zimmermann wrote:
> Hi
> 
> Am 23.02.21 um 14:44 schrieb Takashi Iwai:

> > Aside from the discussion whether this "workaround" is needed, the use
> > of udev->bus->controller here looks a bit suspicious.  As the old USB
> > code (before the commit 6eb0233ec2d0) indicated, it was rather
> > usb->bus->sysdev that was used for the DMA mask, and it's also the one
> > most of USB core code refers to.  A similar question came up while
> > fixing the same kind of bug in the media subsystem, and we concluded
> > that bus->sysdev is a better choice.
> 
> Good to hear that we're not the only ones affected by this. Wrt the original
> code, using sysdev makes even more sense.

Hmmm, I had forgotten about this.  So DMA masks aren't inherited after 
all, thanks to commit 6eb0233ec2d0.  That leas me to wonder how well 
usb-storage is really working these days...

The impression I get is that Greg would like the USB core to export a 
function which takes struct usb_interface * as argument and returns the 
appropriate DMA mask value.  Then instead of messing around with USB 
internals, drm_gem_prime_import_usb could just call this new function.

Adding such a utility function would be a sufficiently small change that 
it could go into the -stable kernels with no trouble.

Alan Stern
