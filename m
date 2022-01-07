Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE50C4874A9
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 10:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346307AbiAGJ3H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 7 Jan 2022 04:29:07 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:55463 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231910AbiAGJ3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 04:29:07 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-285-vpZ-Wp3BMeGthyvSRQk9FQ-1; Fri, 07 Jan 2022 09:29:00 +0000
X-MC-Unique: vpZ-Wp3BMeGthyvSRQk9FQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Fri, 7 Jan 2022 09:28:59 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Fri, 7 Jan 2022 09:28:59 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jiasheng Jiang' <jiasheng@iscas.ac.cn>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] ide: Check for null pointer after calling devm_ioremap
Thread-Topic: [PATCH v2] ide: Check for null pointer after calling
 devm_ioremap
Thread-Index: AQHYA6at8pabwhGqwEGRoa3rWHXCDqxXSSww
Date:   Fri, 7 Jan 2022 09:28:59 +0000
Message-ID: <1100e723d5bb4551b5275fddc42c0902@AcuMS.aculab.com>
References: <20220107091151.4057283-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220107091151.4057283-1-jiasheng@iscas.ac.cn>
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

From: Jiasheng Jiang
> Sent: 07 January 2022 09:12
> 
> In linux-stable-5.15.13, this file has been removed and combined
> to `drivers/ata/pata_platform.c` without this bug.
> But in the older LTS kernels, like 5.10.90, this bug still exists.
> As the possible failure of the devres_alloc(), the devm_ioremap() and
> devm_ioport_map() may return NULL pointer.
> And then, the 'base' and 'alt_base' are used in plat_ide_setup_ports().
> Therefore, it should be better to add the check in order to avoid the
> dereference of the NULL pointer.
> Actually, it introduced the bug from commit 8cb1f567f4c0
> ("ide: Platform IDE driver") and we can know from the commit message
> that it tended to be similar to the `drivers/ata/pata_platform.c`.
> But actually, even the first time pata_platform was built,
> commit a20c9e820864 ("[PATCH] ata: Generic platform_device libata driver"),
> there was no the bug, as there was a check after the ioremap().
> So possibly the bug was caused by ide itself.
> 
> Fixes: 8cb1f567f4c0 ("ide: Platform IDE driver")
> Cc: stable@vger.kernel.org#5.10.90
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
> Changelog
> 
> v1 -> v2
> 
> * Change 1. Correct the fixes tag and commit message.
> ---
>  drivers/ide/ide_platform.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/ide/ide_platform.c b/drivers/ide/ide_platform.c
> index 91639fd6c276..5500c5afb3ca 100644
> --- a/drivers/ide/ide_platform.c
> +++ b/drivers/ide/ide_platform.c
> @@ -85,6 +85,10 @@ static int plat_ide_probe(struct platform_device *pdev)
>  		alt_base = devm_ioport_map(&pdev->dev,
>  			res_alt->start, resource_size(res_alt));
>  	}
> +	if (!base || !!alt_base) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}

That !!alt_base doesn't look right.
Without looking at the rest of the code maybe:
	if (!base && !alt_base)
may be correct.

It also rather makes me wonder about the actual failure return value.
If devm_ioport_map() returns a 'port number' for inb()/outb() then
zero is technically a valid value!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

