Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1ADB298E7E
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 14:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1774648AbgJZNve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 09:51:34 -0400
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:4833
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1421385AbgJZNve (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 09:51:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFOXxu6p3A1EDAf54e8vBFhsPPYomjdFwrcCPRrX6De9tu1FOwOTRC1/ai4gRbk1aRUh9UQTeHGI5RNdLqWlACvN/YAlABuBiFUCNLMhtwQRKve29lq23IEcTv7+hvCLuBPG//DD1TvzLCukDjw3XSvPv+yRKg0jyKMSuxG/eB3od6jIYKfsMKYu+FyyE9BtiTxIANggW3zcfSayNsWbxwkgbqnuSTqofeDc3baMcVf9u1HCFvxa6/BHpqMJRtGepKQLui0YK9CLb/JAREwIlgxqGYqN8wb1JTcvzN69PwUM1+EIG0lN+CWXoGXvohhlVaQkpi8nIeKq+/Pw1zBEeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqgjWreyrbATrdKAoNA/4YH1Qj1jepzq3IZ1RhuKcvs=;
 b=OpVVGTP8eZlkdFsQ8rRDA9ANz5VZkkA28RTNhJoa7Mw25yWNChMOodBlx+UpG8A4Tc3ia4LfiWTMqRoY/U3wPdYV+sTyIQRNKhQmkp1L6QiVvLoup2A5Z3+KayW60UOm35O/7d001i4yzYiI9qgu8ZE2cPtf+fnbOFaMmsEwycfWTUTy3eMIcNAqj/KWIRUb2phFKfgn8pcZ9QYGyu9DwXkpUuydvg0Dug0hQolJlrH2KZRmttIv55dxAaQiCeHjiHVF9jpFRaqz45nU+Krvvnr3MAB1iVKRgXmxYXZzKIIG5zuXUBdGgOX6b3SWLoqad4WYFnjUul3FktN78UgqBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqgjWreyrbATrdKAoNA/4YH1Qj1jepzq3IZ1RhuKcvs=;
 b=mLb7kX5xZci7xxZdI1VIP8Mg/mIX/rECpm5JoOjoZivySQc6QiKCfQV3eYwd79Vz4ttLPZQ0IeglYVfBr4eSMVfkuGoQjcRGc6Ua0SYNe8B90cvrnDB8MzIQ6S0nq7SjSG+aMsrpnUyN6xDH+vsl4Ckkj4fZ8cnEji2r3r5gsKM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB3560.namprd12.prod.outlook.com (2603:10b6:a03:ae::10)
 by BYAPR12MB3239.namprd12.prod.outlook.com (2603:10b6:a03:137::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 26 Oct
 2020 13:51:29 +0000
Received: from BYAPR12MB3560.namprd12.prod.outlook.com
 ([fe80::b46f:9253:b0d8:7999]) by BYAPR12MB3560.namprd12.prod.outlook.com
 ([fe80::b46f:9253:b0d8:7999%7]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 13:51:29 +0000
Subject: Re: [PATCH v3 03/11] drm/amd/display: Honor the offset for plane 0.
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        amd-gfx@lists.freedesktop.org
Cc:     harry.wentland@amd.com, daniel@ffwll.ch, alexdeucher@gmail.com,
        maraeo@gmail.com, sunpeng.li@amd.com, stable@vger.kernel.org
References: <20201021233130.874615-1-bas@basnieuwenhuizen.nl>
 <20201021233130.874615-4-bas@basnieuwenhuizen.nl>
From:   "Kazlauskas, Nicholas" <nicholas.kazlauskas@amd.com>
Message-ID: <f83bc704-9c61-93ab-9b57-331f572e24bd@amd.com>
Date:   Mon, 26 Oct 2020 09:51:23 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
In-Reply-To: <20201021233130.874615-4-bas@basnieuwenhuizen.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.55.211]
X-ClientProxiedBy: YTOPR0101CA0054.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::31) To BYAPR12MB3560.namprd12.prod.outlook.com
 (2603:10b6:a03:ae::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.148.234] (165.204.55.211) by YTOPR0101CA0054.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 13:51:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e1bb3d78-d693-4312-42ab-08d879b63d11
X-MS-TrafficTypeDiagnostic: BYAPR12MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB3239DC97920B57625E321A00EC190@BYAPR12MB3239.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TyOU1Dpj0Uao46uCvH/15+edNhNEnWP0pPYJuSwq8ifLb8+u8UqUarrXRBPjIsXH1k/XZKFlasuB4IZwRjNfxdU9ytPE/yuZai7+vColIltOCPWJhXGWKp4Fo06KOeNonUxmIcDf+j3AUIB6hvJAr5nwwjNtjQ7uLV/XShF+uGH7Qugl1Sah9FToJgvdppFOQyXGZ/SPZ2QjaNzO0T7Lp09gcpVvPQNwsP5KWdO8msxLjCFfj71f9TwB2tQrZd+OojS+tidHSfrbI+t6IroPWn3VYG+mbYHtFHiNt289fYce6hxIlLX8zOKsFvukyCB4YNUY1HP9W3D35NE0THBA2853FAof02wg8TSBEygDdWMpu+5PwP3xnjjbYy9oeykl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(53546011)(26005)(2616005)(478600001)(16576012)(956004)(86362001)(36756003)(83380400001)(4001150100001)(4326008)(66476007)(8676002)(186003)(31696002)(316002)(2906002)(5660300002)(16526019)(52116002)(66946007)(66556008)(8936002)(31686004)(6486002)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Citzu++9QvyOtySSW21lfMLRIbcRJ414xb9zz1lPhPYHJzdsc0mmEj06CDWoH/afonT+LAeQJACd9peGM8hYrGlqZQXMW8JUAjpoQo50ltwolaqN5BWVI3vIw7v4wl9rgL9iJ4h1DTreA3hlFZi4s839txXINGFHkLhAyOd4sboGMi6kWougI1L8LdAk3cblcnP9z+endnVoHStwrDAoflO4YfTa/UKj8rUJmzxPls4zxrJx5ejsZES9gYU6JSJWa/nlJ/Y1Dg3/9zmMQrkO8pPzqVpG8gKV+mXAQyXL8eRuAh6SFJRwU62WzetGc2N8t7qVGGlPhGaHVB7xA1pKt4WZtOAtt2YRuuGOv7ycEgyG8sLFLsZDS5bZFC/a/bX59CMofC2NTX77e1XnXSv3dnGkffUT6RzoD6lw0W5nLfd2zinmx0Oi5I6MBVnh0p2oe9fxT6kdYHp/Xhou+F4dT13qFG5Q4Vf8PAJTGukcOVBSoTAoKCjPaK+hgHVvQNvKV1vtG5ISeJp9wbjrbW4yW4AxkM+Vu3WU2q5AgDCbPX1TqYUFv3oMWnhizSdnVRNkRjheKw5KypcdTbTgZ18nvKNZaElVfiyaIh3vgM390t/HfnqLMjn3ppqp9TWri9tozHMztrLLIzDsJAGTtr5XRQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1bb3d78-d693-4312-42ab-08d879b63d11
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 13:51:29.0304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLbcQBrfo1l3rxzM51e4whViYc0Ys2zb1vc70secr2s66eFTKu+LSULR/I2puiR9YQUtkG57iSwdZ7xI3YmH4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3239
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-10-21 7:31 p.m., Bas Nieuwenhuizen wrote:
> With modifiers I'd like to support non-dedicated buffers for
> images.
> 
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Cc: stable@vger.kernel.org # 5.1.0

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

Regards,
Nicholas Kazlauskas

> ---
>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 73987fdb6a09..833887b9b0ad 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -3894,6 +3894,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
>   	struct dc *dc = adev->dm.dc;
>   	struct dc_dcc_surface_param input;
>   	struct dc_surface_dcc_cap output;
> +	uint64_t plane_address = afb->address + afb->base.offsets[0];
>   	uint32_t offset = AMDGPU_TILING_GET(info, DCC_OFFSET_256B);
>   	uint32_t i64b = AMDGPU_TILING_GET(info, DCC_INDEPENDENT_64B) != 0;
>   	uint64_t dcc_address;
> @@ -3937,7 +3938,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
>   		AMDGPU_TILING_GET(info, DCC_PITCH_MAX) + 1;
>   	dcc->independent_64b_blks = i64b;
>   
> -	dcc_address = get_dcc_address(afb->address, info);
> +	dcc_address = get_dcc_address(plane_address, info);
>   	address->grph.meta_addr.low_part = lower_32_bits(dcc_address);
>   	address->grph.meta_addr.high_part = upper_32_bits(dcc_address);
>   
> @@ -3968,6 +3969,8 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
>   	address->tmz_surface = tmz_surface;
>   
>   	if (format < SURFACE_PIXEL_FORMAT_VIDEO_BEGIN) {
> +		uint64_t addr = afb->address + fb->offsets[0];
> +
>   		plane_size->surface_size.x = 0;
>   		plane_size->surface_size.y = 0;
>   		plane_size->surface_size.width = fb->width;
> @@ -3976,9 +3979,10 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
>   			fb->pitches[0] / fb->format->cpp[0];
>   
>   		address->type = PLN_ADDR_TYPE_GRAPHICS;
> -		address->grph.addr.low_part = lower_32_bits(afb->address);
> -		address->grph.addr.high_part = upper_32_bits(afb->address);
> +		address->grph.addr.low_part = lower_32_bits(addr);
> +		address->grph.addr.high_part = upper_32_bits(addr);
>   	} else if (format < SURFACE_PIXEL_FORMAT_INVALID) {
> +		uint64_t luma_addr = afb->address + fb->offsets[0];
>   		uint64_t chroma_addr = afb->address + fb->offsets[1];
>   
>   		plane_size->surface_size.x = 0;
> @@ -3999,9 +4003,9 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
>   
>   		address->type = PLN_ADDR_TYPE_VIDEO_PROGRESSIVE;
>   		address->video_progressive.luma_addr.low_part =
> -			lower_32_bits(afb->address);
> +			lower_32_bits(luma_addr);
>   		address->video_progressive.luma_addr.high_part =
> -			upper_32_bits(afb->address);
> +			upper_32_bits(luma_addr);
>   		address->video_progressive.chroma_addr.low_part =
>   			lower_32_bits(chroma_addr);
>   		address->video_progressive.chroma_addr.high_part =
> 

