Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3BF686EEA
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 20:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjBAT1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 14:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBAT1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 14:27:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B2281B24
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 11:27:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvTCTBKgnjheZLbgUjquAl19oeuvu3F5mqqh1P4dV+SeYb+wj9BkUl9iKkgfuK2TZOQTXzjHzjIh0w97Jkz/JhYRtVu5ead8zUMaulDkVI/XhgFna5NTKHqsT/yhXg2zrfaZrOZmPCJHPat5di2GcdgrUaVCwuTX/rbYFULO2gVUS20+bgnJ3yukRhOF+dgbGbdWOn1YpsQXSq0AW5fm38e/0ReGUe38o0eBIa1Qt4kkywF/drywD5ai2xhJfpp7+nTBsBqRpyY2FDjrGSVnXd2B11GW7JqL2BLJGyvZZtQ1ENy4SDbrGTIJ7fE8pEtZCGz7iR5AQcXRjytBpGwTbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzEw0XN+vlR0Y5N6pN5bzjCR/bWXE+LqCabl8m0fAX4=;
 b=SM4XDSK51EqL8m8rVlwbr7nwjbvwvD4oUmL4PZRqPGNC3pEFSbQCwyxsfO+X7jREukJN78aEHRZFXObt9xXeTWi+HgNFXKMei3CCEJ3f2VK9R0TvMzQ/koP0Eb0ggiDFEicnj3lNbZ3qK1/gDYenRjXUcRdgtryuinyssLLo0cCYzj99snIZ1VhlLGyOHZy598y7Ti2KLnPGEUl/0RbSNzoxtW+7gsrM7QiqVRTyppaVRLy9Yfp/ir1j9mni4EooLxNeCVXOmMHcCOXEyXAjdfgzPdIZiQ8S1tpsIINSl4fXydtBKdsdjm3jbX4yl0PrBCWMwjtpJtkrBAWibjMEUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzEw0XN+vlR0Y5N6pN5bzjCR/bWXE+LqCabl8m0fAX4=;
 b=07CF85MYfSQG1s8QPjONCOR8fyog2mUB0S3rIORRc4aQB+osaYFYJFgVY2Oa/jF7lFaWei3dr2n61B8e/yr9+3kwFY5Mz5WH+AIVSK0CHPoeHAJXnftQRP9MWEYheWvSV/IorFN/pcWQmqdTiFD+0SwL1bHI7kCdkaYNyF5hSFU=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 19:27:09 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::5cbd:2c52:1e96:dd41]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::5cbd:2c52:1e96:dd41%6]) with mapi id 15.20.6064.024; Wed, 1 Feb 2023
 19:27:09 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Daniel Kolesa <daniel@octaforge.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC:     "dan@danny.cz" <dan@danny.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tpearson@raptorengineering.com" <tpearson@raptorengineering.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "alexdeucher@gmail.com" <alexdeucher@gmail.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: RE: [PATCH] drm/amdgpu: drop the long-double-128 powerpc check/hack
Thread-Topic: [PATCH] drm/amdgpu: drop the long-double-128 powerpc check/hack
Thread-Index: AQHZNm7Yw5z88KfjkkOy14Lm6vTQO666eTMw
Date:   Wed, 1 Feb 2023 19:27:09 +0000
Message-ID: <BL1PR12MB5144368569F2CB3E5A3364DBF7D19@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <dab9cbd8-2626-4b99-8098-31fe76397d2d@app.fastmail.com>
In-Reply-To: <dab9cbd8-2626-4b99-8098-31fe76397d2d@app.fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-02-01T19:27:07Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=d00e19af-d0f6-432d-8d98-ee832b02f82d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-02-01T19:27:07Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 86f07dd2-86a8-434a-8159-b850ad5f657b
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|SJ0PR12MB7066:EE_
x-ms-office365-filtering-correlation-id: cd75c4b6-e3d5-4e21-2b48-08db048a4fba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g0dvFa6wai1SvYi36u4202ihR8+KA6FHLxsQB5mU7n0JKyTuRjmmATfz8zK6hNiXRfrEyfyperTJ9YLf30d2/KGg50J94vKEvz9UDLxLl1zHrmvUwlu9vwgsJMB/tvNHMQLEt44fZWEyT38I3JqKK3zG9EuNsbbtEM1Q4h5xfPqfQBikApJaJEus7IuGnseSxJsd18adxfQYlODhA1GrOjORpuEB5i3wWXUeMb+/wkv1GAqufSFqWjTCvyJjHFBC1673cauVYotSSKSF2Xr3rzBDypeuh2SWpawcUlsDaPZID9MsKZpbMv9MdEy+gG6vd1uvkS+D8KKfIgvXxOLkviOvT0EN1dySpu+EqN7AIkl+o+XdRKkfRaZ6JoNUdf5+BJUz6+Zb7b4g5TB3EerVHzvDLYPJP2EIv4Q7eEJwqPXgWkWSNj4kUIi/W2xJ++1fWsCebDBYVwNxBT7vC4lGZGuK8gDvfxHwnUGN33uy12n+24/VK2IIy5UR+1oguSkZsVTzMfi1H7QJhvDWmfeQzaV/0f8hx9+U74OdMvHCq06zaNj8OLvCpqzXAA2cmBz17yYAHz+999GOeZJ6tSwpcaz9amVc1VnvVB8Am8Kb4nKs1Gd12avS0yCFuVjb+PmsObTZSxB1M1F30hCVKePK/HUhTfNQ5c+udZAvvqcFIFOhLZ7JUuYYY3WPyRXR886xrVCw5jjh86fR6/fY3yVvVbMrJL34zwvxnl/0LCP5Sdk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199018)(8676002)(54906003)(110136005)(66476007)(7696005)(55016003)(966005)(478600001)(71200400001)(64756008)(316002)(2906002)(41300700001)(8936002)(4326008)(76116006)(66946007)(66446008)(52536014)(5660300002)(66556008)(86362001)(38100700002)(38070700005)(122000001)(33656002)(26005)(186003)(9686003)(83380400001)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jO62riMbdnWpoZp+b5aW5YN9XeUb5dA8P0YmNy2kMOFbtcgY78ektpQsp3QE?=
 =?us-ascii?Q?SePBYpG1ohANtEIZoEfArIdBJKHB9IC/plH9OGjqU4t191AN5s5yhzSRIWu9?=
 =?us-ascii?Q?efC+KwkuT6qiCX4LoKxafzYs4lzOKaWWBvw8QsQPHbuJUpuSc0CfeeNBGN9V?=
 =?us-ascii?Q?yoJ8IVGyDiEJAiauyl24xk9X/6CuCSpXy3ex/jVDYuDlHVluIAcyle+CTAHp?=
 =?us-ascii?Q?ASXIx+60wMNOC27ZafF3P/ZEU4VuMuDT84jdui55/eJfCjaXSzdRSZYQDKk5?=
 =?us-ascii?Q?ORNKCK6AshCyKTjm0btJnvW3pvUSUvlc7EnyuzYo+aE2xBiWuVF3YunlU5Ok?=
 =?us-ascii?Q?9sdzjwqRf+bTdFir1s+53Kqo0S+gBzbmbIFQDq7WYESQUZFpWFZ8s4ZCKMDl?=
 =?us-ascii?Q?83D0XUAtd6JgJWJV+fxmxQ59BGZLK7SW2j+q8+JpfJ43TRxvMn+Tqettg4n6?=
 =?us-ascii?Q?blV0fWwGpXdXRnQRxHm+YyqbepxmezBBlbnDFqrbHSQAl3Ku11APNBkCuBcB?=
 =?us-ascii?Q?435XfB4tAIgDQuWytEoTzboOFdkRVk9bbSrRz7tPehHDg12tTfRtFwaZPypK?=
 =?us-ascii?Q?7jGHxBbjMas31qKZD9C2G9R6EBFf6wksX2rta3s6+xmrGquYDlPRGRkvlXpH?=
 =?us-ascii?Q?raBtYRegxJDWuApmuEWiwM1Zu5Xd9digpG+9nqauUoLzdf1wLVZnGEYcWjvv?=
 =?us-ascii?Q?sTBNK3yErsKNiG2D7gQyUvDCsjYmiFLElQgLwCBML3k/VlQCEmQdNN4TDm6x?=
 =?us-ascii?Q?t0NN3sQqcasCgnN1SNV95KszrCvqD/AIm6TMK5mNDShvaiDwgAd6NMBE+aqB?=
 =?us-ascii?Q?bG3lxdfG7DY4i642cAY6epBbrsxEvKC62zNqycwxOAqbeMluSuITjW+7ytEd?=
 =?us-ascii?Q?IOSMMF49PUe6IiMqFH9MfLr7EhW1T6m5lXPSuXY14z2eGCuwTZyPlHbztGla?=
 =?us-ascii?Q?zFleSUNVUmoix8sYQrkUMzBwh8ttJTTWGQQl0HwXczW620aUBwvmQla4bmdQ?=
 =?us-ascii?Q?O+p5UXbQvTKQsy2fi6XAq3Lc3ZE+3WEKpzR8BBBj7JAtiPRe/kidgpwysffo?=
 =?us-ascii?Q?CMDF5GHyCxjfCEOhyWAOYMKsYyBXMKff8v5+47d9ZCw+iUNvq2udp/UP2Clj?=
 =?us-ascii?Q?T2FZFaba8zhH17cP3978NtL6aQ1EWHL20iHaQK2mcArxhrv1ZNNfbPMPFuSV?=
 =?us-ascii?Q?Ouj6beBITq+ohsN3d9OjAopRyktY60QGRWXB+AHJGl/natlT5YD5pD483gqJ?=
 =?us-ascii?Q?/eDKvquNOujory9PAKPiZExxtBGWCpmCfYSpb6Xwqno6H7+eW0PpVcqc03fO?=
 =?us-ascii?Q?Xv7V6AF1xtj3JuzZlndYI2DqcUmxiXJ8EEONIaj6qnUqVI6RnSHUr5gRfURY?=
 =?us-ascii?Q?sZejpq/uv5UoFdvI6KfsZwiRyrYka28OSbgkzJm8+zoi43sqpWEUkTNzkERS?=
 =?us-ascii?Q?RQ+50KVWGO12ye/9WTGCAgjmuXM9F0TJ8osL4bUA+qVslM7tivHw4WofgnDm?=
 =?us-ascii?Q?CuPANfOxpaQ/cvjHGe48ZjQG5UGuZrXkAJ8iCPtELXGjdTadaa8SdKnwwf9g?=
 =?us-ascii?Q?Q7JS1Yyp65xXiNwbSYLilpx2UW23WrfNQQSHkJY1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd75c4b6-e3d5-4e21-2b48-08db048a4fba
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 19:27:09.2031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z3dX106TH1KHDgUa6rid35HyxZTXScObj7R6/aW1VvZcrVUUus/fDg6ggmIjlAfHftc5ltEmR2PjbeqsgHJlZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: amd-gfx <amd-gfx-bounces@lists.freedesktop.org> On Behalf Of
> Daniel Kolesa
> Sent: Wednesday, February 1, 2023 1:46 PM
> To: linuxppc-dev@lists.ozlabs.org
> Cc: dan@danny.cz; stable@vger.kernel.org;
> tpearson@raptorengineering.com; amd-gfx@lists.freedesktop.org;
> alexdeucher@gmail.com; torvalds@linux-foundation.org
> Subject: [PATCH] drm/amdgpu: drop the long-double-128 powerpc
> check/hack
>=20
> Commit c653c591789b ("drm/amdgpu: Re-enable DCN for 64-bit powerpc")
> introduced this check as a workaround for the driver not building with
> toolchains that default to 64-bit long double.
>=20
> The reason things worked on 128-bit-long-double toolchains and not
> otherwise was however largely accidental. The real issue was that some fi=
les
> containing floating point code were compiled without -mhard-float, while
> others were compiled with -mhard-float.
>=20
> The PowerPC compilers tag object files that use long doubles with a speci=
al
> ABI tag in order to differentiate 64-bit long double, IBM long double and=
 IEEE
> 128-bit long double. When no long double is used in a source file, the fi=
le
> does not receive the ABI tag.
> Since only regular doubles are used in the AMDGPU source, there is no ABI
> tag on the soft-float object files with 128-bit-ldbl compilers, and there=
fore no
> error. With 64-bit long double, the double and long double types are equa=
l,
> and an ABI tag is introduced.
>=20
> Of course, this resulted in the real bug, which was mixing of hard and so=
ft
> float object files, getting hidden, which makes this check technically
> incorrect.
>=20
> Since then, work has been done to ensure that all float code is separatel=
y
> compiled. This was also necessary in order to enable
> AArch64 support in the display stack, as AArch64 does not have any soft-f=
loat
> ABI, and all code that does not explicitly conatain floats is compiled wi=
th -
> mgeneral-regs-only, which prevents float-using code from being compiled a=
t
> all. That means AArch64 support will from now on always safeguard against
> such cases happening ever again.
>=20
> In mainline, this work is now fully done, so this check is fully redundan=
t and
> does not do anything except preventing AMDGPU DC from being built on
> systems such as those using musl libc. The last piece of work to enable t=
his
> was commit c92b7fe0d92a
> ("drm/amd/display: move remaining FPU code to dml folder") and this has
> since been backported to 6.1 stable (in 6.1.7).
>=20
> Relevant issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2288
>=20
> Signed-off-by: Daniel Kolesa <daniel@octaforge.org>

Acked-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  arch/powerpc/Kconfig                | 4 ----
>  drivers/gpu/drm/amd/display/Kconfig | 2 +-
>  2 files changed, 1 insertion(+), 5 deletions(-)
>=20
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig index
> b8c4ac56b..267805072 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -289,10 +289,6 @@ config PPC
>  	# Please keep this list sorted alphabetically.
>  	#
>=20
> -config PPC_LONG_DOUBLE_128
> -	depends on PPC64 && ALTIVEC
> -	def_bool $(success,test "$(shell,echo __LONG_DOUBLE_128__ |
> $(CC) -E -P -)" =3D 1)
> -
>  config PPC_BARRIER_NOSPEC
>  	bool
>  	default y
> diff --git a/drivers/gpu/drm/amd/display/Kconfig
> b/drivers/gpu/drm/amd/display/Kconfig
> index 2efe93f74..94645b6ef 100644
> --- a/drivers/gpu/drm/amd/display/Kconfig
> +++ b/drivers/gpu/drm/amd/display/Kconfig
> @@ -8,7 +8,7 @@ config DRM_AMD_DC
>  	depends on BROKEN || !CC_IS_CLANG || X86_64 || SPARC64 ||
> ARM64
>  	select SND_HDA_COMPONENT if SND_HDA_CORE
>  	# !CC_IS_CLANG:
> https://github.com/ClangBuiltLinux/linux/issues/1752
> -	select DRM_AMD_DC_DCN if (X86 || PPC_LONG_DOUBLE_128 ||
> (ARM64 && KERNEL_MODE_NEON && !CC_IS_CLANG))
> +	select DRM_AMD_DC_DCN if (X86 || PPC64 || (ARM64 &&
> KERNEL_MODE_NEON
> +&& !CC_IS_CLANG))
>  	help
>  	  Choose this option if you want to use the new display engine
>  	  support for AMDGPU. This adds required support for Vega and
> --
> 2.34.1
