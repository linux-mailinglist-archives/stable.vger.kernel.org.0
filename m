Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E27F61104A
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJ1L76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 07:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJ1L75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 07:59:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6499599;
        Fri, 28 Oct 2022 04:59:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JsINxEZku3aRVzz+iGphwko4OSnwjwgxUSaEMuvL4J2pR+EAoR2cLUhUbHL60F/6kQI8CbxoDzjZx5avEFRRd4Rz1raptG23s2ojoyi0pX4Kb65pDn2BF/D6Ag0mwHcJ5O3cWMP8XmLndc1PcsxkkuF5rkrAbFdTk5sPWhTGfM0lfqTMXaKpvEFqvdSSE+sfSxpXfNhbldehPY2HWZjQRGNfXEYWLaXRLEDfKlHEnR8egfM7q32SMbdKaBDmWRgQWnFsNApqBMD/7Uudiy899wVTUdwUc26jBqdXwZt2gOBohU1oV1NVeOgrKO/PFIiHafzvpiNNiyGAJQvJcCQH4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3pazRUu+T6IFozKm8UZ+HqbruPgZvy9M2I49gZ3OPc=;
 b=A54LBjGprCE4yP6AeoeyybukGRXdlWDg471WDBA2VUqRMbmExn+r1S8suaXbAPT1fOEa0TU4CQONlB09G9QLAXm+6bCBC9xh6Vnwn0bNaXXPY16lHKk+IUKcuium1IEP2FRRbaUf3nYwBlt4buEUN6I9lAdvHivyDFU5zEutXvVMG5sz/yJZYUDQtOg9XCU3C4fYBP+nQPlXtPpZppI2M6ADgxy054wt0F7EtyMxZMQoR8SRGOtbRRZKHqdqn0EkHSIDhCRJDUlAdoOI/GzTelmtrFP2priBjiOms6ot0i+3QwbngZX9PU2G14ttyq3TBK7TYxJnNa3df7P418WMVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3pazRUu+T6IFozKm8UZ+HqbruPgZvy9M2I49gZ3OPc=;
 b=gSJch9eT4FBsPjEt84AdF0M0yPyz/D+M8YEZzUuVawvMr99DCw3rwH1v9quBP85LaQvw1acSFqzkXnH6gZIVGLrY1eYdccVTXqQMqiSfnZ+RhhEpmWFv3VIzFrHM1LH0G/TKGXFbbp9GcHjk2mHI5dxsNzDI0TQP2hJHHGwgWRymcddPF68v5TKDvqQziy/ABNPZTrfTUWdnoOS7vZ4Sv9oTcqZ8hKlmrqZSeZIhAwfIOerGnoXfljw9MgUVp7Oiiw3mmEEzgQxWBQ1p1UwqTWDMkmTiish7zME+g/zX8Tn6iglMZjOth5rO/ZjlXBTO43WsNSdOSnSrvL23vEe1SQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DM4PR12MB6638.namprd12.prod.outlook.com (2603:10b6:8:b5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Fri, 28 Oct 2022 11:59:42 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 11:59:42 +0000
Message-ID: <5baacb84-ec73-ab45-8620-296a1802d707@nvidia.com>
Date:   Fri, 28 Oct 2022 12:59:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221027165057.208202132@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0047.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::35)
 To CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|DM4PR12MB6638:EE_
X-MS-Office365-Filtering-Correlation-Id: 529aef63-0b07-43cc-39a2-08dab8dbe611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKPoIDhCzDaDyOmSQU8+nMvrBgmvJXrM8B0qDED03lE6Tojedn56M0Blatk9V8hn+0HMg/xNGuEjp/3N/NNYir7/ONffrIIzME6J9VjUY0YMyHqA5i3WSKGGTNwbuzKrY+SbFfEeBlJOshu3LMme45R4yHTBFhUsvEszGScf7obsVaycbZCgC8bkUPk/EhjhP7CIM3UChqHUUc7LFf+7nvXjSptlw3moDs5jUQduvXfxprNmEHWGxyR+FbIqJGrvwL4bM2eqOr4v7O8991mOwwMGxxQlUV7kDt8tsm86mjBrPQi7Vaa9baltCxPcUu+HYU3Q21YVdBQO1+DRzgiky4o5cc1869EhywN4YlzO3O7mJ1RqkSAK/HXf1CpZO3vpMLzdWJpcgeXUMvrYN0PP6ELravqUOcMkC2oP6o9LAmZCvh0cUcfDEIU7/gWFK95Ue884mDsg5YEiKiup5RQoEvrOJ4MXEB69mof6/CBO1CD9dfRkdc6ZW/YW3fQI/vFrGkw1LWiq2SCe+WuZA+CxdYsSBo9zQRSBPWxYyKVxvUG5/JYfJwHDtNqWGvhL7/7MW0K5LX0U7pAOqy+W+zWA/d6/TZrskhtUlt1mXSfO/2AolvtgBBNZZsye3Tqj1rSQ9ChiWPGUZjrHP2mPTrLtr+yNW6JXC86Ja/a+h+LEiD8w5rUkdWzOF00BhjTFFXycaX0HGN9RZEMAsLHPp7Qw12gSwg/kPdu+UqePUJ3txnK1ND+cTv94MYyOIHMeaZDsHOlcvwHNMHSEObWHw4u3kC7MkPS5DZxh3vg32pC7/dn5+xvutacLAod3+6pivrN6CShf/dDD1JSSG8J7okDShtIoAsCw5fZ70YYFiIEziyNCGCEPyNvcriPYErJo07mZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199015)(6506007)(53546011)(6512007)(38100700002)(83380400001)(2616005)(2906002)(31686004)(186003)(66946007)(41300700001)(8936002)(66556008)(66476007)(6666004)(966005)(4326008)(36756003)(8676002)(31696002)(316002)(86362001)(478600001)(5660300002)(7416002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjh0RTJZT2h2Z0ZweVltK3RiVGFnZko2Z1p0amRmeXduNXJvVzduSExVSDMr?=
 =?utf-8?B?cWdCVU9wczJxeFl2WFBRYnlxdFdjanZVZDRvNGtzSzlKVGZwSzZvZkZibWxP?=
 =?utf-8?B?eC9UV0tsa2xTUXlwOHFzd2E3QmRJZXVpbUxjd0pnOG5LMXZqc2N1elh5U0Ny?=
 =?utf-8?B?V3A3UzA2ZXpRSFI4ZzRhY01ZcWNoVzRDZjE2TCtDazBWZDArckpxRndGZGFm?=
 =?utf-8?B?Y3gzRnZ2VnFDL1hXSmdnY3ZNRHNaUHBJQlFUOGYyT2RCcmQvZE1URlBZRHNk?=
 =?utf-8?B?MmNub1B5RjIveHNNRTg1bUtBNlZiT3JRNVBrSVhDUzE1R3lQK3NXQlNRN2Zu?=
 =?utf-8?B?OVcrMGFaQ3NnVXhmQ2o4R2ZwclRiU2lzVDJJZjdwNUw5SFhieHlBaWp5NjB6?=
 =?utf-8?B?ZXRyY3FwRGsveDNubnlKZ0ZSSC9EN3E3U29mazJrMGdoTmlwdE56MFQ5RTVn?=
 =?utf-8?B?VUc1UTJndUppZzg1MzkzTGdRUDhwcE5VK3NDZlB3YzFmR2FMNTZRUHlWdzE2?=
 =?utf-8?B?Y1F2UHFBeUV4enpaajB4aTlCemZtNjRQa1lvMi9SM0l4TjZUR0RNNjFoVmIv?=
 =?utf-8?B?TDFodWRCZVNlNEhKZyt6TWFnOUZKejg3L21WQkM2bUZJdGt2ZHhqSFRzeUZV?=
 =?utf-8?B?M3k0d1NadXEvclpvV0lzZDVpc0xuZ3l1MHFWU1dTcUdjZHBMVlFwa3BKeCtS?=
 =?utf-8?B?eXZSRm9FaWgvTWY1dFdXbE5sRnNXdDJvRFM0cTVrbE0vZms0NUx2Z3g4RnZk?=
 =?utf-8?B?eWRMSXBvZHh3VjErbk83ZkllRVVwcDBtQ25vQ3VsVTBZaEUyeEpiRlEraElU?=
 =?utf-8?B?S20xajdYbUdtdW11bWVncHhMeWNxM2t6cVphdzE5RCtOSmlHb1ZHY3BCdWNQ?=
 =?utf-8?B?Z1B2Tm1YQ0ZHY3FQY2lRTkxqUFZKN2hsQ2c2YmFTbnFGTHFmUlFXNnA3VXFS?=
 =?utf-8?B?K0pFUWtUTTlKWXVod3BSdmlBVkFUWk9CeXN0a2JSbzlXUEFSWDRRKzVWd3Rs?=
 =?utf-8?B?a3htekdiQVpQT2dwblU2K2tQOU9lemJ1Y1EveHpuOG9oOUVpdEdoV09JTGFF?=
 =?utf-8?B?T05KYlBCOEtOYjVoTThEeEx2bDlGN2JIYkdxeWwwNjhQdDZIOWNoOFo5cE1U?=
 =?utf-8?B?TVFVY09qalJKcHZDRmkzcWJ4SkROSTFyMGU2MWhZajNDMWNxb1BBM3ZOVzZU?=
 =?utf-8?B?MUhYalJ4Uk9ZQUx3N3QrTmJuYjlnV1pReWpkZlpjUTB5YytJRzY3djUrZTcz?=
 =?utf-8?B?ZHhtY2NWemtYcTJUVCtybVBJS0E1U0tEL0x5Q2hpdnkzVklQRDBTeERJekl2?=
 =?utf-8?B?SERNa2lzL2tWcHZPVXQ3QWIwRVViK09jejl0MUJWWG5HdUhYa3dzR1VWN2M3?=
 =?utf-8?B?Zy9vVmtGZWd1YlZhYS9rZnE2emZhdjQ2MTNPK0pjbUJ4WlMyVWZiSy9VSk1U?=
 =?utf-8?B?RFRsMnBiVmdCcGlCR2FwNEJHbXk0UUd0SEdtcUt5REtGbkxDNkx3YmNQeG9N?=
 =?utf-8?B?eTFRR0VvZ2Vhb1BUVGFIbTU3djNDT2Evc25EK0JDam5pemREVDJEOXdEaTV5?=
 =?utf-8?B?b1VVbVAzMGZRM3RyellRTksvcVM3UmwvakNwQUZjZEdCTFRKMWNxTFpOSGRx?=
 =?utf-8?B?TGU5QkpYa3krK1l5TWlUQlZVUlpjWU9vSnpOMXNXeVBBZ2VqZVM4NkRsNEtq?=
 =?utf-8?B?bG1EQW1CM0E0OHljbmE2K0FDK001bDdYSEpaRFRyY3pPZHVXZlFTMU5COFZa?=
 =?utf-8?B?b1BGMmJlYUM5ZjJGVDMydEkrRDRoclRBUnZtUEhacW9TeXdOcnBzSno2QzZr?=
 =?utf-8?B?am9CcnVFQkdCSVRCMC94UzczUE0wbDVUMC81cmw3TVdwQ1laelprZmk5b2Va?=
 =?utf-8?B?N2d2dTA1Ym1WVjBRWnI3cnY0T3dGMDJFMnh6RWFtZFZZUUJPNTZ2RXJBRzhm?=
 =?utf-8?B?aVROSDl5WklFUEVPSXBFQ3hCdnlmVkdqaUNwVUFEOThzUkV2LzhVSGtTelVR?=
 =?utf-8?B?cVJoWXAvRWxJTVp3WVN6TzJTMjZlNWYvcG9SVVRTMy9mbXZncktON3ltU0t4?=
 =?utf-8?B?djArTUhFZ1ArV1BPUUo5M2plL0pBdVJYNzk1bFJaUlVZS2lpOHB0OER6dTRB?=
 =?utf-8?B?Qm9YK1R1UHkreHNoQkU3M2pCMTV6NGdBR3ZoTEU0dnVNZWF4VFByRUpIb1E5?=
 =?utf-8?B?NmhPc1E5eHNYNlhyaVg2VnlLT0hyTkluekFaWVdKQks5VEhZY1JkNzhNYW1T?=
 =?utf-8?B?OXB0U1V1dTBOVmlsSEZQeTQrNTZnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 529aef63-0b07-43cc-39a2-08dab8dbe611
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 11:59:42.6395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EoziM1E1/2rX+k+heGsdqSMfef0p8v7gy9NP1xizW9YNF7DSeyoRm8CHun70dFCaXceW/5y79QNFhMhTqkbXrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6638
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/10/2022 17:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.0:
     11 builds:	11 pass, 0 fail
     28 boots:	28 pass, 0 fail
     130 tests:	129 pass, 1 fail

Linux version:	6.0.6-rc1-g3df0520c3ce6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
