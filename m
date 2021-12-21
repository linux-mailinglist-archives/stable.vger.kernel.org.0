Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B889647C367
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 17:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbhLUQDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 11:03:15 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:42081
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229978AbhLUQDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Dec 2021 11:03:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j44ZMohedD4oLMxaVbRp2WVEv5QaEYC3qGyXZY1W3mzzvWY//lTlJ2ZPLWjvs2BsCweMagQnjuSsUD8LB0Va13M+NG6EmVr58gDOOuKDl/AjUKqTfj9UfihLOI4+4RvzyGOtbRy4ZBMXHnzb/hvY/iEDqOwgIYdXQhjuL1Y39Dneyong+/a4WzaMRoQWV5fson5ZDje3CQyohAWKxQXvtaYht/Vw8OGHBHDP2U9ieLGVzvkdADP3LRGPsoVUl9twGLe0HiWRHH+XcWUEqaTyYcx17z4J29QC2oJ2P/l6crxFXgDh8Mc9BT96XJEcMMbahMpzL5eW9TcWFp14vjA12Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMbxUVKY5j9p1DsuJ887XX3RlajPgNbdtzTbFAxEbEk=;
 b=CjhoZAHp1Urc8g10LkvL0ukU604pxX/Ndz48AfbXd97yjUdLNAkBH/vdGlUU5gjPL9a0zMq8JED8Ayr3omtB3QvLBD11Cr7zjWfak75JpCSOwH10V3upSjgcaGLvyUST2cLCzytfWTUr7nXWc1deqCPKbpjreCYN4nSp6Ck0H06fkq+StGNhvdS+Mm/dX9GAmNLsqW33a60NShC37X1bYpsZBYdSSjhLHdPhwYN+twxY8TH2lbUm+XRoCwtWOP+003NaFG4smd9cSdReCme8XKPByyXmFJXIOAlp0Qm9yYCiC64NrBl69XlRcglseBkah5Mzu8YGu74X00XWBakVgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMbxUVKY5j9p1DsuJ887XX3RlajPgNbdtzTbFAxEbEk=;
 b=jY64JP9GqYiIg3JicCeVKtg/tFexUsNBqgDeQJIYlHLIyTdtZMKAe/RV9VUHB9xn/0QFNfxvSTbAUL/VReM/l+h9M0/b9pDfp5+r2E1n796KyUnA662Bn9E8nWZFw9CwkADjW1qXFDsEhHQF2oURaJL+/CDa33H/MhV8rPysy60KIxHXPZHGAdUA5JJnAoaLswV6szu/+vd0gcMaUUlKNbNfawRLWwf5CsqqHsVMnRBKXcGvlaOXhJiOD/d48o9S1IjZW40/FX5IFkW4FySYbQwpn69BeomyzwOjuMWXL/nhN5ymrF8H95gSvbfeUWkXoNY4fXYbiwsivZ7caqz2ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR12MB1208.namprd12.prod.outlook.com (2603:10b6:903:3d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.18; Tue, 21 Dec
 2021 16:03:12 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 16:03:12 +0000
Subject: Re: [PATCH v2 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
To:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, mkumard@nvidia.com,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1640021408-12824-1-git-send-email-spujar@nvidia.com>
 <1640021408-12824-2-git-send-email-spujar@nvidia.com>
 <f859559c-abf1-ae37-6a0f-80329e6f747f@gmail.com>
 <f65ae56d-d289-9e3f-1c15-f0bedda3918c@nvidia.com>
 <46acc080-56f5-f970-a9fa-3a9ece0dd2a3@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <2d5c2e5c-f7a1-ede5-ba29-eaccb2b886d3@nvidia.com>
Date:   Tue, 21 Dec 2021 21:33:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <46acc080-56f5-f970-a9fa-3a9ece0dd2a3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: MA1PR0101CA0071.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::33) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5146a8b2-c0d5-4e41-b5b5-08d9c49b638d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1208:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1208F37AB17D49A82F342BDBA77C9@CY4PR12MB1208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7tDbYl1mTmSqfZbRWSnmIxlG8lGOyTr+ilgkqo2bJFBFAy5X1bULMuLaQafaLJYqAQw6rTY/nxRdfDbfNCW5qtBV7h/XIcA4wbnKUVxc08QkFq7sOnMVYL9Nu86X93TRBB/Qo8SBxcm2Q/Xk9fTZfnw07Wq004qI3bZih73X5Unma/951eHxrUYYwv1i2sGpLm9gzEfv4jFsW5AyqteVwNrgNKlFvPbv0NNJdGNPfvFEdSuHYa4WKu8fHAbtZO8sM8ueI2/X54WpQeqpTUbaCnOWGeUVlAqe11CoBg903uO3jYTR9QHNzuu1i4h4UxpYfeo6xLi7BVM2WtvhBKbhGsHT2/zQksTMJ2XT7Hyu8SGT8Od8yyhYrnYH9W8exIU4ScAJdUQAf8Ejrtd5O9r035mBchSiMyuDhkqCG6+RVL2EfN8Vuylq7j4+zQCERYULpan47kWngPiCOpbTqL44B6RVbU3Dv9hV3iSc6t4Xjv/oDMvZhS5rGzOmAQ74KChdaieKoD9pUr/+mB1YGsNzfNyJmIuJLf5qQtQeclkUA43IWtpqAVrue89WOqMiDkcmJKbgSoPj2BHpQQCnTVH21ysHFNLL9fmGeqz3X1LRvQ+TV/HEFx6bsugDvBWLJ9RR/lvAOeVoKyjDUiI2QgvaAK8litvBzXCBdJBSwcSkwSJRFY74k0xL7aHVLNbdRxwbKIwfjzS1cca9iL4849pbRSn1gyL2E1NADVUdgmYSvZ+LKvkOon1/XCBrc3Rze54lSaXDh+74Ca7L218QY+QUnwXAcWq1/vBjurUAOGVKEBi+WOnpkY2ewWSLv80VnNH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(53546011)(2616005)(966005)(45080400002)(6666004)(2906002)(7416002)(26005)(6506007)(186003)(6512007)(316002)(36756003)(31696002)(66556008)(83380400001)(4326008)(66946007)(86362001)(66476007)(8936002)(31686004)(8676002)(5660300002)(38100700002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlZZZWN5ZjFscVFVdENhRlBMeElZMFVnL01TNnlnM2h0K04xbXgyY2RZR2Fz?=
 =?utf-8?B?ZVp4YnkrVEVPTmRHRmJjWnNYcHppV0VqWW1Nd3c1WXZEK2dsdkliTFFlMmNV?=
 =?utf-8?B?QUxzSFhFYWllM29nQmd3R082K2c4KzMzRGszeitUcUl1SmkzMnVwcDVSV0dL?=
 =?utf-8?B?THVEVHRVRTZxU2RNZkt3elR6ak9UVVBuU3YzTWlISXVob0c2SWIvQjcxRFR1?=
 =?utf-8?B?U0NGSVVVM1BSb005bDlocWRhL0VGVzZHOXFadlV4Vk1LOXBkMUNZaTNWV0pm?=
 =?utf-8?B?VmxtcVlseGI1Q2JXa0xmNUpxYWVpU2c4RWtYN2VnVkJ3andLUm9qTHFKMVVZ?=
 =?utf-8?B?WmJRNlNZQ05ESlFSRmZLemxMYTR4dzZkQmhIOG5hK09vOERSZ3ZzN1lRTVll?=
 =?utf-8?B?KzdlMm43RWZ0VGRyZEJNcjlPK3lSMUpBTk9Fd3lmc25JNFlNTUR5NHNEYzdM?=
 =?utf-8?B?M1NmakZnQmxCaGVFa3YvYmVUdHYvN3FmNVdGV1MwazFvQk0xWUJMODBvTFpk?=
 =?utf-8?B?NW1Nc1pMNGFPSkxhSm1LbEsvc25icmx4dnU5VUNwMVQxTG5icE5ib09mVEdJ?=
 =?utf-8?B?VU9hR1h4VHpkTk11RnU1blpyZ0xGYzRaVXRWVDBkaHNsRlBuelNXYXZNMWZm?=
 =?utf-8?B?eXpaNGZXdUpkUUt1L25PMzV1bmdQazhzUWtmRTZsTHM0aVU5V1NTSEZqZzdC?=
 =?utf-8?B?NUZJR0h6dmF6S0lLN05TN3dna3cxbUJkTmh1b2NxWTk0NS9mYVQxQmp6Tlov?=
 =?utf-8?B?TWJicFdXUklzc3l0OTlpUWVOQUo3TjlMQm11ei85QmRvaEtYNXc1aTVHUnJB?=
 =?utf-8?B?bDczZ2U0QmRXRE1nck1YeGhQVlV1VnNJUFp1SUxucHdDWDJYUXlWakxRN2xE?=
 =?utf-8?B?UmRSV29OamhKdy9wYnNLbjZHS2Y4NVJsVzdteS9sT2tiQ3EyVjJWMDFGUFV4?=
 =?utf-8?B?RjF2YWlxUUJsalVqanBCdkRrazVlMktPWEVjUTlGQXJ2RFhPNWcxa0F0UDFO?=
 =?utf-8?B?ZEJCcVFndWg0ZTgzSUphbk45Rjlkb2ZXVmdnUE9JcFRKMDBqbEpvOXhIbjNE?=
 =?utf-8?B?QTF4akJBNmROWWJUMm8xZlVudG54cVEvbmZTeW1aekRlZSs1MEg1L2xLaTFu?=
 =?utf-8?B?M3p5LzZSbFNlSUk0NlFWdjJNQmw2YWZWbzZ4VmJnNFA2QkQzd3ZUNEhRRUMy?=
 =?utf-8?B?cXFkTnZPZXcwdWllWWFkVFVZVkJoMlZWZ0dHcVBpeVpGbFN5Y0hUNm1MSXNz?=
 =?utf-8?B?dy9LVGpubE40Z09nZ0JBWHBiVS9MNmNWTnk4Z2tYOU1meHdvRUM1L1JRaEoy?=
 =?utf-8?B?TytWT3lVRldyNE5SU0M4YkdFK3UxbVR1QS92d3g5UWxsRk1LaEpSQWZTVXZ4?=
 =?utf-8?B?VFYzV0RYMHFXaUVkU05sYk44SXEvQWFkd1NRclJGcVRwMEhxeHpGMjQ3Nms1?=
 =?utf-8?B?QkkxWFZUTDRlWHpBdTlHNDZnWGJ1bGRPVFdvM3ZxaXBOUm12SXRpSTdjTmE0?=
 =?utf-8?B?NXRZT2tLVEczbk5wZzhwWDhCalFPU2ErNUh2M0FjSmhCZURrQzcrdmladXR6?=
 =?utf-8?B?WkxhcVhBSy9jZHN0SGs3SWNnQzNJcVRsQWtaNnAvUWpBWHk2WFJLRkx4UXRN?=
 =?utf-8?B?WU84bC82UncrUjF6R1hLbm5xWUhhclY4WitINnVnTWk5aSt2eXhveEZ3b2Rl?=
 =?utf-8?B?b0szeWFpQWdBbHlBWDNoM3F3YlRnNWt2RjFFU2RIaEkvblZhekt4NGtkbHpp?=
 =?utf-8?B?N1VBY3UrYVRlaGZqUTMwTlIwdUdhT1NpRWJWczd1eHQzUjdYN2RUMW1obnE4?=
 =?utf-8?B?TzFJczhtbHk3ZnYrbUVldmhMd3piQ0dpOHZYdFBtcDJJVTA3bXdNOFVGeUE3?=
 =?utf-8?B?d0RTZ2VPSzZZcXhXUUFrQ2VId1ZsWFc1aU10U0N4ZkpmOW1mYjBDaTRMLy9v?=
 =?utf-8?B?cGkzVEw5T1VkTDZRRUdycHlXVkFJd0pBMm9VWFJmbzdmL0Y1OUhXQ0dHekpN?=
 =?utf-8?B?MHgwNmUyV2w1SWZBY29aZmdXYzZkcm5LTWpjUWdQcDlGbHVuYkQrRkxGaC9U?=
 =?utf-8?B?UWxZR3NwMVVmbzI0bTdwbXJDcUt5WEdXMm1PMEUrbVpHWUpSamF4L0NMak0v?=
 =?utf-8?B?a2ZMQTRPL1dSWWlUa0hlcUI4UEtOeWtKNXNuWGkzMVlzd290YVl3bmlzVURq?=
 =?utf-8?Q?mELBP3Pd9oNOqMHBr1v+o9Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5146a8b2-c0d5-4e41-b5b5-08d9c49b638d
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 16:03:12.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6VUSY3DOXh8GzVWFQr6Aq6EmpLx0PwsIdGerAHdW9fh3H9QQKzpsq874fYbgCPhcfiDUReVczfMFjOmwHEG0ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1208
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/21/2021 8:50 PM, Dmitry Osipenko wrote:
> 21.12.2021 09:18, Sameer Pujar пишет:
>>
>> On 12/21/2021 6:51 AM, Dmitry Osipenko wrote:
>>> All stable kernels affected by this problem that don't support the bulk
>>> reset API are EOL now. Please use bulk reset API like I suggested in the
>>> comment to v1, it will allow us to have a cleaner and nicer code.
>> Agree that it would be compact and cleaner, but any specific reset
>> failure in the group won't be obvious in the logs. In this case it
>> failed silently. If compactness is preferred, then may be I can keep an
>> error print at group level so that we see some failure context whenever
>> it happens.
> The group shouldn't fail ever unless device-tree is wrong. Why do you
> think we should care about the case which realistically won't ever
> happen? This is a bit unpractical approach.

Though it is very rare that something like this would happen, but can't 
be ruled out completely.

> If we really care about those error messages, then will be much more
> reasonable to add them to the reset core, like clk core does it [1],
> IMO. This will be a trivial change. Will you be happy with this variant?

It would be nicer to know why exactly it failed. Yes, it makes sense to 
have this in the core. I will send v3 with bulk APIs for HDA driver. 
Thank you.

>
> [1]
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Fv5.16-rc6%2Fsource%2Fdrivers%2Fclk%2Fclk-bulk.c%23L100&amp;data=04%7C01%7Cspujar%40nvidia.com%7C53e278c9a4804612f74b08d9c49564a0%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637756968218491760%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=QEe8SlSdAN1N8nOu3XqtAdbXP1JbtMBPlswqnBIhq5w%3D&amp;reserved=0
>
> diff --git a/drivers/reset/core.c b/drivers/reset/core.c
> index 61e688882643..85ce0d6eeb34 100644
> --- a/drivers/reset/core.c
> +++ b/drivers/reset/core.c
> @@ -962,6 +962,11 @@ int __reset_control_bulk_get(struct device *dev,
> int num_rstcs,
>                                                      shared, optional, acquired);
>                  if (IS_ERR(rstcs[i].rstc)) {
>                          ret = PTR_ERR(rstcs[i].rstc);
> +
> +                       if (ret != -EPROBE_DEFER)
> +                               dev_err(dev, "Failed to get reset '%s': %d\n",
> +                                       rstcs[i].id, ret);
> +
>                          goto err;
>                  }
>          }



