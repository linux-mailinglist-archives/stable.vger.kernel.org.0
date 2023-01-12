Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42689667AC4
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 17:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbjALQ2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 11:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbjALQ1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 11:27:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390E012604
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 08:25:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iy6PheUKZZboJPVSnCSMg0YsYEmyiQsocFL5ChMXFmesaX3s4vW2nEhKZnrf2vF8R608TiLMxKW24QClmUG0QikkqDbQNdsH3yZbTRx3J5s+48W7F1zqO+htnoKCPAAlgF8JQKfNngDSGxZE0ql+XuySec60le6GRVrSrLk6sYQ6c/QIpDB2az7ymDvgzlrgoyK9G79zb+qjYYNYACt49tvMZJZkXsgnlAXhrAjhryQ05CmFgq2NPEUs+NonXhyd6mnqLBJOloBIypaBDhfHVPjMNSwFJ8++5fBJwUaKr8Z7hT7TfmAfCduuDLybOs/VOBeeTGTb14896FSAwduSXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iR14CVfiImVg1fCouvOpJqppq2p1el/WtqY2sLaFQI0=;
 b=Ij/WvJoQa2ixQp2lBOCTMDu2WDB+bAV+CffKjqUQ7cMgv3xWrwISyLDgaQg7/BrOZdnuK/KHjmUxy49y+QvCIU0SPzLai4K+g0dPXemEeWyHQTEke2WEa+dw8aewR0Lu6R53TZqVKLQSkADOs39UE/fldPMjZkTlxX8UQt0QoJ3eBYNoE3jtNVf5N1h4Nmi/u1Eep6Ryu7PvcmCvlWq/QDzNF4Z0aUoVRiU0Gfz8dah1byjrw1defGjl6peF7NPjMqubb9uPqW8ADF25H1Rk5S71ZxJ5cbssyx5x2Ge+DUIsB4xtiR0PvyMw3QrsIxsFosj+HoOxQ3ffxbXfQKqKug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iR14CVfiImVg1fCouvOpJqppq2p1el/WtqY2sLaFQI0=;
 b=t5eFDhAhQ+cJdiRAzA0YaumANAoVSr3+CZs3kM3+FNgjIEVAL9370IEsjrbOWi84Flfi8+7lAkELJEHRiEtHky6Ewv3Qe2XwPy6eQNcCml+XOhMh9kQPXhkBAIMgWiwSvcGxhq2HX0FWelJ2cdTO/A5rGCmE/SSrZ6M5HEYwR5I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) by
 DM4PR12MB7621.namprd12.prod.outlook.com (2603:10b6:8:10a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Thu, 12 Jan 2023 16:25:11 +0000
Received: from DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::2fd1:bdaf:af05:e178]) by DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::2fd1:bdaf:af05:e178%3]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 16:25:11 +0000
Message-ID: <e4b4b0ca-b6e6-70ae-1652-3df71df53ab4@amd.com>
Date:   Thu, 12 Jan 2023 11:25:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.0 108/148] drm/amdgpu: Fix size validation for
 non-exclusive domains (v4)
Content-Language: en-CA
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Alex Deucher <Alexander.Deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        AMD Graphics <amd-gfx@lists.freedesktop.org>,
        Sasha Levin <sashal@kernel.org>
References: <20230110180017.145591678@linuxfoundation.org>
 <20230110180020.610387724@linuxfoundation.org>
From:   Luben Tuikov <luben.tuikov@amd.com>
In-Reply-To: <20230110180020.610387724@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4P288CA0021.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::23) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|DM4PR12MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: d26d66ab-4e03-4c4c-0dc6-08daf4b9937a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uz0xBT57u8HCCTQi7lqq2ftqMkZ+IBw64YFkv7/UC6dl1yYcNwbSc1Lv7PdA8hJ5GzBYW3IBOH5OJx/adUQfO34xyCrfYKH91IUFqExI0NDl7vzr/3OLfVRKVe8GjJ8WxN39phsyat+cqiylkN57/mnPuOsY4BydZ9TJaC/djX8WFzDlR9IDn2lp4jhqjUUkNmVGV4XQbZ7UGM5uQbHSVNRGkLz5K/aa3Ti+Jr0CoHq/4THqXBFuGS5T4IWAZKasBGa3A6F8bhM4FmffepzAp8sBmPIb5kkEV2kdb3Y07eUJSKgqTqT+NALC6wvKjNyvWuBMiGBTn7ALTz9/jWvnQvtjEaC4tuczY1dGAXUQ49W0df8iAWnH24CJKIhqQNnBUaFoAUBo/J4lmY3elgPZCTMZIJn4bG2w+xjN5BGxykCNErO5S1BpxP7XXjy2Q2SnIiZ60s6Grv74r0QjJFJe2qPGKYP5xthgAJhViXOlYKTFzxhCosqBV5PvYLmWZ2Ba0mGRCpZ+wngrNbJYeZFCc4xGO/6BbmEpTZ25HaQ/6i4MR+tHroZGyKbVksO6b471YUnrN9oQEj9Q6fKfWzCrS8FIukTkZSiPc8SnmLqVMfvkuElDJPXzAYITBo5Nn3IQJ/trKGD5UxnvcwOU+SOw8v6KwnmsKXzUuV4WXm+GtYE0mK/tT++ST2rs1FSz2MFT/BtCEVbFMcVThuI6i+Q4n1j3UCf0keNfZUrH+gyhr0Sj0h/l9gADVf8JwN7VQYfV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199015)(53546011)(6506007)(2906002)(6512007)(186003)(6666004)(26005)(478600001)(6486002)(31686004)(966005)(2616005)(66476007)(54906003)(4326008)(66556008)(36756003)(66946007)(8676002)(316002)(66574015)(41300700001)(38100700002)(5660300002)(44832011)(8936002)(83380400001)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3Vmd2pZcE51dzM1RVE0ZzlpZ2hTSFYxNUdkRllHNjhvMjNubVRoU1VxdWhJ?=
 =?utf-8?B?ZHFyVzkrVHRtRHU0MGxldXp1NkgzTXdoN0M2c1Y5WUpOQ0pSR0NDUENpbS9r?=
 =?utf-8?B?eHlncEkyTlZyd2JjOXY4anc2OWVEVFhwbXRUcEhpS2JuTzlyYUkrYXhoU3M2?=
 =?utf-8?B?WFZpdFI4N00raEpmZzlQUWRVNFlLZUt5eERaUFZqL09xNWtGTWV5VWM5N3Fo?=
 =?utf-8?B?Zk9sWmtPQ1ZBVzc1dWJvZWlwbXF6aytZTExXRVFpQmpRMThHRms5RXg2QlZ2?=
 =?utf-8?B?WlhXMTFDdkQ3T0xJOUFRdFFJenlFRXFqeVhJeDFRTWl4SXdFaWhnc1IxWGtY?=
 =?utf-8?B?elRNVFRVTUhoZkF4Y2RtY1hBVDBnUHdxUkcvZE9kbDVoNS94bGMzYXpNcG93?=
 =?utf-8?B?UXorZWw0ZklBTGZhdVljY3pHazlOUkk4cnlrU2d5YjQrTXZmeWJ2TTYzZVVP?=
 =?utf-8?B?NzlGbXAzWnYycjUzT1dCdmd5SXZLSE01WCtEczQ4U202UkdmWm5pYldUS1du?=
 =?utf-8?B?NFdCRWE5aHFDYVJRbmpvbHRVZjJMaGhEblNwTjV5czFTUG5mTGJFbWtESEph?=
 =?utf-8?B?cXgyemdnRzFiZGd1Z0ZNSmovUWFjVURDaTdWQVB3MEtORkthMDc2VUgxY1lN?=
 =?utf-8?B?ZWx0QnN5Q0c1TkEwWmI1ZkdmVmxrU0Z3bkVYVW05N2NSODFscTNlWDBzSm5p?=
 =?utf-8?B?Wk01ZUhHZ2JqcmJkdjJxR0V1bXk4WVRqdjZGb09jQS95cExSQjJTOVJYcTh0?=
 =?utf-8?B?UTArQkRmUVJ2N2NGMC9tZzZPVGpqZzVNSGhWKzlmRmZBZmd2ZlNBRzV5NnVi?=
 =?utf-8?B?d0lUM0JISnVEb3ltNE1WOEhtajNUT2hlT2phQmZVK1VMZmlEUmZiZkd3b2pu?=
 =?utf-8?B?OXFFcjBQamNxRUd6bUxhWFNWR1hZOG0vYXI0U1ozMEJIUTljK05rRkFwbTlq?=
 =?utf-8?B?MVVZKzdCZHREb3ZMS0pCM0FnMlJadWFrZ04rWVRXWWVJSWdJa0grcVhFNUg5?=
 =?utf-8?B?UEdKT2trU1VkdmRKMzRXcndaMk9NUHk3M0QycjRiUlZQcGZyUThhVFJ0aVFL?=
 =?utf-8?B?U21IS3k1Nk9Bd3l4TnhMWHdwMitKRjlYSmZhL01xUk9Yeld4SW9XMlFxbW5O?=
 =?utf-8?B?OGl4RXYzckcvMnFtbDJaT3QwQzcvaWR5dXJnRnhtSy90NjJyYTdWTUVjZXBC?=
 =?utf-8?B?N3BiR0ttenprenB0SWJzOWRYdHgyK25EUTBqSkFvQytmVjVPWDlGLzdCRkl6?=
 =?utf-8?B?ZmVaSlhRUnlOUXo0RExkeEtCMERZRUFzZk5EZ29RSkZtZW0wNW1FSGNxQWZH?=
 =?utf-8?B?YWRmM3dIWEFMTkl2VU82Q0FMZW9YSHZKZmlNTmorOThiSUtQRlVoMm9Femgx?=
 =?utf-8?B?LzlkU3pZK2YyaHNLMWl6OVd4Q0V4bFl6N0RPS25HNmhLNEdveG42dHl3eU1X?=
 =?utf-8?B?blFFZjRNVHkxNGFlTU8zc2xXOHdxOWJlWFEveitEblF3OCt5NVBDMDlvbngw?=
 =?utf-8?B?dC9JUE50NXJNUlRVbTRnM1lOd3o2bW5sSTV6Q3lONVFvbHBYQmpjSXVSeTZW?=
 =?utf-8?B?Vk1JejZxVHdiOEhaVTlFN0NrRjk4TzZmQkJsWGpnNVp3SjZUa2hvcTRqRE9w?=
 =?utf-8?B?Z3BNZVdBQnpPWitaNmtkZmcrTnIyOG5ncHdmTmZvUkZHVHFpaXNYempWdlVy?=
 =?utf-8?B?MHdLaktFRkxkMXRPMy9vMFNnbFVpUEsxbGYxWEFOMHc2dkM1VkI3VmIxbXlj?=
 =?utf-8?B?UnVEaXZobTVhYzRNUGZxbnB2eWQxcUFTbGRPRGdPVzFZdTdoWXE1Rm5Iejlk?=
 =?utf-8?B?VkRuVTkwSmN4MysyY1NMZyt1WFIwcVNzbGZhVk9Gd29VY0lvQ1NaOCsxaVJs?=
 =?utf-8?B?dEJpNUErRVhpcWZzajQzdFBFSHRWZXJtU3loT3Z0ZUE2bnVyN1ZhOExxaElz?=
 =?utf-8?B?YVYvMzNXc3hoMUl3YkJ2M0dCRjcyajlDL1RYZzUyYldZVHVDVEhudXQveGl6?=
 =?utf-8?B?RWlvL2hmdVhOenl4Z1JBRnJhOWU2MDRKY1FxalRWNkh0UzBhOFNkVUhnOGZQ?=
 =?utf-8?B?RnBXUndGU3VhQk5nYlR6TS9TcTFoSExXakpEazJQK1c1Y0FGNEhUVUF2TnVX?=
 =?utf-8?Q?OAXOjNKRNkh4TCx7dlNIVo6bm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26d66ab-4e03-4c4c-0dc6-08daf4b9937a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 16:25:10.8754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gLrfVc6QZhUP4StG7GKyPvJB/QpgF7EbOODOWcXKBhWAKRqxG52mddXHN0n3t77y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

The patch in the link is a Fixes patch of the quoted patch, and should also go in:

https://lore.kernel.org/all/20230104221935.113400-1-luben.tuikov@amd.com/

Regards,
Luben

On 2023-01-10 13:03, Greg Kroah-Hartman wrote:
> From: Luben Tuikov <luben.tuikov@amd.com>
> 
> [ Upstream commit 7554886daa31eacc8e7fac9e15bbce67d10b8f1f ]
> 
> Fix amdgpu_bo_validate_size() to check whether the TTM domain manager for the
> requested memory exists, else we get a kernel oops when dereferencing "man".
> 
> v2: Make the patch standalone, i.e. not dependent on local patches.
> v3: Preserve old behaviour and just check that the manager pointer is not
>     NULL.
> v4: Complain if GTT domain requested and it is uninitialized--most likely a
>     bug.
> 
> Cc: Alex Deucher <Alexander.Deucher@amd.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: AMD Graphics <amd-gfx@lists.freedesktop.org>
> Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> index bfe0fc258fc1..60ab2d952d5c 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> @@ -446,27 +446,24 @@ static bool amdgpu_bo_validate_size(struct amdgpu_device *adev,
>  
>  	/*
>  	 * If GTT is part of requested domains the check must succeed to
> -	 * allow fall back to GTT
> +	 * allow fall back to GTT.
>  	 */
>  	if (domain & AMDGPU_GEM_DOMAIN_GTT) {
>  		man = ttm_manager_type(&adev->mman.bdev, TTM_PL_TT);
>  
> -		if (size < man->size)
> +		if (man && size < man->size)
>  			return true;
> -		else
> -			goto fail;
> -	}
> -
> -	if (domain & AMDGPU_GEM_DOMAIN_VRAM) {
> +		else if (!man)
> +			WARN_ON_ONCE("GTT domain requested but GTT mem manager uninitialized");
> +		goto fail;
> +	} else if (domain & AMDGPU_GEM_DOMAIN_VRAM) {
>  		man = ttm_manager_type(&adev->mman.bdev, TTM_PL_VRAM);
>  
> -		if (size < man->size)
> +		if (man && size < man->size)
>  			return true;
> -		else
> -			goto fail;
> +		goto fail;
>  	}
>  
> -
>  	/* TODO add more domains checks, such as AMDGPU_GEM_DOMAIN_CPU */
>  	return true;
>  

