Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70EC66AFDD
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 09:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjAOIKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 03:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjAOIKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 03:10:33 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4352104;
        Sun, 15 Jan 2023 00:10:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiCC73LJN7EcA4h5ty37prcB5NLn8pNkozCEc3SukWlULsh0cNKvSYAz/V7cDEqwLYqE/Q7j2qG3DCSknjQliZvteUVTh8KA0dA5HMaiwHXFbEKD/BFcyoGgCAxWwcDsJHTi2dlF8oG4RK7Qpbv4FhUP/ZqjfMDbQB2w157MmJ9towZaEs4WwEfoJTZg0zxWLH4ANPRZfajnE0xHEEf/7QsYOxdNqpnnuSglB3/ldps2gIicNw2czV9QkuEI1cxdSzSCLym2/gVKRRGBkaKs96rJ0j4YBTx94cm1CR93zpOb3qv5JFAR80nZl/R7Ua4oiG3m63SN/DP4mfcNgLF6oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWLLvi3cyRipsi82fKt6R1PKuKSA6cG6ZiphzFJ7bbk=;
 b=hLMBWwJhJcggKNosVZDkSz3hsqmBx6Yo4rx6iN0qHbU34hG6jO2pwllTMHUgtr7oKIHt4qHj2pRQS77dmA88V5wzqxao6tcWhZE1xV/86ZtQcOw/KUsC+u0qNwvroN/MY881kZoAI5xUhPHH/hyLf35yshnc5LExvXYlgSny54OMt/qY3+q79Nr3hmmjqOfLSpUyBerUMVT2N3FIMnNIa5De0NZCuAFKr4KbSvYb2+cHP1ULbFkBD5wOTZIYyNW6dLaIL3WEMcGlv+Pr83/w/n9/KgyNSzu7NIBcTwoEJiVbQbL+VycR9uhg8X7HhmYVBYEBDEoeNIdjaUIrM8bsNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWLLvi3cyRipsi82fKt6R1PKuKSA6cG6ZiphzFJ7bbk=;
 b=beHURAvlLjWjHSBmwAnjbuW//LNca+WtBM8rzT4IrGg2DmCyc8hFt32L3YMWZ0RiopgH55w7feW+R72G5JjFGFyB/QK6yRYwpnPPaGU5C4+UbcHD4L8dR4uIlFff/bcl66s0MB7hZnPUYSPCLfW4AHFjn8tfqa004EMkRzY2rA151VUvUbj9HXWskF4i2xnc4DqRCvLuukClUinRO66arzyWhwmeDRgncFam4sJv5sCN8i2cLOalqLwGj+A9xmCpjnftFpPaume9j+fLv/t9bgPkBT3VTrJTWbiATekMDZ6tt4HO2xYrEWCVmGp0KvrHvnUm8xSsO6zI3CyahjVhJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by CY8PR12MB8193.namprd12.prod.outlook.com (2603:10b6:930:71::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Sun, 15 Jan
 2023 08:10:21 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::db1d:e068:3fd6:ed08]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::db1d:e068:3fd6:ed08%6]) with mapi id 15.20.5986.023; Sun, 15 Jan 2023
 08:10:21 +0000
Message-ID: <dee7f7b8-2566-6452-6f71-1fe05216a774@nvidia.com>
Date:   Sun, 15 Jan 2023 10:10:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101
 Thunderbird/109.0
Subject: Re: [PATCH 5.15 049/230] net/mlx5e: Check action fwd/drop flag exists
 also for nic flows
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dann frazier <dann.frazier@canonical.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Ran Drori <rdrori@nvidia.com>,
        Frode Nordahl <frode.nordahl@canonical.com>
References: <20220711090604.055883544@linuxfoundation.org>
 <20220711090605.473699898@linuxfoundation.org> <Y8CEv90mCZkmuFAq@xps13.dannf>
 <Y8Ky/3oq4HG0pe0x@kroah.com>
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <Y8Ky/3oq4HG0pe0x@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0600.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::20) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|CY8PR12MB8193:EE_
X-MS-Office365-Filtering-Correlation-Id: c1df6c2f-d978-44d6-8244-08daf6cff1be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJwIroBOfRu9C9mL0EKGoPDxxZkqXyeytoWe/VUBNDvilLuvIH6QRx5bjbOBUHf0COyktGqZ6bv992EHC73fLzWAtDxmi5f+ITYLTOyoOSy9kK4gc3b6dr9bFzGiIjCV3Yw64DEefNkCMdjCCWHDVtcyMNC0ahety/f1eNodnCUTvUr5AkALuV8KSBxaD0Q71jEoDIKlf0B9xvpKncbiEHzvGqQ8M64MhItk8OTRHqpQEcFy3mFO2d/PLYjZ1MEodZUjgZnV7asil80r6dEmjC0WnZ2+R3qPx5LT8aLRkhzTN4NHqnsaYpglk+aUdDQJMUM6zZMRhRQvMu4j1E9lP8X8VwnxbbymDJwfVJPZVIPxAm+FYNpCXUcr1lg2p2K96o7fZAJGNx0+N6k9Mqp77lVhAYRtEemCXnAPwX6m8FRvGhmQQ1UdJqVSYOGqUYnE04wbRsbihAAyRSnLWZuzTCDQdxZ7p0emcJ8s7lYMStOX+cOhjghKAG64aE5jQf5hq9Lg+23DbqsNQjaS50G8OsG8wenwr1/TuWon7pkDhQbXk34wk7sBf4N50ScN1AbidQxsrKT1ty1/s4a1hWR0ybxrtuZpLSTzEamDMR38Xj8A6qO/xGnJKFWGRJhiA/4jx5QYppbJ4IUjCXiielDP4beweQg/KR2l5Ul8aV0QEoB+iiGEv4EnPTdELOfyJPpbo0Dv/SNlpqfdbOtvz1vh8MhV8Afsi2vINWT+I3PyZgc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(38100700002)(8936002)(5660300002)(31686004)(6486002)(41300700001)(478600001)(316002)(8676002)(66476007)(66946007)(4326008)(66556008)(36756003)(86362001)(54906003)(2906002)(2616005)(110136005)(6666004)(6506007)(53546011)(26005)(6512007)(186003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0tHQ3duNXJiTkRIUGF6RlRYZFBMay9yRGk0R0g5LzlucFByQVdLcUhZcS93?=
 =?utf-8?B?Kzc3VnNtYWlZeXkrZzd6NzRsUGxOUE9sOEZzV1FWYzQrRlg1YnRlSGlTQnQ3?=
 =?utf-8?B?UDdnQUVlenF6aThlSzhKZVFxM3VqakZPQ0NKTGRZNE1peXFWTEYwbmVpLzZK?=
 =?utf-8?B?WFQ5MkR3c0tra0RDQWZKbkR4bElGYmloaVdSVDNXbGV1UWhaMDYwSWdJR3Ry?=
 =?utf-8?B?NW1iUjJMeHRxTms2d2tWd3JETXFjKzlqMEl0NUxuVmdRMS9vSVVSOXZKaU4v?=
 =?utf-8?B?aUNsS2RydFlaeUY3YVhsZG96TVlmRFMvL1VlODhycTU1QkQ5SVBZckh6SGRl?=
 =?utf-8?B?Y2d4cS9acUVSSzQvV24wSW40RXJqcUpNN2trVHlmcU0zb3BFTTVhZkw3Y29R?=
 =?utf-8?B?MWlxK3J1RXBNUnRnV2VYNWNTVWRnenlUSDBKdHBMMWFrTFVadnZEU0dIVkxo?=
 =?utf-8?B?TmZSVXk2alBidWU3VGNRNnRSY2UwTjZxSmZUc0tlRFpsTDExRXJKSFlnNEJw?=
 =?utf-8?B?bkxsbzJYaW1qcEd2Z25JNktoQzg4ZDI3bmlVQVFyRFpUNU1IblJkU0E1emgw?=
 =?utf-8?B?Qy9jUHV3V25uNUxFZGl0UlVQNTBCLzNqL3FTc3YzSm85cHRDR3ZJdDJaeWY4?=
 =?utf-8?B?dDlJeU92aFo2ODIzejR3SVd6dDFNSmV5Y2E5RnB5WUxnNU9NRXU4dHcxQk5Y?=
 =?utf-8?B?blFuMzA0cGxRRVpNclZPYjJ2d0xlRFIyR1grNVl2L2JpWENSeDN3eGlvekhv?=
 =?utf-8?B?ajhuVmlCMU1Mcm53VGpqSTJsVXJTcGVnS2Y0QVpxcnI3S3R0bXljOUppb2Fp?=
 =?utf-8?B?RWtGc01BQjBRcnhUL29sVldBNjFBUDNJWDNILzJ1eSs4T1hNUWVtNXhTRkJj?=
 =?utf-8?B?ZXBUMTh1WmgzU0U0Mm5uRG9aRlQ4RXFtVFJsemNwbWNhN2RBV1NxYWpsZ0I1?=
 =?utf-8?B?L1ZsNXJQVW5UOTk0KzJxdXZheEpjVU5aOERCclAyWnZzOWdJMHdLN0dWbGlP?=
 =?utf-8?B?RmE2Qjh4MGVreGhITHVabnlNM211eGpNNmwxTXIyMlJsZDA0RnR3Q0poQVA0?=
 =?utf-8?B?YTVtb3ZqN280L20rVUdjT29jc21NOFBEckcyUW1qdW9wdWFnMEZFWGEwcWhR?=
 =?utf-8?B?dTYrS25hVnVKcmFsbDlnWGR5Ky9vQU0waVY3cHprRkNkUnZHc1ZBVmwrVXZw?=
 =?utf-8?B?S21MUk1Ybzh2TGl0SUxwNnU5M1p3Z2EySzhUZ3JJUG0wOG8vY1FVYXVvck52?=
 =?utf-8?B?NEwzU1JHRnNDYnBzOUhKRW40TDA0VzVaQXRhQVdtNVRLZ3ZCcStHc0F4ZGQ4?=
 =?utf-8?B?dHJGNk5IeGZ2WXBET2g3ODhUMmM0cmNrbTB6eFBWeGNwYnZqS2tqOWZVZnZI?=
 =?utf-8?B?RjNsZ01ZQzQwMWVyZWVpTzdlTVVzaGJoQ0hPYlg5YTJjbnJLOTMweDV2N3lI?=
 =?utf-8?B?Y2xpZEdtbE9CSGZFa1RBa24rOXJCWWtZRU9jbjE2aHpPcXJoRjd6cUZBdFo3?=
 =?utf-8?B?SmsxU0NYcExSRisra3hnSktEQ2RnbU1Tc1RyZVNUN2Vva1R3RHBtV08rQ1ZJ?=
 =?utf-8?B?UEsweXN4OEVEQzNLZnRpS0VVeEc4STZOYjhzYmlWdi9qOU9MU2tNZnF3SU43?=
 =?utf-8?B?WXpSNncybHdFbEVQZnBSakY1dUR1U3RTbXhHM3crZGIzOVFzR2hJRUMwQjVs?=
 =?utf-8?B?Rzcvb3p0MHpwdmV6a0JMWXk1UmVDLy9kbTRkNzM5K1dqVmhOaDNWQnJ4UlRI?=
 =?utf-8?B?V0VXblRRaXIzSUlzOElHV2psZUNmOVBpUUtxVHFTODBJU0YvbzZxS2lBOTFI?=
 =?utf-8?B?ZWJIZndZOEhVTGtDU3VCdTVEWlVOQU9WSVFVeUlVcndRVW0rRlMwSWk5VCsx?=
 =?utf-8?B?cVVEeVhkckpYa0U2N3ZyUy9Qemc2djM3QWFtVkRzZW5yWGsxM2lzbld3UEJK?=
 =?utf-8?B?L2NjaUExcStKcjJ4NVVaZDFYUUhxelpZTzlmVlA5SWR1SU54Q01DMXpqVkta?=
 =?utf-8?B?dWFRYnVZVllkREJGS0JmOGI4S0JyNzdYNXh0aUVUM0pRSGpEdmZ5YVdEdmxq?=
 =?utf-8?B?dlFBOFNhYWt6bWhLTktxcitVT1lvSFRnemk0Zll6MWRaclY5Tm05aHdIRnlp?=
 =?utf-8?Q?8k3A+gPFXeYxepUxZ8A47W/It?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1df6c2f-d978-44d6-8244-08daf6cff1be
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2023 08:10:20.3772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CgGj8pD2H88oBfO3yD+Pz1GiLYQNjOyRhFyq68xchQsMFzqD7DTnqqAGuJbW1xxi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8193
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 14/01/2023 15:49, Greg Kroah-Hartman wrote:
> On Thu, Jan 12, 2023 at 03:07:59PM -0700, dann frazier wrote:
>> On Mon, Jul 11, 2022 at 11:05:05AM +0200, Greg Kroah-Hartman wrote:
>>> From: Roi Dayan <roid@nvidia.com>
>>>
>>> [ Upstream commit 6b50cf45b6a0e99f3cab848a72ecca8da56b7460 ]
>>>
>>> The driver should add offloaded rules with either a fwd or drop action.
>>> The check existed in parsing fdb flows but not when parsing nic flows.
>>> Move the test into actions_match_supported() which is called for
>>> checking nic flows and fdb flows.
>>>
>>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> hey Sasha,
>>
>>   A contact at Nvidia tells me that this has caused a regression w/
>> OVN HW offload. To fix that, commit 7f8770c7 ("net/mlx5e: Set action
>> fwd flag when parsing tc action goto") is also required.
>>
>>  I'm not really sure what flagged this patch for stable, so I don't
>> know whether to suggest it be reverted, or that additonal patch be
>> applied. Roi - what's your thought?
> 
> I've queued up the additional change now, thanks.
> 
> greg k-h


right. thanks.
I'm also not sure why the first commit added to stable but
it caused checking the fwd flag earlier in the code and
the missing commit added the fwd flag earlier.
Both commits were in the same series when submitted.

