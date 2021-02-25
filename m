Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2197A324CAF
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbhBYJXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:23:05 -0500
Received: from mail-bn8nam08on2040.outbound.protection.outlook.com ([40.107.100.40]:12452
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236171AbhBYJVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:21:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRpVfTQUpFBgFmL0dbcmE2shtrtIqxMwKvehbQUUUMTw0WzSFsrK6sGC/v45QrUuBoLAacs6+/nfhl2x/pH/ocS+Ldax38UFfwPvR+9W9pdGijD4efU+FlMvhkrkFset+sRO/SWNMo8Gzxjc2fZvaQmYweK0/Nl71rsuP5V1p4iLAJdcTlSvywMPaerGsLBIbTAacjDVznMfa13xxLSk7qT1p5Vv6Qr/vKpACJSdZgYzG/Omf89bgMReonL/mYw4mCUt1xUd1Ne0OclnHgfWQwgz2mC4kS4ivaZfglOyzqDZwVUamiaIluNW/AQyhzvmxYPKJIvXzCLpBjtDX9S7ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8459AF18gdRset+PItRCTp/dp0P3JBO1Cioqb1rGtVw=;
 b=eoxUqxIAVJAyrbPOTbd3c79m5bbZHGy2DgqPgAn2LgG9DlQrIHsFE8oO1Y/nxvIxYBzIHxcpuIw7kqphjMgDVZrILfh1Lg8lJ7itIrBmvWP/N30mVwmw377vqGiJNH+JA+EaQx+hRn/BXuNzhbYsn/SoyL/gU/NLGMkIKsQQUUOX12r7t//p7f6W0HysP6uCnDJS9yg2CT1uU5JbhaNpJhT63GyfA/AlN63mqcflwyoiWi6bdQVUgOU08OIZ3Z8bIBtrUhvDqAaS+9PnmX63JiRmEAC/oyujV4EM+OGwFtfL5VoturYEPagf/siO0TMr1qSzsgEhP6O75PNAOVlVXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8459AF18gdRset+PItRCTp/dp0P3JBO1Cioqb1rGtVw=;
 b=fQjA8KK3TAQW2aM+mgzbAMHtMfRyfJrMfkpFxdknGXS0iEDNFNfQ/ONUrlqu88hShbA8vErwejWkmpaNDF40hh07kcN1sp14l6qtZ4IPbjRGN82mROlGp7Fg2UAzLTFc7oOZiejnuLSnieqbPliadeLoG+m2vjIUmhb/faBRrfQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by BL0PR12MB4930.namprd12.prod.outlook.com (2603:10b6:208:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Thu, 25 Feb
 2021 09:20:06 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 09:20:06 +0000
Subject: Re: [PATCH v4] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, stern@rowland.harvard.edu
Cc:     dri-devel@lists.freedesktop.org, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
References: <20210224092304.29932-1-tzimmermann@suse.de>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <2803deac-629b-f51b-3d8f-7b1ffd29c825@amd.com>
Date:   Thu, 25 Feb 2021 10:19:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210224092304.29932-1-tzimmermann@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:fc8:43:f4c0:95af]
X-ClientProxiedBy: AM0PR01CA0099.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::40) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:fc8:43:f4c0:95af] (2a02:908:1252:fb60:fc8:43:f4c0:95af) by AM0PR01CA0099.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 09:20:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 99e463cd-7aa0-4e5b-f967-08d8d96e89eb
X-MS-TrafficTypeDiagnostic: BL0PR12MB4930:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4930F863EA0CB1043082048B839E9@BL0PR12MB4930.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dMZ4wyDpb4fIpuSj8puT2MiC1i/kpzHt2zEDHHFjjix30F+U5m3Ev2iuJuB5xNuGxY+3BjYgDg7Qway4Y4JbeeQisKC/xKvFWwLZ5JsgMBBzrwMVwtRyFjXR0zPYl4T/uDji80wh5ckwUiq/1Gu/WELWMFY8pU0tneR1lcQIb38Y+W2++PbSL6kVgf6IAx+BcqoE6Iw8JDVYMvpzZXFYgQJ8T5VPUptDcsYU1E1PuRTzoPgDAv4MNolfQDzY3/Jc8B4004V7PRV07u/vTLS4g3T4FkwgBjgE0Re8puCI7FFm5nZMsf+vXIGV/moCwdlnby0xfHy1KRx2gwBp7LFecZGwn87toD0Z/BgZc4aFsfUMMvspLO8QDnQ5+OP90F/Y46hAOKwcov4RbUyYi/RqYelYppz09NIrB2Q2leswvBo3C7tDzl+0Ah9dcrh8E/STYaSXbjgUL0hgwXZAnAZ0cA22hYNbkRPcdlksvjK/6+TqPGm9mnc2zJrvYwy15jWvQ4oBeuLukX4m9nC81r0pvbKenXucIuraaNwapNwK6AxS4D/B5g4JujASVxoVUzJsv6cotUnoX6iCeYzmhOzTvZvqvblaV6X21G03+PmUs+s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(8676002)(5660300002)(6666004)(31686004)(8936002)(86362001)(31696002)(4326008)(66574015)(52116002)(83380400001)(921005)(316002)(7416002)(186003)(16526019)(66946007)(2906002)(2616005)(6486002)(66476007)(66556008)(36756003)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bnlwRjdibWI2eklCK3VtUkFpZVFDQnZrbnhSOEtwMlFlc0xoWnBkaXJLSEJP?=
 =?utf-8?B?eDIzQlBFb1djS01UMC9ocVNWL1h4dnZUSVY2eDZuQnBnYWQzWGNSNXlhTE5B?=
 =?utf-8?B?ZW1zNGFueHAvcTA5VjNBTmVaVFNycktMUUJ1TVM2cXd0eWszVk10QU9KMzU4?=
 =?utf-8?B?SVdQZ2lWZGxqSG0yWEZjQitFZGovTWh3ZVNKYkxhKzRacFFnaDg4OU8yT2Jw?=
 =?utf-8?B?VXMvREJwSG01eExCZlozOWtXbzhtZURhNllLcTNXZG9HZWRUNS9jKy9XbFFD?=
 =?utf-8?B?TUl4RkRhSi80OWluZ3VZeU0zNlpiNk9qejZrRWxXb2ZGUjNqbjYyTG9SVm04?=
 =?utf-8?B?VUtxQjUvb0g0OHB0SXRmMlJCbHpDNEdrVWt6dFJhdGJGZkRWQVhZUEFtaE84?=
 =?utf-8?B?bmZRUVhEcHFWdDQ0ZkljcUhZeGZIV1JvMEJGaDlndGZCREQrTGFKSWt2VlJ4?=
 =?utf-8?B?cktuZFNDSDU1bDFYc2pQWm1DS2tRSHdvd3hIcDF6V1orclllR3MzZ1NmM1ht?=
 =?utf-8?B?bFFQaTVsWHNwTkJvSUJOaGQ2M0VPeHZQeC9aRTZKOGdKMU4wNnZjY05VV01o?=
 =?utf-8?B?bDdBcnRYTVhSdHFCT3V3dGJNWFNQb1lqZ3ZJbWlHSU9SMVprSTNKc3hpallC?=
 =?utf-8?B?R2RWTUY4SmFoWDhER0lyUXIxc2RYaytpMCsybU1pNmRQYWhVUGp1Vmt0SklF?=
 =?utf-8?B?WExzTVFZNnZwVEMzcXBwUnlUWWhCUVhwWTNQUVN4a3Q1M3NlRS9uald0YlZH?=
 =?utf-8?B?RHZVYm1KWTZmSUVWSTQ1Q0dRK2xvb2VzQ25hS2p6RVhCeUNyOXZUYnZQMUJB?=
 =?utf-8?B?S1RnVGFTSTVsdjVOQ3p5ZEJ6eWJBbkU5eEdHRHlrZHp1bDg4NzJiQkdHOEJG?=
 =?utf-8?B?TWtwczdwSDhYamx6UldQTHZyN2phdy9iMUN1VlJLTm8wZ0hSWEtFWGdlRGx0?=
 =?utf-8?B?T1k1WTFiVUwvWDRJWnU1dmQwc3dTSW9WMzFBaDlMcjR3b3drZUNiUzBsb3ZF?=
 =?utf-8?B?bW1iSnFyS2NCR3hlMmsvaWMyaFBBK3BqaCtXemFLQ3pIbXd5U2dDRGNUL25t?=
 =?utf-8?B?TG56VEUvai9ybHo0NWxQUjlQZUZ2N0RxQUlSa2pZOFk3SkhzSXQxRThLL1pi?=
 =?utf-8?B?ZUlSb0I1S01wQTR1endBTmtWUW9jVkRVWGRQSDM2S24xOVdGVkg2VEdINkEy?=
 =?utf-8?B?VjhKZ3VzOVlnY0U4dzA0R1FnMXprSTdYZ1RiY0FJQ0pJdU0yZjEwZ2NqcG94?=
 =?utf-8?B?cmhVZTFYYWVNaVVxTTJBVUY1K0U4cTlBNWsxdnZrS2U3bEdaN3pRYzJXUnRC?=
 =?utf-8?B?VGxzUldlWWJ5VkphNk5PL20wRVl1MFJkYytYeFd3SUJYSXA1RERQSy83bnFv?=
 =?utf-8?B?a0diRWVpZmtRc3pLdjlIcWwzd1ZYYmhMa2F2TmNPbnllVFlNVXFYbnlsTFd0?=
 =?utf-8?B?QktwbXhYamo2Z1ZqS3hhRDBwTlo0VmtJMWJhQVJXWmY0N1JoZ290SFh6VlBa?=
 =?utf-8?B?YW05K1A4OVNaZmhOUkVwWXN1aHE2QjdTZUtsay9ucGVneHVjdDIrWEdaZ1lm?=
 =?utf-8?B?ejJYNVFBL1pCb3dKdzhoMExheitkd3FoTGpQdUQ2NEdseVU1TUU0a1JQNm45?=
 =?utf-8?B?TDc3eHROSnIrejlpTzdXRXQ5dGZpcEw3RmMvR2VITmpTOHIvbEtPYzRPUGMx?=
 =?utf-8?B?WVVCNXVXVU5YalRWMVFUci9rVHZJTmRqYXEvczVhS0JCMFNidHRyUWljVDhm?=
 =?utf-8?B?aWZoQ1grMkNtMUhaSDJIajlnUndUUzhxV2lBZXNOalZ3eVI2YVQ2b0cxRlhv?=
 =?utf-8?B?b0lqWGtYV28zc1JSL2FoSjhSQjRSZVZNRkFqM1p6UE9taHQrNE90MjI0bFVq?=
 =?utf-8?Q?toZcReAEWLkAt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e463cd-7aa0-4e5b-f967-08d8d96e89eb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 09:20:05.9416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNJu/JOnEAIwaJLaiQGmV53k+MVxJRoUJPXzgKfNP12zQTMw0zGeGpNgLQUTSZBb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4930
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 24.02.21 um 10:23 schrieb Thomas Zimmermann:
> USB devices cannot perform DMA and hence have no dma_mask set in their
> device structure. Therefore importing dmabuf into a USB-based driver
> fails, which breaks joining and mirroring of display in X11.
>
> For USB devices, pick the associated USB controller as attachment device.
> This allows the DRM import helpers to perform the DMA setup. If the DMA
> controller does not support DMA transfers, we're out of luck and cannot
> import. Our current USB-based DRM drivers don't use DMA, so the actual
> DMA device is not important.
>
> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> instance of struct drm_driver.
>
> Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
>
> v4:
> 	* implement workaround with USB helper functions (Greg)
> 	* use struct usb_device->bus->sysdev as DMA device (Takashi)
> v3:
> 	* drop gem_create_object
> 	* use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> v2:
> 	* move fix to importer side (Christian, Daniel)
> 	* update SHMEM and CMA helpers for new PRIME callbacks
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # v5.10+

I can't say much about the USB functions to use, but from the DMA-buf 
side this looks like the right thing to do.

Feel free to stick and Acked-by: Christian König 
<christian.koenig@amd.com> on it.

Thanks for taking care of this,
Christian.

> ---
>   drivers/gpu/drm/drm_prime.c        | 38 ++++++++++++++++++++++++++++++
>   drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
>   drivers/gpu/drm/udl/udl_drv.c      |  2 +-
>   drivers/usb/core/usb.c             | 29 +++++++++++++++++++++++
>   include/drm/drm_gem_shmem_helper.h | 13 ++++++++++
>   include/drm/drm_prime.h            |  5 ++++
>   include/linux/usb.h                |  3 +++
>   7 files changed, 90 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 2a54f86856af..15c82088ab4c 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -29,6 +29,7 @@
>   #include <linux/export.h>
>   #include <linux/dma-buf.h>
>   #include <linux/rbtree.h>
> +#include <linux/usb.h>
>   
>   #include <drm/drm.h>
>   #include <drm/drm_drv.h>
> @@ -1055,3 +1056,40 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
>   	dma_buf_put(dma_buf);
>   }
>   EXPORT_SYMBOL(drm_prime_gem_destroy);
> +
> +/**
> + * drm_gem_prime_import_usb - helper library implementation of the import callback for USB devices
> + * @dev: drm_device to import into
> + * @dma_buf: dma-buf object to import
> + *
> + * This is an implementation of drm_gem_prime_import() for USB-based devices.
> + * USB devices cannot perform DMA directly. This function selects the USB host
> + * controller as DMA device instead. Drivers can use this as their
> + * &drm_driver.gem_prime_import implementation.
> + *
> + * See also drm_gem_prime_import().
> + */
> +#ifdef CONFIG_USB
> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> +						struct dma_buf *dma_buf)
> +{
> +	struct usb_device *udev;
> +	struct device *dmadev;
> +	struct drm_gem_object *obj;
> +
> +	if (!dev_is_usb(dev->dev))
> +		return ERR_PTR(-ENODEV);
> +	udev = interface_to_usbdev(to_usb_interface(dev->dev));
> +
> +	dmadev = usb_get_dma_device(udev);
> +	if (drm_WARN_ONCE(dev, !dmadev, "buffer sharing not supported"))
> +		return ERR_PTR(-ENODEV);
> +
> +	obj = drm_gem_prime_import_dev(dev, dma_buf, dmadev);
> +
> +	put_device(dmadev);
> +
> +	return obj;
> +}
> +EXPORT_SYMBOL(drm_gem_prime_import_usb);
> +#endif
> diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm12u320.c
> index 0b4f4f2af1ef..99e7bd36a220 100644
> --- a/drivers/gpu/drm/tiny/gm12u320.c
> +++ b/drivers/gpu/drm/tiny/gm12u320.c
> @@ -611,7 +611,7 @@ static const struct drm_driver gm12u320_drm_driver = {
>   	.minor		 = DRIVER_MINOR,
>   
>   	.fops		 = &gm12u320_fops,
> -	DRM_GEM_SHMEM_DRIVER_OPS,
> +	DRM_GEM_SHMEM_DRIVER_OPS_USB,
>   };
>   
>   static const struct drm_mode_config_funcs gm12u320_mode_config_funcs = {
> diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
> index 9269092697d8..2db483b2b199 100644
> --- a/drivers/gpu/drm/udl/udl_drv.c
> +++ b/drivers/gpu/drm/udl/udl_drv.c
> @@ -39,7 +39,7 @@ static const struct drm_driver driver = {
>   
>   	/* GEM hooks */
>   	.fops = &udl_driver_fops,
> -	DRM_GEM_SHMEM_DRIVER_OPS,
> +	DRM_GEM_SHMEM_DRIVER_OPS_USB,
>   
>   	.name = DRIVER_NAME,
>   	.desc = DRIVER_DESC,
> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
> index 8f07b0516100..253bf71780fd 100644
> --- a/drivers/usb/core/usb.c
> +++ b/drivers/usb/core/usb.c
> @@ -748,6 +748,35 @@ void usb_put_intf(struct usb_interface *intf)
>   }
>   EXPORT_SYMBOL_GPL(usb_put_intf);
>   
> +/**
> + * usb_get_dma_device - acquire a reference on the usb device's DMA endpoint
> + * @udev: usb device
> + *
> + * While a USB device cannot perform DMA operations by itself, many USB
> + * controllers can. A call to usb_get_dma_device() returns the DMA endpoint
> + * for the given USB device, if any. The returned device structure should be
> + * released with put_device().
> + *
> + * Returns: A reference to the usb device's DMA endpoint; or NULL if none
> + *          exists.
> + */
> +struct device *usb_get_dma_device(struct usb_device *udev)
> +{
> +	struct device *dmadev;
> +
> +	if (!udev->bus)
> +		return NULL;
> +
> +	dmadev = get_device(udev->bus->sysdev);
> +	if (!dmadev || !dmadev->dma_mask) {
> +		put_device(dmadev);
> +		return NULL;
> +	}
> +
> +	return dmadev;
> +}
> +EXPORT_SYMBOL_GPL(usb_get_dma_device);
> +
>   /*			USB device locking
>    *
>    * USB devices and interfaces are locked using the semaphore in their
> diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
> index 434328d8a0d9..09d12f632cad 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -162,4 +162,17 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_object *obj);
>   	.gem_prime_mmap		= drm_gem_prime_mmap, \
>   	.dumb_create		= drm_gem_shmem_dumb_create
>   
> +#ifdef CONFIG_USB
> +/**
> + * DRM_GEM_SHMEM_DRIVER_OPS_USB - Default shmem GEM operations for USB devices
> + *
> + * This macro provides a shortcut for setting the shmem GEM operations in
> + * the &drm_driver structure. Drivers for USB-based devices should use this
> + * macro instead of &DRM_GEM_SHMEM_DRIVER_OPS.
> + */
> +#define DRM_GEM_SHMEM_DRIVER_OPS_USB \
> +	DRM_GEM_SHMEM_DRIVER_OPS, \
> +	.gem_prime_import = drm_gem_prime_import_usb
> +#endif
> +
>   #endif /* __DRM_GEM_SHMEM_HELPER_H__ */
> diff --git a/include/drm/drm_prime.h b/include/drm/drm_prime.h
> index 54f2c58305d2..b42e07edd9e6 100644
> --- a/include/drm/drm_prime.h
> +++ b/include/drm/drm_prime.h
> @@ -110,4 +110,9 @@ int drm_prime_sg_to_page_array(struct sg_table *sgt, struct page **pages,
>   int drm_prime_sg_to_dma_addr_array(struct sg_table *sgt, dma_addr_t *addrs,
>   				   int max_pages);
>   
> +#ifdef CONFIG_USB
> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> +						struct dma_buf *dma_buf);
> +#endif
> +
>   #endif /* __DRM_PRIME_H__ */
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 7d72c4e0713c..a9bd698c8839 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -711,6 +711,7 @@ struct usb_device {
>   	unsigned use_generic_driver:1;
>   };
>   #define	to_usb_device(d) container_of(d, struct usb_device, dev)
> +#define dev_is_usb(d)	((d)->bus == &usb_bus_type)
>   
>   static inline struct usb_device *interface_to_usbdev(struct usb_interface *intf)
>   {
> @@ -746,6 +747,8 @@ extern int usb_lock_device_for_reset(struct usb_device *udev,
>   extern int usb_reset_device(struct usb_device *dev);
>   extern void usb_queue_reset_device(struct usb_interface *dev);
>   
> +extern struct device *usb_get_dma_device(struct usb_device *udev);
> +
>   #ifdef CONFIG_ACPI
>   extern int usb_acpi_set_power_state(struct usb_device *hdev, int index,
>   	bool enable);

