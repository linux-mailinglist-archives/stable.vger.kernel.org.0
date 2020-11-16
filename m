Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CBB2B4674
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 15:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbgKPOzO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 16 Nov 2020 09:55:14 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20121 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730402AbgKPOzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 09:55:14 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-98-JkwNPBRkP3WlYXkMFARcSg-1; Mon, 16 Nov 2020 14:54:59 +0000
X-MC-Unique: JkwNPBRkP3WlYXkMFARcSg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 16 Nov 2020 14:54:58 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 16 Nov 2020 14:54:58 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Corentin Labbe' <clabbe@baylibre.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 2/7] crypto: sun4i-ss: checking sg length is not
 sufficient
Thread-Topic: [PATCH v3 2/7] crypto: sun4i-ss: checking sg length is not
 sufficient
Thread-Index: AQHWvCBry++55PgsQECGWrYMz9WH2qnK16lg
Date:   Mon, 16 Nov 2020 14:54:58 +0000
Message-ID: <0a9e713557104048b535958b5fe6cb10@AcuMS.aculab.com>
References: <20201116135345.11834-1-clabbe@baylibre.com>
 <20201116135345.11834-3-clabbe@baylibre.com>
In-Reply-To: <20201116135345.11834-3-clabbe@baylibre.com>
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

From: Corentin Labbe
> Sent: 16 November 2020 13:54
> 
> The optimized cipher function need length multiple of 4 bytes.
> But it get sometimes odd length.
> This is due to SG data could be stored with an offset.
> 
> So the fix is to check also if the offset is aligned with 4 bytes.
> Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-
> ss/sun4i-ss-cipher.c
> index 19f1aa577ed4..4dd736ee5a4d 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> @@ -186,12 +186,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
>  	 * we can use the SS optimized function
>  	 */
>  	while (in_sg && no_chunk == 1) {
> -		if (in_sg->length % 4)
> +		if (in_sg->length % 4 || !IS_ALIGNED(in_sg->offset, sizeof(u32)))

You probably ought to do the test in a consistent manner.
Probably something that reduces to:
	((unsigned long)in_sg->offset | in_sg->length) & 3u

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

