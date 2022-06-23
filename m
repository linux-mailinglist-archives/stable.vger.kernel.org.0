Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E33557330
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 08:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiFWGg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 02:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiFWGg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 02:36:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170543C480;
        Wed, 22 Jun 2022 23:36:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C967FB82131;
        Thu, 23 Jun 2022 06:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD2EC3411B;
        Thu, 23 Jun 2022 06:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655966215;
        bh=L/HtZBe8zfTCnMDIyq2DhtLoHfHks0NxfofySG0XV9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hT1mVhq0udRcgy8oU0WisKa8/OPYSHG0lKmSa+3PFcKW84ty6BVzt6wvJO6L8OcB7
         WIP8xOX5mjNYGnRS63obGply7lvVS1IdGa7PKRAViK7vnOJEOztQIUELGt0cOUySNU
         QQDKSCJcebadwBgyhmVCgo6W+PLXSU/rCQCQPHC/1PAU3gAE/QwLoRTeVwHQokKFrS
         bVsXRpBxosPui8zyHdteaqX3sujNNX0N5Er6D5401IDijWcUnS2EDvVWF7CyM+v76D
         9npbK4XTDjrcEkPhZEbezJQX6IL4t7olkVQCg+zPJZtuACZz4j0k8DVLukYJKM+WC6
         QxWZLPDEOvWNg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1o4GSQ-0004VV-Vx; Thu, 23 Jun 2022 08:36:51 +0200
Date:   Thu, 23 Jun 2022 08:36:50 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, stable@vger.kernel.org,
        Ballon Shi <ballon.shi@quectel.com>
Subject: Re: [PATCH] USB: serial: option: add Quectel RM500K module support
Message-ID: <YrQKApkdi//0ysiP@hovoldconsulting.com>
References: <20220623035214.20124-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623035214.20124-1-macpaul.lin@mediatek.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 11:52:14AM +0800, Macpaul Lin wrote:
> Add usb product id of the Quectel RM500K module.
> 
> RM500K provides 2 maindatory interfaces to Linux host after enumeration.

typo: mandatory

>  - /dev/ttyUSB5: this is a serial interface for control path. User needs
>    to write AT commands to this device node to query status, set APN,
>    set PIN code, and enable/disable the data connection to 5G network.
>  - ethX: this is the data path provided as a RNDIS devices. After the
>    data connection has been established, Linux host can access 5G data
>    network via this interface.
> 
> The following kernel settings is required for RM500K.
>  - CONFIG_USB_SERIAL_GENERIC
>  - CONFIG_USB_SERIAL_CONSOLE

You shouldn't need either of those.

>  - CONFIG_USB_NET_RNDIS_HOST
>  - CONFIG_USB_SERIAL_WWAN
>  - CONFIG_USB_SERIAL_OPTION

And OPTION selects WWAN so no need to mention that.

But you can probably just drop this paragraph.

> usb-devices output for 0x7001:
> T:  Bus=05 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
> D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=2c7c ProdID=7001 Rev=00.01
> S:  Manufacturer=MediaTek Inc.
> S:  Product=USB DATA CARD
> S:  SerialNumber=869206050009672
> C:  #Ifs=10 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=02 Prot=ff Driver=rndis_host
> E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=125us
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
> E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:  If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
> E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:  If#= 6 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:  If#= 7 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:  If#= 8 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=08(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:  If#= 9 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=09(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Can you say something about what the other interfaces are for?

> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Signed-off-by: Ballon Shi <ballon.shi@quectel.com>

The submitters SoB always goes last (to reflect how the patch was
forwarded).

If Ballon is the primary author you need to add a From line at the
beginning of mail body.

Otherwise you should add a Co-developed-by tag before the co-author's
SoB.

More details in

	Documentation/process/submitting-patches.rst

> Cc: stable@vger.kernel.org
> ---
>  drivers/usb/serial/option.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index e7755d9cfc61..e2587a3c7600 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -253,6 +253,7 @@ static void option_instat_callback(struct urb *urb);
>  #define QUECTEL_PRODUCT_BG96			0x0296
>  #define QUECTEL_PRODUCT_EP06			0x0306
>  #define QUECTEL_PRODUCT_EM12			0x0512
> +#define QUECTEL_PRODUCT_RM500K			0x7001

Please keep the defines sorted by PID here.

>  #define QUECTEL_PRODUCT_RM500Q			0x0800
>  #define QUECTEL_PRODUCT_EC200S_CN		0x6002
>  #define QUECTEL_PRODUCT_EC200T			0x6026
> @@ -1135,6 +1136,7 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, 0x0620, 0xff, 0, 0) },
>  	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, 0x0700, 0xff), /* BG95 */
>  	  .driver_info = RSVD(3) | ZLP },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x30) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0, 0) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x10),

Johan
