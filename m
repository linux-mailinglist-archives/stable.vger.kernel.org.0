Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB6432AEEC
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbhCCAIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1577844AbhCBJ5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 04:57:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBA8764E56;
        Tue,  2 Mar 2021 09:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614678980;
        bh=bG3XD02DL4MaCW2XI6leEjvU1W3wPrk7Lzd9ASOAZvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gE5a2K0/Ko05cgGWq2RR9ypqqxknulsWNKb1MLRxvN+hrzShatu8xOAwBwgsS53rG
         AWg0XvjGWV9Nem+Ic7WCw91l9mUafFFhnoW4ro82ENO6sy8Pi/Zd+3s4lfO7Xo4vVY
         g7uVObNi/MindPLHLebzrIVSiCLxLy9O9D/9S6Z4=
Date:   Tue, 2 Mar 2021 10:56:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        hdegoede@redhat.com, sean@poorly.run, noralf@tronnes.org,
        stern@rowland.harvard.edu, dri-devel@lists.freedesktop.org,
        Pavel Machek <pavel@ucw.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH v6] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <YD4Lwbcb9Q5Wv/Xc@kroah.com>
References: <20210301093127.11028-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210301093127.11028-1-tzimmermann@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 10:31:27AM +0100, Thomas Zimmermann wrote:
> USB devices cannot perform DMA and hence have no dma_mask set in their
> device structure. Therefore importing dmabuf into a USB-based driver
> fails, which breaks joining and mirroring of display in X11.
> 
> For USB devices, pick the associated USB controller as attachment device.
> This allows the DRM import helpers to perform the DMA setup. If the DMA
> controller does not support DMA transfers, we're out of luck and cannot
> import. Our current USB-based DRM drivers don't use DMA, so the actual
> DMA device is not important.
> 
> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> instance of struct drm_driver.
> 
> Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
> 
> v6:
> 	* implement workaround in DRM drivers and hold reference to
> 	  DMA device while USB device is in use
> 	* remove dev_is_usb() (Greg)
> 	* collapse USB helper into usb_intf_get_dma_device() (Alan)
> 	* integrate Daniel's TODO statement (Daniel)
> 	* fix typos (Greg)
> v5:
> 	* provide a helper for USB interfaces (Alan)
> 	* add FIXME item to documentation and TODO list (Daniel)
> v4:
> 	* implement workaround with USB helper functions (Greg)
> 	* use struct usb_device->bus->sysdev as DMA device (Takashi)
> v3:
> 	* drop gem_create_object
> 	* use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> v2:
> 	* move fix to importer side (Christian, Daniel)
> 	* update SHMEM and CMA helpers for new PRIME callbacks
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> Tested-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Christian König <christian.koenig@amd.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
