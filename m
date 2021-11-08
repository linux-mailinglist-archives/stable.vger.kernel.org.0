Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590BE447E54
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 11:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhKHK6v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 8 Nov 2021 05:58:51 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:35998 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238838AbhKHK6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 05:58:42 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-187-MTx5LVPGM4S4GiBqox-4vw-1; Mon, 08 Nov 2021 10:55:52 +0000
X-MC-Unique: MTx5LVPGM4S4GiBqox-4vw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.24; Mon, 8 Nov 2021 10:55:48 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.024; Mon, 8 Nov 2021 10:55:48 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Larry Finger' <Larry.Finger@lwfinger.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "phil@philpotter.co.uk" <phil@philpotter.co.uk>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zameer Manji <zmanji@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Stable <stable@vger.kernel.org>
Subject: RE: [PATCH v2] staging: r8188eu: Fix breakage introduced when 5G code
 was removed
Thread-Topic: [PATCH v2] staging: r8188eu: Fix breakage introduced when 5G
 code was removed
Thread-Index: AQHX0/3oe+k3iU2vCUKwt3hlkWjVnqv5dSlg
Date:   Mon, 8 Nov 2021 10:55:48 +0000
Message-ID: <8e4dd863ae894c8488a3d3d0f6a11f66@AcuMS.aculab.com>
References: <20211107173543.7486-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20211107173543.7486-1-Larry.Finger@lwfinger.net>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger
> Sent: 07 November 2021 17:36
> 
> In commit 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions
> and code"), two entries were removed from RTW_ChannelPlanMap[], but not replaced
> with zeros. The position within this table is important, thus the patch broke
> systems operating in regulatory domains osted later than entry 0x13 in the table.
> Unfortunately, the FCC entry comes before that point and most testers did not see
> this problem.
...
>  drivers/staging/r8188eu/core/rtw_mlme_ext.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/r8188eu/core/rtw_mlme_ext.c b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
> index 55c3d4a6faeb..5b60e6df5f87 100644
> --- a/drivers/staging/r8188eu/core/rtw_mlme_ext.c
> +++ b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
> @@ -107,6 +107,7 @@ static struct rt_channel_plan_map	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
>  	{0x01},	/* 0x10, RT_CHANNEL_DOMAIN_JAPAN */
>  	{0x02},	/* 0x11, RT_CHANNEL_DOMAIN_FCC_NO_DFS */
>  	{0x01},	/* 0x12, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
> +	{0x00}, /* 0x13 */
>  	{0x02},	/* 0x14, RT_CHANNEL_DOMAIN_TAIWAN_NO_DFS */
>  	{0x00},	/* 0x15, RT_CHANNEL_DOMAIN_ETSI_NO_DFS */
>  	{0x00},	/* 0x16, RT_CHANNEL_DOMAIN_KOREA_NO_DFS */
> @@ -118,6 +119,7 @@ static struct rt_channel_plan_map	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
>  	{0x00},	/* 0x1C, */
>  	{0x00},	/* 0x1D, */
>  	{0x00},	/* 0x1E, */
> +	{0x00},	/* 0x1F, */
>  	/*  0x20 ~ 0x7F , New Define ===== */
>  	{0x00},	/* 0x20, RT_CHANNEL_DOMAIN_WORLD_NULL */
>  	{0x01},	/* 0x21, RT_CHANNEL_DOMAIN_ETSI1_NULL */

Is it worth changing that to use designated array initialisers?
so:
	[0x21] = {0x01} /* RT_CHANNEL_DOMAIN_ETS11_NULL */

Then the {0x00} entries can be missed out (or just commented as not used).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

