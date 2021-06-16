Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762463AA0A5
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhFPQCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 12:02:09 -0400
Received: from mail-bn1nam07on2072.outbound.protection.outlook.com ([40.107.212.72]:13798
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234510AbhFPQCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 12:02:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+Eg2toFPDheiiWpb1CGymCh1cDsobyhZBAMkqfpEgSIHS8jYw02lo4GG4WDeCKeA4yxuvDtzXdqMWqkFVMeq0NrBOmzBt1ezf7ozLbWaeeRREXq2MWcIxAQYg53s99revIFarSHuf1emoVv9v4UU8pi65Ym92XvPuDJIeWMcw7FTNrk35HZP8D1rX22s58h5TQK7iJd7NWSRHbH1CzXDo6juCDCAbAl+LV9eNbVixfETV9NkVnDccOFsuY4DluuDSXldtOylY/n3ikT8J1bsT/m+kjrjylflXd7acgGfGDr4XnaGiV8wS7LLfzD6txt6d9blreV4+3/QQBo1TRc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFZkdrHxqy/oQKUg3droBIilBp9IY1Cda9tAaDXlW+g=;
 b=RwZIZVQzKDfK90K7pjzD3ySL6Tx6IvXgjkM1LVxfs7QMDCoFcHWA/gx/bkM01kWPB9ZZ/NyIs+u1tqE+xQOxQOBJgkdGr8g0XG8JOEn9su/yNpYJGIHQMpUNQmtgvsEvHQ5iQUezTbU+tYtGGpeYmU9wVLuR4VBhv/1/6msLSYiU0XXH2QFurEGoqk4Ns9YSqHJaUfMX0N/bMghfVcQ39Eiv06Jc2o+QNpS96mHGY6+yP2+agDBcTlNEp2xIzo0ZLxgA2NRT4k3Bcly3u8viyCWeQSb3XateVTksgYYxps8JGDxuuexu/KR9i1PTFASqrg/DWFX0c0tTqz1N+WI7fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFZkdrHxqy/oQKUg3droBIilBp9IY1Cda9tAaDXlW+g=;
 b=YrGolYuyptnqP5zRsQRckTCmbd3UsoNnTa1bZzCLZF9ZNano3YB8Iatv/DO9EA6lMBuVJ5OuVmNbA5oZGgMYzTxnvGlaBXYc0TtQ6OoUEzUZWNr/KKIlOHpAdAxFAHTfjvoW9Hgu9gzZwX/QbQRoJMa8TxnHin9cokcLVma/kMc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by CO6PR12MB5441.namprd12.prod.outlook.com (2603:10b6:303:13b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 16 Jun
 2021 16:00:00 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::401d:c7a2:6495:650b]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::401d:c7a2:6495:650b%3]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 16:00:00 +0000
Subject: Re: [PATCH 5.4 24/28] drm/amd/display: Fix overlay validation by
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
References: <20210616152834.149064097@linuxfoundation.org>
 <20210616152834.918209675@linuxfoundation.org>
From:   Harry Wentland <harry.wentland@amd.com>
Message-ID: <4a5a8ca2-0080-8576-a9f5-0e054c93bfea@amd.com>
Date:   Wed, 16 Jun 2021 11:59:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <20210616152834.918209675@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [198.200.67.154]
X-ClientProxiedBy: YQBPR0101CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::15) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.3] (198.200.67.154) by YQBPR0101CA0038.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 15:59:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09c7cbc5-29c6-40ce-4e3c-08d930dfcb9d
X-MS-TrafficTypeDiagnostic: CO6PR12MB5441:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR12MB54418C61DBD161AAE25329718C0F9@CO6PR12MB5441.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:43;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fdSu+PLHT1efmD/H4n5jqaQg0tuiFhIlEX9VxJTeaWBL6ejq7oian0oOuRsPNu7uQBtS/NOz1+S/HMtOOVgfCxdtAWrFzH7qnCgl8Rl2LmVK8S/+E5ryci87x3nmhA0Qw0i3gl+v/oO4JvNtfCZXshsbjEcQfE8v7U/cvObhUIMJP/DjWHsWvJI4IlRngZGA1M2bmkTvp407qSBQ4qFjGpYU+RSukQpH6uIGgR7KL1KL3TUMIisxH/WgBiBreWw0a5ncFSwheJahTC/aWFBM8KZps3SzoS4/MzXsmZrramwUTlQUEfmzeYDFLHWsnnLY7/9dcHECm3MY/tXCrQKFnWBJrvBL7sC6vsebeDeC883Yvbz9pW1r/wD1WVwjGpaILdPDW5QL0CKkYEdL9BxCQZEfMUiQgzxpaHlE3MzclAvrKQSDIPwQ32FgICpzd4QZYIhjMjG6C/QMNsGsDc1d2d3+LUV6IBJ3RlfLsFOZ6NLNNQ5q0g9RRBsoixdDoqwlfxwczt9LeD67ab5yWP5ry0iTyVQMETrqUX6ZHw5NjqcLaMigZahDEf3C5BUIWjqM3xhT8vChRHCoNKo2nuGhPTNyB1K0EybE6HVugkJHmEtKjBAnhKhp4z3x2WW1NEyBjoVK5pM09CyxXaT4+yjH+YzNYnHCZgKkvZYql6pmd2OZ0/rxX0JYF7i/LQyA3iYN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(38100700002)(5660300002)(6486002)(8676002)(478600001)(31686004)(31696002)(8936002)(4326008)(36756003)(53546011)(86362001)(6666004)(54906003)(2906002)(83380400001)(316002)(66946007)(16576012)(26005)(66556008)(956004)(2616005)(186003)(16526019)(66476007)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yy9TamdYZGlSalpkUTg4aWFvWmpGOFVxSUNHWC8velF2YWgwRTFVSXFmTG03?=
 =?utf-8?B?ak9HUG9RN2tLMXVGU2lvWkFFZVl1d0pNTTZRN3hjMm5MZ0hZUzJWTGsvMmxs?=
 =?utf-8?B?cm5oMXFYczNsWGpYTTM4ekk5OWcrMUhoOTU5VHZzT2dHeVFSRHA4WERYWk82?=
 =?utf-8?B?eUFud2FwdFp5OC81eWQ3cWN5UnQwbTRkY3hxTTRTNjFraFd6STROclFlbmtP?=
 =?utf-8?B?dGtyNkZQMDNZdlVvb0d4M0xuNnNtakJHMHhWU1JCN0EzNTlJOExvZzhMaVJG?=
 =?utf-8?B?bXlqZGlnQ1FhU2YvTWlhUllqQlp4ZEg3cEh6Rlg2Y0YwUGp3V0pRUXhKWTEx?=
 =?utf-8?B?UVlhSno1UDFSUnkzTXg0SDlqM2poZFlGRER1ditKSUUrSUlFWDMzcm1vUXhE?=
 =?utf-8?B?VEpEdEZwaUxjVFV6UFhJWFlDVXhObFFTdHhXMVg3ZDdZVldIeERmN1FvelBE?=
 =?utf-8?B?QU5vb21WdG5yMzVscmNFT2xIUk1US3JFMHhnU2ZiajhxR2dpa2FocllnQzFh?=
 =?utf-8?B?b0VJZW9rbVpxc0pLQnNSZVowMmZnWlJyNGNlRTRYMVpNVHgzdzVsUTRtL2Q4?=
 =?utf-8?B?TEU5OFZmVzJoTE5FL3JqT0lWSzVTeE9Hcm9lVWpIWVdaRmNWbVZSTWdqMFBW?=
 =?utf-8?B?ZXNTcmtsK0hjRys2cHRXWFdldXBjNStFQXc2a3JoZnhGT0FUSkZ2YmhzSlJu?=
 =?utf-8?B?UzlQb1VvWjZ6VHhOaWNJbGpES3U4RXFsWHVKWDBOUk5rR2djc3A5ZU9qWHd2?=
 =?utf-8?B?eFFXNGlZYnM1WFdMbDQ1T1JKQjgxb2Y0Zm9VbXA1YzRlcHlPZDdXSGtOL3d0?=
 =?utf-8?B?dVRsbkd0dmVCcmIwZGZLbnQrdEdvbDlZZHNFTUNybUVDVktoYW8zNkV2T3Fm?=
 =?utf-8?B?aDZaMU1YdVpRT1paZ3AyMStZUG1Eamd3RTlYeS9JOUxrdjdtbjY4aFNCRW4w?=
 =?utf-8?B?T3VqYm51WGs5K1BpZ0tSaEtLa3RRU0VtTDBQVkd4YzhhZldjSHV5b0JLR3Fy?=
 =?utf-8?B?S0k2UTdKSFhzUWRQU0liejRtZFpsSHJnMUF6ZkdqQXA5ckp4RG54bldlNTlF?=
 =?utf-8?B?ZlBwbGVyNzBvTDNoVWFNdGFOZGFDWno4OGRMdUJRK213ZXdQdmhIdDd2djB5?=
 =?utf-8?B?c3JPQU16dzl1bHFOdXBPaG1TVU9ub2lvU2hvWG9ObFFCb3RlUVVabkVKeU9p?=
 =?utf-8?B?WGVLVzhkWHdOMXNJKzgzYXBrYUFQZHN3SUhWNTBiTDk4Sk50emEvTStLNWlE?=
 =?utf-8?B?SHZWbDFjSnNSY2J2cnMxRHBCTHFWZXRNbXlrWERjWHlhTDFZTXNKOTlTT2F3?=
 =?utf-8?B?YXhPcVVHQUVQVU5Vd1YxSnlmVXF2T3Y3TnVyOXo5YlEwbjl3QU1QaTVnVS8y?=
 =?utf-8?B?dVBYUE0xL0ZKaXJvU1grM1hnSzBIN3FtSHBnYUt2M0FvS3A3KzRWd0c0WTRR?=
 =?utf-8?B?V29ENVFzNzJadEkyQ05UN3FzKzlwVm1Hc2FZRERlUmZKTVBaNnJ0a2dPTStF?=
 =?utf-8?B?bTVnM2JvZEtIbEpMZ0hVekhnMThBdndXVWIyR3FKTW5id2hPUHpXZHUrL3Fj?=
 =?utf-8?B?cWo0MGpyYWk1bzY5eldEWWwwRzF0L2RzR3BBTmRVbHBLeFU3ZVZSK282RHRK?=
 =?utf-8?B?Y0ord2FPczVueFkyUFNZQXFYTjRCV3ZURm8xdlo5d2xINkxMRzRWeFRlTkhR?=
 =?utf-8?B?bEM3M2xwMGVwcStGVWpHNzh1eHZuQ29sRVVFZlRacFE0cXcxUHd1d3pUa3Rk?=
 =?utf-8?Q?hJ61rd6UUcuN9zKAuC4nwK8yz6mcMgC3ySXR0pX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c7cbc5-29c6-40ce-4e3c-08d930dfcb9d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 16:00:00.3153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6i26BLw2n7SrXDX4N4uqYS4yaVtD/GMFf5np6zP76LfFuPsijbPmlo/4cJ62Z11OjfP1uzPrujKB/KKAENdrUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5441
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
> index 6e31e899192c..29657844bac1 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -7272,7 +7272,7 @@ static int validate_overlay(struct drm_atomic_state *state)
>  	int i;
>  	struct drm_plane *plane;
>  	struct drm_plane_state *old_plane_state, *new_plane_state;
> -	struct drm_plane_state *primary_state, *overlay_state = NULL;
> +	struct drm_plane_state *primary_state, *cursor_state, *overlay_state = NULL;
>  
>  	/* Check if primary plane is contained inside overlay */
>  	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
> @@ -7302,6 +7302,14 @@ static int validate_overlay(struct drm_atomic_state *state)
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

