Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7988D6D8CCF
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjDFBhF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 5 Apr 2023 21:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbjDFBgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:36:54 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B29769E;
        Wed,  5 Apr 2023 18:36:53 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3361ZbL72014407, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3361ZbL72014407
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 6 Apr 2023 09:35:37 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 6 Apr 2023 09:35:56 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 6 Apr 2023 09:35:56 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 6 Apr 2023 09:35:56 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
CC:     Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Tim K <tpkuester@gmail.com>, "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] wifi: rtw88: usb: fix priority queue to endpoint mapping
Thread-Topic: [PATCH v2 1/2] wifi: rtw88: usb: fix priority queue to endpoint
 mapping
Thread-Index: AQHZZsantn6+Tl20SEiemBFJimQM3K8dgj+g
Date:   Thu, 6 Apr 2023 01:35:56 +0000
Message-ID: <04a74aa305d04354a5743d2f6fd89a1e@realtek.com>
References: <20230404072508.578056-1-s.hauer@pengutronix.de>
 <20230404072508.578056-2-s.hauer@pengutronix.de>
In-Reply-To: <20230404072508.578056-2-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Tuesday, April 4, 2023 3:25 PM
> To: linux-wireless <linux-wireless@vger.kernel.org>
> Cc: Hans Ulli Kroll <linux@ulli-kroll.de>; Larry Finger <Larry.Finger@lwfinger.net>; Ping-Ke Shih
> <pkshih@realtek.com>; Tim K <tpkuester@gmail.com>; Alex G . <mr.nuke.me@gmail.com>; Nick Morrow
> <morrownr@gmail.com>; Viktor Petrenko <g0000ga@gmail.com>; Andreas Henriksson <andreas@fatal.se>;
> ValdikSS <iam@valdikss.org.ru>; kernel@pengutronix.de; Sascha Hauer <s.hauer@pengutronix.de>;
> stable@vger.kernel.org
> Subject: [PATCH v2 1/2] wifi: rtw88: usb: fix priority queue to endpoint mapping
> 
> The RTW88 chipsets have four different priority queues in hardware. For
> the USB type chipsets the packets destined for a specific priority queue
> must be sent through the endpoint corresponding to the queue. This was
> not fully understood when porting from the RTW88 USB out of tree driver
> and thus violated.
> 
> This patch implements the qsel to endpoint mapping as in
> get_usb_bulkout_id_88xx() in the downstream driver.
> 
> Without this the driver often issues "timed out to flush queue 3"
> warnings and often TX stalls completely.
> 

Add a Fixes tag?

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")

As well as second patch.

> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Tested-by: ValdikSS <iam@valdikss.org.ru>
> Tested-by: Alexandru gagniuc <mr.nuke.me@gmail.com>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: stable@vger.kernel.org

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw88/usb.c | 70 ++++++++++++++++--------
>  1 file changed, 47 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> index 2a8336b1847a5..a10d6fef4ffaf 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -118,6 +118,22 @@ static void rtw_usb_write32(struct rtw_dev *rtwdev, u32 addr, u32 val)
>         rtw_usb_write(rtwdev, addr, val, 4);
>  }
> 
> +static int dma_mapping_to_ep(enum rtw_dma_mapping dma_mapping)
> +{
> +       switch (dma_mapping) {
> +       case RTW_DMA_MAPPING_HIGH:
> +               return 0;
> +       case RTW_DMA_MAPPING_NORMAL:
> +               return 1;
> +       case RTW_DMA_MAPPING_LOW:
> +               return 2;
> +       case RTW_DMA_MAPPING_EXTRA:
> +               return 3;
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
>  static int rtw_usb_parse(struct rtw_dev *rtwdev,
>                          struct usb_interface *interface)
>  {
> @@ -129,6 +145,8 @@ static int rtw_usb_parse(struct rtw_dev *rtwdev,
>         int num_out_pipes = 0;
>         int i;
>         u8 num;
> +       const struct rtw_chip_info *chip = rtwdev->chip;
> +       const struct rtw_rqpn *rqpn;
> 
>         for (i = 0; i < interface_desc->bNumEndpoints; i++) {
>                 endpoint = &host_interface->endpoint[i].desc;
> @@ -183,31 +201,34 @@ static int rtw_usb_parse(struct rtw_dev *rtwdev,
> 
>         rtwdev->hci.bulkout_num = num_out_pipes;
> 
> -       switch (num_out_pipes) {
> -       case 4:
> -       case 3:
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = 2;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = 2;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = 2;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = 2;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID4] = 1;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID5] = 1;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID6] = 0;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID7] = 0;
> -               break;
> -       case 2:
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = 1;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = 1;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = 1;
> -               rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = 1;
> -               break;
> -       case 1:
> -               break;
> -       default:
> -               rtw_err(rtwdev, "failed to get out_pipes(%d)\n", num_out_pipes);
> +       if (num_out_pipes < 1 || num_out_pipes > 4) {
> +               rtw_err(rtwdev, "invalid number of endpoints %d\n", num_out_pipes);
>                 return -EINVAL;
>         }
> 
> +       rqpn = &chip->rqpn_table[num_out_pipes];
> +
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = dma_mapping_to_ep(rqpn->dma_map_be);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = dma_mapping_to_ep(rqpn->dma_map_bk);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = dma_mapping_to_ep(rqpn->dma_map_bk);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = dma_mapping_to_ep(rqpn->dma_map_be);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID4] = dma_mapping_to_ep(rqpn->dma_map_vi);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID5] = dma_mapping_to_ep(rqpn->dma_map_vi);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID6] = dma_mapping_to_ep(rqpn->dma_map_vo);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID7] = dma_mapping_to_ep(rqpn->dma_map_vo);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID8] = -EINVAL;
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID9] = -EINVAL;
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID10] = -EINVAL;
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID11] = -EINVAL;
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID12] = -EINVAL;
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID13] = -EINVAL;
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID14] = -EINVAL;
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_TID15] = -EINVAL;
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_BEACON] = dma_mapping_to_ep(rqpn->dma_map_hi);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_HIGH] = dma_mapping_to_ep(rqpn->dma_map_hi);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_MGMT] = dma_mapping_to_ep(rqpn->dma_map_mg);
> +       rtwusb->qsel_to_ep[TX_DESC_QSEL_H2C] = dma_mapping_to_ep(rqpn->dma_map_hi);
> +
>         return 0;
>  }
> 
> @@ -250,7 +271,7 @@ static void rtw_usb_write_port_tx_complete(struct urb *urb)
>  static int qsel_to_ep(struct rtw_usb *rtwusb, unsigned int qsel)
>  {
>         if (qsel >= ARRAY_SIZE(rtwusb->qsel_to_ep))
> -               return 0;
> +               return -EINVAL;
> 
>         return rtwusb->qsel_to_ep[qsel];
>  }
> @@ -265,6 +286,9 @@ static int rtw_usb_write_port(struct rtw_dev *rtwdev, u8 qsel, struct sk_buff *s
>         int ret;
>         int ep = qsel_to_ep(rtwusb, qsel);
> 
> +       if (ep < 0)
> +               return ep;
> +
>         pipe = usb_sndbulkpipe(usbd, rtwusb->out_ep[ep]);
>         urb = usb_alloc_urb(0, GFP_ATOMIC);
>         if (!urb)
> --
> 2.39.2

