Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4C73AA0B6
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhFPQFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 12:05:01 -0400
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:29654
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230318AbhFPQE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 12:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFAdqMAeeS+IBIvKHgFvOObDhaeKuWc18cFUt5goIc6bR0ZdeDccOpCZtuUOi6rGq65mSJ0udJ2RkmwAzh1Jkn/ggvxd4v+O1ayom7aRaqENJya9JSi3wu2KeMEMT0Qj2EHAcYq/kaYY1cgjcMipb3u0jVjLmhSjSnCe5fFi9GRZbh45zExFVR14LzYUmMDE0/qjrEzfM0ozldwNo8jx761YwmHwdpUUnjCKKIXkA2gT7G7QaLtAdiuGZkniFKFytsl9HoXVhnM96//mq7CaSucZXEd4IeRqs1ffrqvF5mdKAvyOcQSaxTaS3RNRX+q2hErD2pryjWUAZHWqXOkhqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4EOYWI05ud7jIvmNPl8r+vl/ih9hCun3ScGxsMjGpo=;
 b=AOaxRDEjv7VPZiPIXrl4RaIN4r5ietygnU0twVm/ZCuezEFnK+5KBCUOtjbWFXGJAXnsAJSJ4kKWWF4sfb0ezCiC5Rmk4AI3GtdtRw6UV2nuxDInu8q3+wFpVYFwgnlrq1+PieeRSUARIC71qWTwOiqv8kcaZb+tJjQzB4rcYD5BfoyuTZy2whmKgnwn9WkR2qoWwMZMcNmeDlOnAe84iQmf3Q61ZJGmLje20Mq4AzhwvGGDJoaFCoGiZBJ67RR+sbf3L4NnIWla6tW4cJJRpHyEkNixR6P8wb8PfjUujq28KMxE6D2wzXN0eloYULPtDwQBL1aGce15iIVrRPNaAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4EOYWI05ud7jIvmNPl8r+vl/ih9hCun3ScGxsMjGpo=;
 b=skcDTSrDT3ZMMrwq9GHkh4UgBYFT0lovd6AsdpnL4NqfEhN/WJYUE2Ijs7MwiaMb1fWnkmdjOjJ9E8g3/y1yrBamAvQhhYUOm36y/hNukkTx4x3l9T+89ynrdUQ8OdNIylvZdtKZdEsp01TM/4QrJNR0hyv0GE1hsImo+KDG1Ms=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by CO6PR12MB5425.namprd12.prod.outlook.com (2603:10b6:303:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Wed, 16 Jun
 2021 16:02:52 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::401d:c7a2:6495:650b]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::401d:c7a2:6495:650b%3]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 16:02:51 +0000
Subject: Re: [PATCH 5.12 42/48] drm/amd/display: Fix overlay validation by
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
References: <20210616152836.655643420@linuxfoundation.org>
 <20210616152837.971271576@linuxfoundation.org>
From:   Harry Wentland <harry.wentland@amd.com>
Message-ID: <d37781b8-4677-e647-c338-3f5c8eddb1e4@amd.com>
Date:   Wed, 16 Jun 2021 12:02:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <20210616152837.971271576@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [198.200.67.154]
X-ClientProxiedBy: YQBPR0101CA0141.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::14) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.3] (198.200.67.154) by YQBPR0101CA0141.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 16:02:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be395270-8109-4c49-eb95-08d930e0318b
X-MS-TrafficTypeDiagnostic: CO6PR12MB5425:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR12MB54259D76D9EAF7912ECEF15B8C0F9@CO6PR12MB5425.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:43;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BiTMz/oNd9Cc1ck4aQGqjmmN0z8X77U2oqQmKuwOoHEPlsIRoyAJyw9SG/QADn2Bz6VxvyzmjMdjtAoMuQI6vD9IYT6hLs1FEjXFJFC42LRWEDjKKjZq5ddoPNoWkEHz0rqaEsbZJ1m9RH2EoXUo7H0QQ4rJVD0fEDnAhG4ub78bElXESRk5jui6DJY7jCFi3Rf0AKjr4O0KTVXZVAQsapczfO7hb2RwG5DWRVea5bGf513wZIAihq77ruVPAzTPeR5eXAbuExu39DzMupGTTxbv/YfHdXFD5+tBXMdVCJaQKdeWPO0SsDVrKhMyZI4LPXBC6NAlwuUGkN0x2LXhPfanfok7TIMKZn/m/hQNYvj8Avtf3lt0E2mzhPdrELEmdHuu0+vdoXo22vcgXz7cl05xACiB5HzmJxh5yxFMnsBwwZPB/NUtXcjTd8JUyKjmWA3rME13qrDYvWhS6OuC8mQJicSq6s7Lv4a8+/dUeLj9xr216idXvR9l8G8E48wSHCxMxmZPPHXKRdfvTZ4/hdkt5M9Svh9K1baASvKPLjk98tcRm6mSyx5KdcdiULbCmuu/FS/37DJtcN6CaMi7zxmOHsov6bvlldITjgzbegdPkDvansp4IJ+aal4oglepXjm6UjY/wWtS6ZUA8Od/TRoR3zLfsJZ3klvBesQ7/5hpx8dO6st9ZNHedeQWdS97
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(44832011)(8676002)(16526019)(186003)(8936002)(26005)(31686004)(6666004)(316002)(2906002)(31696002)(66476007)(956004)(4326008)(16576012)(6486002)(36756003)(66946007)(478600001)(5660300002)(86362001)(54906003)(53546011)(38100700002)(2616005)(66556008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3BxM3gwdE96dXZibHl2Tkh2K05uZjIwYmdsa3lLYkR0S3JISktoUmtpVnJP?=
 =?utf-8?B?WmMxd1E3eUtUeENJdysyMmN2RTNONWdpQ2JBQWRqUEhkZ3d4YlRjT01zSlJL?=
 =?utf-8?B?Si9nV2R1WFJZMi9xcmxxbHBmdVpYNHkxOUdmekZKejdoTk10dGlkMi9nS1pK?=
 =?utf-8?B?dzVuOUxvTWRLajE1V3VSTm1mNVhnK1VTWHl5M01ldEdScFpvUVZiNmxBNHpF?=
 =?utf-8?B?eGsvRzhrTG1RWVBUT0ZGemlLZzJkMEwzZE1UYksvaXB6ZVpHWXJadEo0aGIv?=
 =?utf-8?B?dkpwNitMbW5uRDdGbW45ZFowS2NmZW1DckFNK0hZV01JOWc3cWNSczVwbmp4?=
 =?utf-8?B?R1RWKzJCZi84TWIrbDNPa1FiQVpNN0xDU3FNTHZBRU83SFVoZDhWbVd2dUcv?=
 =?utf-8?B?K2w4aGplYktMK3RBNEVZYTFnZVdmb0czTXY3VlM3bEs1ZWY2TUkxcXhXM29T?=
 =?utf-8?B?V0VESlFReTNhN3cyNXBiK0JhSUZyOE12aWxwMmJ3YzV1bC9UUEtYdXgwSS9D?=
 =?utf-8?B?NlpMcVZNanZRcnMzdDlHUUhtODZ4RnI0M2l4blBLak9BOTlwWjlmU0huMDRm?=
 =?utf-8?B?T0VXSmp5ZncvdDFKdGFHU3RQbDJITHhEV1JXS3Jhb05lU2lpVDNodnJ3ZlFF?=
 =?utf-8?B?cHdqR1NlZmVOZFdEU1lxWXo4SS9jaGkzc2R6SVI0S1VFdG5kaGRjVE14QkR2?=
 =?utf-8?B?cnUydmtXczJMcVB3OGlGWnZkK0s4bUtCWVArUk5nTS83UlZhZEIrMlU2QXFk?=
 =?utf-8?B?dEpJZ24wQVlwL0x1TC8xVTV1UkpBYlZrME5Lb0Z6RWFGUnpvZXAzZTEzZ3F5?=
 =?utf-8?B?N0RGYVVlUFl4Z3dqNHlwbGZnZHRPTEdKVmxvTnpoRnlaajF6STlYVGlzWHlv?=
 =?utf-8?B?U1FTcE1zdHRWdHZ1czVSZ2lSNkxjZHk5MitpOCtiQjRkU0wxajVTUThGdGZT?=
 =?utf-8?B?N1BNa1poYm5JNW90QTc3OTl6TUVLS0JoM0owbzBTaFA3RTVGUjZKRnRjaUN5?=
 =?utf-8?B?Q3RpcHZWYk9jb3h0c245MGJiRkVQWWNDR3ZoZ0lKUEZDOExVUldGWEx5Yk5U?=
 =?utf-8?B?anhONm1jQWhhUVRnb2N3VklJZHV0L0tJMzFZcjRMU1Uzb1NkeGlmQUJTNkYv?=
 =?utf-8?B?S2FaVDduZHIzaDU1dGphOHd1d2pzTnlqcXd6N0ZkaDdlMGdLemZ3MHh1cGd6?=
 =?utf-8?B?aUtyVWNvVjVHSzRSV0VRUDNuNHduNEQyckZNUFdpcUthcmd2YTl2SU04eGg5?=
 =?utf-8?B?R2dheStOUmVpaDZ0ekpUWW5hSDNVWGVtdVE5OERMeENzd1Joa05RMndFanZE?=
 =?utf-8?B?ZFFrcE1SQWMxeFFlS2Uyb2Vrd1kwMk9oNmdRYkpRd0krVFVHZVQ3MUxlMGZZ?=
 =?utf-8?B?L1BLT2NOaGk0SlY4L2JrVkE5UjV6K1RFT2RzMHd5MTBDYURmOWpyS1NjN3Vl?=
 =?utf-8?B?aXNUTDlaTHRTS2tDZ1FiQ2M4cU4zaGtIU3lLMld3RVlhZFo1L2NyYWdMbVBN?=
 =?utf-8?B?UFgybUQwYTAwSzNUWTducTZlT3lpTDVhaDA0WDAzaFVZQnhoUlBJeW5nMHg4?=
 =?utf-8?B?NyszdEFoK1BLNUVKaGZvL3NTS1NYdGJwbFpQTU96MW0zVkU4NFFzOFc1UDNa?=
 =?utf-8?B?eE1LOVFGckVWUjBwbFdHMXRRQ0hlUmlMbE9TbkhQcFh2azhVbGxqU1JwM3Vl?=
 =?utf-8?B?Vy9INnhVL25hYTdZWlRYbm9lMWNhUFVOSDhVQnBsWEhmUHdWV1JsQllZdlpX?=
 =?utf-8?Q?D9cKifq4K7fLKzkolYqf0Svj9ETGp58Na8Q/2lu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be395270-8109-4c49-eb95-08d930e0318b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 16:02:51.2991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AazpBf2FDhVaNwDOvcpoVndFP3AK1gahP1rt9Prc8rFr4vLqopx+G1NaJKT0DpvK3j+frIcP73vI4TMURKVPnA==
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
> index b63f55ea8758..69023b4b0a8b 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -9349,7 +9349,7 @@ static int validate_overlay(struct drm_atomic_state *state)
>  	int i;
>  	struct drm_plane *plane;
>  	struct drm_plane_state *old_plane_state, *new_plane_state;
> -	struct drm_plane_state *primary_state, *overlay_state = NULL;
> +	struct drm_plane_state *primary_state, *cursor_state, *overlay_state = NULL;
>  
>  	/* Check if primary plane is contained inside overlay */
>  	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
> @@ -9379,6 +9379,14 @@ static int validate_overlay(struct drm_atomic_state *state)
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

