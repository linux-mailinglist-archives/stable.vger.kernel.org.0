Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7093AA0B4
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhFPQE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 12:04:56 -0400
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:17381
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230318AbhFPQEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 12:04:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlXO+DvxQLT+FWPrazHQKZFLoLjDWKNscatiJg4G6bIiH9atb3MCDxj+0z4psXZkojr2vs7hYl3LpoEj4q+CLLqlhDcAzT3ni0CYgEvD2e2ltrR94c5MBkXHACxc32eMypq91wPb9oxv1EPIRSvfHNPNy5VwLxoENPhAp6T2v0N/oHnmS8TblCazr6Av8BQX0WNPQzisXM9LhK9tyxDh/hCFlVdz60hoDxTU35DTgoFwoNw1+4fJcQNAiBXfX5NQ8/5UndBhDdax1NvVtfPTRDg9XbNSQryFf1vXKh4hcD9T47G+/P3+VSAyFU4tQpCH2jw6JpRj/0zBJsJwG9QuJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0rNW/7dv3A3EDxqVXtHKBgXRkLqSO+ZInEyDCqcyqg=;
 b=I2r9A7z+395Fs/RCjWVH/dv2bA5BV7ls/QM+Z2/STaEakPriDsu7w823mVLnu6T5kbBeOWZ175ACmvj7iwIvT85sqW3CeyNR1+L9TEjGzr1GNGaKrV9dMr6vGVinmfbZAEjIW0TK8brgxQlak2VwO46Ou+GABXEaH73sIlgGoLZProNxiFBjb9aApHBPqwOiaBRCNQ3rExLYa7DVCiHmTlZjD9NZ0gyW4qSTVPCrXdwMfgjdwdlexcnjt2bd/qDqKA5Ilvlgb2+ILFJkTqNlB70ebcQo4jbj8UCn13oPBdhkrGXxIvDSx+wo0BZxQGSwSHZwR/G5to/QGHJtVA/H5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0rNW/7dv3A3EDxqVXtHKBgXRkLqSO+ZInEyDCqcyqg=;
 b=RsYZRbw8d9444aJNolWBk2m/Tv4/TR5xeHnCdSUiLvSUQvAofFHykcvrFjHg2z1O89a1cNjO35afm8zvnOdrEB05O1a2ojN3I+WltmQoKdoX/MzDM0qeZmQoDeHh1IixeSGm9vq+ERvoABKGCEcdehoLevjCaQYd3hXc69Whms0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by CO6PR12MB5425.namprd12.prod.outlook.com (2603:10b6:303:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Wed, 16 Jun
 2021 16:02:47 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::401d:c7a2:6495:650b]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::401d:c7a2:6495:650b%3]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 16:02:47 +0000
Subject: Re: [PATCH 5.10 32/38] drm/amd/display: Fix overlay validation by
 considering cursors
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, "Tianci.Yin" <tianci.yin@amd.com>,
        Nicholas Choi <nicholas.choi@amd.com>,
        Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Mark Yacoub <markyacoub@google.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
References: <20210616152835.407925718@linuxfoundation.org>
 <20210616152836.409676264@linuxfoundation.org>
From:   Harry Wentland <harry.wentland@amd.com>
Message-ID: <e6027392-2ae4-d363-85d6-bcf0eafd6019@amd.com>
Date:   Wed, 16 Jun 2021 12:02:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <20210616152836.409676264@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [198.200.67.154]
X-ClientProxiedBy: YQBPR0101CA0162.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::35) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.3] (198.200.67.154) by YQBPR0101CA0162.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 16:02:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac652a85-5f92-4adc-a402-08d930e02f18
X-MS-TrafficTypeDiagnostic: CO6PR12MB5425:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR12MB5425DA700E96861FEC21F2F68C0F9@CO6PR12MB5425.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:43;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dACXo67f4gJYqgoYcokphYBcpV0cGf6zHX7Z3UbLe8An+EeIqvWq7SgcbL3Q872Sui3lzf8NUPYkbN0b/DHUU5jvE1yo5SOQJk28s8L21BjTdPcJhMo955TnhmBo2QJU+vQeAZE3ZVquk9DckpguIO9aoroP7zYcWGFLUoKN1GeWeCZdmpyqnNtVbQGrKlLL+wNyhY/qAxsPVevOw7hyrOTw94BKlrwC2JkoQTJ3kPb6KwaT7Dr3yQ07JpJtpVDDI0IfdemleM4wm731yFywoWJ8arf8gm/lkNKSFoia+Ji3/yIpbKuVQh1K1X8yZW/PAvxfJHB/BGJFL0bhmY7YbhQ2ptDYiWAirhILuDGdUDlSH+DlhJrpUMT2XVcydi3sem+LuUyK2pkOCEvWnpEpjrqHi9ycT49sUwNub1wwUU2onde9TqhG530YrK6WLHPhaURoy8TSbNHhjodJYyPU9EgF3nq5HN5948472C/uBxdJcoH8dI75DyejBimwasF+dLgVtihDqBvu1/f5vimvChf+Lr5HWgLgS485y19CFqWwXxcWjzyPm5+2tZD1pMpzecrxMCftrJIizQEnRxMxeZCuoxahu8UL8a+WaTXBsxFDx9bjHDKAdo+i8z7ppABsaFdUr44SJE5qTnO5yJCk8BXMK44RjWxbG0edNbvf4EJxx/af358zksazFXEcCYCI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(44832011)(8676002)(16526019)(186003)(8936002)(26005)(31686004)(6666004)(316002)(2906002)(31696002)(66476007)(956004)(4326008)(16576012)(6486002)(36756003)(66946007)(478600001)(5660300002)(86362001)(54906003)(53546011)(38100700002)(2616005)(66556008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVdYTWJRbzRTOEFGdEdtcThhZ3FGeThmQzBPZU5DRzlLSHI3Si80TnBneU5l?=
 =?utf-8?B?NUpYZTF6czljSkpvNGRFbGtHcHFUVXhHbmxtSEl1N1ZyWk82WWRYK2lwc0FZ?=
 =?utf-8?B?MHRaU1RxR3BERDJCdUtyRlUyQ0JwbDlqb2d2R0Y5aXJxbkZrQ3BYekdJSEdX?=
 =?utf-8?B?REt1L2tBeFQ2ZU1MMzlzZ2oydnVGY2tEOHl6OFB4RzhxS3VpZTh1aHBQR1dh?=
 =?utf-8?B?dG9RNTNMRWVBQnFXU1BCZW5MOTZzWkVpdzZqdzdHK1pmcWFjTWdKOTVDVjNK?=
 =?utf-8?B?bkRBdk92ckZKVGUxZFhxV0JwOTBuUjJMbkZsU3hDRjVFMFhtd0U2bXZxeW5a?=
 =?utf-8?B?N3BkSXFVeEt4b3NsSzFMOThFNFJMRDdXYno0cVM2UWRiUlNoT0trbEx6TW5M?=
 =?utf-8?B?MXduWE9uc3VOcWtlSFdISi85Y2ppVllRR1IyTWJLdW1yYUxzSGlIeGxsOHg1?=
 =?utf-8?B?aHZZOEcwSWlHUThvSTZOdGxSWDl1SW1GbzhuRy9xYTlrazRpekYrV1hsRElQ?=
 =?utf-8?B?Tk9YRDlXZlppdTdBWFN5MDBTMjAzRytUSUJDVDkyQlFjYWJyb1VoYjhCeFNV?=
 =?utf-8?B?NUgyeG9DQWh2YkcrNVdHcE9uTFFIYjc2OXk0SVJhTmJOWks5eHZLTkU3TWFC?=
 =?utf-8?B?RVlhQ3FhRzJxMkFYdUNUWmhUOCtNeXdHbzJlSGY1NVlYUEFHVFVzR2cyaG1M?=
 =?utf-8?B?eEhHQXBVSmRwMXlCNlZqOTVseW1RZFIwQ2hHLzhaMm9KSXpoOVAyV2JPQlov?=
 =?utf-8?B?dXpEbnJXbjN5cWx1OE1VZzZaUzlmanZCdE1mQnFlazBFTGxUUkIxK2hDRjht?=
 =?utf-8?B?L0ZMVjFuMGZCdWU3Nk81VTJINHJ4S1Ewb1JPcDV6YStla3dsc09WWU5jN0lB?=
 =?utf-8?B?cHQ1dDUrOUp2c3M3UjA5aGFaRENkSkxWN1VvL1ZUREd5REtPRkxJYTNYdHpp?=
 =?utf-8?B?RmNMbGJ4eWdwTktGMUE1cjB2eEZWMXNyK0RpdUlUZjIvTk91QldiVTlPZ1Mw?=
 =?utf-8?B?UWFtRENnNXJiU0xnaitMRytkdXV1dXlXb0NWcFIvREo3bUdNRUpHQjZKcU55?=
 =?utf-8?B?aU5WNFQwTkt6cSs4VllmQ2VYMTNKOUovcU5sYmJkaC9zQ09qY0sxTWp0NUxT?=
 =?utf-8?B?eXZMcE95UVJiOExlVkFCQjU5ZWs4SFRCSEVFZHUra3VrVld2S20vMTIxb3Nv?=
 =?utf-8?B?dXZBZWNWZVJST0g1RVFMeE4vNDNHdkc2bXBrNW1SQitOaFZrZ0RVK2hTMnV0?=
 =?utf-8?B?WmI5WDArTU9sVGF0SmMzL0tMWFYrWHpHNzJ6VWhZbzNjLzA0M3JHeHEwK1ph?=
 =?utf-8?B?cDlac3RMWmdEcXNja0pWK3F0MTN4Nk9lZnlnVlVRendDVFNJanhjV2FUUkNJ?=
 =?utf-8?B?Ui9TMnYrTEExS3hOcTJ6a2FZZlJkeCs2OFZpanVqcExzZ29wUlhwYzdYdlpZ?=
 =?utf-8?B?ZkUveVBIUHQrdiswQ01CUk1KSU5BSmY1eFJoZ01OUEJ2dlI5Wm9McW1PeitN?=
 =?utf-8?B?d1NMQTc2R3haM2FLUW84Sm44Z3ZnUkhVQUFNd1prVnZkRHJ6YjJRaHo1TThX?=
 =?utf-8?B?OFVFYXJFcXphZmJQbDdHUFZxRDU5WUh2a1d2L0dCQjBTSVpIdEQvd0gzbFg0?=
 =?utf-8?B?L2NWNVJpYmZEU0dKbk84dm4rSGZTUDBFRXN3dVZTKzN0SENlSkxINWk1Ym5Q?=
 =?utf-8?B?dDc4eEM5UjFSWWlSZC9LZ244eFp5ZXVaV3UwSGkveXZpeVpiME9ZdnMwdy9x?=
 =?utf-8?Q?VGalguEuCKlMj8yFR3eH3UYZzdK+vlWjRFgwwMi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac652a85-5f92-4adc-a402-08d930e02f18
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 16:02:47.2250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgrNM6PZbhwqa6dO5ltujkYApFMzIkKYfTmnqfLVl7/OQOe1fJa5kWMQOliYdfmzSHSiX6Ttw0ouliE3GGjjpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5425
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

Please drop this from 5.4, 5.10, or 5.12 stable kernels as it's apt to break any userspace that is using the legacy cursor IOCTL, which is most userspace.

We are in the process of reverting this on amd-staging-drm-next. Siqueira will send a patch.

Thanks,
Harry

On 2021-06-16 11:33 a.m., Greg Kroah-Hartman wrote:
> From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> 
> [ Upstream commit 33f409e60eb0c59a4d0d06a62ab4642a988e17f7 ]
> 
> A few weeks ago, we saw a two cursor issue in a ChromeOS system. We
> fixed it in the commit:
> 
>  drm/amd/display: Fix two cursor duplication when using overlay
>  (read the commit message for more details)
> 
> After this change, we noticed that some IGT subtests related to
> kms_plane and kms_plane_scaling started to fail. After investigating
> this issue, we noticed that all subtests that fail have a primary plane
> covering the overlay plane, which is currently rejected by amdgpu dm.
> Fail those IGT tests highlight that our verification was too broad and
> compromises the overlay usage in our drive. This patch fixes this issue
> by ensuring that we only reject commits where the primary plane is not
> fully covered by the overlay when the cursor hardware is enabled. With
> this fix, all IGT tests start to pass again, which means our overlay
> support works as expected.
> 
> Cc: Tianci.Yin <tianci.yin@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Nicholas Choi <nicholas.choi@amd.com>
> Cc: Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>
> Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
> Cc: Mark Yacoub <markyacoub@google.com>
> Cc: Daniel Wheeler <daniel.wheeler@amd.com>
> 
> Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
> Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index fbbb1bde6b06..4792228ed481 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -8616,7 +8616,7 @@ static int validate_overlay(struct drm_atomic_state *state)
>  	int i;
>  	struct drm_plane *plane;
>  	struct drm_plane_state *old_plane_state, *new_plane_state;
> -	struct drm_plane_state *primary_state, *overlay_state = NULL;
> +	struct drm_plane_state *primary_state, *cursor_state, *overlay_state = NULL;
>  
>  	/* Check if primary plane is contained inside overlay */
>  	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
> @@ -8646,6 +8646,14 @@ static int validate_overlay(struct drm_atomic_state *state)
>  	if (!primary_state->crtc)
>  		return 0;
>  
> +	/* check if cursor plane is enabled */
> +	cursor_state = drm_atomic_get_plane_state(state, overlay_state->crtc->cursor);
> +	if (IS_ERR(cursor_state))
> +		return PTR_ERR(cursor_state);
> +
> +	if (drm_atomic_plane_disabling(plane->state, cursor_state))
> +		return 0;
> +
>  	/* Perform the bounds check to ensure the overlay plane covers the primary */
>  	if (primary_state->crtc_x < overlay_state->crtc_x ||
>  	    primary_state->crtc_y < overlay_state->crtc_y ||
> 

