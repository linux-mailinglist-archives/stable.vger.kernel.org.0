Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7825084BD
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 11:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377033AbiDTJVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 05:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359423AbiDTJVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 05:21:35 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E363D49F;
        Wed, 20 Apr 2022 02:18:49 -0700 (PDT)
X-UUID: 73dc67efba0a4edea8631f75926afc2d-20220420
X-UUID: 73dc67efba0a4edea8631f75926afc2d-20220420
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 145167488; Wed, 20 Apr 2022 17:18:41 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 20 Apr 2022 17:18:40 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 Apr 2022 17:18:39 +0800
Message-ID: <37276fd01a518dadff57ef66c7971b78baa9dc15.camel@mediatek.com>
Subject: Re: [PATCH] usb: mtu3: fix USB 3.0 dual-role-switch from device to
 host
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Fabien Parent <fparent@baylibre.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, <stable@vger.kernel.org>,
        Tainping Fang <tianping.fang@mediatek.com>
Date:   Wed, 20 Apr 2022 17:18:38 +0800
In-Reply-To: <20220419081245.21015-1-macpaul.lin@mediatek.com>
References: <20220419081245.21015-1-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-04-19 at 16:12 +0800, Macpaul Lin wrote:
> Issue description:
>   When an OTG port has been switched to device role and then switch
> back
>   to host role again, the USB 3.0 Host (XHCI) will not be able to
> detect
>   "plug in event of a connected USB 2.0/1.0 ((Highspeed and
> Fullspeed)
>   devices until system reboot.
> 
> Root cause and Solution:
>   There is a condition checking flag "ssusb->otg_switch.is_u3_drd" in
>   toggle_opstate(). At the end of role switch procedure,
> toggle_opstate()
>   will be called to set DC_SESSION and SOFT_CONN bit. If "is_u3_drd"
> was
>   set and switched the role to USB host 3.0, bit DC_SESSION and
> SOFT_CONN
>   will be skipped hence caused the port cannot detect connected USB
> 2.0
>   (Highspeed and Fullspeed) devices. Simply remove the condition
> check to
>   solve this issue.
> 
> Fixes: d0ed062a8b75 ("usb: mtu3: dual-role mode support")
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Signed-off-by: Tainping Fang <tianping.fang@mediatek.com>
> Tested-by: Fabien Parent <fparent@baylibre.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/usb/mtu3/mtu3_dr.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/mtu3/mtu3_dr.c b/drivers/usb/mtu3/mtu3_dr.c
> index ec6ec621838b..b820724c56e4 100644
> --- a/drivers/usb/mtu3/mtu3_dr.c
> +++ b/drivers/usb/mtu3/mtu3_dr.c
> @@ -21,10 +21,8 @@ static inline struct ssusb_mtk
> *otg_sx_to_ssusb(struct otg_switch_mtk *otg_sx)
>  
>  static void toggle_opstate(struct ssusb_mtk *ssusb)
>  {
> -	if (!ssusb->otg_switch.is_u3_drd) {
> -		mtu3_setbits(ssusb->mac_base, U3D_DEVICE_CONTROL,
> DC_SESSION);
> -		mtu3_setbits(ssusb->mac_base, U3D_POWER_MANAGEMENT,
> SOFT_CONN);
> -	}
> +	mtu3_setbits(ssusb->mac_base, U3D_DEVICE_CONTROL, DC_SESSION);
> +	mtu3_setbits(ssusb->mac_base, U3D_POWER_MANAGEMENT, SOFT_CONN);
>  }
>  
Reviewed-by: Chunfeng Yun <chunfeng.yun@mediatek.com>

Thanks

>  /* only port0 supports dual-role mode */

