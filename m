Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB16E481180
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 11:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbhL2KFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 05:05:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53294 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234598AbhL2KFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 05:05:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94C9FB8186A;
        Wed, 29 Dec 2021 10:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4A9C36AE7;
        Wed, 29 Dec 2021 10:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640772300;
        bh=P5j26ZheYSQJLe6wZTMum1QTgdT4WQ9w8+X2KjDuy1Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pguocNoq9o0z/Mj6GMg9Jdyo87Gx5e7F1YY+Z6bck41R/WPPgVafeMW58I/Tzqqo3
         kjZChoqwaMOfNo8/0usDoiFWj4sJaBKTG0QxSvgDJx5EIFqeQ0hAlNPTeLW4Q8jskY
         dyKjYP2EH/1oJLvAtNv+S27iHaIP3TOHzDqc5q30=
Date:   Wed, 29 Dec 2021 11:04:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Kay Sievers <kay.sievers@novell.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] driver core: Fix driver_sysfs_remove() order in
 really_probe()
Message-ID: <YcwyyXuqJ3QVevYW@kroah.com>
References: <20211229045159.1731943-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229045159.1731943-1-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 29, 2021 at 12:51:59PM +0800, Lu Baolu wrote:
> The driver_sysfs_remove() should always be called after successful
> driver_sysfs_add(). Otherwise, NULL pointers will be passed to the
> sysfs_remove_link(), where it is decoded as searching sysfs root.

What null pointer is being sent to sysfs_remove_link()?  For which link?

How are you triggering this failure path and how was it tested?

> 
> Fixes: 1901fb2604fbc ("Driver core: fix "driver" symlink timing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/base/dd.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 68ea1f949daa..9eaaff2f556c 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -577,14 +577,14 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  	if (dev->bus->dma_configure) {
>  		ret = dev->bus->dma_configure(dev);
>  		if (ret)
> -			goto probe_failed;
> +			goto pinctrl_bind_failed;

Why not call the notifier chain here?  Did you verify that this change
still works properly?

thanks,

greg k-h
