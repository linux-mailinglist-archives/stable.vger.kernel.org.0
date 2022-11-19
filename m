Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8530B630EF3
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 14:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiKSNU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 08:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKSNU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 08:20:28 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298D274630;
        Sat, 19 Nov 2022 05:20:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNw8XYvvIcJsds9JLQNwNk1hY37+MRrfjHeXS3PrD81dkGQXunKkCn3axtxjQSjUTsoWwczck8WEBHyEOJpgL4UJCz68MDJF8B9x1DJEFCsfSB6hC5CrI0D0KAoOhDMxbnuHVV4jlLvN3HGza0h0oiIGEIwhokVd8p7yPYAH1s++DNTl+uN0Ab4VG67X1FxlCAhjY7hDD7AF+uPkGIilN+OPwlYQmIu23EtYXBHHmvBVHsbjbl+gYwEUNZRWRti+Zze7OvcaimpYLPP5xm+DYD2cOHym5U6UkqlsZ3XHcAt0gtDMpQPDa54BRuQAfJtJngKaHoTOUoVscUIeepSGpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmsFMU8+wIMucsbSVcqRxqozhtkaGrQQPBm0S/kNyxI=;
 b=H8H4AMb1ZPzfBqJZ3yzyzce+/2ut1jCf3ahuJcEeomqz1u50SfN/e1t9RmWyOnH0YjkSbEi8IxVIbBMqvPgo0KnBW6Ve0ozKd2JitGQ44w7+64+UwOW+DoWvIDZ+rfdrCWDd7KMRY5GSTWAJXGeuJfkZHJhlFgGJFZtpUteGi3SFFZGCzZjlsx/GvFPgBQCNNONxfnp9X22t0X+19VrcQAnvqs06yhNaNQP2RHYigIQVPE0X2E7HmrHxXwK4ro5SpxqFpHQw3fVmwjPlbtmFmVoQ6GPl9bqOPmOn/YsfII0OecXhFzpElqyS8SCGLEXvL9tC1ezkyjbDES4JzaOL9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmsFMU8+wIMucsbSVcqRxqozhtkaGrQQPBm0S/kNyxI=;
 b=RIfFsFRg9QSEVoGCzgRKF26ve2LnoUVtjcHRV9UfhtZ9R1HKZSrN4rmbteKU3RfSbQUUuBkNF7SDmfKyvIT4nGN6DEAI5guAtXdaJI1ZipQyxoqM31ZWEayPuTk6Uwx6aSlGalB7fdWwg8Ww+ltM8ikF12V12EzGgXZgpqePd65TuhiniMPD4fhbvny22z9IexV2BM+QAgd0D4+7k7md7pImzlPPMazwf/TMNw9lsz/EFVtousBWWi36SzS3mfAZL4G1kC8VMm7mUW23MWsL2AsLBjeaYK94hkpo3aKHnS1EDBfipLgKde1rz9O2SRc05C2hYx8Y+Birn5ogPzF7cA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2760.namprd12.prod.outlook.com (2603:10b6:a03:72::16)
 by DS0PR12MB6487.namprd12.prod.outlook.com (2603:10b6:8:c4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Sat, 19 Nov
 2022 13:20:25 +0000
Received: from BYAPR12MB2760.namprd12.prod.outlook.com
 ([fe80::6d1e:5a2a:4295:36c7]) by BYAPR12MB2760.namprd12.prod.outlook.com
 ([fe80::6d1e:5a2a:4295:36c7%3]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 13:20:25 +0000
Date:   Sat, 19 Nov 2022 07:20:20 -0600
From:   Daniel Dadap <ddadap@nvidia.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Iris <pawel.js@protonmail.com>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 13/27] ACPI: video: Add backlight=native DMI
 quirk for Dell G15 5515
Message-ID: <Y3jYFP3lBrbHAUO7@lenny>
References: <20221119021352.1774592-1-sashal@kernel.org>
 <20221119021352.1774592-13-sashal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119021352.1774592-13-sashal@kernel.org>
X-ClientProxiedBy: DS7PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::19) To BYAPR12MB2760.namprd12.prod.outlook.com
 (2603:10b6:a03:72::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2760:EE_|DS0PR12MB6487:EE_
X-MS-Office365-Filtering-Correlation-Id: 32cde77b-6580-49fd-b2a0-08daca30d104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkB83J1UIN/vTWq5Fis+CvWBS0jzahQ8Wjxbo0/jak0RNKe1D3IrE0LYE7PRr+i6B/uDOdQ0A8cXaPO+xkn7s9Lu/0Cpx/29rdqNjsIzLFjqcy4DkhdDNcZTOJrtUUj7mTcdmYEIR1oVR+3AOaTegLz+/GSXaJ8n1+CyrsDTdfRwLmKHmqsY21ibN782phj9KdexHpO8xzSKOIshCy6aZKEKNRQmzAU0ruQe20uKWOpqaHCNiIwdaT8C+NAL7Lh6U5FT+Pt90gBUJPj4kn7l1MC3wZUpq8aTStjvUADhAvrqWdgdy4DlqrGQ6THuVArTczFiN+p9ahyJlNRzRXC6cCkKTfg8gs9l+64wkGtRwjLmgGzae3ICdznFYNK2lqgJdiAqRqgLcQfxwGSg0nfdguTLShj0gVOJQtva9hRa572l06nX2NxyQI330SDKvsGs0DlU4LUJTFFJvYYVL4sR6+krpqjHVJdq0oT4WqNFopC35xS7F7omQPezUzqTROFotKjEdYtAQAR/+8BAF/BudZH4G6VY2WQMRMN3tJZbk27oYOW/8mhWKSy5tw56iTDouI3BNryn2emw2aBmc9V0iG6xFbMmlxf15YpBncGudLAIYbPuTB54i0BDrO0Gf/+COIOa49lwq6WUGofbUQ/sFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2760.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199015)(2906002)(26005)(41300700001)(5660300002)(8936002)(6512007)(6666004)(83380400001)(86362001)(38100700002)(186003)(66476007)(66946007)(54906003)(4326008)(6916009)(8676002)(66556008)(6486002)(316002)(6506007)(478600001)(9686003)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xy23iQ63sXhx8+U8sHuOYuqSNCoY6fpXH2NS2ki+GKmNsNHTiGTALsye2oIU?=
 =?us-ascii?Q?PJ+xziOTX/CjYs10mzc0Uszuab8CMGvJ2yWgnX7KFYBW20n7vYOvCi0y+WIx?=
 =?us-ascii?Q?wCgG0em9T0Pfx5hyw3Byrm2Hw9QeyYyGAm+9DTqfCc8uVi+Wcw7T/HPoFKRN?=
 =?us-ascii?Q?6KZkvXQmy9h+0nHWFWQIfKxzjvmRYqpaXlfLY5hswvPN67EqwFNDUZ9HguYa?=
 =?us-ascii?Q?KN6Pw2PLILrinlYe8l2QJeocPdA0U07O0FWhWfnNquowAHiIXiM1ucOQXILs?=
 =?us-ascii?Q?tpQP0ocBTlv6XgUS0qJ4Z2bBJTAPZXKejeYIyFiO/F0YdVKx+AhTuaWVk7e+?=
 =?us-ascii?Q?Ld9pSViUpAuG6tOSxnU72oSp8PG+GG4pIXVn8/ILmLitTz2mK9HPCTWfYPxp?=
 =?us-ascii?Q?8lzhJ4rN8lSv31XCnzgSyItBQ+x7FjpECthZvO2YEAYhjRTly5/krhW6u0P8?=
 =?us-ascii?Q?vwC2Jl8bKdybTaneDPVJIsxcP8Wr/lHiYAWkJ5TK6luU+YNDQDpE+xcAq2hs?=
 =?us-ascii?Q?SelHsEb7Qg7vQLYckppKNvyLG8wUbgSmbAybh64yFmHaYQj/plxqKt6+GrLb?=
 =?us-ascii?Q?KLgY8yJg3CCE3zyDj4vxwC7eelR/YdO7yupvrFhOmsM3UzNjt+Wrk1JusTaV?=
 =?us-ascii?Q?uu68sfubupAwQFkPnvhXBU6B0nsT+Uk9SJ+rrCAypuktooJo/ynb66fWRxVM?=
 =?us-ascii?Q?KBF6xiWCumk+7LNpmXjdyxb8rq890Sx+tBPUrF5kBJpjaKcOafnGcBMHQdd5?=
 =?us-ascii?Q?yxuB3o9+YOIT0CAyq43UDXiqZfQ32IdqlhxbUbDmigkkNZ4jD2BEKNrT0qo0?=
 =?us-ascii?Q?hrUt1UR6YU3D2UNusKfiAlU0DuohJ2/mW+3kyL3ORgNmEY7TgtAhd2eX4/zE?=
 =?us-ascii?Q?ZJuAhCuV/SIQJwoRxFtNXIuwEzd7ZZ0DOAx2IEvrBIQ425Z8L9WbELA3NRai?=
 =?us-ascii?Q?c9s9fAePOd/sRQQZQAeeKew3/FXG/MC4EwfPjGseiOYqPsEuevzxGQlqKRru?=
 =?us-ascii?Q?lGpEolhfiQQuhzHdusU66Kt/1ix5iwDcW2oV/23ZlcJyDDOhSFS9pZYPcEpy?=
 =?us-ascii?Q?eE6BecyRPslFzJTo7ojHAZG0EkHcQ4jaGPyiJWWdO7CrDXyqBoQoG7FziOge?=
 =?us-ascii?Q?QarOPzRASUIk32HFu7Pt55L8nShMhAD9kQ2xr82xjuQFDZ91EFKK5PKdDu/B?=
 =?us-ascii?Q?XjJEy9tjTdG77pBoh/SpxmpQL77yuf80tsr79ox7x6n1Gd15MYWie91nyei5?=
 =?us-ascii?Q?iGgYb70TLss61Q/6U9dDYOQ+E2ZfoOD8hEixKAIY2q19acvyk+S9JNhYtjv5?=
 =?us-ascii?Q?qwy2c8a78u0Az3eZUy6HjOTT0Eb1XAPemRJkglS8u+sQSZQi6Yy5vQhu5Tk0?=
 =?us-ascii?Q?c5PgGMn/izyUl1P0Y4zeLf1RZymKg3Ia9hD1ehMDJVS1XWBpYycGbSnCKbA/?=
 =?us-ascii?Q?FYHwleBYW4xcfTJnW2uwbWyViAE7Ennhj/XmscRvdGA8alVBDFGtOcKp5oVt?=
 =?us-ascii?Q?75SSeabz/SG20UsZooeS/2wcNj1Zh5/1aL+SB9sue4kbGZiBvygp4re98in3?=
 =?us-ascii?Q?XeF7jxkwb9yfZcFKyO9XzV64unMcoxtouJQ2sr0n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32cde77b-6580-49fd-b2a0-08daca30d104
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2760.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 13:20:25.0957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Xftgjj+3GLjLONHnpui/ZYTqcs3goLQoxlVFOLUxlAM64EePt25Gxx46msYIFmYz5+570DBx1AVxyqnikeBzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6487
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

NACK for 5.15 (and earlier) - the nvidia-wmi-ec-backlight driver is not
present in the older LTS branches.

I suppose this patch could be useful for distro kernels which have
backported that driver, but I'm not sure if it's then supposed to be the
distro's responsibility to also backport quirks that affect other code
they have backported. If the intention is to relieve distros of that
responsibility, I suppose this is harmless enough.

On Fri, Nov 18, 2022 at 09:13:38PM -0500, Sasha Levin wrote:
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
> index b13713199ad9..8dfcb6b44936 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -564,6 +564,20 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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
