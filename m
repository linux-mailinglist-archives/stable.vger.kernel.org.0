Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552BF4981CA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiAXOLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:11:19 -0500
Received: from mail-eopbgr70133.outbound.protection.outlook.com ([40.107.7.133]:49122
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229457AbiAXOLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 09:11:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sgdml5adHxDTS9bN5gKdDSEUvqZW6hmhdpmPPXbemPxt0pRzl6K+L3xIUFV0DkzNhoJTAtAn2CGOD/9IKjPrhcDKub2hjVvl2vJEcM0jsnxzp1wEkT8YuPh7SU703GAXZFT7MiyDLhvv+XtwDDqJgJy8u/W2hLlJIqgA0LzsY9LxknwmwoTtkUpsCHHPo6QLN5r6J+B65/QMyw4cw09VQj46OWzRjTWU9FQKok8/BuOJWSYjAyBzb/3ORberXZZSd1Cr3DeK5vkXOOSbMnowtDZsRabZYJasKJfT52zrsapVt9hu6nLMFa/S5gPzysNNljXo+9LIf3Sk1xExQ611gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RoobhfEYJEkvWXIe5AJkCMwEuNmwpYX0qowigzorIvw=;
 b=O9EaL0gJRacRLFfMR7XnhGuhNlYFQcqNy7qmtaOYfGEVZmNxTqwvecuZAT5/US+T+TQXU+BAt8uTmfhKbTvxBDbM6/TKMUGMaMgMtAQM60ROB9x8+hmi4t8Yp6dUeT02Rcac8vxDoGu9QBtmLMUpenzmwOPQ4IYk4OKsTLU8i11t/awhdfKsjp8AdN+FEHXC03mI4NP1/eLrcrfPKCJI2yXxqyQivh3TlTInFoIilsi30jEeWLEYL9RNjmrlUSA09uO8rt9USNJDycOrjOWAzyCjp8zkSK2gtXhm3oeZom/SNEHiA47bdHVZOujaxb0XkZw8BF5Io7ROqpWuTw7/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoobhfEYJEkvWXIe5AJkCMwEuNmwpYX0qowigzorIvw=;
 b=bgCkBu12XukcbT4MwMTScVnceINLvltMiVnw+B8SH+CQLGdw3mvT76mIY293EK/cRa+lFTasdobIVfTmswB0gbxybPi2TegJ/FGyeMYfJLWoUmpTuFP4+xNMPxswjHyIy3ORQjXjMl9f1Uw2g4GgKVOVMrmvx8hrcvXhjVwL3Xc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB3009.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:160::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Mon, 24 Jan
 2022 14:11:16 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::b85e:6bff:84d3:e825]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::b85e:6bff:84d3:e825%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 14:11:16 +0000
Message-ID: <ccc99c80-6771-4f04-11d9-752b7b13a5a4@kontron.de>
Date:   Mon, 24 Jan 2022 15:11:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/2] Fix corner case in bad block table handling.
Content-Language: en-US
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sashal@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        vigneshr@ti.com, miquel.raynal@bootlin.com,
        Yoshio Furuyama <ytc-mb-yfuruyama7@kioxia.com>, richard@nod.at,
        Stoll Eberhard <Eberhard.Stoll@kontron.de>
References: <cover.1616635406.git.ytc-mb-yfuruyama7@kioxia.com>
 <774a92693f311e7de01e5935e720a179fb1b2468.1616635406.git.ytc-mb-yfuruyama7@kioxia.com>
 <9af5a4ae-e919-a545-809d-451217cf40f5@kontron.de>
In-Reply-To: <9af5a4ae-e919-a545-809d-451217cf40f5@kontron.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR07CA0002.eurprd07.prod.outlook.com
 (2603:10a6:20b:46c::20) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c6631ae-6cd8-46e5-aa9e-08d9df4362ba
X-MS-TrafficTypeDiagnostic: AM0PR10MB3009:EE_
X-Microsoft-Antispam-PRVS: <AM0PR10MB300961C8751D8A219570037FE95E9@AM0PR10MB3009.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /TcM6Q+n/gjqdkBY1Rwm8WEHb2w3sKk7o2wH9q9i4nfjrPEYV2cL2T+wHSonRl0risThtxSWcB8/KrDXYwsfozv91MqzuMulGMC0hTGsjZ2VXaWZ3moGUev8i1K6KhpEXEyS7+lqUCg4bAzZMx+vp331B9JD4CYER9QsFECuXd8opk5e4iklyr89VSfwSN4YFG1r+ytLeHfxc3rwU8cYnXgkKB1aErgybZ5dEiO/fpEqDMd+sF7RCQ9ogWkKA5qJNllEhthHiBjWK3Wj/wKcYXrqlk52pRPQnIfh6x6puToJHjF5dPCWP8PvHlllbvTuIK2UH27VSr1P02QZk9beAuQl7YNs5PSdqua3j6rE7TO1NKGYbbv20Z4wsTklG9mu8ozR5Kr9BVpY5rZx0xFSF0KtE+ccmMyMgBfZOwLQ+/Qwvxc8LrvomSmLGQXtlAgI1PBV3infLAMysMK3zPQV0i2RDovFKDTXdS64ajEcWL/fraV6GZ+/VroH7BNqICe3CAoP9zXaC7EOBxKR7XCCTU9Oq4Xm8Ny4c6uoEpQ9XTfL8ysvDPhvATcmORQarhfeaItKsVdqL7ljHlUE5vtpC6V+GoqzWzONsyqLzaXPRYhdwzuboFt6uh2QXdiNQo/5OsyVegP4Ks1lVoeI0it+/bijis7MGP9gHaTYMzU3p6bU26WLRgXcA6z+h0+JN/7qjVOvitGD2Yo0jJjoNrSg7lkodk4IKEmZzLamiNfutFw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6506007)(26005)(508600001)(54906003)(31686004)(110136005)(83380400001)(86362001)(38100700002)(53546011)(31696002)(8936002)(2906002)(4326008)(107886003)(316002)(66556008)(66476007)(5660300002)(66946007)(44832011)(6512007)(2616005)(36756003)(6486002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L294akNOVExvQk5yYjV5ZG1HbXFGK3RFY0Z5L01IUHMxMTA2VjF0bFJ3UFk0?=
 =?utf-8?B?QlB0NGF2QXNsN2x6Ti9JaGxwRmpHVEhiUDgxbXF2Szd1Q29QRnNjV05COHht?=
 =?utf-8?B?U0xCZzBGS3B1aFVYdmlUaWN0anhzNTR1U2VOOTg1c0QrcGkwMEg0RUNpRnBR?=
 =?utf-8?B?d28xenp4ZG1lZElOQmVNbUZxSFlJZWtUN3lJNW0xeXBiMU83S1pkYmNCY1Rs?=
 =?utf-8?B?R3lldzN3NFNQMVNxaDhsRDVRR0F6T2xUQXQyWktTdHVCMUpHODNsbzRHZzRu?=
 =?utf-8?B?d2dMR0NieXZBZnZUMVRHb29uNFZ3WUpNQ0NwSDQ3UExDLzMwWTA0cnQreXhX?=
 =?utf-8?B?a0ZMaUROYktUZUYxS2dadU9NVWRVUnIzU0J1M3Z6OXB3QVdlYXk2c2JJRTNJ?=
 =?utf-8?B?TXlnYzhlZHZMWmpvOXptS2xkT0FSaUhzRE43NzNleFNFZ2ZveWxqaWRQWDFV?=
 =?utf-8?B?VGxOT1VnRW5zdXhzYnpSQTk1THFsMUswMk0wM2xEYUZrbTJzVGR1UlkyYXdU?=
 =?utf-8?B?TCsrL0Y5eWt6QlZSeWhrSHFScm85UVB2c2JzbkFPTGtHV09adjQxZVJRcDM0?=
 =?utf-8?B?SURVb3pNRDEzc0ZhMmxGb2ozQnlNODA0VWVhSGw3cjVET3MvWTJUQnBZdkJ6?=
 =?utf-8?B?MmNnTWJKSmVyTDhMZnJNRlJ4NzF3cnBDVVdEVjE1Z2N0ck1VUy9QMGtaWll3?=
 =?utf-8?B?NGtsbnJQYVRjckFOT2NQOGIvYUJiejRGWk0vNXRuRXJ6QWFqZ0Q2VE9jWnNr?=
 =?utf-8?B?ZkdmVk0vQm5aOE94dEpIWkM3UEtHcVlrZDV5SHFlTUt0UEJScEJOYWI0QnhD?=
 =?utf-8?B?Ti95eXQ3R2hVbEQ0d1BCbTlzYVdVTHIzby9rSmh6K3RvdXFqQjc1dDVNWXE0?=
 =?utf-8?B?RTNzRDViWXE3T3hKbkJWUENHeHd1QkF2V0FqSFpLWVlZSnZkU24rK0dQcEIx?=
 =?utf-8?B?empjdTMvV0txdzlmMlJuZk1OS29XT0lSSE1CMnJUTjdwMW5JOG1hYUd2cmpO?=
 =?utf-8?B?RmUvcnZZTHdvWEt4WFF3Z3Z6WExYcDA5TEdtbXhIVXNqOWNoYTl4MzFTUFBP?=
 =?utf-8?B?dEE3TzhyVmZjZTFxOVBDU3pPRWhqaEVnVFJoeERQVmh1dHVOZ2xxRndaNm1s?=
 =?utf-8?B?MENhVnZMbTZRRWZ6NEtGOWEzMWtxaUxMaWlMY29xVDBEeEpQODVmMm9sQ0xJ?=
 =?utf-8?B?ZHVtU2RTZ0p2TE80OWJlTVoyUDVub1lUa3c1TDJzaW9CT2gxNlhpNUx5eklH?=
 =?utf-8?B?M1krL3ZsNGZWZzdQQVpCYVd0RmpGUDFrUEpjNzNreG1LQjZhOUhHNjJibHR3?=
 =?utf-8?B?YmQyYzNWUlZ6bnpzbTBKSVlEUjY3Nkl0MWxhYVdFOVUvRHVSTDBmODJ0WnZL?=
 =?utf-8?B?eGJuWVgyNEJmM1g3UUJFa2hPakIrRjZ3Z1lqVGNzZW5ZL0EwZm9JVXNPN29M?=
 =?utf-8?B?ckhFcVBIRzNnanhUWUhIWkRtMkZrdzdPL0Ixb1YwRkl5am1rYVBxaGEyeFpN?=
 =?utf-8?B?aDZ3RkhPa1NVdUFTVDJ5ZGhkWXpEaGo3Zi9QNTMxWWMxTVc5czc1OHVCL0ZU?=
 =?utf-8?B?OEpFMzJxQjhaMVBMd0xRSnNWMS9VRlFFTEVRVkhianhXUjNsam9ySDBtbXR4?=
 =?utf-8?B?a3cwajZvV25vaytOM2QxaWduKzJvTFpuNW5BQVhPUTNpVERteS9LYUxNcmNl?=
 =?utf-8?B?c1BNOEJPL0pYN2poOGdhK1Y2QjUvcUtOY3lrano1cEJqWTVDd1A5VWJucE9H?=
 =?utf-8?B?OGNrQXRtbzNCRWV1STFTbitJNDVZVEVjdVFWZEMrd3ZKSlAyZ2k4cHhmZEV4?=
 =?utf-8?B?YllpbnJVTjFkanJ1RXhKazB3VXJnSTRURDJ1OWt4RUdCZW51d3BhemlXZURh?=
 =?utf-8?B?cXBVbUdLVHVGdXZONGxWMzAwTTdvMC95a2ZkRjVKYjQ3bVlDWEhsdTJDRGll?=
 =?utf-8?B?S2tIOGZiKzVyQ012dXNQa09qM1V5Ty9DQlNUTDgwS3gyZkdDV0RRbCtLSlN4?=
 =?utf-8?B?L2lsS2lEb0tIdWFnLzJhUytldGRVLzZrSTd5VEtRMURNMG9LMWpza0M4NzdF?=
 =?utf-8?B?d1ZVUS9DT1hYbUg1amV4NlcvejU1dUlPYisxaGxZUVZyTlF2bGpwSkdqRXRT?=
 =?utf-8?B?ZXlkdTdzdVJZMFBTTE43by81THdmekQ1d3llQ3hncFVnZHMvcGM5UmxUTFNY?=
 =?utf-8?B?dTRmQm4zOHRyMnlNT2J4UGZkMUtvWld3MXg4QXpRcFlWUVh3OXlvSTFWNm5M?=
 =?utf-8?B?YlNtODJHalVXR2JFLzNxV0dBN1ZBPT0=?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6631ae-6cd8-46e5-aa9e-08d9df4362ba
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 14:11:16.5120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +q6Yc6mGrjzD/nVT2qad4iIZ4qoc2IojiDEyul9VELzJbf8pNxbWc4U8Kx0DeU0nL5yvmSyFYjFLRe+WhHYkiyHLCIrCuJxOEjU9GESL1Lw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3009
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

just a gentle ping for the backport request below.

Thanks!

Am 11.01.22 um 16:33 schrieb Frieder Schrempf:
> Hi stable maintainers,
> 
> On 06.04.21 03:47, Yoshio Furuyama wrote:
>> From: "Doyle, Patrick" <pdoyle@irobot.com>
>>
>> In the unlikely event that both blocks 10 and 11 are marked as bad (on a
>> 32 bit machine), then the process of marking block 10 as bad stomps on
>> cached entry for block 11.  There are (of course) other examples.
>>
>> Signed-off-by: Patrick Doyle <pdoyle@irobot.com>
>> Reviewed-by: Richard Weinberger <richard@nod.at>
> 
> We have systems on which this patch fixes real failures. Could you
> please add the upstream patch fd0d8d85f723 ("mtd: nand: bbt: Fix corner
> case in bad block table handling") to the stable queues for 4.19, 5.4, 5.10?
> 
> Thanks!
> 
> Cc: stable@vger.kernel.org
> Fixes: 9c3736a3de21 ("mtd: nand: Add core infrastructure to deal with
> NAND devices")
> 
>> ---
>>  drivers/mtd/nand/bbt.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mtd/nand/bbt.c b/drivers/mtd/nand/bbt.c
>> index 044adf913854..64af6898131d 100644
>> --- a/drivers/mtd/nand/bbt.c
>> +++ b/drivers/mtd/nand/bbt.c
>> @@ -123,7 +123,7 @@ int nanddev_bbt_set_block_status(struct nand_device *nand, unsigned int entry,
>>  		unsigned int rbits = bits_per_block + offs - BITS_PER_LONG;
>>  
>>  		pos[1] &= ~GENMASK(rbits - 1, 0);
>> -		pos[1] |= val >> rbits;
>> +		pos[1] |= val >> (bits_per_block - rbits);
>>  	}
>>  
>>  	return 0;
