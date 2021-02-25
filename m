Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B2432535E
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 17:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBYQTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 11:19:43 -0500
Received: from netrider.rowland.org ([192.131.102.5]:47771 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S233397AbhBYQT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 11:19:29 -0500
Received: (qmail 1352732 invoked by uid 1000); 25 Feb 2021 11:18:47 -0500
Date:   Thu, 25 Feb 2021 11:18:47 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>, airlied@linux.ie,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        christian.koenig@amd.com, hdegoede@redhat.com,
        dri-devel@lists.freedesktop.org, sean@poorly.run,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <20210225161847.GB1350993@rowland.harvard.edu>
References: <20210224092304.29932-1-tzimmermann@suse.de>
 <20210224152153.GA1307460@rowland.harvard.edu>
 <b44307cf-25f9-acd0-eb35-92e8716205de@suse.de>
 <s5h1rd4sgie.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h1rd4sgie.wl-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 09:23:05AM +0100, Takashi Iwai wrote:
> On Thu, 25 Feb 2021 08:57:14 +0100,
> Thomas Zimmermann wrote:
> > 
> > Hi
> > 
> > Am 24.02.21 um 16:21 schrieb Alan Stern:
> > > On Wed, Feb 24, 2021 at 10:23:04AM +0100, Thomas Zimmermann wrote:
> > >> USB devices cannot perform DMA and hence have no dma_mask set in their
> > >> device structure. Therefore importing dmabuf into a USB-based driver
> > >> fails, which breaks joining and mirroring of display in X11.
> > >>
> > >> For USB devices, pick the associated USB controller as attachment device.
> > >> This allows the DRM import helpers to perform the DMA setup. If the DMA
> > >> controller does not support DMA transfers, we're out of luck and cannot
> > >> import. Our current USB-based DRM drivers don't use DMA, so the actual
> > >> DMA device is not important.
> > >>
> > >> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> > >> instance of struct drm_driver.
> > >>
> > >> Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
> > >>
> > >> v4:
> > >> 	* implement workaround with USB helper functions (Greg)
> > >> 	* use struct usb_device->bus->sysdev as DMA device (Takashi)
> > >> v3:
> > >> 	* drop gem_create_object
> > >> 	* use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> > >> v2:
> > >> 	* move fix to importer side (Christian, Daniel)
> > >> 	* update SHMEM and CMA helpers for new PRIME callbacks
> > >>
> > >> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > >> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> > >> Cc: Christoph Hellwig <hch@lst.de>
> > >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >> Cc: <stable@vger.kernel.org> # v5.10+
> > >> ---
> > >
> > >> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> > >> +						struct dma_buf *dma_buf)
> > >> +{
> > >> +	struct usb_device *udev;
> > >> +	struct device *dmadev;
> > >> +	struct drm_gem_object *obj;
> > >> +
> > >> +	if (!dev_is_usb(dev->dev))
> > >> +		return ERR_PTR(-ENODEV);
> > >> +	udev = interface_to_usbdev(to_usb_interface(dev->dev));
> > >> +
> > >> +	dmadev = usb_get_dma_device(udev);
> > >
> > > You can do it this way if you want, but I think usb_get_dma_device would
> > > be easier to use if its argument was a pointer to struct usb_interface
> > > or (even better) a pointer to a usb_interface's embedded struct device.
> > > Then you wouldn't need to compute udev, and the same would be true for
> > > other callers.
> > 
> > It seemed natural to me to use usb_device, because it contains the bus
> > pointer. But maybe a little wrapper for usb_interface in the header
> > file makes things easier to read. I'll wait a bit for other reviews to
> > come in.
> 
> I agree with Thomas, as most of users referring to the sysdev do
> access in a pattern like udev->bus->sysdev, AFAIK.

Apart from the USB core and host/gadget controller drivers, there 
appears to be only one reference to sysdev for a USB device: the one in 
usb-storage (and that one really should be dmadev).

In general, I expect callers of the new routine would be drivers that 
bind to a USB interface (like usb-storage), not to a USB device.  So 
they would naturally have the interface pointer handy.

But the routine could be written in a different way.  If it took a 
pointer to struct device as its argument, it could easily tell whether 
that structure was embedded in a usb_device or a usb_interface 
struct, and do the right thing either way.

Or there could be two routines: one taking a usb_device pointer and one 
taking a usb_interface pointer.

The idea here is to make the routine as easy as possible for callers.  
If this means making the routine a little longer, that's okay -- there's 
only one copy of the routine but there could be lots of callers.

Alan Stern
