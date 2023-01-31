Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5756468317E
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjAaP1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbjAaP1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:27:40 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2083.outbound.protection.outlook.com [40.107.212.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144E310FA;
        Tue, 31 Jan 2023 07:27:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h48aHeVC67AcDYveTDywqpMcI3ZxQfvhQDD45gmQpY/TvOQ8e9cEbRVPs+Qc7012SdaiKXhwft7bFTqQd5HudUDr2rnWGliKUi1RXFEM66ad047vlm1Xav+SrqydUWeaLpUO0+9wfRPygpqs1n58CHC7epOdf/UYbmMED0BYL/YMxpxDlTURVXjQLEIKjYl3hejlNJLiStQjeD8YnCECwt95nu/WZjbiIlB+NTGtonMWJpwevdRvYRZayrAmh2xuLAuTTt0H8lxWEYcY7iMRGDqttUNUoq1TG1dSdFHckvzWH1B5wRtdctYUs+JB6DevDyGErlcBS78vNShk9xKCCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+fTJqB3xp4cXoMeJx9VahUh86m+8ysfkRJsivdk4lM=;
 b=PXfVwFqyye8W4o78h3uVp69ESHO+2PygSARe5SALMBp11euNIjynIUNBXqYVITTYZd7fpUW8AStbjKJtoh2swg5K6UAU7IEtUYL0OxeKa4NftZ0rkDoyT54fL6OQyTHiv0tG3mqeVVICrReT0g0ly/4rc/KEkPsOrzqUG2Xhq+T2UWR7fqN54lJwy7FcpI3mDlEFi0Ys7DDS3rQjjdEBpBl3RudfxkdzGNAFuuHNVosI/siXAo1d6V2fPr05boa7ATWVXSfrtCssMKy6afFQZ91OeqZjqvlIMRPNpMHAbA5fOyXyvPtrLd33WaOTOSxVP4HbJJj2p2vwFgr+NJS/Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+fTJqB3xp4cXoMeJx9VahUh86m+8ysfkRJsivdk4lM=;
 b=VNs6Tp2PwQXlTE2YYF01Zd4/W388BokmQvYBq0/nROSTVoyiojVhlbQ0KZ72NGL8cOQuFcPt4EqqeTQSPtOf3ozkqua3ZTR0TgodNdDxcgMt3ZxsCj3+xW6lnQa+1jo0H3grQLQjH9qZWx7+6kKTLTISln1v+J+41qZrnxE3Dm4=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by PH7PR12MB5733.namprd12.prod.outlook.com (2603:10b6:510:1e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 15:27:34 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::5cbd:2c52:1e96:dd41]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::5cbd:2c52:1e96:dd41%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 15:27:34 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Dave Airlie <airlied@redhat.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        "airlied@gmail.com" <airlied@gmail.com>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "Li, Roman" <Roman.Li@amd.com>,
        "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: RE: [PATCH AUTOSEL 6.1 20/20] amdgpu: fix build on non-DCN platforms.
Thread-Topic: [PATCH AUTOSEL 6.1 20/20] amdgpu: fix build on non-DCN
 platforms.
Thread-Index: AQHZNYTGI/3Z9L7IvESKLAO1TzX65q64pU/w
Date:   Tue, 31 Jan 2023 15:27:34 +0000
Message-ID: <BL1PR12MB51446A7B671814A565749C45F7D09@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20230131145946.1249850-1-sashal@kernel.org>
 <20230131145946.1249850-20-sashal@kernel.org>
In-Reply-To: <20230131145946.1249850-20-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-01-31T15:27:29Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=d0d7540c-8beb-49f4-be25-7d3ebe266c1b;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2023-01-31T15:27:29Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: d016dbf0-f368-4f92-b5b2-bbdb091fa5f1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|PH7PR12MB5733:EE_
x-ms-office365-filtering-correlation-id: 20cf6edb-a9c5-442c-26af-08db039fad6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8hsCDWQBq7gkIS/CAmT7/2GudK7F4SD6rSseAqlHleIcs0IRnS7fIkGMnaEORXX96s33GEWSBLuq0OGGIhytHS2fasBi36JVqVwuWKW0zcaqCzQ5pst2M/SQ8JNdhP5CkuetSC1N8AArp5iONc1RkezPu43RaujYzB4P44gfRT8T4sBEqvwvgIzDqk6FknhiGVqDAvAvycCfRu6HktrUGvzXokp4NH2WBrgeLRRSRvoKZc7U2KiNm/pZS5Qjugj79Lli42vNOCcVobKban4TgEJIpLnMa8hVfQh+g7tJ8uu20pfOFWoCBLb+77veiu2E8/97CdGR8lto4rwpW2/1nmt7+Iq/GN2bIDPHPjD7Uxq6EwTs2C+WYYjO4pWh+RmHzRU5ba6xSs/OgfDOe+d+XGTIJ7Fjy3uulWrV7J9M/tRM9SilLa+P+LeEWuyIxHftjwVgDxWD4lS9DrEf9R2YvVHJqzOd1b8UYGrtfm4u5UgaaJDEU6u1QFwHsXdahmTTqQgTKZtf9Vd2WHYa7SnXfAvHUYHW46MK9d8SljUdSakmF09Y7ZvyjEuZJCMFj2cTYcLn6/rVPIz7O86LDAbapKXP61jAGZ/NQVcjLLqQqvVBs4fPRi5D8MRUU6RU2v+27coAM00yPiDtGtTssLjCIISA6VxWCIKeMs6hFfdVin/KZ5KqT3JErTdTfJnF6SgoqrHKSwCoQ0HsT3xvvIV2Tw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199018)(86362001)(38070700005)(33656002)(38100700002)(122000001)(41300700001)(8936002)(5660300002)(52536014)(316002)(110136005)(54906003)(66556008)(66946007)(66446008)(64756008)(66476007)(4326008)(76116006)(8676002)(55016003)(2906002)(83380400001)(7696005)(478600001)(186003)(53546011)(26005)(9686003)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jQGoL54AOfnuta7WXK2J3qLVre+rlCJVz/pxMtN9W7AYeynH7UuY94j/jddO?=
 =?us-ascii?Q?jHZcp3yyJSNjnIJi/Nro9Xv4FuG2dzRkiZlO2k3aksK/eCBoYrbeoB267y5l?=
 =?us-ascii?Q?W+WFl7BG3fgD9uepjdr+5TOmmkJDp5AB/tww4juIrL3MdtGXqRNVEMtRScte?=
 =?us-ascii?Q?WpHDHWCmpeBtPIP2btpDmc9SFaDLa+tPRaVxbHxneeF7pJSILoF3ivWO9iUr?=
 =?us-ascii?Q?Uszpeg5haUEzQ92BSG7eN5iVRo+VW4FrWvlP8wYX3SjgPa8V+LpkqbkAX+yn?=
 =?us-ascii?Q?IhXczUnKZi047NFTOJRzrsGrPMuqLjdYZRfPFd3MKmb2s+s/gRr0nPHhpAsM?=
 =?us-ascii?Q?oJdOweVX5KNdOi5+NDEocWn88tfTCwnoVb9JFCBK63cFZlLmpwLqYDE1eiOt?=
 =?us-ascii?Q?Zg3gq+RxfcZ5SV3kiLy3F1xBN2EnYvuzRgGP/ybijXCyyqo+lwHqRnOQ5qFw?=
 =?us-ascii?Q?rgsFGOFVlYlJNnbxkK1UJOMNTOcmL+E+1iP5oYal0+5kXVMcBqwuT1g/o6hj?=
 =?us-ascii?Q?eLqZJhJHgbpCbVm5nUfuAsDkDPl9CMxk6BGntB3J8ALORPYkNKcKqJFsUxbU?=
 =?us-ascii?Q?6teley2iO8DAj3bZQSo3ihtgCoUDjdn6vTYhEA0Xjyn4fEK1/1OX3B4kDyhx?=
 =?us-ascii?Q?c24vSIPnsQ8Scud/QVEkJTEiP8a0IxUsyxj9wKEySQEdUFOVnRe44YeVKf8t?=
 =?us-ascii?Q?FVvqfMgeWaR+15LwnGgReTeCnv/1PR4QYon8KrwkAXPZKGtNjY1yi+2+nllA?=
 =?us-ascii?Q?kTJv52+GLrnOhl3KKtPaD75JDDvcsZxIWigPw8le8a9weycNLRdsKr28Arss?=
 =?us-ascii?Q?B6IvEUYkGvn8C4ySa0pnkq1appdweUQVIdiQbq/XgOeO7EHoFIfv3fu03lJZ?=
 =?us-ascii?Q?5QeSisSECkO7aUMCsoTAdrggFqh/03SJR2NHPRxQGu4+cY4PWaDGBbqkAqye?=
 =?us-ascii?Q?jLT8o9Vbya75TGlMXop0AgMnx6A9eAUNJnoSA/5P4gCHVSCfr7Lnua8oZrS8?=
 =?us-ascii?Q?thYvUYYj1LGhtorss8YAV4VeiUSlF6/vUqTX2p9+rOSgwca+pTdahuqPOWQ3?=
 =?us-ascii?Q?b2DGoAA3PVupvgoQ1+6+NmMnMzUKV4ezf0f3MxsnTsVKra/ufHycJl3jEdbh?=
 =?us-ascii?Q?9heiPMyWTlF4dhXFj0BGnvENs+LvgJd1Mwwkw2xr8Mgidg82MQIXijAirqls?=
 =?us-ascii?Q?khD+IB+Q2zpvq0gZJIEDD0vw2qYXMZzUufPb/B2ns97XA2CRTMcB64tVnusM?=
 =?us-ascii?Q?3qMoY8g/uh7SqvSXef9aC9fRBJSdAXGnea1LdkwQmSa3iewKBxeX+ibIOiHJ?=
 =?us-ascii?Q?sN2yzZT+DQgYEvHKz1gga7f/qi89riYgPnVcrw+s/n8wj33qLXkClOxQDSz5?=
 =?us-ascii?Q?fK5A0n+D9sg7rLAoQ8u5O0BWnSMo8uuX94JNs29BwmGV0Hev6pHpjMZlqK/3?=
 =?us-ascii?Q?HrpUZgNVAx52y+0Tq2eRaLFGO5TuAsSgclLuPNvqfyPQWChUxnrNIM4j530T?=
 =?us-ascii?Q?+APUOdKAQX7l00ODIFA8vGz1KiHIyqZqMU8fZSwCjf0V1hrff7txL55c3Xw2?=
 =?us-ascii?Q?YghgTbKaErtmpypI3AouxY3/7J+CgIKXhc5f+lQ6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20cf6edb-a9c5-442c-26af-08db039fad6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 15:27:34.7261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PXMkdMOHz2bG/14KOngAo/sJLwYcjFuLb+aAtmPgYWUWfN/372F7MCBZQr1yqSOB1lW9h8YxZpLaiqt3RPmK1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5733
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - General]

> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Tuesday, January 31, 2023 10:00 AM
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Dave Airlie <airlied@redhat.com>; Sasha Levin <sashal@kernel.org>;
> Wentland, Harry <Harry.Wentland@amd.com>; Li, Sun peng (Leo)
> <Sunpeng.Li@amd.com>; Siqueira, Rodrigo <Rodrigo.Siqueira@amd.com>;
> Deucher, Alexander <Alexander.Deucher@amd.com>; Koenig, Christian
> <Christian.Koenig@amd.com>; Pan, Xinhui <Xinhui.Pan@amd.com>;
> airlied@gmail.com; daniel@ffwll.ch; Li, Roman <Roman.Li@amd.com>;
> Wang, Chao-kai (Stylon) <Stylon.Wang@amd.com>; Pillai, Aurabindo
> <Aurabindo.Pillai@amd.com>; Zuo, Jerry <Jerry.Zuo@amd.com>; amd-
> gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org
> Subject: [PATCH AUTOSEL 6.1 20/20] amdgpu: fix build on non-DCN
> platforms.
>=20
> From: Dave Airlie <airlied@redhat.com>
>=20
> [ Upstream commit f439a959dcfb6b39d6fd4b85ca1110a1d1de1587 ]
>=20
> This fixes the build here locally on my 32-bit arm build.
>=20
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch is only applicable to kernel 6.1.x and newer.

Alex

> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 15b408e3a705..d756a606b5e2 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -9411,6 +9411,8 @@ static int amdgpu_dm_atomic_check(struct
> drm_device *dev,
>  	bool lock_and_validation_needed =3D false;
>  	struct dm_crtc_state *dm_old_crtc_state, *dm_new_crtc_state;  #if
> defined(CONFIG_DRM_AMD_DC_DCN)
> +	struct drm_dp_mst_topology_mgr *mgr;
> +	struct drm_dp_mst_topology_state *mst_state;
>  	struct dsc_mst_fairness_vars vars[MAX_PIPES];  #endif
>=20
> --
> 2.39.0
