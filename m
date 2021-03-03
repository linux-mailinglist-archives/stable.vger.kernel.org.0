Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D30732C80C
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhCDAdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242128AbhCCNwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 08:52:10 -0500
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1592CC06178A
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 05:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tronnes.org
        ; s=ds202012; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ufZ6a7L3pPkoSKdOl6MYUEDajN3hR4/+EwZf1uJ3iZ4=; b=keU4KEuZLWbJBigK/vQdYWMRzo
        l5RzuNnmBmAVUx+zhtZTOYn8nUWPJLIwaim4EzrLAn2gmf9FiQ3CBsEFl6wUMsNTKNJKOk6qnHlsw
        oZB2trUrKJlQDvDhtb9OslR/UTsAAZi/IqjhHdihN1ZyBKtIsnwBbu4M2zH2PG7A/8yPBwkt8mE5f
        nsp89trYdks9EXPIjPQGJ6DA48u/79sVqxgFzE+6tT+rjy0ANL69dh0sjVVSsiYESCXP3U5Cmrixn
        E2AyrnH6rtHNpFxp2Z1I98eipYP8T+42l6ahum0yCdn05VFw/xAMN1RsTgPhlUzL2FkGQwBj+8y9o
        U0b8S2tw==;
Received: from 211.81-166-168.customer.lyse.net ([81.166.168.211]:65356 helo=[192.168.10.61])
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <noralf@tronnes.org>)
        id 1lHRr1-00068F-CX; Wed, 03 Mar 2021 14:47:55 +0100
Subject: Re: [PATCH v8] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        christian.koenig@amd.com, gregkh@linuxfoundation.org,
        hdegoede@redhat.com, sean@poorly.run, stern@rowland.harvard.edu,
        dan.carpenter@oracle.com
Cc:     dri-devel@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20210303133229.3288-1-tzimmermann@suse.de>
From:   =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>
Message-ID: <fcf3faa6-f742-9b73-17a1-5ad6ead76a02@tronnes.org>
Date:   Wed, 3 Mar 2021 14:47:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210303133229.3288-1-tzimmermann@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Den 03.03.2021 14.32, skrev Thomas Zimmermann:
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
> Tested by joining/mirroring displays of udl and radeon under Gnome/X11.
> 
> v8:
> 	* release dmadev if device initialization fails (Noralf)
> 	* fix commit description (Noralf)
> v7:
> 	* fix use-before-init bug in gm12u320 (Dan)
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
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Christian König <christian.koenig@amd.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> ---

Acked-by: Noralf Trønnes <noralf@tronnes.org>
