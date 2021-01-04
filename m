Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A688D2E93D5
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 12:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbhADLBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 06:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbhADLBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 06:01:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D185E207BC;
        Mon,  4 Jan 2021 11:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609758067;
        bh=FQj1a4rL7iltwr5MqltKp3e514hPbhBndFEkl5LtX3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cy5n5Pj/MdtkAB+OCBYxr9O9TzdNMSCOoD/SphCZZnso0dbrt6j6KkAIWECtvOpZ3
         mefMbVXMCQ0Z1o1X17FUcQ2t+wmyXl/i0O+5EbO7c8eAUUbMmwYXQwhWuL2ekE+CsA
         wghPhcvMtDfBB3n4/W6iOFUQrw3Mu+D7/RxsL458=
Date:   Mon, 4 Jan 2021 12:02:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor.Ambarus@microchip.com
Cc:     pavel@ucw.cz, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, vkoul@kernel.org,
        Ludovic.Desroches@microchip.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
Message-ID: <X/L1yZgmni6KHsrL@kroah.com>
References: <20200920082838.GA813@amd>
 <80065eac-7dce-aadf-51ef-9a290973b9ec@microchip.com>
 <d3a6fa19-0852-92d9-c434-40297edc625a@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3a6fa19-0852-92d9-c434-40297edc625a@microchip.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 08:19:18AM +0000, Tudor.Ambarus@microchip.com wrote:
> On 9/23/20 11:13 AM, Tudor.Ambarus@microchip.com wrote:
> > Hi, Pavel,
> > 
> > On 9/20/20 11:28 AM, Pavel Machek wrote:
> >> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >>
> >> This fixes memory leak in at_hdmac. Mainline does not have the same
> >> problem.
> >>
> >> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> >>
> >> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> >> index 86427f6ba78c..0847b2055857 100644
> >> --- a/drivers/dma/at_hdmac.c
> >> +++ b/drivers/dma/at_hdmac.c
> >> @@ -1714,8 +1714,10 @@ static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
> >>         atslave->dma_dev = &dmac_pdev->dev;
> >>
> >>         chan = dma_request_channel(mask, at_dma_filter, atslave);
> >> -       if (!chan)
> >> +       if (!chan) {
> >> +               kfree(atslave);
> >>                 return NULL;
> >> +       }
> > 
> > Thanks for submitting this to stable. While the fix is good, you can instead
> > cherry-pick the commit that hit upstream. In order to do that cleanly on top
> > of v4.19.145, you have to pick two other fixes:
> > 
> > commit a6e7f19c9100 ("dmaengine: at_hdmac: Substitute kzalloc with kmalloc")
> > commit 3832b78b3ec2 ("dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()")
> > commit a6e7f19c9100 ("dmaengine: at_hdmac: Substitute kzalloc with kmalloc")
> 
> this last commit should have been
> commit e097eb7473d9 ("dmaengine: at_hdmac: add missing kfree() call in at_dma_xlate()")
> 
> bad copy and paste :)

So are all 3 of those needed on both 5.4.y and 4.19.y to resolve this
issue?

thanks,

greg k-h
