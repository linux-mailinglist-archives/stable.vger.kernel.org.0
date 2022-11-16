Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F114462B268
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 05:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiKPEkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 23:40:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiKPEkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 23:40:05 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AE631204;
        Tue, 15 Nov 2022 20:40:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E83PQE5e1KLWvWU623WMPkbdky6OQ62oN70KRWoGuC2gt2BCTT0QdM8juSmbq1GaCOEWHieDo7b/N3WoMrfF6/a9tuhdClrark0b6FJBtvkIa3PulZxZp3SzF8hdURUNECwiUD8Tu/9ap+5aCX1l0edBLCQF+91mSV1fuvHNxQypxEg7Ta48D284P5a8O3N7zRNZ58gMsrkQhqhenBz+iAqVUX1NfUv/TjlErhL8amGSNVhogFDx5dc37YRtJwGyA5WjeWK63Z/YQPbnnJy/0MH6CYOU21FsR+V4OY2u8wv37TYcp6OOEST4VDXcuUlHvaa4H9n1sjLybxqLGgAI3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9V2riYdfJNNuFuM6xSBl1BDyk6DblgtlHNGG/s56qM=;
 b=b9LfBTBB9R2k9t099TPfjeMpxTTYcioldoflsx425Ky/i4Xq+EhslWs+5zYqgRoKNowHTNBPnFtDIQxnOqqrqBtyVdY4b+wjtfhD9LDQDz8jPmAk53P079XKELpad8eVyjBmyM0sgnPt2/Q1+PECi59jhSCiTBflyjCA7Y26neolXdaC/lW1DAMxbs3Gocj9d9J3aqUiBWVQogX1fWcGDgHDb7Cd37geis/wNHGw/AbmVi276JCTVSK4dRhCTGZbx5pxYNTEog/TXTyPq3GVX9c7vm2f0BfFu2ZKtT2KPPfs/qUDA3shmf/wZWPL9/Z7bHf6Knbp85D0dtA25IWFEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9V2riYdfJNNuFuM6xSBl1BDyk6DblgtlHNGG/s56qM=;
 b=riSRb3Tiow1Zl5ZhiDP81w2fpMM/h4vwChEK6oBrMiT8XPrer7d7/lBAjp/kUiAUU30d4HSqxzbXzbADZEGmVfwkxfsYXm/kTxKAAuYbdyfK6Mr9PpLwlwVVrxJdVtssRldFBp0CsC6+mHKfbcfjIgiTTTnSAPcVhnj4kzLRboo=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by CY5PR12MB6252.namprd12.prod.outlook.com (2603:10b6:930:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 04:39:57 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::2509:5f0c:f0f4:882d]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::2509:5f0c:f0f4:882d%3]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 04:39:57 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     Lyude Paul <lyude@redhat.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "Wentland, Harry" <Harry.Wentland@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        "Li, Roman" <Roman.Li@amd.com>, "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Wu, Hersen" <hersenxs.wu@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "Mahfooz, Hamza" <Hamza.Mahfooz@amd.com>,
        "Hung, Alex" <Alex.Hung@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        "Liu, Wenjing" <Wenjing.Liu@amd.com>,
        "Francis, David" <David.Francis@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/4] drm/amdgpu/mst: Stop ignoring error codes and
 deadlocking
Thread-Topic: [PATCH v2 1/4] drm/amdgpu/mst: Stop ignoring error codes and
 deadlocking
Thread-Index: AQHY+HcT2dT0uSQ3+UaZejS/vjAtwq5A+SQg
Date:   Wed, 16 Nov 2022 04:39:57 +0000
Message-ID: <CO6PR12MB548932515652B8D3130C66DEFC079@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20221114221754.385090-1-lyude@redhat.com>
 <20221114221754.385090-2-lyude@redhat.com>
In-Reply-To: <20221114221754.385090-2-lyude@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-11-16T04:39:44Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=f9a793f6-7271-48af-813a-188558cba7c3;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR12MB5489:EE_|CY5PR12MB6252:EE_
x-ms-office365-filtering-correlation-id: d5aa038f-4211-4998-6193-08dac78c9d6a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8nqRrdAH6a2qa+pxcdP3pGiYdhic49tK1epmKXfUETexxNNMaF8A52J0QPUZwb6lczAXH1F1kOGebynZygNQecwPsYu7eeNohU1q/GyJ10vCNIQaBvJFCN168zPNBNkaHHDjpoLJR38EOAKtceXqBtAwfGCRbtowqbieZWD/Ib0ZV4dx4WUsRW4zWKPdhD6Jy6I7gO+kMEup5JinXSaGoxt+imH0SG0aSPHDBRmUcAc+nyGvtFocdey1g6aoLgoSfYMF1xUEPPUYmYlWeq52ESGtXlm7X0PwFtFadqHOXhwHxBYMlnrThO0zp2UnTjkslR4Axc2IQU8aeLcqRlgqHP0dKC28yJ+dAs+bdvtxaJLKPI+FellLDN8VxOrNGIwpiMFG1I5wT8lWgSG6J0kRaYP8pSeC4Yom3BFyK0CUkyrlHtyyEqYoO3cyEhIrq93EhSI0bCEAx4wEXO2ik6tb36PC19X1+CrivYfqZxzM6Fs3uN7+SYN42CrwZrRfTn/xSX8tZeNL7Bu1Nj3zIdt032IE7Cjw+ibJ9819ijtYy6afoReGzr0C12/9Sh+yH2IE+1OGi88Xm8BMBGIGquO+gG0pzboWfLEa2mEmUfaqMObHqaCM2tEIhZwZQJMAcjWvZJSq3yP8vZGAF5XVRzxB1XHxceMQqgAlJgoJeOo5hiovXo4obqiPXpcEt4koP3yroaMW8vikn2NstjAokaoXMFFyDI6aLue/m/5xxIWuqp6L9Zh9wQCXa+z3NyWwxHopBFJhUOHOleNpwAa2bg8y702UgPrRdUiPoI+puCp8Los=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199015)(71200400001)(86362001)(26005)(53546011)(7696005)(6506007)(9686003)(316002)(110136005)(54906003)(38070700005)(33656002)(38100700002)(83380400001)(55016003)(66946007)(8676002)(76116006)(66556008)(66476007)(66446008)(64756008)(30864003)(5660300002)(52536014)(122000001)(8936002)(478600001)(2906002)(41300700001)(186003)(4326008)(11716005)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1HbBvnMpn86Kt/Vy9oZMHMXe9I+1rJ72TgWZBLx/DproGgidHKy7K/ctziLL?=
 =?us-ascii?Q?En3Eu6oDdTe1Zsmg4L66dg2ApKBckoxaWe3GFjS25+e7RIbhFQHxgxoktJAT?=
 =?us-ascii?Q?vFeEt/mCYC52sEU6WCtXOmRoNQM2jcXcaMBSCGOC0UvxjSnSPO2cleZUgecZ?=
 =?us-ascii?Q?MmPVhxEeCLQ185SNUykeK5xSotMQwWz0il1n2fOEgHaTWrvHGj1aSw9k57Xg?=
 =?us-ascii?Q?0CqPPXGV4A26KmK6EUvEE5Jd7/E9QM2iVr35WvneVnrClZhk35GbhQW7JU8v?=
 =?us-ascii?Q?kXgMbVI9hFXl0ZHaO8rMOQqz5ylKntgCiL6CCi8J+7WeWOIwh19lU1vc4f1s?=
 =?us-ascii?Q?VCusnHglmzcNmRrBtnwiQIRTm9Wb9Gi6oCf/IVIyW1w3UTO9TWKpEdl+w625?=
 =?us-ascii?Q?jGWopz/+CvFCsyu+idksNEQBzqOnJIzposrnD/noCpI4IdPHSE9h2lFljKJM?=
 =?us-ascii?Q?jURobjGiV62IlGEzu2R/IT19Dw7eU9wtuX9fl/VNJ5G9T1KI8mPfTaw7Z1Tg?=
 =?us-ascii?Q?JcSTYOJDrfs1cSIi1/UZ+ihnGU9zmrlTIvFaJ98eROlIfUq7gGTML2rilGxl?=
 =?us-ascii?Q?akgzx+7i1Xpbplayod5vAmZctAj46rSC96UONkGKAUDOWvW8smv37zBmFkQO?=
 =?us-ascii?Q?OwzuFzdx6QT7oSic80yILD5Jgg15Cw3BzRbzB90GYlMYIxUosp17PMga3kHg?=
 =?us-ascii?Q?DuNtOGhQZZ9wCcrfkefb3CsuJj6jR0UeA2vYuTM8EGyywDZqCHXxCDeA35x5?=
 =?us-ascii?Q?zaIkGWZA60oOn487W1Oi1+R+xjmAMDa2to82FSuwxD0f958yalZumSTN7Wxa?=
 =?us-ascii?Q?u0rxfdwSUUIgRUDvg7LWZEMZhTgPDBTkOT+SfFmqlTIWE+uHosw0VU3jAI85?=
 =?us-ascii?Q?BUfPah+MGWq09XXcn4UxNUOmBEoWZZxl8bI890ar2lYd76JGHIUPz1AfBrqU?=
 =?us-ascii?Q?YC/5l1SHVcAdUxa/RbGFDCc0lOPBZnzlVElKBWvzKgJbmoKhp+wrRdGVdkJv?=
 =?us-ascii?Q?XArMhHrgKNPLWYXd1kLIBeNSTeOZF7xVygo52cvbVsM4MwcxBIlhACmlnOg0?=
 =?us-ascii?Q?Ki4kiB0OH9Q2s2iiE9o1OZGrtvHSY6rk4K3FxA9ktH5MJ+tptf0TloCdJXTr?=
 =?us-ascii?Q?AnDGOwBuFOlTJbbhVwK6S5FedtF5nKweHGvoIXIKeqVbVc/B1A29f/KZ4qkb?=
 =?us-ascii?Q?kVCiWa9XV6a6f1hhss+blGC8jzWIcik22UkwguW/+z7zonkpRc44aMVsJ7op?=
 =?us-ascii?Q?/5jxPFpuVgPPC5ya6+4PvXsaYqyUv5S6nvJ/5oyj0LB9cWvtAYG0L+qL90iC?=
 =?us-ascii?Q?HMX6Aq0/f08mwl1PLI4BYrjl+IJ2MB7SKGInRnJn5vdb/hUrkddP7rXpGTah?=
 =?us-ascii?Q?a6nKSfWFLAK0qrk/hd2A5xiWrIy4Byy/xYD8h5vUe37/FSgQHfONALVNpUr0?=
 =?us-ascii?Q?v4xZISRIL/qPZHdpUJsTJUXU35lBHZCIfdHTqaYRlM4H1nGKzhyCepg1W6pS?=
 =?us-ascii?Q?Mc5DEV0B3XcHmW2C38y0Z7zHJYckDgKC07cL9gAsFcH9lkb2mSvtevYBy0w9?=
 =?us-ascii?Q?v5xU5I5ElXh+g2bCYQ4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5aa038f-4211-4998-6193-08dac78c9d6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 04:39:57.6221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ee+tgj+7bU6LiIr4iPGVa7/MF8fezli9ylSR22QAPQeOEzlt/KqK5W9zXrfTpGBNjtQYvEfixsWtjr6fx2bH5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6252
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

All the patch set looks good to me. Feel free to add:
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>

Again, thank you Lyude for helping on this!!!

Regards,
Wayne
> -----Original Message-----
> From: Lyude Paul <lyude@redhat.com>
> Sent: Tuesday, November 15, 2022 6:18 AM
> To: amd-gfx@lists.freedesktop.org
> Cc: Wentland, Harry <Harry.Wentland@amd.com>; stable@vger.kernel.org;
> Li, Sun peng (Leo) <Sunpeng.Li@amd.com>; Siqueira, Rodrigo
> <Rodrigo.Siqueira@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Koenig, Christian
> <Christian.Koenig@amd.com>; Pan, Xinhui <Xinhui.Pan@amd.com>; David
> Airlie <airlied@gmail.com>; Daniel Vetter <daniel@ffwll.ch>; Kazlauskas,
> Nicholas <Nicholas.Kazlauskas@amd.com>; Pillai, Aurabindo
> <Aurabindo.Pillai@amd.com>; Li, Roman <Roman.Li@amd.com>; Zuo, Jerry
> <Jerry.Zuo@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Lin, Wayne
> <Wayne.Lin@amd.com>; Thomas Zimmermann <tzimmermann@suse.de>;
> Mahfooz, Hamza <Hamza.Mahfooz@amd.com>; Hung, Alex
> <Alex.Hung@amd.com>; Mikita Lipski <mikita.lipski@amd.com>; Liu,
> Wenjing <Wenjing.Liu@amd.com>; Francis, David
> <David.Francis@amd.com>; open list:DRM DRIVERS <dri-
> devel@lists.freedesktop.org>; open list <linux-kernel@vger.kernel.org>
> Subject: [PATCH v2 1/4] drm/amdgpu/mst: Stop ignoring error codes and
> deadlocking
>=20
> It appears that amdgpu makes the mistake of completely ignoring the retur=
n
> values from the DP MST helpers, and instead just returns a simple true/fa=
lse.
> In this case, it seems to have come back to bite us because as a result o=
f
> simply returning false from compute_mst_dsc_configs_for_state(), amdgpu
> had no way of telling when a deadlock happened from these helpers. This
> could definitely result in some kernel splats.
>=20
> V2:
> * Address Wayne's comments (fix another bunch of spots where we weren't
>   passing down return codes)
>=20
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  18 +-
>  .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 235 ++++++++++------
> --
>  .../display/amdgpu_dm/amdgpu_dm_mst_types.h   |  12 +-
>  3 files changed, 147 insertions(+), 118 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 0db2a88cd4d7b..852a2100c6b38 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -6462,7 +6462,7 @@ static int
> dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
>  	struct drm_connector_state *new_con_state;
>  	struct amdgpu_dm_connector *aconnector;
>  	struct dm_connector_state *dm_conn_state;
> -	int i, j;
> +	int i, j, ret;
>  	int vcpi, pbn_div, pbn, slot_num =3D 0;
>=20
>  	for_each_new_connector_in_state(state, connector,
> new_con_state, i) { @@ -6509,8 +6509,11 @@ static int
> dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
>  			dm_conn_state->pbn =3D pbn;
>  			dm_conn_state->vcpi_slots =3D slot_num;
>=20
> -			drm_dp_mst_atomic_enable_dsc(state, aconnector-
> >port, dm_conn_state->pbn,
> -						     false);
> +			ret =3D drm_dp_mst_atomic_enable_dsc(state,
> aconnector->port,
> +							   dm_conn_state-
> >pbn, false);
> +			if (ret < 0)
> +				return ret;
> +
>  			continue;
>  		}
>=20
> @@ -9523,10 +9526,9 @@ static int amdgpu_dm_atomic_check(struct
> drm_device *dev,
>=20
>  #if defined(CONFIG_DRM_AMD_DC_DCN)
>  	if (dc_resource_is_dsc_encoding_supported(dc)) {
> -		if (!pre_validate_dsc(state, &dm_state, vars)) {
> -			ret =3D -EINVAL;
> +		ret =3D pre_validate_dsc(state, &dm_state, vars);
> +		if (ret !=3D 0)
>  			goto fail;
> -		}
>  	}
>  #endif
>=20
> @@ -9621,9 +9623,9 @@ static int amdgpu_dm_atomic_check(struct
> drm_device *dev,
>  		}
>=20
>  #if defined(CONFIG_DRM_AMD_DC_DCN)
> -		if (!compute_mst_dsc_configs_for_state(state, dm_state-
> >context, vars)) {
> +		ret =3D compute_mst_dsc_configs_for_state(state, dm_state-
> >context, vars);
> +		if (ret) {
>=20
> 	DRM_DEBUG_DRIVER("compute_mst_dsc_configs_for_state()
> failed\n");
> -			ret =3D -EINVAL;
>  			goto fail;
>  		}
>=20
> diff --git
> a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> index 6ff96b4bdda5c..bba2e8aaa2c20 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> +++
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> @@ -703,13 +703,13 @@ static int bpp_x16_from_pbn(struct
> dsc_mst_fairness_params param, int pbn)
>  	return dsc_config.bits_per_pixel;
>  }
>=20
> -static bool increase_dsc_bpp(struct drm_atomic_state *state,
> -			     struct drm_dp_mst_topology_state *mst_state,
> -			     struct dc_link *dc_link,
> -			     struct dsc_mst_fairness_params *params,
> -			     struct dsc_mst_fairness_vars *vars,
> -			     int count,
> -			     int k)
> +static int increase_dsc_bpp(struct drm_atomic_state *state,
> +			    struct drm_dp_mst_topology_state *mst_state,
> +			    struct dc_link *dc_link,
> +			    struct dsc_mst_fairness_params *params,
> +			    struct dsc_mst_fairness_vars *vars,
> +			    int count,
> +			    int k)
>  {
>  	int i;
>  	bool bpp_increased[MAX_PIPES];
> @@ -719,6 +719,7 @@ static bool increase_dsc_bpp(struct
> drm_atomic_state *state,
>  	int remaining_to_increase =3D 0;
>  	int link_timeslots_used;
>  	int fair_pbn_alloc;
> +	int ret =3D 0;
>=20
>  	for (i =3D 0; i < count; i++) {
>  		if (vars[i + k].dsc_enabled) {
> @@ -757,52 +758,60 @@ static bool increase_dsc_bpp(struct
> drm_atomic_state *state,
>=20
>  		if (initial_slack[next_index] > fair_pbn_alloc) {
>  			vars[next_index].pbn +=3D fair_pbn_alloc;
> -			if (drm_dp_atomic_find_time_slots(state,
> -
> params[next_index].port->mgr,
> -
> params[next_index].port,
> -
> vars[next_index].pbn) < 0)
> -				return false;
> -			if (!drm_dp_mst_atomic_check(state)) {
> +			ret =3D drm_dp_atomic_find_time_slots(state,
> +
> params[next_index].port->mgr,
> +
> params[next_index].port,
> +
> vars[next_index].pbn);
> +			if (ret < 0)
> +				return ret;
> +
> +			ret =3D drm_dp_mst_atomic_check(state);
> +			if (ret =3D=3D 0) {
>  				vars[next_index].bpp_x16 =3D
> bpp_x16_from_pbn(params[next_index], vars[next_index].pbn);
>  			} else {
>  				vars[next_index].pbn -=3D fair_pbn_alloc;
> -				if (drm_dp_atomic_find_time_slots(state,
> -
> params[next_index].port->mgr,
> -
> params[next_index].port,
> -
> vars[next_index].pbn) < 0)
> -					return false;
> +				ret =3D drm_dp_atomic_find_time_slots(state,
> +
> params[next_index].port->mgr,
> +
> params[next_index].port,
> +
> vars[next_index].pbn);
> +				if (ret < 0)
> +					return ret;
>  			}
>  		} else {
>  			vars[next_index].pbn +=3D initial_slack[next_index];
> -			if (drm_dp_atomic_find_time_slots(state,
> -
> params[next_index].port->mgr,
> -
> params[next_index].port,
> -
> vars[next_index].pbn) < 0)
> -				return false;
> -			if (!drm_dp_mst_atomic_check(state)) {
> +			ret =3D drm_dp_atomic_find_time_slots(state,
> +
> params[next_index].port->mgr,
> +
> params[next_index].port,
> +
> vars[next_index].pbn);
> +			if (ret < 0)
> +				return ret;
> +
> +			ret =3D drm_dp_mst_atomic_check(state);
> +			if (ret =3D=3D 0) {
>  				vars[next_index].bpp_x16 =3D
> params[next_index].bw_range.max_target_bpp_x16;
>  			} else {
>  				vars[next_index].pbn -=3D
> initial_slack[next_index];
> -				if (drm_dp_atomic_find_time_slots(state,
> -
> params[next_index].port->mgr,
> -
> params[next_index].port,
> -
> vars[next_index].pbn) < 0)
> -					return false;
> +				ret =3D drm_dp_atomic_find_time_slots(state,
> +
> params[next_index].port->mgr,
> +
> params[next_index].port,
> +
> vars[next_index].pbn);
> +				if (ret < 0)
> +					return ret;
>  			}
>  		}
>=20
>  		bpp_increased[next_index] =3D true;
>  		remaining_to_increase--;
>  	}
> -	return true;
> +	return 0;
>  }
>=20
> -static bool try_disable_dsc(struct drm_atomic_state *state,
> -			    struct dc_link *dc_link,
> -			    struct dsc_mst_fairness_params *params,
> -			    struct dsc_mst_fairness_vars *vars,
> -			    int count,
> -			    int k)
> +static int try_disable_dsc(struct drm_atomic_state *state,
> +			   struct dc_link *dc_link,
> +			   struct dsc_mst_fairness_params *params,
> +			   struct dsc_mst_fairness_vars *vars,
> +			   int count,
> +			   int k)
>  {
>  	int i;
>  	bool tried[MAX_PIPES];
> @@ -810,6 +819,7 @@ static bool try_disable_dsc(struct drm_atomic_state
> *state,
>  	int max_kbps_increase;
>  	int next_index;
>  	int remaining_to_try =3D 0;
> +	int ret;
>=20
>  	for (i =3D 0; i < count; i++) {
>  		if (vars[i + k].dsc_enabled
> @@ -840,49 +850,52 @@ static bool try_disable_dsc(struct
> drm_atomic_state *state,
>  			break;
>=20
>  		vars[next_index].pbn =3D
> kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps);
> -		if (drm_dp_atomic_find_time_slots(state,
> -						  params[next_index].port-
> >mgr,
> -						  params[next_index].port,
> -						  vars[next_index].pbn) < 0)
> -			return false;
> +		ret =3D drm_dp_atomic_find_time_slots(state,
> +						    params[next_index].port-
> >mgr,
> +						    params[next_index].port,
> +						    vars[next_index].pbn);
> +		if (ret < 0)
> +			return ret;
>=20
> -		if (!drm_dp_mst_atomic_check(state)) {
> +		ret =3D drm_dp_mst_atomic_check(state);
> +		if (ret =3D=3D 0) {
>  			vars[next_index].dsc_enabled =3D false;
>  			vars[next_index].bpp_x16 =3D 0;
>  		} else {
>  			vars[next_index].pbn =3D
> kbps_to_peak_pbn(params[next_index].bw_range.max_kbps);
> -			if (drm_dp_atomic_find_time_slots(state,
> -
> params[next_index].port->mgr,
> -
> params[next_index].port,
> -
> vars[next_index].pbn) < 0)
> -				return false;
> +			ret =3D drm_dp_atomic_find_time_slots(state,
> +
> params[next_index].port->mgr,
> +
> params[next_index].port,
> +
> vars[next_index].pbn);
> +			if (ret < 0)
> +				return ret;
>  		}
>=20
>  		tried[next_index] =3D true;
>  		remaining_to_try--;
>  	}
> -	return true;
> +	return 0;
>  }
>=20
> -static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state
> *state,
> -					     struct dc_state *dc_state,
> -					     struct dc_link *dc_link,
> -					     struct dsc_mst_fairness_vars *vars,
> -					     struct drm_dp_mst_topology_mgr
> *mgr,
> -					     int *link_vars_start_index)
> +static int compute_mst_dsc_configs_for_link(struct drm_atomic_state
> *state,
> +					    struct dc_state *dc_state,
> +					    struct dc_link *dc_link,
> +					    struct dsc_mst_fairness_vars *vars,
> +					    struct drm_dp_mst_topology_mgr
> *mgr,
> +					    int *link_vars_start_index)
>  {
>  	struct dc_stream_state *stream;
>  	struct dsc_mst_fairness_params params[MAX_PIPES];
>  	struct amdgpu_dm_connector *aconnector;
>  	struct drm_dp_mst_topology_state *mst_state =3D
> drm_atomic_get_mst_topology_state(state, mgr);
>  	int count =3D 0;
> -	int i, k;
> +	int i, k, ret;
>  	bool debugfs_overwrite =3D false;
>=20
>  	memset(params, 0, sizeof(params));
>=20
>  	if (IS_ERR(mst_state))
> -		return false;
> +		return PTR_ERR(mst_state);
>=20
>  	mst_state->pbn_div =3D dm_mst_get_pbn_divider(dc_link);  #if
> defined(CONFIG_DRM_AMD_DC_DCN) @@ -933,7 +946,7 @@ static bool
> compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
>=20
>  	if (count =3D=3D 0) {
>  		ASSERT(0);
> -		return true;
> +		return 0;
>  	}
>=20
>  	/* k is start index of vars for current phy link used by mst hub */ @@
> -947,13 +960,17 @@ static bool compute_mst_dsc_configs_for_link(struct
> drm_atomic_state *state,
>  		vars[i + k].pbn =3D
> kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
>  		vars[i + k].dsc_enabled =3D false;
>  		vars[i + k].bpp_x16 =3D 0;
> -		if (drm_dp_atomic_find_time_slots(state, params[i].port-
> >mgr, params[i].port,
> -						  vars[i + k].pbn) < 0)
> -			return false;
> +		ret =3D drm_dp_atomic_find_time_slots(state, params[i].port-
> >mgr, params[i].port,
> +						    vars[i + k].pbn);
> +		if (ret < 0)
> +			return ret;
>  	}
> -	if (!drm_dp_mst_atomic_check(state) && !debugfs_overwrite) {
> +	ret =3D drm_dp_mst_atomic_check(state);
> +	if (ret =3D=3D 0 && !debugfs_overwrite) {
>  		set_dsc_configs_from_fairness_vars(params, vars, count, k);
> -		return true;
> +		return 0;
> +	} else if (ret !=3D -ENOSPC) {
> +		return ret;
>  	}
>=20
>  	/* Try max compression */
> @@ -962,31 +979,36 @@ static bool
> compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
>  			vars[i + k].pbn =3D
> kbps_to_peak_pbn(params[i].bw_range.min_kbps);
>  			vars[i + k].dsc_enabled =3D true;
>  			vars[i + k].bpp_x16 =3D
> params[i].bw_range.min_target_bpp_x16;
> -			if (drm_dp_atomic_find_time_slots(state,
> params[i].port->mgr,
> -							  params[i].port, vars[i
> + k].pbn) < 0)
> -				return false;
> +			ret =3D drm_dp_atomic_find_time_slots(state,
> params[i].port->mgr,
> +							    params[i].port,
> vars[i + k].pbn);
> +			if (ret < 0)
> +				return ret;
>  		} else {
>  			vars[i + k].pbn =3D
> kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
>  			vars[i + k].dsc_enabled =3D false;
>  			vars[i + k].bpp_x16 =3D 0;
> -			if (drm_dp_atomic_find_time_slots(state,
> params[i].port->mgr,
> -							  params[i].port, vars[i
> + k].pbn) < 0)
> -				return false;
> +			ret =3D drm_dp_atomic_find_time_slots(state,
> params[i].port->mgr,
> +							    params[i].port,
> vars[i + k].pbn);
> +			if (ret < 0)
> +				return ret;
>  		}
>  	}
> -	if (drm_dp_mst_atomic_check(state))
> -		return false;
> +	ret =3D drm_dp_mst_atomic_check(state);
> +	if (ret !=3D 0)
> +		return ret;
>=20
>  	/* Optimize degree of compression */
> -	if (!increase_dsc_bpp(state, mst_state, dc_link, params, vars, count,
> k))
> -		return false;
> +	ret =3D increase_dsc_bpp(state, mst_state, dc_link, params, vars,
> count, k);
> +	if (ret < 0)
> +		return ret;
>=20
> -	if (!try_disable_dsc(state, dc_link, params, vars, count, k))
> -		return false;
> +	ret =3D try_disable_dsc(state, dc_link, params, vars, count, k);
> +	if (ret < 0)
> +		return ret;
>=20
>  	set_dsc_configs_from_fairness_vars(params, vars, count, k);
>=20
> -	return true;
> +	return 0;
>  }
>=20
>  static bool is_dsc_need_re_compute(
> @@ -1087,15 +1109,16 @@ static bool is_dsc_need_re_compute(
>  	return is_dsc_need_re_compute;
>  }
>=20
> -bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> -				       struct dc_state *dc_state,
> -				       struct dsc_mst_fairness_vars *vars)
> +int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> +				      struct dc_state *dc_state,
> +				      struct dsc_mst_fairness_vars *vars)
>  {
>  	int i, j;
>  	struct dc_stream_state *stream;
>  	bool computed_streams[MAX_PIPES];
>  	struct amdgpu_dm_connector *aconnector;
>  	int link_vars_start_index =3D 0;
> +	int ret =3D 0;
>=20
>  	for (i =3D 0; i < dc_state->stream_count; i++)
>  		computed_streams[i] =3D false;
> @@ -1118,17 +1141,19 @@ bool compute_mst_dsc_configs_for_state(struct
> drm_atomic_state *state,
>  			continue;
>=20
>  		if (dcn20_remove_stream_from_ctx(stream->ctx->dc,
> dc_state, stream) !=3D DC_OK)
> -			return false;
> +			return -EINVAL;
>=20
>  		if (!is_dsc_need_re_compute(state, dc_state, stream->link))
>  			continue;
>=20
>  		mutex_lock(&aconnector->mst_mgr.lock);
> -		if (!compute_mst_dsc_configs_for_link(state, dc_state,
> stream->link, vars,
> -						      &aconnector->mst_mgr,
> -						      &link_vars_start_index)) {
> +
> +		ret =3D compute_mst_dsc_configs_for_link(state, dc_state,
> stream->link, vars,
> +						       &aconnector->mst_mgr,
> +						       &link_vars_start_index);
> +		if (ret !=3D 0) {
>  			mutex_unlock(&aconnector->mst_mgr.lock);
> -			return false;
> +			return ret;
>  		}
>  		mutex_unlock(&aconnector->mst_mgr.lock);
>=20
> @@ -1143,22 +1168,22 @@ bool compute_mst_dsc_configs_for_state(struct
> drm_atomic_state *state,
>=20
>  		if (stream->timing.flags.DSC =3D=3D 1)
>  			if (dc_stream_add_dsc_to_resource(stream->ctx-
> >dc, dc_state, stream) !=3D DC_OK)
> -				return false;
> +				return -EINVAL;
>  	}
>=20
> -	return true;
> +	return ret;
>  }
>=20
> -static bool
> -	pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state
> *state,
> -					      struct dc_state *dc_state,
> -					      struct dsc_mst_fairness_vars
> *vars)
> +static int pre_compute_mst_dsc_configs_for_state(struct
> drm_atomic_state *state,
> +						 struct dc_state *dc_state,
> +						 struct dsc_mst_fairness_vars
> *vars)
>  {
>  	int i, j;
>  	struct dc_stream_state *stream;
>  	bool computed_streams[MAX_PIPES];
>  	struct amdgpu_dm_connector *aconnector;
>  	int link_vars_start_index =3D 0;
> +	int ret;
>=20
>  	for (i =3D 0; i < dc_state->stream_count; i++)
>  		computed_streams[i] =3D false;
> @@ -1184,11 +1209,12 @@ static bool
>  			continue;
>=20
>  		mutex_lock(&aconnector->mst_mgr.lock);
> -		if (!compute_mst_dsc_configs_for_link(state, dc_state,
> stream->link, vars,
> -						      &aconnector->mst_mgr,
> -						      &link_vars_start_index)) {
> +		ret =3D compute_mst_dsc_configs_for_link(state, dc_state,
> stream->link, vars,
> +						       &aconnector->mst_mgr,
> +						       &link_vars_start_index);
> +		if (ret !=3D 0) {
>  			mutex_unlock(&aconnector->mst_mgr.lock);
> -			return false;
> +			return ret;
>  		}
>  		mutex_unlock(&aconnector->mst_mgr.lock);
>=20
> @@ -1198,7 +1224,7 @@ static bool
>  		}
>  	}
>=20
> -	return true;
> +	return ret;
>  }
>=20
>  static int find_crtc_index_in_state_by_stream(struct drm_atomic_state
> *state, @@ -1253,9 +1279,9 @@ static bool
> is_dsc_precompute_needed(struct drm_atomic_state *state)
>  	return ret;
>  }
>=20
> -bool pre_validate_dsc(struct drm_atomic_state *state,
> -		      struct dm_atomic_state **dm_state_ptr,
> -		      struct dsc_mst_fairness_vars *vars)
> +int pre_validate_dsc(struct drm_atomic_state *state,
> +		     struct dm_atomic_state **dm_state_ptr,
> +		     struct dsc_mst_fairness_vars *vars)
>  {
>  	int i;
>  	struct dm_atomic_state *dm_state;
> @@ -1264,11 +1290,12 @@ bool pre_validate_dsc(struct drm_atomic_state
> *state,
>=20
>  	if (!is_dsc_precompute_needed(state)) {
>  		DRM_INFO_ONCE("DSC precompute is not needed.\n");
> -		return true;
> +		return 0;
>  	}
> -	if (dm_atomic_get_state(state, dm_state_ptr)) {
> +	ret =3D dm_atomic_get_state(state, dm_state_ptr);
> +	if (ret !=3D 0) {
>  		DRM_INFO_ONCE("dm_atomic_get_state() failed\n");
> -		return false;
> +		return ret;
>  	}
>  	dm_state =3D *dm_state_ptr;
>=20
> @@ -1280,7 +1307,7 @@ bool pre_validate_dsc(struct drm_atomic_state
> *state,
>=20
>  	local_dc_state =3D kmemdup(dm_state->context, sizeof(struct
> dc_state), GFP_KERNEL);
>  	if (!local_dc_state)
> -		return false;
> +		return -ENOMEM;
>=20
>  	for (i =3D 0; i < local_dc_state->stream_count; i++) {
>  		struct dc_stream_state *stream =3D dm_state->context-
> >streams[i]; @@ -1316,9 +1343,9 @@ bool pre_validate_dsc(struct
> drm_atomic_state *state,
>  	if (ret !=3D 0)
>  		goto clean_exit;
>=20
> -	if (!pre_compute_mst_dsc_configs_for_state(state, local_dc_state,
> vars)) {
> +	ret =3D pre_compute_mst_dsc_configs_for_state(state, local_dc_state,
> vars);
> +	if (ret !=3D 0) {
>=20
> 	DRM_INFO_ONCE("pre_compute_mst_dsc_configs_for_state()
> failed\n");
> -		ret =3D -EINVAL;
>  		goto clean_exit;
>  	}
>=20
> @@ -1349,7 +1376,7 @@ bool pre_validate_dsc(struct drm_atomic_state
> *state,
>=20
>  	kfree(local_dc_state);
>=20
> -	return (ret =3D=3D 0);
> +	return ret;
>  }
>=20
>  static unsigned int kbps_from_pbn(unsigned int pbn) diff --git
> a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> index b92a7c5671aa2..97fd70df531bf 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> +++
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
> @@ -53,15 +53,15 @@ struct dsc_mst_fairness_vars {
>  	struct amdgpu_dm_connector *aconnector;  };
>=20
> -bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> -				       struct dc_state *dc_state,
> -				       struct dsc_mst_fairness_vars *vars);
> +int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
> +				      struct dc_state *dc_state,
> +				      struct dsc_mst_fairness_vars *vars);
>=20
>  bool needs_dsc_aux_workaround(struct dc_link *link);
>=20
> -bool pre_validate_dsc(struct drm_atomic_state *state,
> -		      struct dm_atomic_state **dm_state_ptr,
> -		      struct dsc_mst_fairness_vars *vars);
> +int pre_validate_dsc(struct drm_atomic_state *state,
> +		     struct dm_atomic_state **dm_state_ptr,
> +		     struct dsc_mst_fairness_vars *vars);
>=20
>  enum dc_status dm_dp_mst_is_port_support_mode(
>  	struct amdgpu_dm_connector *aconnector,
> --
> 2.37.3
