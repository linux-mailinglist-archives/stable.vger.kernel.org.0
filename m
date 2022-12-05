Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D703B64382A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 23:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiLEWcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 17:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiLEWce (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 17:32:34 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC97210;
        Mon,  5 Dec 2022 14:32:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9lDzRcHQ2IbWpirS8AycqAaq2kVuwn5fjRvWxIGC01Dg1rtbUY7W8fP2Fz9fs2GoJkwAKTd/lU40q+TRGCFPDXmTuA4RrCwGqS7Gn3W/N9x7S/1om+ewuoB//ZWy3CA0+g3vLl1xK4D2cfMPSzBwUk5wdZoynAjU9T5vsRR5tO3DinDChPFVGxuC1M7B5vlIZG3gycuAGBAbwPcoHL1sKLyAdO/7ZuF0PLIwIM4u1e8VB8UnK5Q5qhuLRE1q4541eUt1al/GdxMwShny5lAnqQxt81r68MEOvoN0U5jNSzSTMTu1vTBoEN2U4f23xPKRrqg7tjrn4iFvGKYfvDMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYdTERL8OAtr79Db25UGl9vM+QAiv/FZUG6Vh75W8YA=;
 b=NzfQiDOoLSHp+JXCef2hxIZarqZJccL8Z6oo0Xd3znitCqcIXkLiCfYNGpFcvjzprVBNEIMQatcJa9uBmUUtm1WS7UUAwMv6dXrGaIjuAFIRGRbBxZF1YjmNqfu87rWP/6fjsla0xZE2TEPi2WMyjGgqD8BnMUKNBmJILe7rnntUHpSqc619i1UReSqW7SbzNuWMT895CtZloNe9/fHKNEfjdZiNmhQ/kyQ5jlbJc7K+pgX8HCz5s02q1Ikgj5NBwNujOI7+dEqyeKp4e/VtjO5EZajsroXSLQfJeQmceOIuhnzaJvPeZu+nM/VNaQbNhbs+KOh5AXPwcECyQMZYIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYdTERL8OAtr79Db25UGl9vM+QAiv/FZUG6Vh75W8YA=;
 b=YnjZh7r17fUvh6CVWyS/d0Qux6qnBKvdsEJTs6wIbesEdIpMd6ZuacNkb5tgVYtS+E0HFAci/Fweyn1YIIFBlH7XDW3yJ0al5nbYL6cOMskkfQSRhH1QbwrvdES6buZXowd3yO6Lyn2+smRQxXPGQpYHvs6uTuKRDfllH98yp+Ugw5DCxWOqn3qzHhgxQE2WgfSLZjNWlygNWWyNdElVWZ17IE7/KBDUy9uY6w1cG/UcDGeybStSFlxgDJzKtIkwnjA6Lvb4d2RF+osHadstBJ1+8nP5tYje7xuQT7nrNPO8+FpkHl39Ln+G9U0u5XPMYfa2p/CrMxmG5JQ2qcmx4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CH3PR12MB7499.namprd12.prod.outlook.com (2603:10b6:610:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 22:32:31 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f1be:5d:f297:e2f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f1be:5d:f297:e2f%8]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 22:32:31 +0000
Message-ID: <80305ea1-4d52-b1d3-e078-3c1084d96cc7@nvidia.com>
Date:   Mon, 5 Dec 2022 22:28:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/62] 4.9.335-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190758.073114639@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0042.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::14) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|CH3PR12MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ba14404-310f-44ed-36db-08dad71098d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cVPipctemOMCLb0fzyW1AIUHRNiA/jFPsvno5vWXxQlvimB2lmJ/zjJqXYxv7jmQ0mXG2qQsfeal1LLMU1nHPtCPkgcUfA0baQqIxlkp14TdCbasnRtWjMegf7KMHokntLQtcgFGGeLvOOZFSoBs7UgM4qx5GFdAm4FP0/qGy7OzYnMym9t2WCYGiBrNeBt18x6xyoHaRpBIk18qp+DiHPD/1tAKHPqS8yrbLMxQOdL+TUSWoDnMqeVQhbciAniaQWEIO/bTbf2LUAF/Fs+gTWXadt/l4OghqbbspeFMySGYg37J8ikte0Bm/oojQtzUVHhv2Qna6P3b9jcEbn+wFMe9Gtiwb4qHJ6uNUmzOrpwfRPQZRG8PTg4qPPDLCCwPdL0TWf/wZXgePMwEZCYraEWM6H6B+Vjy/mkaaFXWFB5zi4gHTTdlDQqsM1wlc+dKK1ka8lGaDm5sOsX8Vcltwn0kJr9pZdi0wQ38RRBHLSyHC+xZwHNYfrt+lgaboO/kddZ2+BqOz0kbUwxEDm1cz/PhtDsXPOPfE+Xobm6Zh6F4SGaWW5rgls5Szjdu8RHiaUoTdPsnliYA/IHLQFRft/lllI6ZCM+DkhaEm7q93DaRGfqp/KdYxBhXnnf7/3Rs9y0mAZ1QwfV5Irja5/kGHSx/8rBp4T2NnQx0Vu1Qy34wAK9BCdbKqQ/I84f4MwLwctYoM8aB53EDdS2U5JPoX8seKs21kJ+ywt6FLd1CYB+NlXFcPugFqPl2/uso/8JtKzitRZS0f5zKGxEBG7wggyfWyAJY7hNlRL0Zm17ODQ7faLqEA8J2E5SxZesw1Btr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199015)(31686004)(36756003)(38100700002)(6486002)(4326008)(66476007)(8936002)(2906002)(478600001)(7416002)(66946007)(66556008)(83380400001)(86362001)(31696002)(8676002)(2616005)(186003)(316002)(41300700001)(966005)(5660300002)(6512007)(26005)(6506007)(6666004)(55236004)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Um1uanVQZ1IrT3k2eEVyaUNxbzR1aEJ4RCt1SGJHR002Y3hsdHRLakpZOEdY?=
 =?utf-8?B?eUdZVjlMTitQdHk3ckNXWFZOQW5FU0JvRmx5eUEyVUg4cTB4MzJkSXlQNWdM?=
 =?utf-8?B?YTZESEYzLys3ay9JMWZrRjFIWGhraHFrZXpHRTlZdXpybFhUWTVMeVNCdFRr?=
 =?utf-8?B?RS91bWFSRVMxdXZ4cUVjY29PR29weFFwT1Y5WlF2NmVSSHBEYS9NV0luN1ZN?=
 =?utf-8?B?UWhnQm93dXFuTWdaYldBL2hOK0VVczBZSkl4U2NpTHVFSUcycTYvZW05VTht?=
 =?utf-8?B?QUk2ODlWb3lQQThPRFVyeG43UGE4Umk1cXlZR0VNUkV0bDhmRFNFZ2lrMUNr?=
 =?utf-8?B?UXpoTUdzL0hKRmdpeUNNMXR2emJRRE16MXdyMnBrWTNuZFJUelFGMG0raDlz?=
 =?utf-8?B?eEU0NFh5ZGVVemZXZUx0TXhzekJ0UGJBUGgvUHpPR1FpREJSZVBKQnJkTE0x?=
 =?utf-8?B?TEkxOUZuOGVKZXQrd3NzaXcyNEFlMDNFMzBxN0tucElxRDJtS3ZlSVdhdFV2?=
 =?utf-8?B?dm5IU1lzWXR0MEhBNmVKRERKRFlDcmJCRVhtZ09pSHFRQmRXZXhNREh3N3ZB?=
 =?utf-8?B?UTBxS253Y0w4ZzhkaTFDNUcweW14S1RGVE05YXZzRGliTmlYTitLbmoxenNR?=
 =?utf-8?B?ZWxodWN3eGlrOFlTeXIxSXpVazBKOWYxNW44YmJwYWl3K0lMalRHZHZ1YSs1?=
 =?utf-8?B?V0c5NzNIcDZLeHR5akxBMWdFc1g3Vkg3bEpWRU1TT3llTmZkVVhYVkFYelRi?=
 =?utf-8?B?dU0walNzWDdlOW1NaHdzQkYvQTF5NmFLL0wxT1FTL3oxQUJUQVo2WkFtWmhM?=
 =?utf-8?B?VFJBM0pmNzFjTDNQUm5OM0pSMStSNzlHVGROYUdxaGtKa3NNTEJqeEIxWTls?=
 =?utf-8?B?VkRvK2pPbWJDamVqeVpNbk1Za0w1QU5DVzExMVpiVnJudWFUZm5BL3lWMHh0?=
 =?utf-8?B?alFLL1pZOUxTR0VZUVBiVHNJTE1kZ3VMZndZR2ZQRHM5d1IyRjQ5MVM3M3gw?=
 =?utf-8?B?SnJVeDRoYUZQOEpLYWNSNnBKK1JST0N2VWhuK0ZNNnJTdjJhVWdmNFc1eDZX?=
 =?utf-8?B?SmYxdWNPUWJETVhGY0o3MjUySHI3VFdxZ3RlZ1E5dmltOHUybnR3bWlZQzh6?=
 =?utf-8?B?MzdnVXlYWk1JZWQ3d24xRGMxc1dkeG1xSk4vYml5bmlMR2VZUm5pK0o1L2hV?=
 =?utf-8?B?bGF6SllJdlQrbnNqNWxCTFZXMWc1alNQc3YyUTUwZWpNdGVTZXl0Ulg1cjla?=
 =?utf-8?B?b3k3R3VZeHpKeDVBOU5Bd0VKWW53NnFmZ3lDU2JiajJVWGZQdnQwc0lqdkps?=
 =?utf-8?B?bGhMaXRkZ0lPVTlNTTlDa1lJYkwrL0E1bDQ0N3BYRXpsdWZIZTR1NW15UTdN?=
 =?utf-8?B?OHNScmg3MCtOVHdGc2hqRUFrR1g3T3pVa29nUnIxWFYvNEtZZGEyY0JWMUpv?=
 =?utf-8?B?c3hrQ3ErcE01R0Q5dXpyUWVoYlg0THNxN0hqMll4T05ITFlYYnU3VmFERDJU?=
 =?utf-8?B?NWZiRDh2MWNOYlhZVzVENS9OR0ZyclcvUWhVcHZ3R3NoNEpSTFUxSUZVYUFB?=
 =?utf-8?B?aUlWWSszSWhCalRFQ2kyNnlDMFh1WFQ3bnY4OTZWcjNBeUhLaEM4aHYrMFZu?=
 =?utf-8?B?K2F0WHh2TVNNckhyaEEvSG1qSUdjNnRhWG84UWRCVThnN2pmWXRpd2tyaUNT?=
 =?utf-8?B?eW16elluZDh5cUJndEtQQXFHNGdvbmF6MW9FY2tvNnVUUVkyL0d3QlpBRjdK?=
 =?utf-8?B?ODRWUUZHaCtvYmRPSnVJcU1QbW5YRVI5OVFmenZ1S0RNcWNkWk53S2ZPZEhK?=
 =?utf-8?B?azdZVEQxZHdKQ0FZc0VZbzZqSVFCajBaaXR0UVZLK0RxM3RsYXFoZ3AxVUdh?=
 =?utf-8?B?Ny9RTldHbndyVGVwdTR4c1R6T2NrYXlMRGE0bXVnY3JkOUpSRHBrWjlMN1lP?=
 =?utf-8?B?bUh4WDVuazhGbW9pVTZQd2hZVTZlM2I2algwckNRdnZnd011YzMyZi94eVdH?=
 =?utf-8?B?VS9ERENJTnFXYmc1bTRxTG0rL0J6NVh2MUdTK1ZUUUVVbFFOc2t3UnFoSmhK?=
 =?utf-8?B?cVozb1VXZ2xNdFhyN2FwZDFMbHNrblQ3allRS1NaK2VzdUZ5dEFiMHdHd3di?=
 =?utf-8?Q?ngjsLiloSO23/ueUKU4N1GU3W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba14404-310f-44ed-36db-08dad71098d0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 22:32:31.3171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MIgbiW3hyJM1aq1DfTiMECHnCXIooDx77ikoETp1cB8Tr94gGO1jTa+m7VWmJMImoTWjr/h4VzaEk1vQWQQYbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7499
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 05/12/2022 19:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.335 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 4.9.335-rc1
> 
> Adrian Hunter <adrian.hunter@intel.com>
>      mmc: sdhci: Fix voltage switch delay


I am seeing a boot regression on a couple boards and bisect is pointing 
to the above commit.

Test results for stable-v4.9:
     8 builds:	8 pass, 0 fail
     20 boots:	16 pass, 4 fail
     16 tests:	16 pass, 0 fail

Linux version:	4.9.335-rc1-g9ad972a03b17
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                 tegra210-p2371-2180, tegra30-cardhu-a04

Boot failures:	tegra124-jetson-tk1, tegra210-p2371-2180

Cheers
Jon

-- 
nvpublic
