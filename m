Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770053237E8
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 08:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhBXH2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 02:28:06 -0500
Received: from verein.lst.de ([213.95.11.211]:36462 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233582AbhBXH2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 02:28:06 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6F25B68D0A; Wed, 24 Feb 2021 08:27:22 +0100 (CET)
Date:   Wed, 24 Feb 2021 08:27:22 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Takashi Iwai <tiwai@suse.de>,
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
Message-ID: <20210224072722.GA32481@lst.de>
References: <20210223105842.27011-1-tzimmermann@suse.de> <s5hh7m2vqyd.wl-tiwai@suse.de> <f4452070-bab1-35ad-69aa-d020a4a3a5b7@suse.de> <20210223160054.GC1261797@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223160054.GC1261797@rowland.harvard.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 11:00:54AM -0500, Alan Stern wrote:
> The impression I get is that Greg would like the USB core to export a 
> function which takes struct usb_interface * as argument and returns the 
> appropriate DMA mask value.  Then instead of messing around with USB 
> internals, drm_gem_prime_import_usb could just call this new function.
> 
> Adding such a utility function would be a sufficiently small change that 
> it could go into the -stable kernels with no trouble.

The DMA mask value on its own is not useful.  It needs to be paired with
a device that the dma API functions can be called on.
