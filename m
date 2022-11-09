Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD7B62276E
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 10:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiKIJsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 04:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiKIJsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 04:48:54 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049C6B25;
        Wed,  9 Nov 2022 01:48:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWyEhnzIZz/sSfoxJfpFq6+aUaPkVP7L7Em49+tx4ddXIjGE37dFmdz9VRVQjMinB/PlkUidZ00t8pFjad3gfRIw7lkj23DtI3krx7UQNnrnseKUNlNFuubxSW6jMhFcyVto3uRQsT1UCOWESjKNCuU+df9cwD+5hdCWrQ/AzgNjr50VVWm0/MYL2bJdQ7wsoGKkwz3EojRQgdEMfGDtC0hpPVaS0rvn+MOgrAzmnLuF5Kye30fIxO+xGsQuAczGPvYrmSZyj9kw2mayfjV03Yi7cIamaDbTDL05Zhz0QQGEVNvYVi6R3D3+QciGFbQcvUh1C3iFcBjy0GZhfgvUfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqwi1OdDSlzuigFF520g/qM+1jhBLJg+nKEFr7U4Kd0=;
 b=VPj7yvOzclv6yk1sKKNK2hDWxXw8Jevyk21sdzrySLH+IKUvVLsNb40OSchpsC18NzE+Q3YTX5Bn/nucH7ye/s2qGiw0exwrZuzAKh5JYeetHNnx6gMAWZYroauRBqhYatVjvPqhFn3Wd1imDUUR+EuoxKJbbxVoWMXeOkdwi+y2QZV1wE/EEeUBJgOgnS7D6T4KvrydeZ3VMvyCWZDOQyr6Fj99lBjPygDzlz8SS1kkLNOpNWLn1Dh31nXe0UwKcqWw1w366EvX2k8JRJzbs6FMAg5WIDoHQT0GqxSqfQxK8ArC7GyZpzmChUpYCqMHoVD/6CgP2KPdE1D/NgbfIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqwi1OdDSlzuigFF520g/qM+1jhBLJg+nKEFr7U4Kd0=;
 b=Eb20HM8s31xcNuwuk+8bSFsH+QHiwi0LN7LcG+hy39Lh0mHcnl+v4QVxkgwQuOKOeMRNbYJbB31PLjGZ8pt7yy4lXqvTG0rrGotEqZgJ3j794uolqxevLDCOAAdSnI3D0duqmqGRwJj+Bgi4goK6NEsLRTcxPslXA2a9nD5bjx0=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by DS0PR12MB7605.namprd12.prod.outlook.com (2603:10b6:8:13d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Wed, 9 Nov
 2022 09:48:45 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::2509:5f0c:f0f4:882d]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::2509:5f0c:f0f4:882d%3]) with mapi id 15.20.5813.012; Wed, 9 Nov 2022
 09:48:45 +0000
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
        "Francis, David" <David.Francis@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        "Liu, Wenjing" <Wenjing.Liu@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] drm/amdgpu/mst: Stop ignoring error codes and
 deadlocking
Thread-Topic: [PATCH 1/2] drm/amdgpu/mst: Stop ignoring error codes and
 deadlocking
Thread-Index: AQHY8KmDMbF79LTxvE27gfK2SyT5Bq42XHDQ
Date:   Wed, 9 Nov 2022 09:48:45 +0000
Message-ID: <CO6PR12MB5489E3850FE3C9FBDA7BAC29FC3E9@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20221104235926.302883-1-lyude@redhat.com>
 <20221104235926.302883-2-lyude@redhat.com>
In-Reply-To: <20221104235926.302883-2-lyude@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-11-09T09:48:34Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=7634b220-8709-4bdc-b720-34b477742d9a;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR12MB5489:EE_|DS0PR12MB7605:EE_
x-ms-office365-filtering-correlation-id: 1ae24466-150f-43f7-c203-08dac23797e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mkSaSqekt2Jf5IKZfBLIY4rf6Iag3XcsgdJEjsxodTOvNIESWydvCwYEfSu5cpNRdSXwYCB3daEQfLEFBJ/Qy57Ena2IhC6FfbGM86FAd1RGe9lMlZhHObYD/rRcPQzB4o4SdZIQaRJijTJdWd6FTEWOFBb0WVY9uACb+OUbAXQeqTVG7Scl9/wULa31aSrtIGU+H+waLV5ZXmB54zio8cTHjzZY3UjHX8dvT8Y1kP50D8BE2kd63en7cqbRHNzMqX5ZR/Wo2EsU8YMN7t9zpu7n4vcUFSIskPYIUDGGHywNR7aLOFljz+W8aSa4ps7Ip5PXfaQG2/5kEWs03MCNcO4EYOr1tQ22bDXf4Q0J7gU4JNBSYFQt0W2rEcfWnkguYa0C+TKNrUYeeU/w91qU6egd0zLtgNzw8EOT1vfhBxNc5a+iY3C9nrsZguml04f3SEbHjSyxf5Z1llCPW20BuMp6405Bu+JxoIoQtEcbHt51h0xfWxsTJ3S9Y7Ye/VnB4TFC78r8ahpIWyxQiMP+P79D1LxJU3vyjsry7d+heS2G570LOeimoWP0weLWzvzXdedOf4NcfTT1o7gw2Ssab04c9YRgIITDCNpL0Wg1ldDy4+LVYgdfYtvFurCVWe9gtcygyPGb7PjGHJEA9KLlQamnFb9eSPcjoOMyEu8uT5jONabcJZJbAMYLN8d4tlYxoeXFPid3tfAZB8fH5jWL3XFM+68M/bZUbaOs6CNjt27KbrKQyA5AUjvhxLSrtckbU0a6WlwgfOOJX7uVF9F8Lx+cFb2VvrFWqnnq7qiOq1o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(38070700005)(122000001)(38100700002)(86362001)(55016003)(33656002)(71200400001)(316002)(54906003)(110136005)(478600001)(8936002)(41300700001)(30864003)(52536014)(5660300002)(7696005)(8676002)(4326008)(76116006)(2906002)(66556008)(66476007)(66946007)(64756008)(66446008)(53546011)(6506007)(26005)(9686003)(83380400001)(186003)(11716005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k+vKMywCPLpD4xwEKiyoZSlg2f2dtqytqv+/kX4B2ZQQMyXgbmY2tsyKkXao?=
 =?us-ascii?Q?lz/LyceIlLsoEiC49xi6UTyZ7hY2Ge5lLgw6MnJhR8LJ8DphahfRTkoCgZRe?=
 =?us-ascii?Q?vVPbpTvwt94enUF8QQEWMw/D8K0A3OUs3BxeBiTEfQ+T7NQnzEuA9i5oZWYD?=
 =?us-ascii?Q?EUn5t3Y8PLTTYv1JxCtT+2UyT2QKfd44YM0upF4TANBzqHFVVS50uxpaJQNC?=
 =?us-ascii?Q?uHu9nk3nq1uDCIaQUbJEbjrJvM8hTowzkc4R2zPAEjDEhYQXs5yfpCLIcLuv?=
 =?us-ascii?Q?s8YYwmW/yqAZUIh+XWBHARz3nWCdUL8SvtBDIiiUu8yoFGC+WF/jhJhc/wB2?=
 =?us-ascii?Q?VCo/7n+sMiBy2urvacEQ3WHXZgu65mBlwB0g7YkX/GPUPnwyjPcrM4pT6lvM?=
 =?us-ascii?Q?nbT0H2H7kqnCWH9HTPO88hj1AeXOtlcghPDSdbwDZvBOOy4iux3BovGrBeHl?=
 =?us-ascii?Q?VbhGkuP+rbqhN4n3QwGuRsll/WUheyoL8cPxd/oV4nvhcX3wSsE6/5PCmWD6?=
 =?us-ascii?Q?lsY/p1OhIY1OleDOwm0mpVY+z87DYcXbc6eU/RYMk/tYZO9iW+PD4SOX8D50?=
 =?us-ascii?Q?x0Ya/8xa/yI1Sd3HAtWoHcCtFgfXBEmjPceXRYYaxCxmPZUUHXZao3Y2Hm4s?=
 =?us-ascii?Q?LAoXdaOUrMxqQvkm14R/x+E0vzVxpuW3hTDJKdD7jQp3ps1Bj8/Vs9+AUiOF?=
 =?us-ascii?Q?/FPBrTwrxItqiP8XF1ROi7xiEVCR0WVRj/72ULmxu30q8pKLQX4fjWBNJLlc?=
 =?us-ascii?Q?r2Cm0iMAuYVQLOjEzmDGG3fxEj9eJZZAqUUpwy5GvKHWMGFKa7AKp0xmddK0?=
 =?us-ascii?Q?DAXe2WiLf585a56RlgcTfRG5BtZUmI+g2bYPLLpRDpZ8oVAASgi7TCSWJRv5?=
 =?us-ascii?Q?kHxVoo3IlFv4mUEKW5lhN2T5zdQZwOMP3IwXwbu/avi497+sZ9EiuinZfY4m?=
 =?us-ascii?Q?2ci5jOuy2GG53i4i5LMCQqhprDQsHCR5p0pW7BwzNrGly3NnIUDIC5YTjg0A?=
 =?us-ascii?Q?lCam8sUgomfkuBd/LbxrYm1W7aeEAmEfz0QCDJktIS1BmI/e4xbGGNJsE1EJ?=
 =?us-ascii?Q?8Ek6m0i508ns8sicANPrkv2/dQ9FBeo1LtPvM8kXwC+cl17PXb+QeQkFIqEE?=
 =?us-ascii?Q?KT9WXPJ5LH7Y00NhXLeB0J7Ux1kBD0pV0HVlKawJivOMjgY2pBPtWp/oYBQ9?=
 =?us-ascii?Q?nYXl5eWemdyQScUtvX+KglSgdkLkbtscBotEjXbFHY5R4Jd0Y9XnK71481WR?=
 =?us-ascii?Q?Lq0WaR+fHBxfEaABQstZOafW54oYGMXNpcLFy9qnjrkpGSS4vS6yXXbstoNY?=
 =?us-ascii?Q?u690BORBEB5jkt0csC2O0q6piRXl4goa9CaFFsefY+Q2gA93nYeoKQ3GHBDY?=
 =?us-ascii?Q?qKlGgj0slwCsNIeidDq5B2JuvzWfvG6jBtQsC6HNqoqcVZ9x843a+v4vgZQF?=
 =?us-ascii?Q?BV/RKyFBvJKTSaYPQUFlH9djcHqkI7wHL2tbVMUcdI+1g4jQL0zmUFgWtdBf?=
 =?us-ascii?Q?yd9Q3QqQDn9RVw68T1kcg8lf3VEo7Bhyrx+t2gbsjSYBWEjg3AYIF7gZNrmJ?=
 =?us-ascii?Q?yBsZKTKxr8iv0Fv5auI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae24466-150f-43f7-c203-08dac23797e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 09:48:45.2957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iUU5OXd3kcXsLNhJ8rORv9liLEh7IJ/r/A/pf75j8TliIZNCQ6m800ln4KWIJ8wJyim5u7y2I6KMhtZj8qK4PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7605
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Thanks, Lyude!
Comments inline.

> -----Original Message-----
> From: Lyude Paul <lyude@redhat.com>
> Sent: Saturday, November 5, 2022 7:59 AM
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
> <Alex.Hung@amd.com>; Francis, David <David.Francis@amd.com>; Mikita
> Lipski <mikita.lipski@amd.com>; Liu, Wenjing <Wenjing.Liu@amd.com>;
> open list:DRM DRIVERS <dri-devel@lists.freedesktop.org>; open list <linux=
-
> kernel@vger.kernel.org>
> Subject: [PATCH 1/2] drm/amdgpu/mst: Stop ignoring error codes and
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
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 8c20a1ed9b4f ("drm/amd/display: MST DSC compute fair share")
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  18 +--
>  .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 107 ++++++++++------
> --
>  .../display/amdgpu_dm/amdgpu_dm_mst_types.h   |  12 +-
>  3 files changed, 73 insertions(+), 64 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 0db2a88cd4d7b..6f76b2c84cdb5 100644
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
> +			if (ret !=3D 0)
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
> index 6ff96b4bdda5c..30bc2e5058b70 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> +++
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> @@ -864,25 +864,25 @@ static bool try_disable_dsc(struct
> drm_atomic_state *state,
>  	return true;
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
> defined(CONFIG_DRM_AMD_DC_DCN) @@ -933,7 +933,7 @@ static bool
> compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
>=20
>  	if (count =3D=3D 0) {
>  		ASSERT(0);
> -		return true;
> +		return 0;
>  	}
>=20
>  	/* k is start index of vars for current phy link used by mst hub */ @@
> -949,11 +949,14 @@ static bool compute_mst_dsc_configs_for_link(struct
> drm_atomic_state *state,
>  		vars[i + k].bpp_x16 =3D 0;
>  		if (drm_dp_atomic_find_time_slots(state, params[i].port-
> >mgr, params[i].port,
>  						  vars[i + k].pbn) < 0)
> -			return false;
> +			return -EINVAL;

Should we also return the error code get from drm_dp_atomic_find_time_slots=
() rather than=20
assigning a new one here?

>  	}
> -	if (!drm_dp_mst_atomic_check(state) && !debugfs_overwrite) {
> +	ret =3D drm_dp_mst_atomic_check(state);
> +	if (ret =3D=3D 0 && !debugfs_overwrite) {
>  		set_dsc_configs_from_fairness_vars(params, vars, count, k);
> -		return true;
> +		return 0;
> +	} else if (ret =3D=3D -EDEADLK) {
> +		return ret;

I think we should return here whenever there is an error. Not just for EDEA=
DLK case.=20

>  	}
>=20
>  	/* Try max compression */
> @@ -964,29 +967,30 @@ static bool
> compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
>  			vars[i + k].bpp_x16 =3D
> params[i].bw_range.min_target_bpp_x16;
>  			if (drm_dp_atomic_find_time_slots(state,
> params[i].port->mgr,
>  							  params[i].port, vars[i
> + k].pbn) < 0)
> -				return false;
> +				return -EINVAL;

Same as above.

>  		} else {
>  			vars[i + k].pbn =3D
> kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
>  			vars[i + k].dsc_enabled =3D false;
>  			vars[i + k].bpp_x16 =3D 0;
>  			if (drm_dp_atomic_find_time_slots(state,
> params[i].port->mgr,
>  							  params[i].port, vars[i
> + k].pbn) < 0)
> -				return false;
> +				return -EINVAL;

Same as above.

>  		}
>  	}
> -	if (drm_dp_mst_atomic_check(state))
> -		return false;
> +	ret =3D drm_dp_mst_atomic_check(state);
> +	if (ret !=3D 0)
> +		return ret;
>=20
>  	/* Optimize degree of compression */
>  	if (!increase_dsc_bpp(state, mst_state, dc_link, params, vars, count,
> k))
> -		return false;
> +		return -ENOSPC;
>=20
>  	if (!try_disable_dsc(state, dc_link, params, vars, count, k))
> -		return false;
> +		return -ENOSPC;
>=20
>  	set_dsc_configs_from_fairness_vars(params, vars, count, k);
>=20
> -	return true;
> +	return 0;
>  }
>=20
>  static bool is_dsc_need_re_compute(
> @@ -1087,15 +1091,16 @@ static bool is_dsc_need_re_compute(
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
> @@ -1118,17 +1123,19 @@ bool compute_mst_dsc_configs_for_state(struct
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
> @@ -1143,22 +1150,22 @@ bool compute_mst_dsc_configs_for_state(struct
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
> @@ -1184,13 +1191,12 @@ static bool
>  			continue;
>=20
>  		mutex_lock(&aconnector->mst_mgr.lock);
> -		if (!compute_mst_dsc_configs_for_link(state, dc_state,
> stream->link, vars,
> -						      &aconnector->mst_mgr,
> -						      &link_vars_start_index)) {
> -			mutex_unlock(&aconnector->mst_mgr.lock);
> -			return false;
> -		}
> +		ret =3D compute_mst_dsc_configs_for_link(state, dc_state,
> stream->link, vars,
> +						       &aconnector->mst_mgr,
> +						       &link_vars_start_index);
>  		mutex_unlock(&aconnector->mst_mgr.lock);
> +		if (ret !=3D 0)
> +			return ret;
>=20
>  		for (j =3D 0; j < dc_state->stream_count; j++) {
>  			if (dc_state->streams[j]->link =3D=3D stream->link) @@ -
> 1198,7 +1204,7 @@ static bool
>  		}
>  	}
>=20
> -	return true;
> +	return ret;
>  }
>=20
>  static int find_crtc_index_in_state_by_stream(struct drm_atomic_state
> *state, @@ -1253,9 +1259,9 @@ static bool
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
> @@ -1264,11 +1270,12 @@ bool pre_validate_dsc(struct drm_atomic_state
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
> @@ -1280,7 +1287,7 @@ bool pre_validate_dsc(struct drm_atomic_state
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
> >streams[i]; @@ -1316,9 +1323,9 @@ bool pre_validate_dsc(struct
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
> @@ -1349,7 +1356,7 @@ bool pre_validate_dsc(struct drm_atomic_state
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
---
Regards,
Wayne Lin
