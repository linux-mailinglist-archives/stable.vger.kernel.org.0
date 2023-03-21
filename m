Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40096C30DF
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCULvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjCULvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:51:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E895B126E4;
        Tue, 21 Mar 2023 04:51:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYBWZyInl3FwLXDIs0d4xVd7ViI1KXi4DdGVe0lnMpfG8uYq3ChGo47+uYGUdnCNY9ayoBEkW+TiShXEmJXOWVTQHUq1uuhN3I47VioNNv84QnuxbhgvXIZTnLbiYnmI527rx0qWzWu24qg8NnrdHujNYPMKO0DLpYiRxd/dNkZ+GDHN1Fuspzq4DI2mfV39geSPMAI4m+g5IkJxX94kB9cddgQNhiH2awKZ3hA9aK4ZtuiPGbAF8sn0M6dyJmEEr38w9oVUnE8Ynst4x5jnd605NyyygUc+5/QB6lZaf3j2j8zfTjz4TCo+LFE16oEttJ+BnX2Yvf5coxokW46fuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tg/GB6ZJi6FpSnHgytRJtHBwrZo6Iqod1Y2oHaaQn5g=;
 b=VQKDGY+kvC33/kF0HVAwLAjtzbbODYGDRzG4/BeprN1AaNIhGL4g+npGTOJYvLo3TgzUtwFtM6kyP8tHpweBJbZ/kHB5NLdy9FgI+sDzg30WuWw+d9bAgEtMKOAQAo5/tCOOMqP+11rkGXXGyrrXO3CnpSiVCl0/cXpKWsyQHiPgvJeJQVMuw/XeOuMyUv/4VFuVSwgYy7ZwW/7xU8dc5z8t6PP8tlc9gTzuvWOlw1IoxR5clxh9356puDhg0GHY/DYk98eQMwoVS21QgyOyRKHBH2ZWpQhrOW25EHB9BLacNnx4hCwpNrZRbCvds7gv6wdpFOv2Q5yil947ze1mMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tg/GB6ZJi6FpSnHgytRJtHBwrZo6Iqod1Y2oHaaQn5g=;
 b=SxGMXrg8YSXiVZ6F0mcE82uKuliCZ/MDaVwLOIfrm50idRRvMOEGScK5lfL3ZAJUDdcrrnfkYIsWIh29PZJVt94x7dBJew50asRvOUqAtsIRg/UGz07R2W4KsuWXU9SUh6Khy3Im6PCy6hAxpKV7adie8JlSVg1bu4bWhmY1KX2OEavseb6oiTn13KkjWHPAAxSCtNPijyEVSzOPkBU3h0pormaWRjzdyhkml5t5zegOMyQepoNlnu9HS/QqwUI67WgzuinSnfSZMgwy655CfODIwK9Y+8C/GI80ZcN59LOAUZYibCTbCUMzjFJ7zbUtND8uPurdFglqbyZNzITl8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH7PR12MB7164.namprd12.prod.outlook.com (2603:10b6:510:203::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:51:21 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:51:20 +0000
Message-ID: <a3b0a8f8-6b00-2489-921d-3485da6f30a0@nvidia.com>
Date:   Tue, 21 Mar 2023 11:51:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4.14 00/30] 4.14.311-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230320145420.204894191@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0199.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::6) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH7PR12MB7164:EE_
X-MS-Office365-Filtering-Correlation-Id: 17d6b1b5-4232-4ec0-44ec-08db2a029667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 073w+gRqe/5w3l8ypP7ZqZgALxwen1G4oi0qYVHpvjbbNYXeb3/uBpec2fq7i1/gjZ4haSYoAIZu/Y3lZWBqL2HEeGHiiUGwCg72AU4b4qHx5f++a+obnwTy2i7+tJbV9S4J8gPo0ntWqA3Rdr1KIyxFeoX0HNMwZ0iqwoqmMEWmNgZiAtB7GOHyjCukSS8aPXGWLqy4facPpQ6NnQ1lp2auZVuzW1vMroW8ym4qjCSPbajiIGeGZLRupXoECxU77hOgRDPLLh+oRIz6+QQ5bDhgYKpG3ASvqMsDFN49EaflgBLKK///G82jvKSIioBsZ9D4VIOi3Yn30bF9XqFsw4mkW6LH0QQscUaMFwCwhpQeaBlWVK2O0RuNh+KcKSKcufaN0O4N8WQSFMr4Jze5AysiOqfdhddOwwxqLgf9FpWib7Ub0C0+QJQmMYcSPoBMQ1kKv+EmoeUWJF1Jd+/o7EpaPtHsqcg0tocoYQDA79Rm83x0Ks6b+FAf6Q56Ed5QdesA85pqOV/0UGE5e1L4sNnh8ogECMl2bhZow6yilAD5wdvJ/J8LzPCQJWZMc2Oq3tqbRf9XfmRp1LhYbJzZUJculHSyrV6l7O6+yCwme3H+onhY3ko4+bpkl4z/GwlHe+El21XK5Eo7a431ZmFeYqNDltHmGJxLpGG1PDX2L8b29iSd3qPnfmxqT2lRBQeLFDL8TXiO644z5OOWXJ6UDWhDcrjlCUNvTASTK9YmYaXnjzq5pwjSOJOJTBTdYVZcqXf+ZRx/Ta0UdNWi3NyPfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199018)(66556008)(2616005)(6506007)(6512007)(55236004)(6486002)(186003)(26005)(966005)(31686004)(6666004)(8676002)(4326008)(53546011)(66476007)(66946007)(316002)(478600001)(4744005)(7416002)(5660300002)(8936002)(2906002)(41300700001)(38100700002)(31696002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2kwVTdaZzNCSnhlNWlBeWloM3pLQzQ0Tkg4UTVwRmVNNDdHVkc5aktsMU9O?=
 =?utf-8?B?Tk0vTHlwWG9DTUJuREJDa2ZjTW4yKzdBM0hKeW0xd2VMYVRscENkOHZWR2s3?=
 =?utf-8?B?OVg3NWluVTVLUHZGZHRjM0pEbldMY21mcStGY2Y2RWxTY1VTWHhPbjNBVlRk?=
 =?utf-8?B?VDNYWm9MSCsyYWRiSmM1b0ZCcWFna0ZaQ3pWaUlvTUhibDJaWDBZeEhNSmxq?=
 =?utf-8?B?WWFxZlhtWkthMFVBbXp1WFlncVpaQ3pRWXp6TERMQ3VRQVhUVkdrRW5VbklX?=
 =?utf-8?B?c0ZGQW9JVGVqc0NDWVg5OXZtb2xqUmhKSWMwUUZma2NycUhIRW5mWHdwMFJB?=
 =?utf-8?B?a0R4TEREM0h3RXFzY0Z4cXFtWlVqSmZVNk1sNmZ2RHJIZGZlS0pSTS9WNUdo?=
 =?utf-8?B?c0ttZVRQVmFrQW1jSytnK3llcEwwTDMxa1laQnN5MGRicGRFMjFXSFgxSUwv?=
 =?utf-8?B?YXlLNHRaRnRib3JrQ1VjTFR3c1VlSzFJOHhySzRRNTdIMTBFTEswVzRMbjdo?=
 =?utf-8?B?YlN3UDVWd0treVJkUGNOY1lUM3IwdkZrNTFneUlDSzlIY01JOU5Fc0ZZeVNu?=
 =?utf-8?B?RVFvSGY1TXMzSmtiUEJZbXdpWVI4cUtlNVloTGNhcmwyUHUwYmVVVWx1RVhM?=
 =?utf-8?B?am5QTlJlb0R0TGh0RFVtUVAxeGhJYjdkeERoYUNDU1pYTmxYQ0tCbmlSbWhE?=
 =?utf-8?B?S1lGekFoWDFFYkkzNWVidmNNMGNISUUyM0NDZzc4d0dsTjlaM0xPYnVhTjBP?=
 =?utf-8?B?MTJmRWhHOVFBRHRRd2tzSXk5d05rVHYyTlVnMW02Mk5ma1A4SVZBQ2lDNkgv?=
 =?utf-8?B?RldmeVgrVFZvTlN4NklMK0xVbHZ2RzJXcVZTNVh3aWZCL05QaWxmSjJ6aWQy?=
 =?utf-8?B?UkZaQlpCZWxTZ3Qvc2dmVnFQYTR3V2FqSnZEa3VoMDhjZlZRZVNTZmpFTGRC?=
 =?utf-8?B?bnVKUGd1WWM5TjNkTEZoQTlZai84dkJ3cGJyZ1ZSNG5mWHNseW9MWlg1ZS9N?=
 =?utf-8?B?V3kvNXk5d2xGZmdBblVJc2pnTjRWd0Y2TmdkSU1IdDE4S0Ryc1JhdnhFaW5V?=
 =?utf-8?B?MkdsK3NXNWFYUlkzODgzckVJaldmeGdtWnp2SkVQOS9zemkwWFY2M2oyQ1BN?=
 =?utf-8?B?SWZRb0Y4SURpRmhXSml0N0QvSjl0dUtuTXM0M1oxTWJCYWI0RVVjSEJtZmcz?=
 =?utf-8?B?RXZWcGhFSVJrS2ZPRVZJN21LR2JDSFU3alhQR0JGOTZDVkYvazd6UDVIYVBB?=
 =?utf-8?B?dXR0RkdNem1pNGU1WEVMZmF2NFAxTzBrVVg5aUhjdjR2M1dmT21ZUktyb1dp?=
 =?utf-8?B?WmY5eURIS0NkZmpwWkExN2g4TzZwMm84aVNPc3JzMmhCYmpFMUFDT01GQzRm?=
 =?utf-8?B?V3g3RjBjTG9HVTRLaHY4d09MdzFEbStLY09vUFk2MlpFeGJJeGhQYUtkcU5O?=
 =?utf-8?B?d00vckhNVHdpRTg1TEd3ZkllSkJBbnVkU29vQkRlZHA2UU80K25nZ2ZtdjRF?=
 =?utf-8?B?N2JBMkQ3dGRwZjFOMU9taHNlY3haR1BFdHpTRnlENXFDVTNGaEw5RXhnY2Rr?=
 =?utf-8?B?cEpVQUJWMlpwcmdoRGRIVlAxbGdWR0ljV1ZleHJMVTlLZmdWTCtUSm9sTzJx?=
 =?utf-8?B?YStTelJOeGczMVpTbkk2ejViOEN2MFRjWEkxbWU1RVpOanlINHJBYWlhL3gw?=
 =?utf-8?B?MGhnSzZFZDhBOVFDR2VVNDVxWEVnV0EycnpON1Z4QVpPNGhHSjYzYWJHdnpI?=
 =?utf-8?B?Yk5WZmYrbnAvRzczSTc2SWN2U1pQOUJhS3VCNEtYU1pFNnFDdzRtRU03ai9M?=
 =?utf-8?B?V1l5T1RDc2tPNXZScjVBUFhJT3hkeHhWd3RVbndnZUs0ekVQa2hKeGxKazBN?=
 =?utf-8?B?YW5ndGtmVE1KdXVmK1gvanZYRWJwKzdreEZJWU5ZMmlSTjdjUTQ0ekpTNDRu?=
 =?utf-8?B?RjdjdU51U0NDZmQyQVRrSlBJZm9xQ2NlLzdQZnpzMnBGYzl3eUEvUnU1RjZV?=
 =?utf-8?B?Sk5ITC9NNXU3MGZiQ3ovSjVtdCtwZWRrMENXcU0wTTFKS2g2aXNyS0xXcXQr?=
 =?utf-8?B?RmhzTjBlUjlYQ3dWTW9nM2FsWDBzWWpZRUVxbjhkR2dxanJyUjNPZnBWdy8r?=
 =?utf-8?B?NkZxa3p2dFBlTUM3c0NHK29hdFQyeFlSYnZDY3ZQdFg1WVo5bXRNRUYvbzlO?=
 =?utf-8?B?N1E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d6b1b5-4232-4ec0-44ec-08db2a029667
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:51:20.7375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmMrULvWqnCjr3qp+pJtBh4EteuYa4mqgyjgoNQ6EkYlXHgHW1HMY3kZaN1XJDTxlilBxx1nXVFAIo0cE0GpIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/03/2023 14:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.311 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.311-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra.

Tested-by: Jon Hunter <jonathanh@nvidia.com>

We are having infrastructure issues and so I can't pull the test report 
at the moment, but I can see the tests are passing.

Jon

-- 
nvpublic
