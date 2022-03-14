Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DEA4D864E
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 14:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiCNN7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 09:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242044AbiCNN7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 09:59:33 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2061.outbound.protection.outlook.com [40.107.95.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F365524F2E;
        Mon, 14 Mar 2022 06:58:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEYvr2G6FOQXVxOuNv9zl7asLFpwpMs9Vxi60BT9i6ZIR94m+F6yztEDDnG+5TMuefu5CxBGJVGGLMqhXJ3onT/D2H3cw7Pgm9hEA6243hnw0/J57LrQnYyCxPywQ4UvMW5pZOXxQfmic3BZ3C5uUWXKiUtg2FWc7lLy4h3/tAN/auYyZC9ty2vQ0jKgzOzs7Qn4/GzQ7aG4MhLnDxUBtqS+Yn7a1IU9HqmUV/wdy1UvYbThulpfoJgKarXowSZyMxqQ4kHfvfduzigu5n4NCnvz6DRBOzTS9fiUBYwhKdlFuWUrpzc9s5cTsHeN6noG+ltxJqXAStT4nf/3S7Gu5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K74HEb4uW97UusE69BxwmLK9fbMug3aAD7HxH+Z/UTo=;
 b=abwCyPdsqIglbJMFHJswnx+I+IXDBGiHsYwTPCtWCOcu6iwUAH7G+H+KzaSPJQotvL80/dJWcwB7uTzsUmZ82wH5oJ9NK0BV8U3d/FvZ7A0ecOdR31u2OjMUu9BoZqYa/rIwslOq+hvJ++HnmSS1LKIuziwqWt4UDZlfqP3PCMowe0XnWou4WHDdXTavAGo/KuZplELBE46WPQ8RwNgGYPZ/vTd1zLOK605zh4qmqCSqLN0PN7ubt/bpQxiMZX8U5E6OL1oJRj02tY7Pr/EVexha1DmB5NQKD27GQfkpOJwC1wZvL/UT3reaR84s1MrnYQ5Ci1rBC7tOSsjKghvHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K74HEb4uW97UusE69BxwmLK9fbMug3aAD7HxH+Z/UTo=;
 b=rTDk2Dh3mh8Cvwwl7rZLoYyisRf022rFWujQEqVrzHsXSKBwtMIrMw7UJipX0UAlTBUKAalB6A7sajIfatVZXLVzGO4feS7ThmfmQ085dYNan5ru4bImAaVgTmXxbdn31JDvetOn00LJ8gfjzwyHdBvrrvqtRcblEbvTOLjnmzNHeYkpi8HXn6o3gwI2rGmqoU8mQIUnGrfzeQZiu/lAxcdGC2q8Kt+HmNwaEpMiSH3gH3KIVLzv5+lmRHhCdQheeTWN4IrJ6108ChJHSHrOz8pk5uOygKHQyFqTke5MMoDeJEnUrlBzVlIpKjLy3rc8lcRmCloGcwYRu6h0wK6NhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CY4PR12MB1896.namprd12.prod.outlook.com (2603:10b6:903:124::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Mon, 14 Mar
 2022 13:58:20 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::88c:baca:7f34:fba7]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::88c:baca:7f34:fba7%5]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 13:58:20 +0000
Message-ID: <0ac87017-362d-33e2-eace-3407e0891a94@nvidia.com>
Date:   Mon, 14 Mar 2022 13:58:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.19 00/30] 4.19.235-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220314112731.785042288@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220314112731.785042288@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS8P189CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::7) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81d3a79a-0193-455f-79e0-08da05c2b249
X-MS-TrafficTypeDiagnostic: CY4PR12MB1896:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1896FBD0B152944069DA3F5ED90F9@CY4PR12MB1896.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DxTew+YJiJhxpeycZsw8gpHbcUwgYxhi8XYT9+INxVpixGYrOTwTbg0ZaU+EGz3Q7qTCygN5fEmG1ln6NovFj3ZkKUWJRaTAW8rVPJkygLzgdg30b18ueYOgBwcSC44d8V9xjGiA2BwUAYoqRi0Ppa7nEbNzjZa9gL1IpAVM4KbVt9vYWl/a2nGK1blVADjredgzcHRRhNakNhkXSiwEhrgZlZT6QDZj5sRA188mYWoQQ3HOmnxGNMfhl+9/9gPMqlTRYXl1w93Lp3lLpLY4XNkI9w79djcCEUmcxjhoeHzTTvhHpbHLEm04Wv4Tiz/yB5xM68APm555VpGVm1xAn1DKsyUiryZqBTeXbbmjS4EEne27MfqPvsMW874Mn6dgkoDTfeuLaI0pwaVbd59cB3aMfE6d57ft+90HVtZ15Dzm3a4SDyXtKbGE2XBUYv0C16eqvv0yst4aouJ+XJSk4hrw03ePHhGvaxs+936VtsjNgIss5m+wrRSekkTCfatWSAdMZRrgCSvde5gNtH/RRou9ZZIFHbdi1GXmLVCK0b5jtSKhnBmrv/o08k4+ZPNS2xDnafidjjV/lOFrSkFmC438IO7/gsea0xXqJygxm4kRm5EPKxL1kwMEk5SMckR8ESQXcOHt4y5RR/sKZFVDMMw8q4lvICroohhPyl8zEk5xRS+c6l7zElLWxF8eSl4bgU24+N4lDgfHjrAR0FmX2pxEAVtbewRulZpVrflLcEKmqxzULPlKJNtUtO4PHMeVYcoxWoooWLKUoiT3PnrlRE+QUFFVXqCDX9w5aYf5JXyQgLF+bibw7DrVgLykxjz8lfciuMuck7FRfF+3Ng9I8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(966005)(8936002)(7416002)(5660300002)(508600001)(6486002)(36756003)(2906002)(38100700002)(8676002)(4326008)(66556008)(66476007)(66946007)(86362001)(6666004)(6512007)(53546011)(45080400002)(31696002)(55236004)(316002)(6506007)(26005)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE5UU3lNR3BpeC9yTSsrQk11K3JIL1hzdnMzYXpIUmdoSC90aSt6RjJieVZ1?=
 =?utf-8?B?SEJrOEpNbkI4ekNEV09FSDJobFk4bXY5bUFOeW5LclB6RkxkaTRjaFdMOVU3?=
 =?utf-8?B?aFV2Qit4MzhNRFFBVkRDaTBNVDU2K3dEMXh3WXB4MlhHeEsvSE5oVXhGTzVm?=
 =?utf-8?B?RXFodXZqMTBvRHRqRy9nTjdMQWlLYzVScTN0TndzTUt5OE53ZjJtcXFjbWly?=
 =?utf-8?B?VWc1ajZLRFQrRlFLdWdOVEpHdVF1RThrenArcWpjZ242QTlrNEw2REY0U0FI?=
 =?utf-8?B?c0VGMHltbzZ5clI1N2NrRnpPSEM2ZTFLSVdKUElRN0ZmbEFWUlI1M1RaNXNq?=
 =?utf-8?B?ZmZXZ2d6TktmTjJEV0gyZjZLSjREYkhnaW1YOXFNL3lPUVBkNDN3Y1k4MXFS?=
 =?utf-8?B?SUZwWVcwNXFlemxGZHVjQnJtT3ZmTGdteldQdG0vVXMxVnBiYTc1RER3N2xE?=
 =?utf-8?B?c2NNQXhDcTNnZ0tiUDRtaXY3UXRmYnlLRExHT0g5aU1MNkpiRjV6R3pKL3Fq?=
 =?utf-8?B?WXgvc05rYTBKcDhjRms0ZWNiM2lRNmFnMFZVaXRwbFQ0aTJqY016ZXpQTGJV?=
 =?utf-8?B?azI2MEhMWEFIelBnN0lQcEY3Mkt0TTZFY1RpbW00UnZab2xtVVRyR1ZIQmRZ?=
 =?utf-8?B?TlM3TmZ4U1ZlZXBwdmNWbmllZjhxVFFPdzNpaG1Jd2t5OUNTL2lTKzFHNzZj?=
 =?utf-8?B?bW9URzBpdTA4b2h3c2Qxc0JNVEJLSWh0NWl4RUtPait5VFdGWkZjNXY2YnBP?=
 =?utf-8?B?RW8zU283WGdxbldLVktsZlBVaUYvVTQzekRwQ2Z5NmROR0IyNWNhYy80TVZG?=
 =?utf-8?B?dVFVUDRLVjNFN1cvaUlHTWRRR2pBemZ0cno2Y1hvYjk2SDZaQVJXZDh0NXdJ?=
 =?utf-8?B?VDZDanM2eXhUYjRCNHFiQVlzU2M2ZVU4S3EvTGVnOWdRSXYvdGowTnF4WDBQ?=
 =?utf-8?B?N0dlUTN4cGs4UlBLcGtMbU10OWZEUDljREJKcWlFQm9CNlNIb0VtZUZxZ2lB?=
 =?utf-8?B?cEtBZ0ZaZ2ZhNEtLU3pjNE5id3d0VFV6MFNQRWZjVWwrZy92QmE1Q01QSzBU?=
 =?utf-8?B?T1F6dHhNYW1neWpETnNtQzcxVHZJblJOK0lLU3k1Y2xSS0Y3Smtvbi9DYlNR?=
 =?utf-8?B?SGxTbUQrTHZjYkFNYTdDdzZqaHIwWG5FdEFWQktNTDRWazdUVXhFcG93bDlm?=
 =?utf-8?B?OHJLQmQvRDBJY211bXZUUjVCaFJmUWpORzg1TjA4ZEFxUUdqaTY2djB5WGRD?=
 =?utf-8?B?YzdvYjRmMk9HT1o0c1Z0TFh1TjhmOWxJb1hoRU1rUDVMNCswMithTmtVZlU0?=
 =?utf-8?B?d3R4Sm5VSzBFV29BdHZyaFg2WEtic1dsVG5uZkNOS090WEpZNXh2d01QMVNo?=
 =?utf-8?B?eGVFVTlEWHh6bWhCMlNPMUFINVhudU9ROUJ2M01BaitYckt5RnpocmJEazcv?=
 =?utf-8?B?UVUzT3drZy9EdkZCWHJqTWJGOXgyeEY3WjBzRnlaQjRiYTRFcmRBbU5rOTlV?=
 =?utf-8?B?QkJQcjczOHo5bytWR1paVDRkNzdOU3hXTVV2YVhkQUpxdExlcC9scEp4RWJY?=
 =?utf-8?B?YWwzOVBoVzZTNE54d1d5ZmJhamd6eElCTXdsaXZBMVMrcEhUNE1uMFZNT1hC?=
 =?utf-8?B?cFRmQ3JrVEkrekNFajR2eXNlMW0vTHhpbjFVQnNqMnpML1JEdTJPczc4Qmgz?=
 =?utf-8?B?aUJEcDEyamdndDBmcUs2alYyUTJJc1lvYmtYVGxhamVkMWRMSG12ZkhuTGJz?=
 =?utf-8?B?UUdUelBFZDJPTlZHdThKMUllOXVQSWFLRE1DWDdyUU8zV2VHZjJDNzRTQ1A1?=
 =?utf-8?B?ZjJjc2w0bndaMnZLTFgxa0Nqa0JpdWUrb1F4citBMDZEL1Z0QUU3SFM3SkJK?=
 =?utf-8?B?aUZZdHRjQWFPTmFLUWxaeU5MN3B3elBJMXpQQmVTaUhXWXByY245K1l3Tkp5?=
 =?utf-8?B?NzBsQ29UbnJ5ZCttZXNIR3orSzYybEVtR3lwZ2dzS0VmdXpEbE9uOFBZVjZT?=
 =?utf-8?B?TjFGMU9LVXpnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d3a79a-0193-455f-79e0-08da05c2b249
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 13:58:20.2268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eK98i0+ogAStaq+3ud+F9JOj/644llykOYMWyG0CBSju3xEVVp+518kwf7kMrLUF66mrao7rsgedkJozSFKIAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1896
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 14/03/2022 11:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.235 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.kernel.org%2Fpub%2Flinux%2Fkernel%2Fv4.x%2Fstable-review%2Fpatch-4.19.235-rc1.gz&amp;data=04%7C01%7Cjonathanh%40nvidia.com%7C4c0c664e42044e5bd8a208da05af4c30%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637828547981871505%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=xF4hLHeQMZiCVtbZX2jXwWYGz30QY84EzlbqHLPUZSs%3D&amp;reserved=0
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> James Morse <james.morse@arm.com>
>      KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU


The above is causing the following build error for ARM64 ...

arch/arm64/kvm/sys_regs.c: In function ‘reset_pmcr’:
arch/arm64/kvm/sys_regs.c:624:3: error: implicit declaration of function ‘vcpu_sys_reg’ [-Werror=implicit-function-declaration]
    vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
    ^~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:624:32: error: lvalue required as left operand of assignment
    vcpu_sys_reg(vcpu, PMCR_EL0) = 0;


Cheers
Jon

-- 
nvpublic
