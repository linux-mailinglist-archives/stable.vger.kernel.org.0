Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848514AC4A9
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 17:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346316AbiBGP7o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 7 Feb 2022 10:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384365AbiBGPvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 10:51:47 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 07:51:31 PST
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 009E1C0401D3
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 07:51:31 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-108-njvjn7dXMv-LfAVryvNBVg-1; Mon, 07 Feb 2022 15:50:25 +0000
X-MC-Unique: njvjn7dXMv-LfAVryvNBVg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Mon, 7 Feb 2022 15:50:16 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Mon, 7 Feb 2022 15:50:16 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ari Sundholm' <ari@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Anton Altaparmakov <anton@tuxera.com>
Subject: RE: [PATCH] fs/read_write.c: Fix a broken signed integer overflow
 check.
Thread-Topic: [PATCH] fs/read_write.c: Fix a broken signed integer overflow
 check.
Thread-Index: AQHYHCmhrNPdt8nHtECGo27UFYwbXqyIOyHw
Date:   Mon, 7 Feb 2022 15:50:16 +0000
Message-ID: <051a5e4621344301a2c4f84c3de57ec3@AcuMS.aculab.com>
References: <20220207120711.4070403-1-ari@tuxera.com>
In-Reply-To: <20220207120711.4070403-1-ari@tuxera.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ari Sundholm
> Sent: 07 February 2022 12:07
> 
> The function generic_copy_file_checks() checks that the ends of the
> input and output file ranges do not overflow. Unfortunately, there is
> an issue with the check itself.
> 
> Due to the integer promotion rules in C, the expressions
> (pos_in + count) and (pos_out + count) have an unsigned type because
> the count variable has the type uint64_t. Thus, in many cases where we
> should detect signed integer overflow to have occurred (and thus one or
> more of the ranges being invalid), the expressions will instead be
> interpreted as large unsigned integers. This means the check is broken.
> 
> Fix this by explicitly casting the expressions to loff_t.
...
> ---
>  fs/read_write.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 0074afa7ecb3..64166e74adc5 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1431,7 +1431,8 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
>  		return -ETXTBSY;
> 
>  	/* Ensure offsets don't wrap. */
> -	if (pos_in + count < pos_in || pos_out + count < pos_out)
> +	if ((loff_t)(pos_in + count) < pos_in ||
> +			(loff_t)(pos_out + count) < pos_out)
>  		return -EOVERFLOW;

Hard to convince myself that is right.
The old code is the standard check for unsigned addition overflow.
The new one is just odd.

If pos_in is guaranteed to be +ve in a signed variable you can check:
	count < (1ull << 63) - pos_in
since the RHS is then guaranteed not to wrap.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

