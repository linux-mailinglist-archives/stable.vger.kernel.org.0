Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F87C21B3
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 15:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbfI3NSg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Sep 2019 09:18:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:49280 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731103AbfI3NSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 09:18:36 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-207-hnslXOvPO-C_5kCPTbZeHQ-1; Mon, 30 Sep 2019 14:18:32 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 30 Sep 2019 14:18:32 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 30 Sep 2019 14:18:32 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Denis Efremov' <efremov@linux.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
Thread-Topic: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
Thread-Index: AQHVd36LU5ikVLKK6EuvH5wLNYQtMKdEMyLw
Date:   Mon, 30 Sep 2019 13:18:32 +0000
Message-ID: <37b195b700394e95aa8329afc9f60431@AcuMS.aculab.com>
References: <20190930110141.29271-1-efremov@linux.com>
In-Reply-To: <20190930110141.29271-1-efremov@linux.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: hnslXOvPO-C_5kCPTbZeHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov
> Sent: 30 September 2019 12:02
> memcpy() in phy_ConfigBBWithParaFile() and PHY_ConfigRFWithParaFile() is
> called with "src == NULL && len == 0". This is an undefined behavior.

I'm pretty certain it is well defined (to do nothing).

> Moreover this if pre-condition "pBufLen && (*pBufLen == 0) && !pBuf"
> is constantly false because it is a nested if in the else brach, i.e.,
> "if (cond) { ... } else { if (cond) {...} }". This patch alters the
> if condition to check "pBufLen && pBuf" pointers are not NULL.
> 
...
> ---
> Not tested. I don't have the hardware. The fix is based on my guess.
> 
>  drivers/staging/rtl8723bs/hal/hal_com_phycfg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
> index 6539bee9b5ba..0902dc3c1825 100644
> --- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
> +++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
> @@ -2320,7 +2320,7 @@ int phy_ConfigBBWithParaFile(
>  			}
>  		}
>  	} else {
> -		if (pBufLen && (*pBufLen == 0) && !pBuf) {
> +		if (pBufLen && pBuf) {
>  			memcpy(pHalData->para_file_buf, pBuf, *pBufLen);

The existing code is clearly garbage.
It only ever does memcpy(tgt, NULL, 0).

Under the assumption that the code has been tested the copy clearly isn't needed at all
and can be deleted completely!

OTOH if the code hasn't been tested maybe the entire source file should be removed :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

