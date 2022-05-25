Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA49533EC9
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbiEYOIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 10:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbiEYOIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 10:08:24 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30124.outbound.protection.outlook.com [40.107.3.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806EF9D042;
        Wed, 25 May 2022 07:08:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvSssAukiIiRqXXR4M1E2cXt84EnZLyyDJCT6Gzec6PwKyYtHzFKbc1JzyXyosES1Nr4xCCNMxu/6P2/YzJ106GVwnkNsWLLMYHI2xaCShUCj7Hp1KN6km8DyE7B8LqyHRVGDGwbCpnLUYPXBGVke/a1w/l0JSH3aHl1qXvfPXLVBTBodu9jf77r6hEKZiBtDGBGNC3F8DMwh8Z8f80kTZuslj+fF1o1LW5sUP1cNsI20f1dQIEm6Jlx0Fgc/3uYNxpUSITDoyw2VOX4wgNWqJjnmtyVzEy4EnjX1ZmhHgkoZTnfrN1enQ+wzQPAyImmqr4v1T8KHeeNQBugHAgTQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRrA0RRscVfrHFL28KoDMYONkAT3ex4UALGsSmm+WeQ=;
 b=IX92qCICGIUFtm52N2VJ6WSgUiE0x2pi8hopNNrQFDpT1ocWdLBmZxRS/Ilml1MU9fOrYojsYN5vHgf3R/xU3N7f81kXf4kSQo1+37Sr6JDy4Kjjj803cltZcGT6dcl+3lYgh7FSYt/VsiWpzmwAhJuplOgZQqxqfNoTVYDT+44VXIMDS5qtXJUFbRtarki1uRO3nqe3TCaag3xi0LZA8ykeNoFhAh1ybrhEy5ZCqaS1yp3cq/Ezq0ghoqOY89fDkVOuwxOZ+k12R3w7rA1Cxjf95A8JSOdxE5RD8Z8yvemlptK65cbuOFuX9gkHpizszL1w9ZCKlWSa3eQmy5AKFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axentia.se; dmarc=pass action=none header.from=axentia.se;
 dkim=pass header.d=axentia.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRrA0RRscVfrHFL28KoDMYONkAT3ex4UALGsSmm+WeQ=;
 b=JHkKChpbxDNq4wdH+9Hi8jV9AfH9JKjDcUnwgxocTan0VpgUjVrZzTClQK5fLWJ0C1MRGTFiAURcLTvabPf6wpfMI/5HaEbNPOUhYIlTR5UIXsht3hhuMG+MeHNLz5vlFH8MyFo0XjVXUQfn/9DAHeFqMTtQh1uQ7p3O5nMiZNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axentia.se;
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com (2603:10a6:208:ed::15)
 by PAXPR02MB7390.eurprd02.prod.outlook.com (2603:10a6:102:1c9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 14:08:18 +0000
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::dcef:9022:d307:3e8a]) by AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::dcef:9022:d307:3e8a%4]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 14:08:18 +0000
Message-ID: <d89caadf-0940-7a72-a245-31acec95d673@axentia.se>
Date:   Wed, 25 May 2022 16:08:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] iio: afe: rescale: Fix logic bug
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc:     Lars-Peter Clausen <lars@metafoo.de>,
        Liam Beguin <liambeguin@gmail.com>, stable@vger.kernel.org
References: <20220524075448.140238-1-linus.walleij@linaro.org>
From:   Peter Rosin <peda@axentia.se>
In-Reply-To: <20220524075448.140238-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0102.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::27) To AM0PR02MB4436.eurprd02.prod.outlook.com
 (2603:10a6:208:ed::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c77852e-41e7-415e-800b-08da3e5804e1
X-MS-TrafficTypeDiagnostic: PAXPR02MB7390:EE_
X-Microsoft-Antispam-PRVS: <PAXPR02MB73901579FA53D2531EB37254BCD69@PAXPR02MB7390.eurprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rxgq/pjHU/dMIDSYAgD1dxse6LERh/htgodAZpqh315ALnLEGK/HxM3vCnviFpwhYKLS2Pr6hcTmbHpxG/e2cIoKM1i4XWLeSWyI+wA/PjAlYoFKVMNu5JDh4if16Ud3Bg8Q2ut1pK5rPT3k4llM9U0Is28im/nJD7SIVckJiwokmlHTagy8rr5eTkyzrPrr/X2T/w/SykPFEzYJ7bgLyX8cfBUDY/2jnRBMLbaH2kcRqydfn+YOClm4UXDd3YDtUUVs7SktI6ntTCN67Biamf3R25r+z7RVkIfpm4y2OS5uyj/H/WJtRfgAGEf4HCfpl/ZNlU2ShzdJfQBLyfgAZ+LY9m2aMW++y8BX7+HXrg04Z/oZ1XDZJ6RI7Ep56WpQsnPc0oz5NAMRf/fDHr+slDx26hZEykCPJWhJVyqPcsnkz0V5cGZo+NVHqpiM4KAfQIlCThVoaMhqC3w5y31IS0Mu7MlotB4lQA0spf6bDHF0Tl9rp4rrTxW/UsKUnubMJbn8nBSLlVm3ZuIT4MQnLYOVeS5aablcKgM5QXdW+Pbjix6QHgxyjpK3bi3pEkcZgTrSiX/5X40FrsTEaP+vLwuEvz+Fgidet4BAfdSHlJYx7bYuJ6sc8ksAawz+f5zSIS2TYLlO3OBr3/Lwzx/Tf9RhS11ka269//zGVRaCvFpmAyj20AZwLQNrdgWHsZXh5YAmh5tG1xwtNQP3aTFHjl05vRfWjoSpoTMvfWC66Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB4436.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(366004)(376002)(346002)(39840400004)(31696002)(36756003)(6486002)(2906002)(316002)(8936002)(31686004)(86362001)(6506007)(4326008)(66556008)(8676002)(66946007)(508600001)(6512007)(26005)(66476007)(110136005)(41300700001)(54906003)(2616005)(38100700002)(83380400001)(186003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHN4d3g4SXp6cEcrM3B5NEgzY01yZjc0T21nNFl1SDE3My8rVTQyMGZnRTRy?=
 =?utf-8?B?QmVoL2tPdzZnMlFqaFhhbUFQRUV6Q3VSODhMb285eTYyWnFmUFZ0bkZIOExz?=
 =?utf-8?B?Y001WHp0UGJ0Q0NSekl4cit0U1RtNVRWVnlSV1VJU3p1eVh1WGV6bEVpQkRF?=
 =?utf-8?B?cmd2WDhtV25OZElLeVREeXhHUVBVWStLWm1IYVZ4WnkvandxZGorL2RCTTVS?=
 =?utf-8?B?QlRvYzk4a0QrMzdNK3RWRUoyVXpYdEljMGsxQUFCbHFabkxjQ0tWcDhrRk5h?=
 =?utf-8?B?ZHFSSzJZMHA0azVhZnQrdjl2eDJrOGNQTi96RldBdk9SYkN2c05YcDBIZzFE?=
 =?utf-8?B?V3RHVWpvZEhoMHZEMDlHOGpaNG5YdWVjUS9Hd2FqdWdQd2xlYlV2ZVVna01j?=
 =?utf-8?B?ZHpaaFhsZmhuSkZKOXl4TUtQRWRWUVdFMXJTalRJbFNJUnFuYzJqYldXZFRP?=
 =?utf-8?B?bXU1ZVh5eVcrajdHVDRXenEwL1hBZHhxUDl0MmlJRmlPeG9NZVlZVDNYUVJr?=
 =?utf-8?B?ejZxeUdpR2JCMDVVUmlNL2FDOXhBUC9nR3A4ZVNTSTJQUSs5dXpwcEpRbFVJ?=
 =?utf-8?B?RU1MU1IvQjFDVDZlNk9TTFBJZ0R1a1lRdU5QUldCYlZUMEdPV1dFcnU0eVJm?=
 =?utf-8?B?czFiZ2c4ejlMeGxiQ3U0YjZSRVNEcDhNTEQvRnByY0h6NWp3M2dNS0d1aVJ0?=
 =?utf-8?B?L1BxQ0xiV0FTVzlPOHlZcUpYM2RESEs4MUlLbUo1ZWRhbkRYVXhLUDNjZXds?=
 =?utf-8?B?QUdwbkVVb1R2SkFUNVQvMHppZ0hmNFU2ZHZLSTNGMG5vQzNuaCthTUVhNmJl?=
 =?utf-8?B?aGlabG0wNUVac0dENlF6ODM5K28rc2FsT0Q0TktDMWxWWEp4Ty90MENVYmpM?=
 =?utf-8?B?TWVOaUJUMWxPVUZLQlZqSE1Vb0pZQUZDenR1WmpHNkh6dzdsZjJKQzhydXR0?=
 =?utf-8?B?SGI1RllyS2k0SjcyS3d6enZ4SUo5MEZ5VU9nQUMwbmtjanJETEtPVEdoWVI2?=
 =?utf-8?B?dHh0T1o4ckdBS3RvVWNRZzBFdUMwVHhBcWM5RkE5dWFvcjlHNGl3S2J6TXd5?=
 =?utf-8?B?VFBncE9jYmJXTjZSUmsrZU1oRk9lQkpBOUx2TWZWQWtBUUpKbUlQcEVCbUlv?=
 =?utf-8?B?V3RGMUwxbXlTMGx5SWo0cjhuN3Jkb3dkQVdSdFlNMkhINSswZm1RKzhkVGRi?=
 =?utf-8?B?TWVmbTVZaGp6QTBZbDdWYUlSTENGQnQ5a3p0K3kvekRXTk81dldSSkFFRnFh?=
 =?utf-8?B?ZEM2S2k2RW5mTEZuVUt2Zm5RK2FZQ2YxQUdWZHdqY1B1cnZOeCsxaHRYMmFh?=
 =?utf-8?B?WHhUaWUyYlkrNGhzYVZSMURwSzFLRjYrTkF1NXoxWUMwclJpNkFENkVnLzdT?=
 =?utf-8?B?T1B4NmpzdGxsV0F1R09GQjJvTmlSRHdwNExETEFaZTYvSFYxYlJSem1HUW5E?=
 =?utf-8?B?a2gyazZQczMwUUdDRXBVQSsxalkzWTZ5Njg2NGx5ZVl0WGo2WmRGSHQ3YVVx?=
 =?utf-8?B?cU1STUlFQXlNaThwUEJtckJiRTVyWUt4OEVnV3ZMcys4eDJ5WllVMG5PR1FW?=
 =?utf-8?B?U083MTVkYW9MYmozaUo5WVNad1YwTHdndXBiT3FlVTBnbzIwUVl6RjJEWHV3?=
 =?utf-8?B?N1hoblFheXM2aDcvQ3FUbUxETzdHTGRtanJqUzdCSDhGV0pXZzVtRUE3WmNG?=
 =?utf-8?B?bGJ5TUt1NGtzTEo1c3E4NURUWUk0RTRGWE5FNVdWb0txQmhZTnBHZkNZdUY0?=
 =?utf-8?B?cms2UVJURTFNeExNTWU0M2s5Qit0ampVQWpsWk4yUTR2OFZYMGJmY05RVlZw?=
 =?utf-8?B?QzZYbHY0SnRETGgvejhFZ1dZRzRQTlBBL2NURmpxR3hXbW1VY09WMnB4cjVM?=
 =?utf-8?B?bDJ3ZnA3QzF3NS8xM3ZaSGNsNHZXK2tUL1lqcnkwZkU0UjU3aFVyUGMxNjhv?=
 =?utf-8?B?ajkxdDMrREZzY2tLbUpnUVVOaXovUlVnUUtOWHRkdlMxVUZsaEtLanpMRWFk?=
 =?utf-8?B?VHBJdVArT0FHajFROTVieXk0MC9tR1ZYazlxY3M1RklyWDlFNmNFcXY1V0Fo?=
 =?utf-8?B?ZTUveUtSaEwrOGI3dGR1TDhWam96V0dBUkdXa0pJbko2MTlKNXJiS1VvNjI0?=
 =?utf-8?B?STF0MXV5VmhCRDNlOXJNUzA4MVgyTkc5engycVdXTi9pUnJMM1BQVXFSQW1o?=
 =?utf-8?B?RjZWWndrWHp2Wjd4SDQ3NUpvdXFyZmJ0Sk5DR3RoamorRk1iRXdNbURqRjI1?=
 =?utf-8?B?ODIrYllqTzZwYk80RStXMm83VlVhZm1Bbll6UEdnNlJhRmFEUW02NS9QQ1N6?=
 =?utf-8?B?bTZHVUtoajNPM2FoY0NjQ2xWcW4xY0FUQ254UUxZcVFEaVFTMkQzQT09?=
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c77852e-41e7-415e-800b-08da3e5804e1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB4436.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 14:08:18.7996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hh3McwXpvkwkQiCw2D3eSCePxHqhTVgtYRJp3fMlA+SioJkx8lxM2wN186KlFGvk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR02MB7390
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

2022-05-24 at 09:54, Linus Walleij wrote:
> When introducing support for processed channels I needed
> to invert the expression:
> 
>   if (!iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
>       !iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
>         dev_err(dev, "source channel does not support raw/scale\n");
> 
> To the inverse, meaning detect when we can usse raw+scale

Nit: use

> rather than when we can not. This was the result:
> 
>   if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
>       iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
>        dev_info(dev, "using raw+scale source channel\n");
> 
> Ooops. Spot the error. Yep old George Boole came up and bit me.
> That should be an &&.

Good catch!

> The current code "mostly works" because we have not run into
> systems supporting only raw but not scale or only scale but not
> raw, and I doubt there are few using the rescaler on anything
> such, but let's fix the logic.

Scaling something that provides raw but not scale *could* have
been implemented by assuming an upstream scale of 1, but it is
not. Instead you get an error in that case and thus no scale at
all. While that is perhaps not wrong, it is also a pretty
useless situation.

Scaling something as if there are raw values when that something
only provides scale but not raw also seems pretty useless.

So, you have my

Acked-by: Peter Rosin <peda@axentia.se>

Cheers,
Peter

> 
> Cc: Liam Beguin <liambeguin@gmail.com>
> Cc: stable@vger.kernel.org
> Fixes: 53ebee949980 ("iio: afe: iio-rescale: Support processed channels")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/iio/afe/iio-rescale.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/afe/iio-rescale.c b/drivers/iio/afe/iio-rescale.c
> index 7e511293d6d1..dc426e1484f0 100644
> --- a/drivers/iio/afe/iio-rescale.c
> +++ b/drivers/iio/afe/iio-rescale.c
> @@ -278,7 +278,7 @@ static int rescale_configure_channel(struct device *dev,
>  	chan->ext_info = rescale->ext_info;
>  	chan->type = rescale->cfg->type;
>  
> -	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
> +	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) &&
>  	    iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE)) {
>  		dev_info(dev, "using raw+scale source channel\n");
>  	} else if (iio_channel_has_info(schan, IIO_CHAN_INFO_PROCESSED)) {
