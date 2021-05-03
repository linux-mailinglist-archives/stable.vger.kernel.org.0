Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF3F371675
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 16:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhECOOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 10:14:17 -0400
Received: from mail-db8eur05on2100.outbound.protection.outlook.com ([40.107.20.100]:61760
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233908AbhECOOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 10:14:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfSF4IL+c4/B/NEvSDC2Z1n8h9aMHZE9ZWoMfUO6eJMgnciYrkRvn+rThlrL4tUlNlrXURIr3iVGqfKVEekLkTL0mXev/JH3QC1wYl+SewiTa5JjtwZSkTDvpHj1m0N3kXweaP+sDYegBqkZSBFBRtnXS+fLC+e4dBTczOA9PYNIWEZIGRoBiOVI+w53OH0Ac7OSngYvWh9cdWbVLsGXQEVHUAdG/if6zy8z0GTV52+4H8X+sspLccZDmnFovAAi0+fla8rCOsul384alUR6zcOr1NSRDfoilOKASKIgPbFZd8S+JLbHu0NDhnOu75FvMNfYnJ1+2oPvpW8NHChwwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shZ/szXJW9fFCvckgeL3I+AbvYFaKRnPaRSbI7Ltsx4=;
 b=S55JVGgKsaNO5tGp+w2b395xzxQX5MD4kXgpM8o7ATYJEbraawiiNGHKboXse+QQkRQFedF1FKjK3o56a7oJZW5IgZMQoKigUxYlEc3lLJvDgdN17fS0ZVT1eWWvqdWMhjWljYr86jNhjz5DwERdxMnPKCZk81FKdqcW6yrxBxH0bOmZ6NPfFTWZB+i3+C/oh+saOJskEbneUZkA3MMRR2r/QP8GopLWIGqgoGPuvzwyuBkbjwCMllqTYLdGBREItLRX5nMzsmT34ab58pXAqlMe4pxg6DQNGob0AGYNyYQ7IyKd2BTBZyXpLyy4Pr6qtGpPWCA/XaLderpvDLA0pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axentia.se; dmarc=pass action=none header.from=axentia.se;
 dkim=pass header.d=axentia.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shZ/szXJW9fFCvckgeL3I+AbvYFaKRnPaRSbI7Ltsx4=;
 b=JYW2NkhfkhhCckJhP8dpRWzQSAhXsvkzokF3tfDYCTZvSUSuAHNV95BZKiyQUfvs90doocUh4DO9Pj1ObtM/OiQtk6W3mwrAiZuo3Ism8PXCrsCSvamCez37/pf8Him2wzizLtjdhEfA39pKfxJJ/6jz3w5LhJGc25Yn7B3Z8YQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=axentia.se;
Received: from DB8PR02MB5482.eurprd02.prod.outlook.com (2603:10a6:10:eb::29)
 by DB8PR02MB5611.eurprd02.prod.outlook.com (2603:10a6:10:eb::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Mon, 3 May
 2021 14:13:20 +0000
Received: from DB8PR02MB5482.eurprd02.prod.outlook.com
 ([fe80::d47d:ca8c:4fe6:3908]) by DB8PR02MB5482.eurprd02.prod.outlook.com
 ([fe80::d47d:ca8c:4fe6:3908%3]) with mapi id 15.20.4087.043; Mon, 3 May 2021
 14:13:20 +0000
Subject: Re: [PATCH 27/69] cdrom: gdrom: deallocate struct gdrom_unit fields
 in remove_gdrom
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable <stable@vger.kernel.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-28-gregkh@linuxfoundation.org>
From:   Peter Rosin <peda@axentia.se>
Organization: Axentia Technologies AB
Message-ID: <223d5bda-bf02-a4a8-ab1d-de25e32b8d47@axentia.se>
Date:   Mon, 3 May 2021 16:13:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210503115736.2104747-28-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.229.94.233]
X-ClientProxiedBy: AM5PR0301CA0032.eurprd03.prod.outlook.com
 (2603:10a6:206:14::45) To DB8PR02MB5482.eurprd02.prod.outlook.com
 (2603:10a6:10:eb::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.13.3] (85.229.94.233) by AM5PR0301CA0032.eurprd03.prod.outlook.com (2603:10a6:206:14::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Mon, 3 May 2021 14:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 337449e8-5dc8-4b7b-9fee-08d90e3d9ac7
X-MS-TrafficTypeDiagnostic: DB8PR02MB5611:
X-Microsoft-Antispam-PRVS: <DB8PR02MB56116412E1B824D33247A652BC5B9@DB8PR02MB5611.eurprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +PIa0zhqjMM0/6as8H9XNttk0b414AktkVEZG4dqNVR1eBoEJoGZfG0Pr7mvZTIblNvG62GMmsK8e5KJ0p70vyKblmlQN9VVn14cgp4450okICb6KByi28sXrAPw96wbDoFe+Q1Fl0IaovMDid2ccAWP1UkRMuNQTiyXUFO45a3RJf1MzUTHIrS8mcbECqIq2911IvHt1Aex4hzZNP9uUmVCkPpMURP94KtVwM4cl+tLDNi3ZDWyEsp/gH4kdKTCtR4B+cRh81eo67YX4lQ8BSpWYGB2B0zjC9834zkYcBnO4/U/DZw9vlwvimkmDe2VTj+fyGDqxTKfzE+JACbuCEuqVxTw8GPa5FvpAIaWascbg6bVRGskwoYXSD7LEJPvrhXMiJ3fw5VYanwTyuZHNEY1w1PxaslrVdYnz4fd97yBp4Rq81kA3WwyVU1wRbysPRvQRRauKNpFWxRWmIUgAjXj2VdWNu49hOh4N/GW2rYwFHr8Eqo47uW05UvPrnaYF7fQqODrJGb6ABjXbdpXcwlhlIg919N5TQwvPN4SGjRnLccA2WR52mqHKXDNIVSo+HKIWzhZo+61rcXtv+tx7bulHpoG2RE91PmSdg5xfyYIWqQ1BTmVIJeQ9A/5q4gx8ECwnafzObDcD1DBVSuhrTnipGxeOZFDV3iDn0fL8se0ggsQdUHZWS1A7r798fjg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR02MB5482.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39830400003)(396003)(83380400001)(8676002)(478600001)(8936002)(16526019)(53546011)(2906002)(956004)(186003)(4326008)(31686004)(5660300002)(36916002)(6486002)(316002)(26005)(86362001)(54906003)(66556008)(66476007)(2616005)(66946007)(31696002)(36756003)(38100700002)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TXB0bmVqQ1dFeTMzQTdiMmVXSUZUZUZtTjNSamVoeWNFSHhtZjB6LzVIRFhO?=
 =?utf-8?B?NzY0UGowY2ZVaWRyZWt2N3NoMitDSzQ2YzI1QUk4eFlBWFVRelpQQmFmMDBX?=
 =?utf-8?B?a0QwWGJpaVIzQ0dkSEFCUFJmcFJpeWlsUGdBdjMzcGNlOVBJVkhKdkZMeGNB?=
 =?utf-8?B?UWVFYS9TbTEzWEFWN2FOMWRreXpoOGpOSTVmYkh2SUFiZkpPTm5tL05GZzRR?=
 =?utf-8?B?SWJka01nSlluOWV0RncybGZ5UmFhbFJvTTRQRjdHZ2gyM0NONWcxdUZGNlNz?=
 =?utf-8?B?a3FxUGhZRjdaNEdpZUxwVEJQbzBPdFp4TjUzVlRYT0lBcDk0d1JzVVNScjNK?=
 =?utf-8?B?VWlydW5ORUZOS3A4eFdnLzBaZmdtTnE4aFQvNzNXRGh1WjdnMk1ZWlRiSVY4?=
 =?utf-8?B?ZEc1MHIrUjliUGpXbkFOLy9FQm1MMVVMempoUlpEQmVnOVRmLzUvdCt6VHA3?=
 =?utf-8?B?aDJCQmxmNWFXWkUweGcyNE04WDFLeTlIRC93cEx4M0d0TCt1TXBCRVgvbGZM?=
 =?utf-8?B?T3pkSGYzL2JoUFZ3ZnFPUDJVNDY5bzhoWGg5V281QjJGUTVXWTBsa3lxRmt2?=
 =?utf-8?B?MUc4Zm1UeFZPZDlNRzZlS2hkY01SS1NsRTRPTU96Z1pNTkJDYXFPQ0JpVVU0?=
 =?utf-8?B?eXdtWS9tWUYyUEJyTDUyWnZTT3BIeG9XZWNFNHBaQmpBeUVCTkpzbGN2Vk9q?=
 =?utf-8?B?cXhaUlFndnlveGs1RFZlS2s4a0NkMDhTQTB0Zzg2bWZOWCtQOXQweXlmc1Zr?=
 =?utf-8?B?eS9NTHpKWVNTZUQ2bi9MNXNWc3Z2VnBGanRVMEN5VHRLUXdNM0RIUXJndzMv?=
 =?utf-8?B?S29aSlFuYUFrUXZoc2Q0Z3RFZ29QTXJabEh2NzVaeUY3YlF4YXl1clhUVU04?=
 =?utf-8?B?ZmwzMXVLeTNBaDdObVlONFJyRXNKVkRpKzJGSGZGMEFqbEpDY09jYTdwMFdp?=
 =?utf-8?B?U21QRGJsMUU5dmF1NTBlRHlRNERKVm80UU5Fc1NPWkVRMGFFTFQ2eVFJN2ps?=
 =?utf-8?B?Sk9WTmdIYUxmSHBUUnVCbFdjajlUVzVKUlNvVnVhVmUyb3pSSG0zeGJSdDJz?=
 =?utf-8?B?d2dyeUxBQTF2cEIxbENYSVlJVlJxalVIdExJK3ZGOFY2bDlyU3JlRlczM0Zv?=
 =?utf-8?B?ZHArK2RSVFVrY3M3TW9FYmVIdVcvaDVZenQwOFIwcVVtVy9tRzBuejczZ3g4?=
 =?utf-8?B?cEZ6QXZqU1VBenZpc3o2YWJLeUVTZXk5dm5jMnV5bnBFVER0dUNJa2hmK3Vk?=
 =?utf-8?B?QUQrczRjVnRMU2pUSUM3V0JvS0x0YUFBblVqSndheGZRZVQvdVZOeDQwbmRl?=
 =?utf-8?B?cENZV0I5QUNoNkg5OGxGZXlEbWZEL0JjZEtjQVBvMmxUUkZCcmlMZ0NJcnEy?=
 =?utf-8?B?MjNSdHFJTGNZNG43UWh0dEZETlpBeDkwRUE5WmpKY3o4NXlHWDFJaUNBdGx1?=
 =?utf-8?B?cE80KzhCU3VwVkM3Y1MzeWlPRVBneGkvVG5KelBzYjlRLzdsSzltSW9PVGJ2?=
 =?utf-8?B?M2h1bVlFdFh6ZG10MEZXUSttZ290YTRaMG1RQjhERldSUWJHbWx6ZHBQSmla?=
 =?utf-8?B?cGJYdTlsSkg0cHlJQ0ZkU1VXaG0rQjQ4d3JyQTNJZUpvV09SOHZacmZyQlgv?=
 =?utf-8?B?NERKTkVKdnFEdllnNHRib0JKTzVJWlJLY1g5N2hLeW1Tc21WeHhFZjRvUTZE?=
 =?utf-8?B?d21UeUluRTdaQzZNVUludys1TGFTTjhWZVhERHpmRTNXSlRGdzE2cHQyN2Vz?=
 =?utf-8?Q?RD8RN2eUiqtNsNwe2VJ61bB0vlN/FPAzhTpm9tr?=
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: 337449e8-5dc8-4b7b-9fee-08d90e3d9ac7
X-MS-Exchange-CrossTenant-AuthSource: DB8PR02MB5482.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 14:13:20.3742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/Uh1eS5qK5vHk4POGZNF4IUJytdF88qBpYpIASBKZXdfRYvXqvsQ2PpyAiCB5Vb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR02MB5611
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On 2021-05-03 13:56, Greg Kroah-Hartman wrote:
> From: Atul Gopinathan <atulgopinathan@gmail.com>
> 
> The fields, "toc" and "cd_info", of "struct gdrom_unit gd" are allocated
> in "probe_gdrom()". Prevent a memory leak by making sure "gd.cd_info" is
> deallocated in the "remove_gdrom()" function.
> 
> Also prevent double free of the field "gd.toc" by moving it from the
> module's exit function to "remove_gdrom()". This is because, in
> "probe_gdrom()", the function makes sure to deallocate "gd.toc" in case
> of any errors, so the exit function invoked later would again free
> "gd.toc".
> 
> The patch also maintains consistency by deallocating the above mentioned
> fields in "remove_gdrom()" along with another memory allocated field
> "gd.disk".
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Cc: Peter Rosin <peda@axentia.se>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/cdrom/gdrom.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> index 7f681320c7d3..6c4f6139f853 100644
> --- a/drivers/cdrom/gdrom.c
> +++ b/drivers/cdrom/gdrom.c
> @@ -830,6 +830,8 @@ static int remove_gdrom(struct platform_device *devptr)
>  	if (gdrom_major)
>  		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
>  	unregister_cdrom(gd.cd_info);
> +	kfree(gd.cd_info);
> +	kfree(gd.toc);
>  
>  	return 0;
>  }
> @@ -861,7 +863,6 @@ static void __exit exit_gdrom(void)
>  {
>  	platform_device_unregister(pd);
>  	platform_driver_unregister(&gdrom_driver);
> -	kfree(gd.toc);
>  }
>  
>  module_init(init_gdrom);
> 

I worry about the gd.toc = NULL; statement in init_gdrom(). It sets off
all kinds of warnings with me. It looks completely bogus, but the fact
that it's there at all makes me go hmmmm.

probe_gdrom_setupcd() will arrange for gdrom_ops to be used, including
.get_last_session pointing to gdrom_get_last_session() 

gdrom_get_last_session() will use gd.toc, if it is non-NULL.

The above will all be registered externally to the driver with the call
to register_cdrom() in probe_gdrom(), before a possible stale gd.toc is
overwritten with a new one at the end of probe_gdrom().

Side note, .get_last_session is an interesting name in this context, but
I have no idea if it might be called in the "bad" window (but relying on
that to not be the case would be ... subtle).

So, by simply freeing gd.toc in remove_gdrom() without also setting
it to NULL, it looks like a potential use after free of gd.toc is
introduced, replacing a potential leak. Not good.

The same is not true for gd.cd_info as far as I can tell, but it's a bit
subtle. gdrom_probe() calls gdrom_execute_diagnostics() before the stale
gd.cd_info is overwritten, and gdrom_execute_diagnostic() passes the
stale pointer to gdrom_hardreset(), which luckily doesn't use it. But
this is - as hinted - a bit too subtle for me. I would prefer to have
remove_gdrom() also clear out the gd.cd_info pointer.

In addition to adding these clears of gd.toc and gd.cd_info to
remove_gdrom(), they also need to be cleared in case probe fails.

Or instead, maybe add a big fat
	memset(&gd, 0, sizeof(gd));
at the top of probe?
Or maybe the struct gdrom_unit should simply be kzalloc:ed? But that
triggers some . to -> churn...

Anyway, the patch as proposed gets a NACK from me.

Cheers,
Peter
