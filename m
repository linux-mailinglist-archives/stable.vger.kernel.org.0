Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFFE48D281
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 07:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiAMG4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 01:56:30 -0500
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:3552
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229661AbiAMG4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 01:56:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/7AFQi6mcu1QB9E9ffxCon2niuUOFC0xdv9tnNjK0tY1m23rBD52mzUAQACswFDLhfXYe2EtSPd1N3jj5PxGBRNdZsWiR2gaJ6XesGWgAghJgIU3SX9u69/WBw3qv1OSUn3e5xfco+PO6zCxkFx1DPLq+a0oNDQLPnjxXGQNiZCgOuGGcjeY5LygTACTFAbnVIqWL7ls1TtlK5Ndq8e4CQQKiqOG0zqJn7OnkeGPtwk8Q/TVJsZgORtmOJL0k5yDSfy3HhMoT8BOLbUregwnuZT0y7lPLmjMKhEXWrjVoMsTUYr21os1caWDmg2Oh7MdcxcK5uIpjPgA6oWlECx/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhRlx02M2udDzRd23Ctv4CQ1uGaFKYv9xtj/t0N8l+s=;
 b=Oqt37+leTBvRdmCVH/wiXV5EeqewuL69/5QwDZ4T0ZdMAZvrMojskWBtsjXQXBW51Yi4TfcnrzEF0zrxBTuqthZeFrB8H2UWxncmD2RLfegLTifqoUrHpAmgMkKJ4cz5ZBBqLv0MpSaPlbi8JQmun/+NqNecHXXGoEl3TArCT8NLPcH1N0xbZ0JgzPNtchCgqo5XFxJopREnZCWTr0CrSgTZaP/suJ2QiHXoLLjBqgIZ9Y8bSYxXQ3A7ttWF0w/X17mFu/VGnOacRw2JTwViPiL65cStc6/7nS/JpEZymV0NYhmKzD/pbESZ+P4tYLML8r6YTZyQHQQKzN3aYRQAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhRlx02M2udDzRd23Ctv4CQ1uGaFKYv9xtj/t0N8l+s=;
 b=5toFhBNa7HoGv8z8Q8SzV8x5u6fSsDGQh12NG+aCKfDwdvLJSvhNtT5zi9Gn6McE7h6J0kYoZnlr9JYDWNBsdMhE7VI71mrGpE7w6t0ji/cw8Lt1hK8e7yH7K3mwNbLpY3IaUukj6jPKdGEY9Xy+P5w7+jzJg0LQwaZALHDpTew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by BYAPR12MB3541.namprd12.prod.outlook.com (2603:10b6:a03:13c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 06:56:27 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::9c25:ce1d:a478:adda]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::9c25:ce1d:a478:adda%5]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 06:56:27 +0000
Message-ID: <1586c31f-9e84-c63b-8abc-1862b08cf707@amd.com>
Date:   Thu, 13 Jan 2022 12:26:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] drm/amdgpu: don't do resets on APUs which don't support
 it
Content-Language: en-US
To:     Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20220113040103.311160-1-alexander.deucher@amd.com>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <20220113040103.311160-1-alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0033.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::8) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d380b05-3017-4cba-a5a0-08d9d661d194
X-MS-TrafficTypeDiagnostic: BYAPR12MB3541:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB354102616DF0FC3D7A7367FB97539@BYAPR12MB3541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KF7OHXnWZoGIx/Jb1DcHvvOc3KAO4I7UE2HfCzLvROlbZSygA4vwIJADNPFHc94DMOyEPt42JvNFiQC0LkLBWsv1LR+nJvzkA9gsI3BsShgWpcwIguIaD/e4QzviIgr8U46yBnjvvj07m+PGTSnpPmjX0iyE+ZpNoXOPqGu5lHyM2N6TEJa9No7udBnf6s2PLgZAr8Py8CWviS27YqgCpdJbxrLyhnsq8cV2kf/spUVyGOJT5h6PJ1T+JAdg6s2HXY1xND6EnqGUtV2JH+mQgBilDoGwdBM8EaaJx1G3RqLOOG+EvMHRIs6bxupZN/5WHLJax2vo1EmoGHRn4Xg3px8cymKImaP8jcs8K4tzwID9rh308/3IeMeFHWQJtHEGZ59qgjErI+t4uXLyOhv9ody6/OqkozY07M9INeI5D4WrkPdLxNic7ioE9JAgOmiGQ1ng2AEBnkweDcO5qVHRnnO21W36+7gybn1iE05z2jD5zruFsYwSlLjZlbL886kl87TKwXQmoFOgN71OFGZTBOfdObmv0QlMMXvmNUC64SvG6nEzwLsEX+hwiUwSU/67iEq2zmaIjygahdVdRegfXicWvbguj20RTHacseOcvbDzyTgxKpMqBFPBUfYMpbZeWP9GvvKYTl1Davdnlwj1dnK0GJavmT4WJa79LN0wNcNlJjR8WbXCZJefX0XL3pHkbKMP9XpHOXcSMhqfNrLqYFDet5FKXUAAtC46B77nf85K8iGtiVrB5Dl9eCe14yS5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(6506007)(83380400001)(508600001)(86362001)(4326008)(31696002)(8936002)(6512007)(31686004)(6486002)(2906002)(53546011)(186003)(36756003)(5660300002)(26005)(2616005)(6666004)(66946007)(316002)(66476007)(66556008)(8676002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjNYU2FoOVN1MWJxbG9HODlJbjBqR0lOSHhDaDR4SGNLMlRmTCs4NEozUVJV?=
 =?utf-8?B?NDlVa2tZNUREZGNiRVR0b05YRU10TmYrZyt0Mk1OQWpmVjdFemtUaWxWa3Fr?=
 =?utf-8?B?ZndRa0UxeXRic1pvdHQ4Qk5XMXpwT1ZIZlNWWGRUUmlxSngwakYza2RmRG9y?=
 =?utf-8?B?ZmVwanR1KzlsTTdyUmNJNDJtWHNIRko2dEozeG1Sc3lXMTBiUG5ML3BWcWpW?=
 =?utf-8?B?MkRnL2VKaXFPZ2J3VHJMM0x5eitQM0ZYQXdhQm1FM3h3L0w2NjNUaDFFOU9O?=
 =?utf-8?B?d3VRdHI0clFLR205UzR3Z29VOTJDNmI2M3FaME05ZG5HWUFwczljM2l0eUk1?=
 =?utf-8?B?U1lua1M1S2llbU03Vm9MWkN2ZC9nejc3dUVTaWE5cWZpQ1VNV2lObHZaYVFw?=
 =?utf-8?B?Y2FVYm1oY2FaYUJMM2lWd1ZqWFBnTitIK0x6NU9qTmg4ckJaTk1WWjBBZFBD?=
 =?utf-8?B?Ykw1Y3NoSlc3V21HYlNpdk0wNnRYVk5sY1k0SGZJb3J4MEVRd3RFaU5vT2FF?=
 =?utf-8?B?OGhPdCtCVlJqT2UrVEdpb3dacGh5Y1YwU0NVUzlPRmFYRDBWOUxvRURhcVM1?=
 =?utf-8?B?OEZzYnNCdHMyZlIzbVMyTzhsZis0S0krYkptNEhDZHFleGVOZkgrcUxkc3J2?=
 =?utf-8?B?R2pMQWJadW5ZN204MUZQa3hrMzBkOEh2aFF2a2YxUGJrUi9mWGc3cFNVYitS?=
 =?utf-8?B?cGdOVjRyeXhTU0UzNTZOSnRCOUkvNzF1b3pWYmJBSUI5ZnNJb2VaWWpXNC9X?=
 =?utf-8?B?aTl6WGdLcG96WFE0enVjVk9DOUpoMlhJSEFxbVQyMDdPVnVJU0RkY280eTRj?=
 =?utf-8?B?VFZTM1BBUXdORS9nOGYrbE9yVCtzL28yUnhIS1ZTSGN1TEJNeTBQS3VnaE9G?=
 =?utf-8?B?VnVCZjd6TmVjbVQvMHVIS0tOTGZ4VHdoNXJrcytVcnVmYU1INGhmMGszbjNV?=
 =?utf-8?B?eEMvZ3lZS2ZvZjJOS1JJbFE5cVZNNmFIK2lMNXlvZEYrQnFrWU56M0NUWEpK?=
 =?utf-8?B?d2hPS09Wd00yVnNsdVE3UmFXK3o1UmQ5cjFjUWM3NVl4YUk4Kzl4c1o0Wld6?=
 =?utf-8?B?bUFocm5uYmFaWGowZkRjem5KS1MrZDVzc3pVUnQ4bkhtSEFDcFN6d1lqYmRm?=
 =?utf-8?B?K3pxMFNXNUw1bTBTV3VtNFh1QXpjUHUyeVJ6MGE5OW5nSC9RRzJpYjZaaDZU?=
 =?utf-8?B?d1kxUkZrZktaVGk1WTN1L0NPTzFRZlZvSytZYjYxaTl5dzEzWHBxZHcrdy9S?=
 =?utf-8?B?YzBreXE0eDlmK2RISnlQbkoreXJYN2M5MkRNRnZtanVBUm4yOGFwRU1OdThT?=
 =?utf-8?B?RFhLaFU4eWpOUkJCQ01mQXc1amE4WmV3cllUaUNRV1dSREFFcWpwOHloSy9T?=
 =?utf-8?B?MHBEZEU1Z1VLdk9vMGJkMmFYM1dqU2s4QTZ3VllnekllKytBYnUxUGI2QWlC?=
 =?utf-8?B?QW52M3V5d045V0hsanl1Y0ZIc3RQRXdlRE1BL1RqenJVYXFYc0tud3llYTBZ?=
 =?utf-8?B?OVZ2aGR1U3VaTFRlK0NjSG9nSVFxemk3S3Z4a2tFVXlJbko1ejl1OE5vS3By?=
 =?utf-8?B?eHVYZHdLTlB0RFd1VUVJT21lVjNVYmRsSEhoclI3dkRHUmwwclMrVEJZVlNo?=
 =?utf-8?B?dkN3RzlrNHlSZENvaVJSYzFySFdoQkU0ZnF0U3pPTk1za1ROTERmWWpOdFZJ?=
 =?utf-8?B?TkNrZi9GNHpSWnV3d3VOK3p4NWdUMklJOFlZaEJNNzRHMVdub0M4NzZZeitW?=
 =?utf-8?B?R2tJYUE0eDIzaXdMSlVuSmRwbU81dmxSbkpMZHN3Ym1FSVZDVGVhSFY2N1ow?=
 =?utf-8?B?ekhMZTF1MVFwaWYwVS9qN09vZ0tuZmtqd1Y3RzF3cVZpdkN1L3VYM2l6ODZD?=
 =?utf-8?B?WTdxTnBMdlRkTWUwbW1KSll4OG8wcmxPZW94WE9GVXFKMndoTDR5TkJYRnNR?=
 =?utf-8?B?TDdxSXFJZnorblRBVEJtRTM5NGYvR2hiTWFkR3YxWWFMVlhRRnpUSVVUVE42?=
 =?utf-8?B?VFQ1SldBVUVuZkNEWUhjeWUySEtVajRUMHdUbmhneFdHRk5QajBlcU96K25u?=
 =?utf-8?B?cTdJUVdWaDlqWjNST0gxMGp1VmhxL1V3eFh2S3NSWSt2RGF3NXFZcmtrS1Zj?=
 =?utf-8?Q?/P/8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d380b05-3017-4cba-a5a0-08d9d661d194
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 06:56:27.0362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MW9NC4vp4M1YjbZ0XceprG/7XINwKlCv8rc83rSdOGg40hWl7IOcc5sgZpqMZQxJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3541
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Alex,

What about something like this?

bool amdgpu_device_reset_on_suspend(struct amdgpu_device *adev)
{
         if (adev->in_s0ix || adev->gmc.xgmi.num_physical_nodes > 1)
                 return false;

         switch (amdgpu_asic_reset_method(adev)) {
         case AMD_RESET_METHOD_BACO:
         case AMD_RESET_METHOD_MODE1:
         case AMD_RESET_METHOD_MODE2:
                 return true;
         }

         return false;
}

Thanks,
Lijo

On 1/13/2022 9:31 AM, Alex Deucher wrote:
> It can cause a hang.  This is normally not enabled for GPU
> hangs on these asics, but was recently enabled for handling
> aborted suspends.  This causes hangs on some platforms
> on suspend.
> 
> Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")
> Cc: stable@vger.kernel.org
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1858
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> ---
>   drivers/gpu/drm/amd/amdgpu/cik.c | 4 ++++
>   drivers/gpu/drm/amd/amdgpu/vi.c  | 4 ++++
>   2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
> index 54f28c075f21..f10ce740a29c 100644
> --- a/drivers/gpu/drm/amd/amdgpu/cik.c
> +++ b/drivers/gpu/drm/amd/amdgpu/cik.c
> @@ -1428,6 +1428,10 @@ static int cik_asic_reset(struct amdgpu_device *adev)
>   {
>   	int r;
>   
> +	/* APUs don't have full asic reset */
> +	if (adev->flags & AMD_IS_APU)
> +		return 0;
> +
>   	if (cik_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
>   		dev_info(adev->dev, "BACO reset\n");
>   		r = amdgpu_dpm_baco_reset(adev);
> diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
> index fe9a7cc8d9eb..6645ebbd2696 100644
> --- a/drivers/gpu/drm/amd/amdgpu/vi.c
> +++ b/drivers/gpu/drm/amd/amdgpu/vi.c
> @@ -956,6 +956,10 @@ static int vi_asic_reset(struct amdgpu_device *adev)
>   {
>   	int r;
>   
> +	/* APUs don't have full asic reset */
> +	if (adev->flags & AMD_IS_APU)
> +		return 0;
> +
>   	if (vi_asic_reset_method(adev) == AMD_RESET_METHOD_BACO) {
>   		dev_info(adev->dev, "BACO reset\n");
>   		r = amdgpu_dpm_baco_reset(adev);
> 
