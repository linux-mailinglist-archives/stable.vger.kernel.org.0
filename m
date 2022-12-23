Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2D0655125
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 15:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbiLWOBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 09:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLWOBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 09:01:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE6F6300;
        Fri, 23 Dec 2022 06:01:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 087B0B81F79;
        Fri, 23 Dec 2022 14:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0253C433EF;
        Fri, 23 Dec 2022 14:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671804060;
        bh=AJ6hHUXccdAnIHM+TsMt4CJZeVcaFow5vwyGrPBRFhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LUZztam9jZfDWWYubVcqtjHZEtiebuyncHyEL2rqdaxgiyJDv90q7RWXmOBJPR/qs
         euWOMpLmkhrNdJv3nxm2GyHiStAzBe2xsD4AAx7gKiqLEfv25c5G613PpEjFtfsRnu
         zgBFoDnVDeqtHsKnhdXT32pjZDZBH5CKKhoRq1nUBaF5M6oA1pccRJVhoROrfbnEFX
         pF2HNBb0alV4jXC4feUr+Kn1/J/Q+qxVkU5zXz4Iv6blp6i3dajOGVYrLtnNcBjJtf
         sSjA3xwU/o2Be/uhxlhwZ8DV/b0hN7GzEO7CbczGqitD+8A12Klb1dcSTENBaGa3F6
         IRM3SRxVaTi3A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1p8icU-0000ES-KX; Fri, 23 Dec 2022 15:01:54 +0100
Date:   Fri, 23 Dec 2022 15:01:54 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
Message-ID: <Y6W00vQm3jfLflUJ@hovoldconsulting.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 02:26:44AM +0000, Matthias Kaehlcke wrote:
> The primary task of the onboard_usb_hub driver is to control the
> power of an onboard USB hub. The driver gets the regulator from the
> device tree property "vdd-supply" of the hub's DT node. Some boards
> have device tree nodes for USB hubs supported by this driver, but
> don't specify a "vdd-supply". This is not an error per se, it just
> means that the onboard hub driver can't be used for these hubs, so
> don't create platform devices for such nodes.
> 
> This change doesn't completely fix the reported regression. It
> should fix it for the RPi 3 B Plus and boards with similar hub
> configurations (compatible DT nodes without "vdd-supply"), boards
> that actually use the onboard hub driver could still be impacted
> by the race conditions discussed in that thread. Not creating the
> platform devices for nodes without "vdd-supply" is the right
> thing to do, independently from the race condition, which will
> be fixed in future patch.
> 
> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> Link: https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> 
> Changes in v2:
> - don't create platform devices when "vdd-supply" is missing,
>   rather than returning an error from _find_onboard_hub()
> - check for "vdd-supply" not "vdd" (Johan)

Please try to remember to CC people providing feedback on your patches.

> - updated subject and commit message
> - added 'Link' tag (regzbot)
> 
>  drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/usb/misc/onboard_usb_hub_pdevs.c b/drivers/usb/misc/onboard_usb_hub_pdevs.c
> index ed22a18f4ab7..8cea53b0907e 100644
> --- a/drivers/usb/misc/onboard_usb_hub_pdevs.c
> +++ b/drivers/usb/misc/onboard_usb_hub_pdevs.c
> @@ -101,6 +101,19 @@ void onboard_hub_create_pdevs(struct usb_device *parent_hub, struct list_head *p
>  			}
>  		}
>  
> +		/*
> +		 * The primary task of the onboard_usb_hub driver is to control
> +		 * the power of an USB onboard hub. Some boards have device tree
> +		 * nodes for USB hubs supported by this driver, but don't
> +		 * specify a "vdd-supply", which is needed by the driver. This is
> +		 * not a DT error per se, it just means that the onboard hub
> +		 * driver can't be used with these nodes, so don't create a
> +		 * a platform device for such a node.
> +		 */
> +		if (!of_get_property(np, "vdd-supply", NULL) &&
> +		    !of_get_property(npc, "vdd-supply", NULL))
> +			goto node_put;

So as I mentioned elsewhere, this doesn't look right. It is the
responsibility of the platform driver to manage its resources and it may
not even need a supply.

I see now that you have already matched on the compatible property above
so that you only create the platform device for the devices that (may)
need it. 

It seems the assumptions that this driver was written under needs to be
revisited.

> +
>  		pdev = of_platform_device_create(np, NULL, &parent_hub->dev);
>  		if (!pdev) {
>  			dev_err(&parent_hub->dev,

Johan
