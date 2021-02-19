Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F38D31FD52
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 17:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhBSQmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 11:42:07 -0500
Received: from netrider.rowland.org ([192.131.102.5]:44803 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S230021AbhBSQmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 11:42:00 -0500
Received: (qmail 1115516 invoked by uid 1000); 19 Feb 2021 11:41:19 -0500
Date:   Fri, 19 Feb 2021 11:41:19 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        gregkh@linuxfoundation.org, dri-devel@lists.freedesktop.org,
        noralf@tronnes.org, Christoph Hellwig <hch@lst.de>,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Felipe Balbi <balbi@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
Message-ID: <20210219164119.GC1111829@rowland.harvard.edu>
References: <20210219134014.7775-1-tzimmermann@suse.de>
 <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>
 <20210219155328.GA1111829@rowland.harvard.edu>
 <d2d581fb-ccba-00c9-0a22-b485870256ae@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2d581fb-ccba-00c9-0a22-b485870256ae@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 19, 2021 at 04:56:16PM +0100, Christian König wrote:
> 
> 
> Am 19.02.21 um 16:53 schrieb Alan Stern:
> > On Fri, Feb 19, 2021 at 02:45:54PM +0100, Christian König wrote:
> > > Well as far as I can see this is a relative clear NAK.
> > > 
> > > When a device can't do DMA and has no DMA mask then why it is requesting an
> > > sg-table in the first place?
> > This may not be important for your discussion, but I'd like to give an
> > answer to the question -- at least, for the case of USB.
> > 
> > A USB device cannot do DMA and has no DMA mask.  Nevertheless, if you
> > want to send large amounts of bulk data to/from a USB device then using
> > an SG table is often a good way to do it.  The reason is simple: All
> > communication with a USB device has to go through a USB host controller,
> > and many (though not all) host controllers _can_ do DMA and _do_ have a
> > DMA mask.
> > 
> > The USB mass-storage and uas drivers in particular make heavy use of
> > this mechanism.
> 
> Yeah, I was assuming something like that would work.
> 
> But in this case the USB device should give the host controllers device
> structure to the dma_buf_attach function so that the sg_table can be filled
> in with DMA addresses properly.

Indeed.  Although in the contexts I'm familiar with, the host controller 
device is actually passed to routines like dma_pool_create, 
dma_alloc_coherent, dma_map_sg, or dma_map_single.

Alan Stern
