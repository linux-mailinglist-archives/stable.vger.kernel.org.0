Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C542533989
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 11:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240660AbiEYJJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 05:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238263AbiEYJIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 05:08:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D42C8CCEB;
        Wed, 25 May 2022 02:05:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1Wrwe/qq7nSZUIdiwB+mzMp/7yEfTe0GXN97rmxO/ZnE7qWgxHdW742jj7EQ1TXaoLAnMpgP9ZY6p3SplkTVOJ1hHkwF+QFV9EBr20t9+YuueNmXkCv+0t0CmccBijG/wlUHg7YQc20+zjOgntBgnJYaIT2MFB6d5S2ZfpYV6AYI2Gc4N7+6luPa4Vd20vAW8jVpwqlfp3jMaoy0cFx3eiJjasc30FwdH+jXSyoEmhZEgg7PrCHMpsvhigSJ45iEjEDqf3nD/OLliGUA2WMIBpCfUHWtyYn7fyupJDEOonwHbgOPeCUCLSMi6wPGFkDXga70VVhEkwtVbgywnk13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ky29R2A4Yr1s1fLcKg3szRnFU0jgvTLZvL2f9NNDK6g=;
 b=N12yF04SpnWKxcB5K1t0SwrxYnkHtKGeK79jBHjjfMn/eJBPBKwlAZKu2wMlrneZhW0NVt9vuvCY+UWs0UTmuoglGHsa4KzDZdlNl7i9jkcK1nMPfQB3UKXS7gGo3FdvOBr0aOrNjREvv1CPGlqdWyqrK0000DhOGIYBQfmoWvQEbnGXb9L2/BmYZ5wle1IVy6ZmRqH1WJJG8ULWya5/5itPsHA2Dj/iPYg5w5Nmpbz8rpjLMABnlm24GAKiL5qDDCQnwPMKLDSGbZOZ/vXGDyFGsgTvHY5Dm3XTU+MJCZkzrjko8aJmHOuiWS9ZIpEYgdJ6zHlAJsz4VWA+uSib9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ky29R2A4Yr1s1fLcKg3szRnFU0jgvTLZvL2f9NNDK6g=;
 b=k0BaTPR6aVZdNLmrxgb2clXDEYPHhVnilfYELFO5sURidb6YGFIcuEGUdoyrTc13mB+IDUFG1chlRZkxNwByqF4KjznaZ7QQlnRGzM0YwbHzRFSEPzdWmo/S71GZbEY/mtfv4QY3N7rLrpa9j8Biy5BPHEKXv8UGTdWpgxOi7jVVTcsMtaM1hDTmvtpk8zg/WZ2WLioKJwsg1g8fUZIv9chAU9toU46YnlF0anUpoKjh6keng6EfhZ6uRJ1sjJtgfIfecB1LA1j4QWh1YevGHsaUAMyvjAY74yfktHjPO4VOXfPf3GxtHMtwnRGXYqAktcsl2UvifskuD+H2sxC5qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DM6PR12MB3402.namprd12.prod.outlook.com (2603:10b6:5:3b::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.13; Wed, 25 May 2022 09:05:24 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5293.013; Wed, 25 May 2022
 09:05:24 +0000
Message-ID: <46098d18-a83c-4b02-f55a-55200fc2f993@nvidia.com>
Date:   Wed, 25 May 2022 10:05:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220523165743.398280407@linuxfoundation.org>
 <6f4034a5-f692-8a64-a09d-8bfe49767b78@nvidia.com>
 <YozK4DvamHBJ1qdX@kroah.com>
 <fbeb9833-4166-1919-e6ab-9ac7625a21d6@nvidia.com>
 <Yoz0Xv59MrUwFkMT@kroah.com>
Content-Language: en-US
In-Reply-To: <Yoz0Xv59MrUwFkMT@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0446.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::26) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9096d2b-f333-4f3e-2bf5-08da3e2db416
X-MS-TrafficTypeDiagnostic: DM6PR12MB3402:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB34025343C132D0DA54E81969D9D69@DM6PR12MB3402.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yM0y2WRu+711wf6FdVv5O6votP2TTq2zw3PmhDEZAITnPpWABP9ytpvjNZ46Fhq8ep2GFlf7ADbZH5bFMWlZRqrC7jkTpUJFEg/tF7VB63O5T45V4aY9NMUGHepF4YU1WiVGiqkOWsQUBm3BmW1XJXJWe6ZOI1OOoyLfLDbR0HhyeviL+ksE4BicZWJqT7NSz5IeF6xY1eiHXzjY7o36qBAhOdL8QNVoezEu8xikf6cKQ71X5IvXDbbbtMftRN0L5D0pIzaEkj2W7d13aDaZv8yUtqWd8Hhhv5SLI+tUUQg0wONMFZy8o0IkB0NO/mCYnc32X+nASrmepsrYU7jUNbQ0Ao3PfIkIybDaP37If/SzXuKc8cuqEun2Q2lJGrJouCBgUl8sjMRYp1vQ3ojiGp629YHamFGaKTFvgc9R7I50i6Tnz0nLrd6EYBq58zXdi55+/mthMWEXf4+Dk9VraMwNHRqg4Pw6OxzqZ0qrUXNx6BhNc5sf0vLnzlf4sERt+xNIELZmvP39YS0XdjJ+e0/hbuBmbN7KIA4aYGDyk7qPreWVXAse1AGqFwPq52z793sbUeGRU3cSaW88qbwov+dIPEz+ToxM5Wtii++EcjAMQrUlr1msZYUfA24QDFvZwLFK2bXr0tEfrbqxdlsMcCLOtzCDDWCao8KfSFdv1vmItr55EhQ/jqZ3sLdNIJnfBH51vvxLvtCymXT+WU1bvwndJmlCwfMl0ZWAJsiB4gw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(6512007)(38100700002)(31686004)(2906002)(31696002)(6506007)(54906003)(6666004)(55236004)(53546011)(36756003)(316002)(8676002)(4326008)(66946007)(66476007)(66556008)(186003)(86362001)(508600001)(2616005)(8936002)(83380400001)(5660300002)(6486002)(26005)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGdidEtTb0drS1lqWks5c1NFQ0doOUxTa3pGS09JRUpoVzRvNG5haGNNaC96?=
 =?utf-8?B?Ym0rL3V3NUkybGZOeGE3b3B3TmhPTzdYYXlIWVE5d2R2ejErMUpwRzFMOXY0?=
 =?utf-8?B?NnJnbWwzbFRTOUx4Rko0Y3UrU25pZ2IvQnVCNktmQzQvKzdxODZDeXdrTzBr?=
 =?utf-8?B?elJteVJSdU9YZ2xPTnNqZ3BNZWRuSnFvSGgwbzZ5Q0k3SjZZTEdmY1JGUHJL?=
 =?utf-8?B?U3p5TVhmcHV0ZHlnUUhvRHhmd2MrNjkyU3kxSC9tWDBSeGtrZG56bUtjNkNu?=
 =?utf-8?B?QmdRbFNMcFRGaDBuNitwZ0g5TEMwWktmZVpWQ2xFejRmNDNNUTVVUUdkV2d5?=
 =?utf-8?B?c3lnK2R6ZVlpdWRWWUhPTlprSCtNUXBqMCtsMGwwY0FKMVgzL3BIREZHNE5O?=
 =?utf-8?B?Q2pGQ0Q3d1dpOGJuRFkwM25OYUpBZWE3NmhYQjFjc2RFQ3hyRi9zbHJCaEtm?=
 =?utf-8?B?TUErVXV6Ylp6UXVQcnVZeGJTclYyVVYyY05NTFA3eWtPRENpTjlycDNuV0to?=
 =?utf-8?B?UzVmSHd5THZ2MUpTNUwxSjZqYnJKa2tZckkxMTlsTVhLQXYzc0JzZG9ZTDZG?=
 =?utf-8?B?OGpLTTBxMjhaNUdua0VJT1VOdXhEMlpuNmFBZ0pjbGZtR3JuN2hydkJIdm0w?=
 =?utf-8?B?VGRRZytqMGNna2RCM2VlUnhrZytqSm9Jdmwxd1c2dldnWVVtUUlGeWkvbGts?=
 =?utf-8?B?Q2I2cWI4RDJ1ang3cTgzaitZR2J5UUdSYkNKbzZnQ25HUEk1Vnd3ZWJqYjVy?=
 =?utf-8?B?ZmFHMUthUVVYdEprTUJjbkNsZTB1MzhyeTVEN0RhZ1cxSXpxT241bm1Wd1Rm?=
 =?utf-8?B?a1NyUy9Nc0JodUFGRWswaStvakFPRlhZeEQ5VG1LQ09mRW5sRGY3ZHlFWHE2?=
 =?utf-8?B?ZnpwalFpWTB2eWpZWXo5dy9QNXlzTCtxaE1rU1g3Z3lqZE5UVUdzM0ZWQVVv?=
 =?utf-8?B?dElra1JGMCs4TzV1aTk5UW5YdE15alV0SWNHbGdNamhReDVLNm9DSmhtV3Jm?=
 =?utf-8?B?UzZPdHlwSGh6MVBNY093QVJ1b0pNeGhOTGthRFZ5eFk3UVVkNTR6enVaZ1Ew?=
 =?utf-8?B?L1gwRGlMK1BGd044cEFST2F6N1RXZXY5VWtCSVZOeGtERW13NTdvQlRDeXhP?=
 =?utf-8?B?akJLSjBXZ1pYbmEreEZBZDY0Yy9Ma0t0S3BlTHhNeDBwMjZydGlsS3hlcVF0?=
 =?utf-8?B?T3E3V2JkR2dEQktYK21XQVJDYy9xYWN2RG4wUTJvNU83bnloYUFEZ0EvT1o1?=
 =?utf-8?B?d3Z6L1YzazBzTk5hVERnRTFMVkVCb1A5SjdIM01rU0kyUXFaUFp6MGUwS1M3?=
 =?utf-8?B?L1k4L0p5czBFVWlsdlZpaFp6M2NHaVlzNjhuRzdTNEFUTXptZTVwVzA5REtL?=
 =?utf-8?B?QVNLaU1NQ3VjeFVvMmEzNTVCUFRZUTZmMTV1QUxoRE5wVUFMeFhmWVQ0SFdi?=
 =?utf-8?B?Zm9keWs0SENUVnF2a1U4TkErQnhJanRFRTJ0emlIVm9WMWRKRDFyVUhhRkxD?=
 =?utf-8?B?UTZEN0J1VFRscDRWeThyWW9vTjd0aWNrSEJXWnVVMW5LMjhmZFluZzRnY1Fy?=
 =?utf-8?B?RkdCWmtWa0FySlhrMHNxWkdGSWdCQ25rNmRUai9SZVVuTFJjRlgrU0I4QmY5?=
 =?utf-8?B?UUVqVHFIN1lxZFN5eXZ4cEpKTkt4d3ZTOVN2QTRZZ0xVOSszL29RTGZlUTVR?=
 =?utf-8?B?MlRqeEJFakJRcmVkRmtuSGRqMTFiV3g5YitXZ0tYS2JDblV2c3VwMTJqTHpD?=
 =?utf-8?B?SStRZW4zZ1I4VkM4R1djMEpoOUFob09xdVFVZWxyS0VUWi9kRkpXdGZFM21v?=
 =?utf-8?B?V29oR0taUkI3TE9XMkltdTk2QjBJRjR4ZU80NFRBbE1BdUorZ0dua3JNTGRx?=
 =?utf-8?B?QkxCdEFmQkpzMUhvaTZDUmFNVjY0b0pOZll5emF6emx0R0ZFdG45ZmhldTMx?=
 =?utf-8?B?VWQrVzlwdkF6dGZ3aTBueW1EbE11Nmg2cld2RzE1cVcyOUdlNlh2OW1GNnM0?=
 =?utf-8?B?VW42aHd2MnB5bWd6QUdlbm11dndxSEtCZG5pd1JZd2Z1UisyVCs5VDI1M3E0?=
 =?utf-8?B?dFJCbFF6T2pMMmtCYjY2YmVQdWJ2NG1UTklGMFFnYllaYWdtSlRvZzh0K1hl?=
 =?utf-8?B?bkxKbjVxRHh5TVhZdWEvQ0UvSG1iS3R0VGlEZlRBVHlIRjIvbERkRDJEdjhT?=
 =?utf-8?B?NVc4VXFYT0JhRzFPM2JNYzdsS1loeTZ0bU10djFBY3VQejBEWWJvVnlySTFH?=
 =?utf-8?B?RU4wK1IwTHAyelNJSVFMOEk4MnFGOUl3eFhwc3E3QlZsVmhrRFFkMGdrdmw5?=
 =?utf-8?B?dERnRG5LdzlnblhucnJWMSs5UWdzWHVTQUk2eW9QRTljQXNWd3pQQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9096d2b-f333-4f3e-2bf5-08da3e2db416
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 09:05:24.5741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJdhEaTvR0ivNsFg/UX21KyVTlkrB/hVhcRxFC4/5ulAmlmfs1e1KuX0pTNw+z+94V1/zi7JNvtwVI70zhsSeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3402
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/05/2022 16:06, Greg Kroah-Hartman wrote:
> On Tue, May 24, 2022 at 03:55:58PM +0100, Jon Hunter wrote:
>>
>> On 24/05/2022 13:09, Greg Kroah-Hartman wrote:
>>
>> ...
>>
>>>> I am seeing a boot regression on tegra124-jetson-tk1 and reverting the above
>>>> commit is fixing the problem. This also appears to impact linux-4.14.y,
>>>> 4.19.y and 5.4.y.
>>>>
>>>> Test results for stable-v4.9:
>>>>       8 builds:	8 pass, 0 fail
>>>>       18 boots:	16 pass, 2 fail
>>>>       18 tests:	18 pass, 0 fail
>>>>
>>>> Linux version:	4.9.316-rc1-gbe4ec3e3faa1
>>>> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>>>>                   tegra210-p2371-2180, tegra30-cardhu-a04
>>>>
>>>> Boot failures:	tegra124-jetson-tk1
>>>
>>> Odd.  This is also in 5.10.y, right?  No issues there?  Are we missing
>>> something?
>>
>>
>> Actually, the more I look at this, the more I see various intermittent
>> reports with this and it is also impacting the mainline.
>>
>> The problem is that the commit in question is causing a ton of messages to
>> be printed a boot and this sometimes is causing the boot test to fail
>> because the boot is taking too long. The console shows ...
>>
>> [ 1233.327547] CPU0: Spectre BHB: using loop workaround
>> [ 1233.327795] CPU1: Spectre BHB: using loop workaround
>> [ 1233.328270] CPU1: Spectre BHB: using loop workaround
>> [ 1233.328700] CPU1: Spectre BHB: using loop workaround
>> [ 1233.355477] CPU2: Spectre BHB: using loop workaround
>> ** 7 printk messages dropped **
>> [ 1233.366271] CPU0: Spectre BHB: using loop workaround
>> [ 1233.366580] CPU0: Spectre BHB: using loop workaround
>> [ 1233.366815] CPU1: Spectre BHB: using loop workaround
>> [ 1233.405475] CPU1: Spectre BHB: using loop workaround
>> [ 1233.405874] CPU0: Spectre BHB: using loop workaround
>> [ 1233.406041] CPU1: Spectre BHB: using loop workaround
>> ** 1 printk messages dropped **
>>
>> There is a similar report of this [0] and I believe that we need a similar
>> fix for the above prints as well. I have reported this to Ard [1]. So I am
>> not sure that these Spectre BHB patches are quite ready for stable.
> 
> These patches are quite small, and just enable it for this known-broken
> cpu type.
> 
> If there is an issue enabling it for this cpu type, then we can work on
> that upstream, but there shouldn't be a reason to prevent this from
> being merged now, especially given that it is supposed to be fixing a
> known issue.

Yes understand. I have been doing some more testing and with v4.9, this 
is triggering a boot timeout 100% of the time. So with 20 boots, all 20 
timeout. Note the timeout is 2 mins. With v4.14, I saw only 5 out of 20 
timeouts and so it would seem that v4.9 is slower to boot in general. I 
think that the more recent kernels show intermittent timeouts.

We have some verbose logging enabled on this platform, which until now 
has not been a problem, but I will disable this and that should resolve 
this for now.

Cheers
Jon	

-- 
nvpublic
