Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1062F3FB301
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 11:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbhH3JTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 05:19:48 -0400
Received: from mail-eopbgr40104.outbound.protection.outlook.com ([40.107.4.104]:22287
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235073AbhH3JTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 05:19:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVToKsii9XoctuemjbYNCT2G7c9JK6vTSrv9x+iq2OhO5jOIwXEmAVRVbsg+LDIp1GuSrEH0TZ2cIURMy4wE0rzCmWunwKFi3IuZVUhVhi/1Ttpx44MmVL6VRD0CbCDokfID5kzMJpfWrT5iVK93VquVidS+ot0unwxaF+Qm+rQpB3AA4hDfMFGhW/GWogNdIbM/q/wgZ6+f9eWKLpYYQTdrt5UQ/xL/pyHJP0BBZ/ogSvHDk/yMp49b0u9MuiLM4Q/A9jMY0cAN5uWwMPfCpXuCMMoloFuVMM7p/y//9PZ+OGlEV648DyA+w9rP3vMWIAQnFMksiaku+aIyaMjHpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/Q1lquckZwWjCsDJGAavPtnhQ31G9Ab8GOEqq2vf0Y=;
 b=LNeSPqKosHqZN1fmuG5YzY1YK+85J5uuKJC93x/BqQb+l0TRGid0R5A4tTRM524Apjdnzxr5QVMMS0WAJCiqebfMBd7vBGEM8tnBX97QySaYDQ848zlLWvoqDuCPxxJdqndi/cvGCIckVxhemiX8l9liRRpObGfT5XkSENQ/H8u+DLAB9+3Z6syfsfjlLirAJ+iuaeMChtNP3oZYvbckKuyOUzbxb1OwJONzE+lloDTewqh4iYJE8P6UVmIzEiSVtFl1Bau/rJig5BcdXqIBVQqFgMJZLll4p5+3p1lmfezc/vsoAyY8MAEiqGbKls/4vxRY2GT43n1yBrMQem91+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/Q1lquckZwWjCsDJGAavPtnhQ31G9Ab8GOEqq2vf0Y=;
 b=YAcgfSy18BynM0YiGmHBaxNkfxQZvp72yrz4tnttbcFUnWTkqb6fi9+3IF3sK7RHvMwymrkiuitds/wE7SuasNh/mto+iitObi9BVlaF7rntDGLFn1k+hpfmRYCD6JAfCNujVPO6O2ekHWQ3lK9nhhr86MkcBDodtat39rdNPnA=
Authentication-Results: mxic.com.tw; dkim=none (message not signed)
 header.d=none;mxic.com.tw; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2724.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Mon, 30 Aug
 2021 09:18:52 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a468:e307:d46:63a]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a468:e307:d46:63a%4]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 09:18:51 +0000
Subject: Re: [RESEND PATCH 5.10.x] mtd: spinand: Fix incorrect parameters for
 on-die ECC
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Frieder Schrempf <frieder@fris.de>
Cc:     stable@vger.kernel.org,
        voice INTER connect GmbH <developer@voiceinterconnect.de>,
        Alexander Lobakin <alobakin@pm.me>,
        Felix Fietkau <nbd@nbd.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>,
        YouChing Lin <ycllin@mxic.com.tw>
References: <20210830072108.13770-1-frieder@fris.de>
 <20210830104122.58f9cdaf@xps13>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <35e30f69-c6f8-ac9c-2314-f566190ac2cb@kontron.de>
Date:   Mon, 30 Aug 2021 11:18:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210830104122.58f9cdaf@xps13>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR07CA0072.eurprd07.prod.outlook.com
 (2603:10a6:207:4::30) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.30.113] (80.147.118.32) by AM3PR07CA0072.eurprd07.prod.outlook.com (2603:10a6:207:4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.6 via Frontend Transport; Mon, 30 Aug 2021 09:18:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a95a9ce-9309-4f74-f559-08d96b972eaa
X-MS-TrafficTypeDiagnostic: AM0PR10MB2724:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2724975C05AA36FB81F421D5E9CB9@AM0PR10MB2724.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uF7E/ZCxRROWdwEStKDyblNoLQbqeHsnwtJdl9cL536ZrH7hDbdBBj6ugKySdGIY2DvTpWtUIdOV0Yu7kzqinwcF52oPz1XR7JLYjb/20zSRC8Np2PrtOWQm9uIEeBTzF7vTfTLOrqaADUKX9DXS65A9VqiKeCJarCOrNhHQYhJbRfbe3CakuIfcNcPbifYy+I6mDYSAhyb7DUvku/Jfoze7XVJnqw4uJm2R8v6RHIz21pzqQBJuqdFdSIcVBOKkLyvN/S6B4uNtj7Mb0TrMJuA/1PYICPSOysZLmK/x59Dd/RbEGLuQPNRoS+TwFFbkf9/LEJmjF0jx3PGGDjHVdW65X0LpRmfrTFv+FPoY0Rd+ktHZ6eNpOB01OZ9RCKhp5qnFWyKD4V/j1DAiJUf/XbDptHBa4BbgtT4BnEwsteNSMZiGPERZWmmUfT0wNNuNWrehtXt+GoaWkrhNZiG60y4aeBxwEbYNbuNnmeoacsZR1XAl5+eHT7pbNj7M9FZo8R9Pb1GGLOAsWgt6DlPE4130L7CJ86+vDXCFa1D4TademqoiW1Xsy/Y0/AIjrPOFV52B/8JvqvwgYp7e4o+ecBz6tICMlNJJrbT/vBRSYtb57bekb0c9LBegiVsgyKrDoimS9v6E+Ep/QoxTQYGlsJrwYNF5Xrdb9f7Dub+Kp7rr87K6TpX/EYUh66XsnGM+fCduPYRc0r5KNK9bCstUJxbjnY7G5Re08h3yFQj6V0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(8936002)(7416002)(110136005)(83380400001)(66476007)(31686004)(66946007)(66556008)(53546011)(956004)(5660300002)(86362001)(36756003)(478600001)(16576012)(66574015)(8676002)(2616005)(44832011)(38100700002)(31696002)(2906002)(4326008)(186003)(316002)(26005)(6486002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnpVc1REeExUbTZvajdkOGRpa0VWOUxVaUxHamVuV3pwNFV2TzBvYzlzcTJn?=
 =?utf-8?B?SlYrWUFET2NaN1lZM0VVSU9lSUUyMFB6TW1CZnhWdTYrVFF6cjJrcHIzTVNJ?=
 =?utf-8?B?VngyeEt4MHp6NW9HdDRXd1EvNzVMdHM1WWU5ZTZDaUF1N1JDWTgrU1BIVEUw?=
 =?utf-8?B?eExNVFNROFE4a2l0b2ErK3NCWHRwbWhENnB5RHJXM1lrRGJHNHJROEhqWDc3?=
 =?utf-8?B?ZFNVejBkRUgrRDJ5UXlnYkRINzM2Vm1uZmFDZXRJQkxONnpRNnhWYTdBOHJt?=
 =?utf-8?B?ODhBRDBIZTBQUXErRjhXT1REbGFwWDl5T3ZUOTN6eGY3dkh6SXJzb0JucjNM?=
 =?utf-8?B?YXZGcVdaT3d3SldnQ2d3dDVubk52ZXBFL3A2RXRFV3Y2RUJhd3dGREhZYzYr?=
 =?utf-8?B?dVUyUFFFTTBDMDdja2poSTl2ZFlKRkp3QlFyQ0ZzMUtzRElmdFRzdnNoOWpz?=
 =?utf-8?B?b1BKbWU0UHpZRzcySVArRVczYk9uYlRxRmJ1bFRHSDlZVjJZeDFJT0VQVXNT?=
 =?utf-8?B?T3U1MGdkRVlOZkFXalBMa1NUOW5vbkt2T3ZhL0pmanFlRUxsUlRBd0F1Ym0v?=
 =?utf-8?B?ZDgxYmYxVkV1TThjN0FOb1lRamM4MEhwUzV1U29DazNQZVNhdUF2dzFRaC83?=
 =?utf-8?B?c3BxQ1V2WElhTkg3SWprRDVuTHYwOCtnU050cFpVZG1zREROYk5iY3pRMWdR?=
 =?utf-8?B?ekFZb0hPakQ1ZFNESjd3cGQ4MDNkMWYwMVRWbklrRUpuQUxFYllNK3R0MEFr?=
 =?utf-8?B?djNpdmtxOWFXSDhLQVpnVDVER3JFZkllMkR0Wm9NSDNKOVkyYVJ2Qm9IY0cw?=
 =?utf-8?B?RDE0Tk9SekJXSHBVWDNpM3hnOVNLWUYvWjlhV3JBN1lPZ3B4dWV5TEtIN0tp?=
 =?utf-8?B?MDNwcmVQS09kUkl4Y0JVK3pFMTEzc29CcC96UTh5MHp4R0w0cjV0ekJsRDZv?=
 =?utf-8?B?RnViUU9qeGRxSHZDdFJPS0w3T0RXcnA0STRiMHhFdEs2V2ZsUnQzbmpNdkMv?=
 =?utf-8?B?eDh5aHlrYjBMaFpSOU5wMGdMeEV0Ulk0Wm5QUHlieXhPdEVrblMyVnRMWWkz?=
 =?utf-8?B?c0FNaFhsd2pyNTljREE2ZVppNFdseCtyTXRwODAzOUs4bmV5RlV5TmZ5R21r?=
 =?utf-8?B?UzRybHlxVTJLUFJ2MmFEUjRrMThlQXB2WUcxc09LQmRzWit2aUJRaHJ1WTZu?=
 =?utf-8?B?VndiRmRJcFBzNWNrL1dpNHhuSHRoQVJWYWIzNER0OXpmY3A1NjZ0amRkaHkw?=
 =?utf-8?B?WjFadGh5VGdBSFJBdmFTYzZyWVUvTjdOaThQUFVaRmNXME9PVGxuQ0JhVkdI?=
 =?utf-8?B?cXJVYXYwa2owQjhMU0N6M0I3dWoyNW44am5qeUV1aWFjeDRzdGx0NHY3UFpR?=
 =?utf-8?B?ZDdUdkZjQVowb2p6Qy8zS2ZNaTdJL09SRU9ObXBRU2FiUjlWQ1NLd3lWS2x2?=
 =?utf-8?B?dTRxUUF4aVNGbkVXWWlmWkx5RllPQVJteFFoMXZXYWNGV05jRncwYWlHYTdC?=
 =?utf-8?B?a2JFZnhZRmlZbktnMWljVlZpVTlENDJCVGoxc1BGc0l0YXd3UEZMcjBMckd6?=
 =?utf-8?B?Zlh4cXRLSTlLamZwcFh0OHpLeTZ3RUllcktoekh4K2o5WnBLYmhqbkdudmlK?=
 =?utf-8?B?eXVKMEVjNjQxcWJ1UzJMRndzYWE4K3JnL2lQYUVTMHY3TVJ2VlFpaiszdThW?=
 =?utf-8?B?ZE93aCtjZTZrLzRjTjJYam9mVmNIbk5MSVhzNlNOV3NUekVXL2Y2Y3llaHNN?=
 =?utf-8?Q?EgQM39NbuxtlVRmCCuOEqv5Ogv8DVx49BR3JkRh?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a95a9ce-9309-4f74-f559-08d96b972eaa
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 09:18:51.7854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PfoA9cTpXZM/fw0022MbSCziLE+NJZ3psgY6djxRxKqRtiOS4KGQ3Uf3xWQX+MKNOePzr6nPM6mem9R9HqY7bUzBrIfSiiAMiWKVq7D+4q8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2724
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.08.21 10:41, Miquel Raynal wrote:
> Hi Frieder,
> 
> Frieder Schrempf <frieder@fris.de> wrote on Mon, 30 Aug 2021 09:21:07
> +0200:
> 
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>
>> The new generic NAND ECC framework stores the configuration and requirements
>> in separate places since commit 93ef92f6f422 (" mtd: nand: Use the new generic ECC object ").
>> In 5.10.x The SPI NAND layer still uses only the requirements to track the ECC
>> properties. This mismatch leads to values of zero being used for ECC strength
>> and step_size in the SPI NAND layer wherever nanddev_get_ecc_conf() is used and
>> therefore breaks the SPI NAND on-die ECC support in 5.10.x.
>>
>> By using nanddev_get_ecc_requirements() instead of nanddev_get_ecc_conf() for
>> SPI NAND, we make sure that the correct parameters for the detected chip are
>> used. In later versions (5.11.x) this is fixed anyway with the implementation
>> of the SPI NAND on-die ECC engine.
>>
>> Cc: stable@vger.kernel.org # 5.10.x
>> Reported-by: voice INTER connect GmbH <developer@voiceinterconnect.de>
>> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> Why not just reverting 9a333a72c1d0 ("mtd: spinand: Use
> nanddev_get_ecc_conf() when relevant")? I think using this "new"
> nanddev_get_ecc_requirements() helper because it fits the purpose even
> if it is wrong [1] doesn't bring the right information. I know it is
> strictly equivalent but I would personally prefer keeping the old
> writing "nand->eccreq.xxxx".

I think reverting 9a333a72c1d0 to use nand->eccreq.xxxx doesn't work as the eccreq member has already been removed in 93ef92f6f422 ("mtd: nand: Use the new generic ECC object"). So we would need to revert this commit, too. That would work for the SPI NAND layer, but might have implications on RAW NAND as it already uses the new generic ECC object with 'ctx.conf' and 'requirements'. At least I can't tell how this would affect the RAW NAND layer.

> 
> [1] We don't want the requirements but the actual current configuration
> here, which was the primary purpose of the initial patch which ended
> being a mistake at that point in time because the SPI-NAND core was not
> ready yet.
> 
> Thanks,
> Miquèl
