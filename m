Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2A96D5937
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbjDDHLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbjDDHLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:11:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5011988
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 00:11:49 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pjapJ-0005XZ-3k; Tue, 04 Apr 2023 09:11:33 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pjapF-0000B6-Nv; Tue, 04 Apr 2023 09:11:29 +0200
Date:   Tue, 4 Apr 2023 09:11:29 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Jonathan Bither <jonbither@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Tim K <tpkuester@gmail.com>,
        "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>, kernel@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] wifi: rtw88: usb: fix priority queue to endpoint
 mapping
Message-ID: <20230404071129.GW19113@pengutronix.de>
References: <20230331121054.112758-1-s.hauer@pengutronix.de>
 <20230331121054.112758-2-s.hauer@pengutronix.de>
 <cb5980b4-1e0e-57f8-e680-44e14fa0b02c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb5980b4-1e0e-57f8-e680-44e14fa0b02c@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 31, 2023 at 10:31:25AM -0400, Jonathan Bither wrote:
> 
> On 3/31/23 08:10, Sascha Hauer wrote:
> > The RTW88 chipsets have four different priority queues in hardware. For
> > the USB type chipsets the packets destined for a specific priority queue
> > must be sent through the endpoint corresponding to the queue. This was
> > not fully understood when porting from the RTW88 USB out of tree driver
> > and thus violated.
> > 
> > This patch implements the qsel to endpoint mapping as in
> > get_usb_bulkout_id_88xx() in the downstream driver.
> > 
> > Without this the driver often issues "timed out to flush queue 3"
> > warnings and often TX stalls completely.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >   drivers/net/wireless/realtek/rtw88/usb.c | 70 ++++++++++++++++--------
> >   1 file changed, 47 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> > index 2a8336b1847a5..a10d6fef4ffaf 100644
> > --- a/drivers/net/wireless/realtek/rtw88/usb.c
> > +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> > @@ -118,6 +118,22 @@ static void rtw_usb_write32(struct rtw_dev *rtwdev, u32 addr, u32 val)
> >   	rtw_usb_write(rtwdev, addr, val, 4);
> >   }
> > +static int dma_mapping_to_ep(enum rtw_dma_mapping dma_mapping)
> > +{
> > +	switch (dma_mapping) {
> > +	case RTW_DMA_MAPPING_HIGH:
> > +		return 0;
> > +	case RTW_DMA_MAPPING_NORMAL:
> > +		return 1;
> > +	case RTW_DMA_MAPPING_LOW:
> > +		return 2;
> > +	case RTW_DMA_MAPPING_EXTRA:
> > +		return 3;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> Would it be beneficial to use defines for the returns? Would the
> USB_ENDPOINT_XFER_ defines be applicable?

The USB_ENDPOINT_XFER_* macros encode the type of the transfer, like
bulk, control, isochronous and interrupt. What I need here really is
the endpoint number. I don't see a benefit in adding a define here.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
