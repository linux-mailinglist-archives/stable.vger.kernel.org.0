Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA704D880F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 16:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbiCNPaN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 14 Mar 2022 11:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241833AbiCNPaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 11:30:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF8441A820
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 08:29:01 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-88-2bsKW7hAOQG-IkU6s2hIvw-1; Mon, 14 Mar 2022 15:28:58 +0000
X-MC-Unique: 2bsKW7hAOQG-IkU6s2hIvw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Mon, 14 Mar 2022 15:28:57 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Mon, 14 Mar 2022 15:28:57 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Srinivas Pandruvada' <srinivas.pandruvada@linux.intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "amitk@kernel.org" <amitk@kernel.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>
CC:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matthewgarrett@google.com" <matthewgarrett@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] thermal: int340x: Increase bitmap size
Thread-Topic: [PATCH] thermal: int340x: Increase bitmap size
Thread-Index: AQHYN7Lachj8EG/q40KIX1FHOIeB5Ky/AJ1Q
Date:   Mon, 14 Mar 2022 15:28:57 +0000
Message-ID: <c23d75b4e9164094bcc488c0ba9e0d77@AcuMS.aculab.com>
References: <20220314145017.928550-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20220314145017.928550-1-srinivas.pandruvada@linux.intel.com>
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
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada
> Sent: 14 March 2022 14:50
> 
> The number of policies are 10, so can't be supported by the bitmap size
> of u8. Even though there are no platfoms with these many policies, but
> as correctness increase to u16.

You might as well just use 'unsigned int'.
May generate better code and there is still padding
in the structure.

	David

> 
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Fixes: 16fc8eca1975 ("thermal/int340x_thermal: Add additional UUIDs")
> Cc: stable@vger.kernel.org
> ---
>  drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 72acb1f61849..c2d3df302214 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -53,7 +53,7 @@ struct int3400_thermal_priv {
>  	struct art *arts;
>  	int trt_count;
>  	struct trt *trts;
> -	u8 uuid_bitmap;
> +	u16 uuid_bitmap;
>  	int rel_misc_dev_res;
>  	int current_uuid_index;
>  	char *data_vault;
> --
> 2.31.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

