Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCAB630EFE
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 14:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiKSNbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 08:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiKSNbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 08:31:09 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8A97A36F;
        Sat, 19 Nov 2022 05:31:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwZ1mbjSigZTXM54mh/B8m0qFc3xmeWsNVL/Me1gpGiL0yqVgTpsN0p8NRPsS7z/QnDQjEwVWWgDbgLEiLZkhHoQgpRnAjI3Dhf3h4wgL9VHTf+AdaM0KQ3ftq5lMhkxVnWoW+oXt0H8abn+dNHHY0pOEoGnkhdLiztgfSGzN2C0y0zCzjNG9Z/iQvKk8aV7ddpxzp2cI76a80WltirV4lXZJD0gHv2zWN+XLbjtmbGniWXWHZFQXALNl2u2Z2V2dp3CDcOi2ZatnA6BcONdcrxAhrX9JPl6E/GCvIYKjipT+3D1EijsyRc0elCEdR/rF6KhPDRXP2rbhWBAhbaTSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZFzh75AMNc1bI/LaSnoXM8r55OS6NR+riIq6iSo58Y=;
 b=C6O8PJSQ3Ojpdkyig00NQV/9gKgLaryDxhy8he9wt2CSD2HjLUWrCd6szU/GM83Hm42shfOKU+b3oGswqfQOboTWI1lZjjv+G17+Ss81JlWM0breCjUebLI3W2v18uiLY5LrLASydeKSoKzIAlRZ2uvjDV2YBcrrQToAAqFTSVL8/PF7/qNafEi+VUl+krLTSAS5CzHe2oFuCTcbwH5tnjRl/73fk7dNERPkOKqDTAy26zhubsGf/2w3D/t0kNJkZov6Oov7AjaFC+OvQ4T14MFyAr13KhiZ9M+pC+E8ITu6XpfVuAXrEyHqiV6HzzkfsDd2crSesXoUME0OLryE8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZFzh75AMNc1bI/LaSnoXM8r55OS6NR+riIq6iSo58Y=;
 b=RF3OUSKI36iD4eJptAyF9pb+gPz5BZZ6pa/tFI/qBLNlx5KWUo4+tkuBpVDsdijfBMMpnoFnxjqexqtVg5Dheaszn3d5LWBpMWZz7zx9y+zW3iLnmM1aCLDQ2FiKiIC19uVIFRDsgFjqG2yeqqi2fYVc2ztzqkfe55fooD5viQNExCeE1Fu0sdtf2WYS9mTuAFA/S1It0+4oN6EOWVb5gxhYsLUFxq6hHfloSeQKlXkhhsxWG+8hHseA483+Bxo1eThru2z5WMxUywhlD26YK4l5mzU9Ht2/dUhF/SPzYBnNxVpopxEDrY0zSbmVtEDGLgMc6QB1oSdXfmoSy0hwQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2760.namprd12.prod.outlook.com (2603:10b6:a03:72::16)
 by MW3PR12MB4587.namprd12.prod.outlook.com (2603:10b6:303:5d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 19 Nov
 2022 13:31:06 +0000
Received: from BYAPR12MB2760.namprd12.prod.outlook.com
 ([fe80::6d1e:5a2a:4295:36c7]) by BYAPR12MB2760.namprd12.prod.outlook.com
 ([fe80::6d1e:5a2a:4295:36c7%3]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 13:31:06 +0000
Date:   Sat, 19 Nov 2022 07:31:02 -0600
From:   Daniel Dadap <ddadap@nvidia.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Iris <pawel.js@protonmail.com>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 18/44] ACPI: video: Add backlight=native DMI
 quirk for Dell G15 5515
Message-ID: <Y3jalhV1iGJObn0i@lenny>
References: <20221119021124.1773699-1-sashal@kernel.org>
 <20221119021124.1773699-18-sashal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119021124.1773699-18-sashal@kernel.org>
X-ClientProxiedBy: DM6PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:5:334::8) To BYAPR12MB2760.namprd12.prod.outlook.com
 (2603:10b6:a03:72::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2760:EE_|MW3PR12MB4587:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ad400a-e4d5-4650-a4f7-08daca324fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2Zb3c1FYNLv0orkU9JR3ruQt7PcFi8E3AVHrOdPpyWFTzwwkxEDfySRAQsYcDVGu5bW897xGeWM08PMoKnOY2uNPlAoFlJMuWdj6W+PcOCSjly+yqbXQirXNhFz3kG9JDR6Vd3JigVgIo+mPLrVNCTI+PKC77dBI4zYsFO6/FUD/bphEWK71G904s2Gxu9hfZHN/JTg5nB7J39aVRJHbP4EvUggLAkE1OrmzaN5Z1K1mM3a05Xapewm7GyPI4UEsXOQqOLpwmHn6KNr7EIbXMaY3ZoOJCrZjUph6C5AYGg83WXd5SmvVtb0YiTEIVtS0CyRh+r4DdP1ZSfoVaw5hapOLFpK3YsFT0QXqoUGvknELI6t1m48fDgwXgmLC3osUrcCPpQ5b/x7/S/XXNbweZAheUI2lya09lAL2wmcc+MJUrWuAn8CNtGKv+5P1sbOcs66vyKUThnyKYQ4SePu4tvzgd6CdfJsEVXiM1W0gTRel/f3LxZphw2x28oDXE5Dm48GF8D0Fm9FCuoYmLwiZLPna62xSjxWW3aS9oMG/QnWfKoz9TLSpZFBOInnWl3Z13K0l03EVM2YZSYZT+bMKXHNoODQ8V8o9jjZMHqBTkhtDr/uBbz4YTuSnHYvWmPMg3jtP+SwDRS4txtXAG3TJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2760.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199015)(26005)(4326008)(66946007)(66556008)(8676002)(66476007)(41300700001)(9686003)(83380400001)(6512007)(5660300002)(186003)(86362001)(2906002)(8936002)(38100700002)(6486002)(478600001)(33716001)(6916009)(54906003)(6506007)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Y7RI/RjV72GgLOk9+H6/49Pnj0W4DRJk1Q/R0Kjs2jwb7gA/SU3iM5Tbw2h?=
 =?us-ascii?Q?QhG3efy0Kd4ndYW42asEjqRgFpNX02GL6kzq1kILTeWdNGcfohnP1zq4zJ7F?=
 =?us-ascii?Q?+YV3CKHdjyfjqgxVzrEahk/L4HW2DeOfdtgnjg6ry1beXIN2FbBLu4vOzA+R?=
 =?us-ascii?Q?1w4pZBUotk3Dj4Waa75BwhaONK6NtthD6P8E01h9IDjba+UJaaOFO2JDJrVI?=
 =?us-ascii?Q?0FoPlFAY1+JKn35NRbRq60Cx33jaf1rdUoYfjQAn0mU12ZhFQ7FTO+X/uQBL?=
 =?us-ascii?Q?8+ZWG4zLLoSJ2cevFzZW5lV354JUmmzcZJkJbJJBnpafxlPDGqZuOysU75JS?=
 =?us-ascii?Q?UvJ9lM8IqH+wLvoOibDv4Rws4niHTmIG97rJ4KOX65YEmJtmdI6iI9XtktFW?=
 =?us-ascii?Q?pbpijOmjsfuiJLgygpFa01HMe5UpEqcruFMkGCc+mW+3VQbPta7hIl5QSWPE?=
 =?us-ascii?Q?psCW8vxQxW1MTeWt0tjNp3gvPpq4K5CYHS5Ojhj5cP4eNNmykC2jiJHWEBBk?=
 =?us-ascii?Q?LiM6DJ+VW6Vj1pibbk2B5NSTos8HaRcwWJEQ/h+qGfPma0cdwO5XQfgcKj+F?=
 =?us-ascii?Q?vKP563JiUyhOQJX+jnAi3Z3PUAb/eJ8M4sKgfQebbSoP8SHR6m4Xbois4Ca8?=
 =?us-ascii?Q?sEWgQYiwgEox3n8CrNiE31lZvV1mEek6JezqbfZSFrB0+9Eys9GyCEj/9Hdx?=
 =?us-ascii?Q?sAxySjAB7vHo+a6H1R7epxdsRxldU8sEEpZCRIyYy93K1MzK80to7j6Sk8MY?=
 =?us-ascii?Q?LO9PqjTbiMBOBoHjJ1ZWDEjMKJQfQeRzcUczmuhvVl4SUZyfPwdMX0zgafzg?=
 =?us-ascii?Q?+C6ptDaINIHst1ht8KOBwVDW5duGGLZaDh+I1DN8C3oO2Hx3Zr4X03HZGLn6?=
 =?us-ascii?Q?YndB6iUM0iQLNf6vVyd1IILuMCCSn83deSF6X0sdmwuPdeqpVl0wBdgcVTkY?=
 =?us-ascii?Q?//DoXwPc1AH6MDLnr+z0H0O0m7HI/Dcz06JCnitw0BaWQyS4dSsfvZ74RnbK?=
 =?us-ascii?Q?h04TtjHAToeLEs1UosUIjQ5hHP50qoZ3+t2B2b1PEj1FmjMRR5Km4cohsxBh?=
 =?us-ascii?Q?1lg53R76H19aQrq7QglQ7aSOYRibunSh8mrb4cQt5p81ONAea1K8LuBwEfHi?=
 =?us-ascii?Q?+MZJ379b0PknFrEJuec2KBBTQaMm9kEbkmTgNZO0tT4zauHJCjEKkZhI7uAZ?=
 =?us-ascii?Q?bvRl/qyCwswJKq0bfSeAjfxoPNCqsCB0EiwhxZct+w7epZ6ZvpufsNlo7PfA?=
 =?us-ascii?Q?+3yF5U+rhVfQ+bjZOhEsisx1cRlmAD4J8b3+c4nfX+/eb+TFecVU63RUcHKT?=
 =?us-ascii?Q?bEuqALqx1YVDof18j5po2dun0glb35hcjNzk0JmXYERiJTO7u0HMIVHEXwjQ?=
 =?us-ascii?Q?j6MxZ2r8fo8q7kG5nLJwsWkoWgRLgiEwcMN1nVUw47jgqFDG4rcialXsiuc3?=
 =?us-ascii?Q?Sb2eGtRaMMkvLce/QLsWr5KtIopWkbQrRsac8AlYrKpNIt7/NfitfgsPgSVn?=
 =?us-ascii?Q?DGgzRhZEUrwC8I5jBSegUNueDtOfD3W9Ktomuu5bI1d5ljNRVjcTqKdTTiqz?=
 =?us-ascii?Q?49++tm6M75j53gkjEU/Ni+W7Rg0DFVwamOEthS71?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ad400a-e4d5-4650-a4f7-08daca324fe1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2760.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 13:31:06.8084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxU+r6KEAmvqQirJf2XBdqcNE+khPJ/Mephoc2zVf8bl5/Xknm+pWDCq+B1KLm21UNQT2L+j0TAmKx2rom06Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4587
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ACK for 6.0; this patch is appropriate for any branch which has the
nvidia-wmi-ec-backlight driver.

On Fri, Nov 18, 2022 at 09:10:58PM -0500, Sasha Levin wrote:
> From: Hans de Goede <hdegoede@redhat.com>
> 
> [ Upstream commit f46acc1efd4b5846de9fa05f966e504f328f34a6 ]
> 
> The Dell G15 5515 has the WMI interface (and WMI call returns) expected
> by the nvidia-wmi-ec-backlight interface. But the backlight class device
> registered by the nvidia-wmi-ec-backlight driver does not actually work.
> 
> The amdgpu_bl0 native GPU backlight class device does actually work,
> add a backlight=native DMI quirk for this.
> 
> Reported-by: Iris <pawel.js@protonmail.com>
> Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> - Add a comment that this needs to be revisited when dynamic-mux
>   support gets added (suggested by: Daniel Dadap)
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/acpi/video_detect.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 68a566f69684..aae9261c424a 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -578,6 +578,20 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
>  		DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
>  		},
>  	},
> +	/*
> +	 * Models which have nvidia-ec-wmi support, but should not use it.
> +	 * Note this indicates a likely firmware bug on these models and should
> +	 * be revisited if/when Linux gets support for dynamic mux mode.
> +	 */
> +	{
> +	 .callback = video_detect_force_native,
> +	 /* Dell G15 5515 */
> +	 .matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5515"),
> +		},
> +	},
> +
>  	/*
>  	 * Desktops which falsely report a backlight and which our heuristics
>  	 * for this do not catch.
> -- 
> 2.35.1
> 
