Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407875A877A
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 22:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiHaUVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 16:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiHaUVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 16:21:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0BED86D0;
        Wed, 31 Aug 2022 13:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QOtbQ4yJveAuBSbPqKAD8fBOR2UFCoCezNEyy822MA8=; b=RWTXs0S5NMPiMNm3DzReyR7HIH
        9BSyfgq0C/oLwpvxRj13cxPUljrsp99FTOgX4LJ9Q4dYT5K4DR26WlG975PZfHACip6e9tSAK0LOe
        nYDaaKusx6MpomBtWMUVifptUtGEWjvkJOg/oNgQL5d6/Q279mMkefo3UYeQNX/ZUmEcOCThZhvaU
        Eaga1uavqxmdS/8FLOeuCh5bvx9F/89dANjNuxsK8OIMcpQbHTfiGHrhpV1Mob2jXFWi/V4/Rtlon
        JOlC/lYHYdo5lmbxTa8muqT+o9DnpVUToNhl4SmJvq69owrXnSUgK3jr53GBpMGyhxlUiC//Ny4vJ
        kP9FZqBg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34026)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oTUDN-0004ru-2y; Wed, 31 Aug 2022 21:21:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oTUDJ-0002nh-Ke; Wed, 31 Aug 2022 21:21:29 +0100
Date:   Wed, 31 Aug 2022 21:21:29 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Guenter Roeck <linux@roeck-us.net>, kernel-team@android.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] driver core: Don't probe devices after
 bus_type.match() probe deferral
Message-ID: <Yw/CyRFr1bYNlNGh@shell.armlinux.org.uk>
References: <20220817184026.3468620-1-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817184026.3468620-1-isaacmanjarres@google.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

Are you happy for me to pick up this patch as part of the fixes for the
AMBA changes? The original patch that it is fixing is a patch that was
part of a series that was merged through my tree.

It's fixing a problem that has been noticed by several people and the
fix is now a few weeks old.

Thanks.

On Wed, Aug 17, 2022 at 11:40:26AM -0700, Isaac J. Manjarres wrote:
> Both __device_attach_driver() and __driver_attach() check the return
> code of the bus_type.match() function to see if the device needs to be
> added to the deferred probe list. After adding the device to the list,
> the logic attempts to bind the device to the driver anyway, as if the
> device had matched with the driver, which is not correct.
> 
> If __device_attach_driver() detects that the device in question is not
> ready to match with a driver on the bus, then it doesn't make sense for
> the device to attempt to bind with the current driver or continue
> attempting to match with any of the other drivers on the bus. So, update
> the logic in __device_attach_driver() to reflect this.
> 
> If __driver_attach() detects that a driver tried to match with a device
> that is not ready to match yet, then the driver should not attempt to bind
> with the device. However, the driver can still attempt to match and bind
> with other devices on the bus, as drivers can be bound to multiple
> devices. So, update the logic in __driver_attach() to reflect this.
> 
> Cc: stable@vger.kernel.org
> Cc: Saravana Kannan <saravanak@google.com>
> Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Reviewed-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/base/dd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> v1 -> v2:
> - Fixed the logic in __driver_attach() to allow a driver to continue
>   attempting to match and bind with devices in case of any error, not
>   just probe deferral.
> 
> v2 -> v3:
> - Restored the patch back to v1.
> - Added Guenter's Tested-by tag.
> - Added Saravana's Reviewed-by tag.
> - Cc'd stable@vger.kernel.org
> 
> Greg,
> 
> This is the final version of this patch. Can you please pick this up?
> 
> Thanks,
> Isaac
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 70f79fc71539..90b31fb141a5 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -881,6 +881,11 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
>  		dev_dbg(dev, "Device match requests probe deferral\n");
>  		dev->can_match = true;
>  		driver_deferred_probe_add(dev);
> +		/*
> +		 * Device can't match with a driver right now, so don't attempt
> +		 * to match or bind with other drivers on the bus.
> +		 */
> +		return ret;
>  	} else if (ret < 0) {
>  		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
>  		return ret;
> @@ -1120,6 +1125,11 @@ static int __driver_attach(struct device *dev, void *data)
>  		dev_dbg(dev, "Device match requests probe deferral\n");
>  		dev->can_match = true;
>  		driver_deferred_probe_add(dev);
> +		/*
> +		 * Driver could not match with device, but may match with
> +		 * another device on the bus.
> +		 */
> +		return 0;
>  	} else if (ret < 0) {
>  		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
>  		return ret;
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
