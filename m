Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA5B6D6E77
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 22:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbjDDU7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 16:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjDDU7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 16:59:39 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE28244BF
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 13:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBPGg0pRGRXZnDm079GS3qEwkNXJQh7dq6xGQdJ4yeAaH8FHTPzF0ACzRI8Gv1udIF39sLlM9kiFwubEAKvYpHMwhcHEp85fAVb51hGYxcezKSzadpp5bmq2ZBy0gAkc/AjBD795mbSyQXfL/isbiZAncT3MWzBDyDQOdATh7QlbHzHCITKW+MQpV3k9QIcs8nrLo2BrlmnGCXtonJtrrLhL8rA7OXuDbL9CnF5l7A8okB77mbIrTWXdgHt6ooGyeDof7IWGfWaPsqIl2mUHV5PzppfzyXvCb7PvpmQBvF9qLWS6lYarh+VilXSu51+gNY8g9cjkNA71JTCGwgxSWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+5NFHXngqAO1rFBHEts0Qs4Bfcxa8agEVJayBwSmCU=;
 b=OZod5dtyWWOROIt0dSdTFZ5WA57fbVUYw0oM+1UPUHje7d75kYU7KeKG6w+AWc30Kox7ZPW0iB9Q1al94BybtXtoR3ewGq4ybDqLfASZ7YQStaDO0CmJ0Nvw9wgNBdelcIOaLWV2CyT5uJLjTSCk8lj8oJjQy3UAoPc5YJkAKFsZ2tm/q9zZ6Gflx32GWIJjxi68pLUHfGCN5hsVkMulz7b3HFnZJo7+YL5WEjCwGug1ZFDNK0z2/JNWc+wrqr6tRcdNXcpqhKOk7DR3BqLV5vHs2g0y1g7N6vqWkajv1X00VkwkXLGMi9xNaU/B31BFLzh9oZZpU7Y8o8MdM+TsAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+5NFHXngqAO1rFBHEts0Qs4Bfcxa8agEVJayBwSmCU=;
 b=RM7KJ0UN5isAFjeuTdGurOUCKOE8BAyo3xZ4dwygaJqsNAEqJt9WVjl4277+ZvRsKOjD0erZpgL4SVNuY9Cu8UmVUox2vJQUVDHYPDhbu8BN9Pjk/twnakcHJioTAUJD72aTkjvY/94KVF2dTIHGFVbijYqxuP/dkUCicFEGqGyoA3Vhh1aKZHmumlJ4DLr8laDcUEr/pBJD6voeSVK9t5incQcSgt8H/e378cLvdC2wPvmn6R0RTq6KE3pLB8joiSxWUUVuhbJNTMcVZBcJCVzTpMaHeV2d9FoeDJwS1G3qhvWpv65qpifC7biK/m4y2BZF/PfIRjXsIjz4QXCuzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2981.namprd12.prod.outlook.com (2603:10b6:a03:de::26)
 by MW4PR12MB7333.namprd12.prod.outlook.com (2603:10b6:303:21a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 20:59:35 +0000
Received: from BYAPR12MB2981.namprd12.prod.outlook.com
 ([fe80::eca:4dea:f6d4:88de]) by BYAPR12MB2981.namprd12.prod.outlook.com
 ([fe80::eca:4dea:f6d4:88de%4]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 20:59:35 +0000
Message-ID: <090966b8-acad-62df-40aa-232471502edd@nvidia.com>
Date:   Tue, 4 Apr 2023 13:59:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 7/8] video/aperture: Only remove sysfb on the default vga
 pci device
Content-Language: en-US
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
References: <20230404201842.567344-1-daniel.vetter@ffwll.ch>
 <20230404201842.567344-7-daniel.vetter@ffwll.ch>
X-Nvconfidentiality: public
From:   Aaron Plattner <aplattner@nvidia.com>
In-Reply-To: <20230404201842.567344-7-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::18) To BYAPR12MB2981.namprd12.prod.outlook.com
 (2603:10b6:a03:de::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2981:EE_|MW4PR12MB7333:EE_
X-MS-Office365-Filtering-Correlation-Id: 547e2f34-8f4c-46cc-1c10-08db354f7efa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9GU2PGQvO/FWpCtDjk7YghNhOhcsl+cpaDXBGEUZABo6f6HnzDDpjnklPdpkbGRIXqvZaIKe16VkpqPT2yL+zYgmaP7u4yiMzJqO+WnlQCCJ9YfWejmku79IdWj+/aeIkib/hGxbLyPlQdpE6f3RDN/oDw4TOUCtSKKuuRxR071EdH1imickTszCM8ysA6r8QQqSWFaJcBIibZVg2U+etLRbYSCOn2pBDSYfwOp4KIQ0w2F6qZn3mR4hy0NqGhHbLE6pTMnMNrZsBJJq8C4lxqss+8U6X+YWj72SYw8wLUR2HPJiX850GAuSwV81JiMZvhgE3d/OUWeUhuO1+AB0J4N/t/JZcbi8FWz/BWE6j5vHUrMxuFCUtd+jdRJTru+3pXtwrlaGKx5xmdi6EEjEP+9frkeNdA/7AFpGub8o8RygQJcRiWAuNsC9TpOEmOsVTX6BPjNkN3N0pp661imu5PTwCiYQnZWeOsniLewFH5TIk6pLmPgJE/65jK9Qg4Gpr2KaM1yILuWer+ohm/U9p9zov8kwA6CwQ0jXmvDzTotatmFWdmXqS9HefTU+j09iQK8+fXLQ8qftYvFfEmokCaHZC213ZK4sC4ukx24wtdUufXHOxMprsUztiLQFQa80qunTag21YAZQhfWBh1Eh1whq/BG5a/DPFSOxZOv0l8b4bINJDi/El+RoGWK6LWA7qyc3fSiQ2umtA4xfGPRYMXfZKttax4QCW66H31ADNg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2981.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199021)(966005)(6486002)(5660300002)(36756003)(478600001)(38100700002)(110136005)(8676002)(66476007)(4326008)(66556008)(86362001)(31696002)(66946007)(41300700001)(316002)(54906003)(8936002)(2616005)(186003)(31686004)(53546011)(6512007)(6506007)(2906002)(7416002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGlXUEdGaXlISzNzR3U0QklBT2w2b0ljRTN6eFYrYlQyWEhBczZ4b043eGwr?=
 =?utf-8?B?TGF3WnFGQzJBYW9vblduMTlUZ3dxT1RUWm91cUd1MFZCckVOWnlUcFJaOWMr?=
 =?utf-8?B?KzR3bCt4Y05UbGphTVR4ZnVmRlg1a1V4bzNOY1l1b3U5cjhMR2tnbkV4YzZX?=
 =?utf-8?B?TFMyN1hXUHl2VzZIVUFqOExjNmd2SnR5Yi9JZWZUUHNRRWZOM2JJMC9ZV0pP?=
 =?utf-8?B?YTk3cEtUd0hWeDQzZjhqTnF1NFhrK1JCRElyUVJCRUJoczN1RGFzVkJXSGdS?=
 =?utf-8?B?SUxMM1NwaGVyWXRTa2JaQzZ2M0hOUE1icEMyN0VkVmtPRGtieEZxOFNEVkNa?=
 =?utf-8?B?UzV3RDRnTm1xQll5M1pVUUl2RU9CYUZYME4wYTRBR25vZHJwNTBpTWhBOW5E?=
 =?utf-8?B?dm8wYmlXNHRpZnBqM0lCZTZEUFYrNCtrL0JzR05HaXpCSmFqR2dTcEFwbU1x?=
 =?utf-8?B?MXZvRkhyb1VzejJwVlh6SjlMeEszUk9zQmlZL3RtOEJjWnJDTmJXQndwUEJu?=
 =?utf-8?B?RGFTYTlEVmlua0RORWZUb1hEeDJveW1weGprK29QcUVoZXNoQ0xPZWNYMDJQ?=
 =?utf-8?B?UW1YcWxuZDB1a3llQjk3ZWtVbHk3Zm5zSWVIN2Zwb1BYMDRRL2lKUTlQaVhZ?=
 =?utf-8?B?QzM1ajdFZEVyRWtiMy9rK01uS09zclZOaVN2OWU2QVVSNjk5c29ZRitrZUlu?=
 =?utf-8?B?QW1PQzhVRHlZRXQ5R0dmUGltYXFPdHp2MUlEUFcxZG95VllJbWEzOEJXR3pI?=
 =?utf-8?B?NmU5VFh4Vkluc2hIdWFOZFVmTTh0V2hPU0Y0VHMwcVRaL3NTMVYydXVUN0NQ?=
 =?utf-8?B?OU9CbXp4Sm5MYnlaUHIwMlJnRGVjQ3NIdnF5bkVxUHdQdGsrRkRzdkJaQVVO?=
 =?utf-8?B?OWREbDVBTjZTU3QzeHVvSUxzUGhkOG40VGlEZnduemVkMWtFLzE4NllHczhH?=
 =?utf-8?B?RHZyNlZmMUsyVXkzLzY4WW9QSk9SYXQvQjFVT0pwQUZlUlZiaEtwWWJIWmdS?=
 =?utf-8?B?ZjRiWkJzbktYK0FMd2pYZ3c4bmdqeDJrMzZ3WUF6SWVCYWtrbTZ2TisxM3BQ?=
 =?utf-8?B?bHpmQWxoREl3QnEycHZTdUNDcC95eU93T3lnTm1hS1YyRHNndjFzSjJqeGxj?=
 =?utf-8?B?QU5MWXFGbDZRM2JUdFlLV0R2MUwxcUErS25lQ0J2SExGN0NrREVrano1ZUJJ?=
 =?utf-8?B?MUtBeitSbEoyKzRzVUZVeUpyZGtkbkFqV1BFTnp4RDQxSFBYc0FtVzVZQUgv?=
 =?utf-8?B?S3RwamlQOEtiYzRvaHZRV1JyaGJab25ZQkZPSjJISzNrSWxEQ0ROSmR6Nm5s?=
 =?utf-8?B?NHFIdG1mRkMxemd1clJUREJyUnpoQ1E5QnIxMC9ldHl1NmJGUW0xVWpISXRz?=
 =?utf-8?B?UDJOdFI2KzAvTEJoTUNpZFhSeGJ5bzl6Ylg0TWlqT1krdjd6NEJZOXA1ODdr?=
 =?utf-8?B?WTF3bGZiL3QxUjFaZlJDRVR5cCt4OHlqU2Fqa3JORHRoTXUxZitlWFJGemtL?=
 =?utf-8?B?ZVg0WHNmTTkvTThLZTFxR2V0YUJLamNBVXZnekcwWEJvWThEcUFKY3FhNHdM?=
 =?utf-8?B?ZHhxakR6OG5jR25QczBIU1VIRnVCcDhQMnlzM0Z5UnpWYWJ3MEh3NkVTWXUy?=
 =?utf-8?B?N0tqYXA3TWlpclVkZ1Q2cHdvdTVwN2Z1MGlPODd5LzRFb0pQb2JKNVZ1anhw?=
 =?utf-8?B?amwwN05JQWU1eVBmV2QrZkpvVWFuSjBzeVA4bXhmc2VYSlJrRDB5NExXM0Q1?=
 =?utf-8?B?eDRYNklYWWJ0UjJZNUFIRWIyRi9YMWZHY2VYZU9nM1FVNWNKeVBoQU5GODVS?=
 =?utf-8?B?NmwxOGpMSndOM0Q0NW9vYWRHaURQQnZXU3k0dU9KQyswR0c5K1dPUWVYSkhC?=
 =?utf-8?B?S2JoZTlndWNIZ2pGUUJpa3VybjJ3OFVNMi9sSkU4eEdsY0JwSzZNVEV5Kyts?=
 =?utf-8?B?NEZrRjlnaE1zY0xyRnhxZ2orUkZIM1NyRGhSa2VOY21iY1NqYkpyTVoxckp6?=
 =?utf-8?B?RExVZWZaRGFaZzRxalg4SzY5bDk5RDN6L3Q2S0g0dHhNWnB6UHphcEdDYWFO?=
 =?utf-8?B?MXhQT2xrRGx2WWFlUldRZnJOYzc3VDl2VWw4bWlSRE5LUFIyS0F2dmQxWTN3?=
 =?utf-8?B?dU13a3hpU01oaW1NZ2RvMW1tWGpZK3VzZENSclV5aXRLdHY2YmIzdDFQYWZs?=
 =?utf-8?Q?lJoFsVpz3V3WUeblx9OkWbU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 547e2f34-8f4c-46cc-1c10-08db354f7efa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2981.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 20:59:35.3123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U//aBKCGJ7zI71raPXpyN+XugjAv4vtST2jSw2lZVdaOnzspAmHPafZOjtASjqeZ/x8fgsoy3XwEDYG4vBb0Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7333
X-Spam-Status: No, score=-1.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/4/23 1:18 PM, Daniel Vetter wrote:
> Instead of calling aperture_remove_conflicting_devices() to remove the
> conflicting devices, just call to aperture_detach_devices() to detach
> the device that matches the same PCI BAR / aperture range. Since the
> former is just a wrapper of the latter plus a sysfb_disable() call,
> and now that's done in this function but only for the primary devices.
> 
> This fixes a regression introduced by ee7a69aa38d8 ("fbdev: Disable
> sysfb device registration when removing conflicting FBs"), where we
> remove the sysfb when loading a driver for an unrelated pci device,
> resulting in the user loosing their efifb console or similar.
> 
> Note that in practice this only is a problem with the nvidia blob,
> because that's the only gpu driver people might install which does not
> come with an fbdev driver of it's own. For everyone else the real gpu
> driver will restore a working console.

It might be worth noting that this also affects devices that have no 
driver installed, or where the driver failed to initialize or was 
configured not to set a mode. E.g. I reproduced this problem on a laptop 
with i915.modeset=0 and an NVIDIA driver that calls 
drm_fbdev_generic_setup. It would also reproduce on a system that sets 
modeset=0 (or has a GPU that's too new for its corresponding kernel 
driver) and that passes an NVIDIA GPU through to a VM using vfio-pci 
since that also calls aperture_remove_conflicting_pci_devices.

I agree that in practice this will mostly affect people with our driver 
until I get my changes to add drm_fbdev_generic_setup checked in. But 
these other cases don't seem all that unlikely to me.

-- Aaron

> Also note that in the referenced bug there's confusion that this same
> bug also happens on amdgpu. But that was just another amdgpu specific
> regression, which just happened to happen at roughly the same time and
> with the same user-observable symptoms. That bug is fixed now, see
> https://bugzilla.kernel.org/show_bug.cgi?id=216331#c15
> 
> Note that we should not have any such issues on non-pci multi-gpu
> issues, because I could only find two such cases:
> - SoC with some external panel over spi or similar. These panel
>    drivers do not use drm_aperture_remove_conflicting_framebuffers(),
>    so no problem.
> - vga+mga, which is a direct console driver and entirely bypasses all
>    this.
> 
> For the above reasons the cc: stable is just notionally, this patch
> will need a backport and that's up to nvidia if they care enough.
> 
> v2:
> - Explain a bit better why other multi-gpu that aren't pci shouldn't
>    have any issues with making all this fully pci specific.
> 
> v3
> - polish commit message (Javier)
> 
> Fixes: ee7a69aa38d8 ("fbdev: Disable sysfb device registration when removing conflicting FBs")
> Tested-by: Aaron Plattner <aplattner@nvidia.com>
> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=216303#c28
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Aaron Plattner <aplattner@nvidia.com>
> Cc: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: <stable@vger.kernel.org> # v5.19+ (if someone else does the backport)
> ---
>   drivers/video/aperture.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/aperture.c b/drivers/video/aperture.c
> index 8f1437339e49..2394c2d310f8 100644
> --- a/drivers/video/aperture.c
> +++ b/drivers/video/aperture.c
> @@ -321,15 +321,16 @@ int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *na
>   
>   	primary = pdev == vga_default_device();
>   
> +	if (primary)
> +		sysfb_disable();
> +
>   	for (bar = 0; bar < PCI_STD_NUM_BARS; ++bar) {
>   		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
>   			continue;
>   
>   		base = pci_resource_start(pdev, bar);
>   		size = pci_resource_len(pdev, bar);
> -		ret = aperture_remove_conflicting_devices(base, size, name);
> -		if (ret)
> -			return ret;
> +		aperture_detach_devices(base, size);
>   	}
>   
>   	if (primary) {
