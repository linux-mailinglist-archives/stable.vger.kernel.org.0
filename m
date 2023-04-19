Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDE96E7A6F
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjDSNQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 09:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjDSNQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 09:16:44 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6F513FA3
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 06:16:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzE65be9Nm7xn6I13qP1918RCklpoBWeq10arMcQXGxC5wOK0nm3DiPeuigZlN4la6zugckzek+VQ9koc8zja0++UK8Yfu1XUAaMGVKje5DFO4hryTyTDrsFqI1NZ5G8/2M8kc0BwcFYKyMz2cd5WugYr7x+gJIOJAHtKBGcBiGrdAm9Bhk7iOIbB2oP0eBlnzyo779I9771OQuXGqONzw+RxGpfru540gvcGeRoOzAf5omZ9izsHVqcY6iXY/vjOSYewJmxGww9GE0ypNx3graNcb+TXdb9Op+XevFbZlXJo2hg0dtayNIn1gnqfv5/4YX4ZhTg5Besj6r9lmu6EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ko8C7qSp8ETG6z4yxn8uRZn/a9pM3tfH+dZx1mIN+TQ=;
 b=W6CcH8keGXPuWQ+tQwYd81L4WLRW1b60NUyLf0WDnmpdi+Stcr7uv2nRrbC4uvg7bQaXNQlS2KCw1eHOtvZqvqUW4b4NpT8I4TbKymSO7422K9w6CUpJ/PLDt4QaBpbDPFH9ybfi2qUnse8HdK2lUISjtaOs9tmy2wlKV20z/rYGkxaJiDhEmpLCeg/wyLSJJriot4sNJqP8kKbbQXIB4LD/feOu+Sm8W2pQOcMRKlJ98BL4bOPESB4lbIiBdPkD0WOUo/a93Fgw5O6lT46C4cQhRFXdyWTAdZKYTGCEdscoJWLwayWZQlQXsw4G27Db7W8m0kyVeO6oL66wY9b2Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ko8C7qSp8ETG6z4yxn8uRZn/a9pM3tfH+dZx1mIN+TQ=;
 b=3g8l4FB8wGeIYdf+Fj4619kA1fazHiqgEXzD9Tp+xAz3yqtzwCXvKPKgsx3R4F8Bbb35Qe+C13OdEndPlk01OR+JCCuwlpazVc6vZQysyJkWXfclOVG40vQWdtdv1pRD9hFsmCVzpbCEnxaRbbxuk42lKBg8vChrbMROZnRBHq4=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM4PR12MB6087.namprd12.prod.outlook.com (2603:10b6:8:b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 13:16:39 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::34de:5470:103b:594b]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::34de:5470:103b:594b%7]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 13:16:39 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zhu, James" <James.Zhu@amd.com>, "Liu, Leo" <Leo.Liu@amd.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>
Subject: RE: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
Thread-Topic: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
Thread-Index: AQHZckNXQR5Q3QWOVUGW9PDmA1R9Ja8ym8+g
Date:   Wed, 19 Apr 2023 13:16:39 +0000
Message-ID: <BL1PR12MB514405B37FC8691CB24F9DADF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20230418221522.1287942-1-gpiccoli@igalia.com>
In-Reply-To: <20230418221522.1287942-1-gpiccoli@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-19T13:16:37Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=d489ffbb-5e02-4d36-9816-56854f19f606;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-04-19T13:16:37Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 432fa6e0-1745-4647-8826-35ac2aa7eaac
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|DM4PR12MB6087:EE_
x-ms-office365-filtering-correlation-id: 844bbece-2c2a-4538-2529-08db40d84f62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YggIhRihgViGql+1iYJX6NgR+nhLxtSocCZRHma2gF899U4n2B1z72lGFPF3wnXIPRd2CQIYOs8Oy+hAXFyh8oVMFP9nSF+xe0CXteY6CPa92V2zWkokRsDOjB4WmoOlh547u4lLIGZEdYyOOgy2mV4nJww1gUZ0/fkGoVjvCWlP56FbM3AeABKaC3uKDP0LXLoLMIapXAOHAjyE338wcbPpXO7/3JrihAFI/4+WMP9XtfdwN0JYLvMSSxRuOVY2t//8A0ZqubtviB1HrAtt2TqFvPObIP/pRhwtVADTkMnt3m5LHESj0aPQdaksfx3TlsdBBbr2e8Y47+O7onAhmeSRE0secgUMdoRp3oL8vYo3yqdWpklmByKIZv2zCbva7n7EYaTKsEbYhZsGYC6RZAGThUF1i95lLj4jDNBJNofTbWdxsmm34sFMpeD9WOOTVPKA1qkdHCYis4TV4oboAQCNJOSSFmspjE95gWEfaZHCgLOP7teqd41GfplzMyXt0eZ5OdDS55iMOU5U/maBOr2baSQoxiVF5UEuGnR98TimncoKoiMFZPVe7FThX3uG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199021)(122000001)(2906002)(38070700005)(33656002)(55016003)(966005)(478600001)(71200400001)(7696005)(38100700002)(83380400001)(26005)(6506007)(53546011)(9686003)(186003)(86362001)(41300700001)(5660300002)(316002)(8936002)(8676002)(52536014)(110136005)(54906003)(66946007)(66446008)(66476007)(64756008)(4326008)(66556008)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ii4UapCbGZajgTMtDA0vMzch3NiI2eapHWuIb9NYYkuZaLuDMLjI870we/a8?=
 =?us-ascii?Q?6uikuZnd0EhRt6WuBjI3u7WPr+zrcCJEjYeHuxRkZzkEfmBycCqe5aXaCjAQ?=
 =?us-ascii?Q?u8jzESSSsQ8OJHd+UWEgIzgWwTHJ2ncy7Lw3zJXBcDJuCyo8jNoAxVsI2jho?=
 =?us-ascii?Q?/rOZc7k15QSyXd4NxoRgh1PodWO4C/UbA2SWylNFxJgyDUCmrkVplwEdQh3j?=
 =?us-ascii?Q?ULk917EppoWJddO3bGYJHbD1a76veJy+LfmcC5y0SlGYXl/gGGduEJ1wBMP7?=
 =?us-ascii?Q?sunl/9eVN3XDuQTSOOXq2CONssFg/o5X3oaruHKg5oknnMk3rPUBBzK63Oxp?=
 =?us-ascii?Q?ZJvRzdnSB9Zf6bukiT+KjwjI4hK/S/Z/n+FwFwE2WFVJwvuwKU6hWUFK024y?=
 =?us-ascii?Q?jnBcaeokz5U6AujiCYEPOFRFpsB/Qr6wnW5OjNw8b0RNGGjyfPN3wyOcQIMt?=
 =?us-ascii?Q?dhaOu9A4oN5gQs/fFdz2+xYMAk/47LHy0GG8xL0RrPqOTn3EO8FRkKLCdBVp?=
 =?us-ascii?Q?CxTJ7l6Waa9ERiX5rV7yOvEdA57MpjoacYRMph/9wSLYQ3hIrFsUbn8D5pGu?=
 =?us-ascii?Q?gXkrsjcLIsWUBgbKtA76sZrBz8pxWJl8Pr0ZAErDhizqyMiJNwz95klNM2qq?=
 =?us-ascii?Q?hEWzhYasrrQScmF7euGCBSo4J4yCkTaGZSupofxjycAdwm6l0NHDNEoISXNG?=
 =?us-ascii?Q?q/A1XTsAW81FAHSwuF9QxsLkF0K0Uxb6crvcmSmJmtfxcRPsU1u37uCB5TGQ?=
 =?us-ascii?Q?Mqsll6s9RH1/LS6qQ+62RY9RxP5i8wE3vNvZwIsoQtff6xNYHaspKcvbAb+S?=
 =?us-ascii?Q?RsGE4clBy6r2eJj2lDOOUUCyJFf43RjPsCLn8i/951F/fHIeoAcd+fNXw36L?=
 =?us-ascii?Q?DvAto9VnTxwkVGby0sI1oa/xa5zy4035FOwqlgmXPaXA0W2ckLwTTW2OcaZ+?=
 =?us-ascii?Q?eUCf7330nTf1bZPCishlFf8CY3ZOMrmlO+79Qx6I9ypi+yq9kufgfHICW2bB?=
 =?us-ascii?Q?qB3LtYUi+z1Fu6/7/xz2DymayeMRcQkC8qzEwPWbrV/UNPaDfBDIV9c9isIq?=
 =?us-ascii?Q?m+fx0EnhSM2TdyGGQtuD6yl4v6aWQtTKbWipKMLxsv4tkC1H8uDfwad5RFMI?=
 =?us-ascii?Q?Y3QuJ57W2FglwI3f+boUp0B7kfbQCn/jN0ykBhf5fKrA4C4/Nx575guH1tPz?=
 =?us-ascii?Q?S52dhD2U40hxpQw+fEOKFj0cnEdQgUDwy58iOfMBybUZjzHHM3KzDiAylJZ3?=
 =?us-ascii?Q?eteVxFFJwDJQz3yYvgw8RvtbkrHSgQeSPfu/JmY+mexpRtslDMzTQW6ObEeC?=
 =?us-ascii?Q?mLdxpOKOAcpENGuyXMUnNOB+wtxF+fVEDAGFkfkPIakQ+T6svInkRDLu67a0?=
 =?us-ascii?Q?/Xbhl5xnELYWTRThu1AXcgClP7/p/ZPX24YGZVE7Fz9khXwmLARz3qKAXCko?=
 =?us-ascii?Q?sL9D+97p8FYKsMXpOxlhqldqtoXh/GXlbSbk1HGMqgkU81zNkTO4/dGgAShA?=
 =?us-ascii?Q?WgrAOoprpbaXcL5NYFzRJf4bYJYWyS8OExAc/MMVF6DlyZ+OeMedV4bdtzz9?=
 =?us-ascii?Q?yxzKMCrrzpbuBiZkbgQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 844bbece-2c2a-4538-2529-08db40d84f62
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 13:16:39.1825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 06W4NBpN2tEZm0RWuZzSt2k4qNqjIopyRzL1s3bItRTi23dfMC3LEcLYGSVbt+QEkE82VgtGqk6z/92PsB/ikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6087
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Guilherme G. Piccoli <gpiccoli@igalia.com>
> Sent: Tuesday, April 18, 2023 6:15 PM
> To: stable@vger.kernel.org
> Cc: gregkh@linuxfoundation.org; sashal@kernel.org; amd-
> gfx@lists.freedesktop.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Zhu, James <James.Zhu@amd.com>; Liu,
> Leo <Leo.Liu@amd.com>; kernel@gpiccoli.net; kernel-dev@igalia.com
> Subject: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
> broken BIOSes
>=20
> commit 542a56e8eb4467ae654eefab31ff194569db39cd upstream.
>=20
> The VCN firmware loading path enables the indirect SRAM mode if it's
> advertised as supported. We might have some cases of FW issues that
> prevents this mode to working properly though, ending-up in a failed prob=
e.
> An example below, observed in the Steam Deck:
>=20
> [...]
> [drm] failed to load ucode VCN0_RAM(0x3A) [drm] psp gfx command
> LOAD_IP_FW(0x6) failed and response status is (0xFFFF0000) amdgpu
> 0000:04:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring
> vcn_dec_0 test failed (-110) [drm:amdgpu_device_init.cold [amdgpu]]
> *ERROR* hw_init of IP block <vcn_v3_0> failed -110 amdgpu 0000:04:00.0:
> amdgpu: amdgpu_device_ip_init failed amdgpu 0000:04:00.0: amdgpu: Fatal
> error during GPU init [...]
>=20
> Disabling the VCN block circumvents this, but it's a very invasive workar=
ound
> that turns off the entire feature. So, let's add a quirk on VCN loading t=
hat
> checks for known problematic BIOSes on Vangogh, so we can proactively
> disable the indirect SRAM mode and allow the HW proper probe and VCN IP
> block to work fine.
>=20
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2385
> Fixes: 82132ecc5432 ("drm/amdgpu: enable Vangogh VCN indirect sram
> mode")
> Fixes: 9a8cc8cabc1e ("drm/amdgpu: enable Vangogh VCN indirect sram
> mode")
> Cc: stable@vger.kernel.org
> Cc: James Zhu <James.Zhu@amd.com>
> Cc: Leo Liu <leo.liu@amd.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> ---
>=20
> Hi folks, this was build/boot tested on Deck. I've also adjusted the cont=
ext,
> function was reworked on 6.2.
>=20
> But what a surprise was for me not see this fix already in 6.1.y, since I=
've
> CCed stable, and the reason for that is really peculiar:
>=20
>=20
> $ git log -1 --pretty=3D"%an <%ae>: %s" 82132ecc5432 Leo Liu
> <leo.liu@amd.com>: drm/amdgpu: enable Vangogh VCN indirect sram mode
>=20
> $ git describe --contains 82132ecc5432
> v6.2-rc1~124^2~1^2~13
>=20
>=20
> $ git log -1 --pretty=3D"%an <%ae>: %s" 9a8cc8cabc1e Leo Liu
> <leo.liu@amd.com>: drm/amdgpu: enable Vangogh VCN indirect sram mode
>=20
> $ git describe --contains 9a8cc8cabc1e
> v6.1-rc8~16^2^2
>=20
>=20
> This is quite strange for me, we have 2 commit hashes pointing to the
> *same* commit, and each one is present..in a different release !!?!
> Since I've marked this patch as fixing 82132ecc5432 originally, 6.1.y sta=
ble
> misses it, since it only contains 9a8cc8cabc1e (which is the same patch!)=
.
>=20
> Alex, do you have an idea why sometimes commits from the AMD tree
> appear duplicate in mainline? Specially in different releases, this could=
 cause
> some confusion I guess.

This is pretty common in the drm.  The problem is there is not a good way t=
o get bug fixes into both -next and -fixes without constant back merges.  S=
o the patches end up in -next and if they are important for stable, they go=
 to -fixes too.  We don't want -next to be broken, but we can't wait until =
the next kernel cycle to get the bug fixes into the current kernel and stab=
le.  I don't know of a good way to make this smoother.

Alex


>=20
> Thanks in advance,
>=20
>=20
> Guilherme
>=20
>=20
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
> b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
> index ce64ca1c6e66..5c1193dd7d88 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
> @@ -26,6 +26,7 @@
>=20
>  #include <linux/firmware.h>
>  #include <linux/module.h>
> +#include <linux/dmi.h>
>  #include <linux/pci.h>
>  #include <linux/debugfs.h>
>  #include <drm/drm_drv.h>
> @@ -84,6 +85,7 @@ int amdgpu_vcn_sw_init(struct amdgpu_device *adev)
> {
>  	unsigned long bo_size;
>  	const char *fw_name;
> +	const char *bios_ver;
>  	const struct common_firmware_header *hdr;
>  	unsigned char fw_check;
>  	unsigned int fw_shared_size, log_offset; @@ -159,6 +161,21 @@ int
> amdgpu_vcn_sw_init(struct amdgpu_device *adev)
>  		if ((adev->firmware.load_type =3D=3D AMDGPU_FW_LOAD_PSP)
> &&
>  		    (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG))
>  			adev->vcn.indirect_sram =3D true;
> +		/*
> +		 * Some Steam Deck's BIOS versions are incompatible with
> the
> +		 * indirect SRAM mode, leading to amdgpu being unable to
> get
> +		 * properly probed (and even potentially crashing the
> kernel).
> +		 * Hence, check for these versions here - notice this is
> +		 * restricted to Vangogh (Deck's APU).
> +		 */
> +		bios_ver =3D dmi_get_system_info(DMI_BIOS_VERSION);
> +
> +		if (bios_ver && (!strncmp("F7A0113", bios_ver, 7) ||
> +		     !strncmp("F7A0114", bios_ver, 7))) {
> +			adev->vcn.indirect_sram =3D false;
> +			dev_info(adev->dev,
> +				"Steam Deck quirk: indirect SRAM disabled on
> BIOS %s\n", bios_ver);
> +		}
>  		break;
>  	case IP_VERSION(3, 0, 16):
>  		fw_name =3D FIRMWARE_DIMGREY_CAVEFISH;
> --
> 2.40.0
