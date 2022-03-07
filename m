Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2F74D051A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 18:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244402AbiCGRUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 12:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244260AbiCGRUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 12:20:20 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0D12F03C;
        Mon,  7 Mar 2022 09:19:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsRnKUaHFFVNZzJXOXiCo/Nng+WH6i2r1rJwioodiV+f/3lM24TaQuVzpmT9LtpOgXFvWZEpdyjtEHQNsNsiHQ0tcnbQ7FAi6FvPNVJ5sROOLgyJ7hpZC+XLqG5GBYzTzIZnD+bZxnCC7mwCfeknBsR+tMf9Jz0pvoKo61oodAsKbQ2Z4oen921pQTr0O+XCxCkPNjHmRJyfyZc4iKJI/ipy1afTPoBZMUt4d7UN6uxBVUileZStW5IHbPZO1jLutP1XYJrvFxvWuPieRVcEYZozbShnoo9IcyV+XQgOXBwg62v1O27c8tmXkZ4yR2nkhUAPGp2ivu8SgumhM4wB3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1rKM6aOY8FSl50n8mpy/OAhhBBCfmNAvZHuV6vwsM0=;
 b=k2bN0L2A8gAZCL4P4cqps4vIx0IeNLBDJnwsQg5YDOuSokBM7NTtZj22aQigYp7w8J7+Fod5DaKpDj4/MdaBeQqrPR2z2XjSnyBwl6aEArx4h1DiZmKJP2E9HcnU2EFU5Nl7dBK+menIeiIrDbO84Zi/6GLsrUdMMwh/fM83ETGhbZb3P7Gi3+7J37p8xsl5j5BkSbO8ZFaESzqI8NCvYtkT0/Hc98eEEvm6+tY+tCGYuiwAF/C9wCDxNcrGDRe/QofDbS6BZx7NxJcKUsvI/oln4Tw0X9ec5+/eOsv+DCVTbyQIOk6cqRkfkUVIqTpa/b/nB6uJHkaQ3xhVCBlq8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1rKM6aOY8FSl50n8mpy/OAhhBBCfmNAvZHuV6vwsM0=;
 b=sr6nBu7u85FsHYUPSQ6QhQNkCD5ks1HEpCZj2AEoTAd4Nda2l8+3mesKkwc69s0EuUVp+x7lAXSAR/jd1n9sJBRF14dkkd8eWDLZwUzAAN9xhA+57u0eZiyz74c12lJ8YwF5kirYHU5opqe2fLFtcy6B8oRCxQApaRAjyYyJXx0=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 17:19:20 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::2877:73e4:31e7:cecf]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::2877:73e4:31e7:cecf%7]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 17:19:20 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Wu, Hersen" <hersenxs.wu@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Gutierrez, Agustin" <Agustin.Gutierrez@amd.com>,
        "Wheeler, Daniel" <Daniel.Wheeler@amd.com>,
        "Zhuo, Qingqing (Lillian)" <Qingqing.Zhuo@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.15 100/262] drm/amd/display: move FPU associated DSC
 code to DML folder
Thread-Topic: [PATCH 5.15 100/262] drm/amd/display: move FPU associated DSC
 code to DML folder
Thread-Index: AQHYMgdOSuVNXIR9nku4dCgcxKRASqy0KkvQ
Date:   Mon, 7 Mar 2022 17:19:20 +0000
Message-ID: <BL1PR12MB5144BBA7ACECD892E9DE088AF7089@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20220307091702.378509770@linuxfoundation.org>
 <20220307091705.301226097@linuxfoundation.org>
In-Reply-To: <20220307091705.301226097@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-03-07T17:17:20Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=84aee0ba-83c1-4c6e-ae74-a9af3b8c052d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-03-07T17:19:15Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: e6306658-617d-4f77-ae47-7535e271d4e1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d49f273b-0783-417a-4158-08da005e9e03
x-ms-traffictypediagnostic: DM4PR12MB5214:EE_
x-microsoft-antispam-prvs: <DM4PR12MB5214AB20F582CA3FA8545EA5F7089@DM4PR12MB5214.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yVkqWOiKabivT6YBGvgzjOykn8cEVzT05xZuCXbmE9qMbc8H4EyoITx8wDqoND/EedhrmnJuFyZ7NTDiY4oh5Kb/2gFOxLNRrYJwxTBRH533EK3O/UTJz3GIZHYpPt84M9QQAfNvKx/zjvqajcsJ5bqkbpPz/DCFLCaKxv7gz+ws7iWUiXPQ76f1a90qVny9E5xTLHo2hYWkt3XCKK3R6owIqqeNFwsDwjJAyhOv4rDIi31+fFZeLNjo6ndcmj8l/lt/bhpXPjBsnQW0WHhJLNPx58HhPWjjJ/KG023dOXoD1ihCJJ3fT6zKjh2+7bYEhuICZ5i2jG431bMwaWwd/DazxKZz7QPajB82E0TFDRcYIWeLU/nTzkXuuMWBfpazZrIAHmid8hSqsUZTPg3gEckOmtjP/iiRVb9rCljJtTX9rtt6bdmuW0gxfWGGdAtc4MNB3e+JsFCpT5I2VNGfymAUAXFVR3XqxuxuDh5fbmVNIC1CzwV/wHlt85IP4sEie6xhoNlA+i1c+yn8tRe/HeMFB/pIKWOYYr7FQ/ak18LMrkgzrp7p+qa/RS8vXwgb9VdCOd6mYcpIYgZZGB5Ocz0e+cIBBVgi1WWLajlbO6Fsb8rXF9/FX+V11GeHf2K2WOo5R/OA99apU38NaWOwvkvdBq3Rx4Xb2SV1NG7V1hI3oJB6GqP9/EdFFa+NqbXF/XoZETQVrEoyHOeFhtpAheq8PN3p06K/T9lLVLupt6f7BLz7qxIkYHYfXtzt1ubxkXTwnekxKeMbuFgXzFLZ++fV8hp+VL4MCGJHMvtEk3IwDkH8K2jelS99BY8yuT6+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(122000001)(71200400001)(9686003)(6506007)(7696005)(86362001)(966005)(316002)(38070700005)(38100700002)(76116006)(508600001)(33656002)(53546011)(66476007)(66446008)(64756008)(8676002)(66946007)(66556008)(4326008)(55016003)(66574015)(26005)(8936002)(5660300002)(186003)(83380400001)(30864003)(110136005)(52536014)(54906003)(45080400002)(461764006)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?IApC4HGIEhpyoRzh42/dCs3MVuHWYCghF9fkHGTiTre4YFThCvAIzvWt1D?=
 =?iso-8859-1?Q?whoAM47ZHkNrypYfgSzEk8W5z3LYUUU4KEnhxNyXuYiVGZ8W/uFI1+IGGA?=
 =?iso-8859-1?Q?L6oUiI8w//e8YlHV2ZzclZ3+ggwIGxBVCD6ZqDwLzsxmPVRZQBjyju+P6G?=
 =?iso-8859-1?Q?dt8QZe7tD220F8a9DrtVFzaAoL/0oemWCanIvsqa6YCRAR9h9+L6weOHzD?=
 =?iso-8859-1?Q?cd3D/LihHqPGRwwwL7IYf2MLLnEiShPXAO8NhAlKTpSdfbn8FfW7xCuvj2?=
 =?iso-8859-1?Q?MAiNIgZ+9CiIDyMuqVWaYW9IzFBGZQzRK08hLfQszeY7TW2pWFDba5BxfO?=
 =?iso-8859-1?Q?v9AX3dC8mON5SXw9MFmrVpNin3m3+dZPx17ywJk8vz1Ck5+sF+Ua5TGjgl?=
 =?iso-8859-1?Q?fFfIP9h6qiHAx74LVz6ed3EdkZc8tefN9TKV8h9X+tbEcjRytZmMv0+0G7?=
 =?iso-8859-1?Q?F6ux8MksYEns6b/c3IOCSDCurC128HZwkIFbTiBS1gEJu0ME2yD+MWXoyk?=
 =?iso-8859-1?Q?7bUNF5kw93X3tOX0JoDdRH+sTrvCk+I6lKo2AcYRKCDCTVUqI+dLNAJmPr?=
 =?iso-8859-1?Q?wzAuDqaWlxe9cZyan8KgZToJe4860nBPGVBxXepy31pCtRlpan+IeckzF7?=
 =?iso-8859-1?Q?0hPtj7rCL1xeZ1paoOvxKj7w1qaRV25YSHVjQbtCwWr2wwo77cUq6Vbxtb?=
 =?iso-8859-1?Q?sl3YgHTJafJ6k6KUmYWDok+bKbKmsmrPFnhlDMVHq6opPKx6a81gtM3K6i?=
 =?iso-8859-1?Q?LaC30ezJZmEc5HLBNZqKBcuWZnhQBjBAndmvDfegICkdR41InN5+7lonjd?=
 =?iso-8859-1?Q?uKKxPsvEMD3flBhDbiQH7U7C157T+6pStJuZqavLDnTmQsSdRWytk/ootI?=
 =?iso-8859-1?Q?2gpePZT9hPFQdl1lgKub7p7oXS7FCPaHFzTUpQMg0FY0OuwxmZNl5N3xJ6?=
 =?iso-8859-1?Q?dfCZUr+CpIN3V97wNUv4lt7hYlILIiJ5vy+NhlEFeQ+LFXrY3qD5EHFPVq?=
 =?iso-8859-1?Q?0tqLJ6lRJNucunBMSOhuLd9zzK8mue3EKoCCuDOUFrYdnuVHUUk0PjDdBr?=
 =?iso-8859-1?Q?yTXDJL6fUL6OzfeAmLWbrTyZxmoCsPB/K/nlM294uqK1HMxsj8tMuNuGI6?=
 =?iso-8859-1?Q?ls3Xre9c5nsffbd6yNsaVB6BdcSCvnW4qxrv0Se31tPa4QxuMGhiy/TRlA?=
 =?iso-8859-1?Q?VxWQ/kUaD7KiaQkd0xckBlfmyAoTUq6VLh0UAZIOtp0SoLFxGAW1wYAZo0?=
 =?iso-8859-1?Q?mhgL3D4nol5LUmW45AeT8EWqfoPNJnp/vZII3CbBNphhHunAmwgpr0GPFI?=
 =?iso-8859-1?Q?LG6xxba/oMYKtDmJoxbcam0TQKLX3ixHbY9ks9btmnJAjMMeEq+H8iT11N?=
 =?iso-8859-1?Q?Xt6aq7FBmq1q0jMLTjM432RwYqdC9bN1TwN3Dl7GMytaO2/q0LNRgma2sW?=
 =?iso-8859-1?Q?AuGoM6clSLEgy17c29XDihBTF8FoTBmY9ylgHjbGbCMJbxo947Aegde6k+?=
 =?iso-8859-1?Q?hscAl0wDBaPuF231ZsEmUo0ekP4o4a+2urhUaPqiY/7OGtVxgT1rwbDddB?=
 =?iso-8859-1?Q?0F5ddsn6N5eaRSFwUN5pviz0uJty86Z49fnKxopfqpfduYKRsITp9vewvU?=
 =?iso-8859-1?Q?ISKASq7IHmQLroY+twkHreM/brd08ouVTx3FzNGHty/3ZY+ATAuwS3rsSg?=
 =?iso-8859-1?Q?c1mEt7PnXjOQAhlsPTM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d49f273b-0783-417a-4158-08da005e9e03
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 17:19:20.0849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +nkPH+tmsZLIcEXZM+MKtgLorSV86a3rgkFr1KHVDzfJ+gbkNDOTK/kCk4XE0HquR2IrMIT46poSLPpO/YaAhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, March 7, 2022 4:17 AM
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> stable@vger.kernel.org; Koenig, Christian <Christian.Koenig@amd.com>;
> Wu, Hersen <hersenxs.wu@amd.com>; Anson Jacob
> <Anson.Jacob@amd.com>; Wentland, Harry <Harry.Wentland@amd.com>;
> Siqueira, Rodrigo <Rodrigo.Siqueira@amd.com>; Gutierrez, Agustin
> <Agustin.Gutierrez@amd.com>; Wheeler, Daniel
> <Daniel.Wheeler@amd.com>; Zhuo, Qingqing (Lillian)
> <Qingqing.Zhuo@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 5.15 100/262] drm/amd/display: move FPU associated DSC
> code to DML folder
>=20
> From: Qingqing Zhuo <qingqing.zhuo@amd.com>
>=20
> [ Upstream commit d738db6883df3e3c513f9e777c842262693f951b ]
>=20
> [Why & How]
> As part of the FPU isolation work documented in
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatc
> hwork.freedesktop.org%2Fseries%2F93042%2F&amp;data=3D04%7C01%7Calex
> ander.deucher%40amd.com%7Cf4f4d5bfb9f74edfb8b108da001e6d8f%7C3dd
> 8961fe4884e608e11a82d994e183d%7C0%7C0%7C637822427968538535%7CUn
> known%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6
> Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3D2Mm24%2FPkRkih%2BToJ
> oBGx2wpeth0Z0Rv3dG77D06fHbw%3D&amp;reserved=3D0, isolate code that
> uses FPU in DSC to DML, where all FPU code should locate.
>=20
> This change does not refactor any functions but move code around.
>=20

This is not a really bug fix, just general reworking of the FP code.  I don=
't know that this is stable material.

Alex


> Cc: Christian K=F6nig <christian.koenig@amd.com>
> Cc: Hersen Wu <hersenxs.wu@amd.com>
> Cc: Anson Jacob <Anson.Jacob@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> Acked-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
> Tested-by: Anson Jacob <Anson.Jacob@amd.com>
> Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
> Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
> Acked-by: Christian K=F6nig <christian.koenig@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/display/dc/dml/Makefile   |   3 +
>  .../amd/display/dc/{ =3D> dml}/dsc/qp_tables.h  |   0
>  .../drm/amd/display/dc/dml/dsc/rc_calc_fpu.c  | 291
> ++++++++++++++++++  .../drm/amd/display/dc/dml/dsc/rc_calc_fpu.h  |  94
> ++++++
>  drivers/gpu/drm/amd/display/dc/dsc/Makefile   |  29 --
>  drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c  | 259 ----------------
> drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h  |  50 +--
>  .../gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c  |   1 -
>  8 files changed, 389 insertions(+), 338 deletions(-)  rename
> drivers/gpu/drm/amd/display/dc/{ =3D> dml}/dsc/qp_tables.h (100%)  create
> mode 100644 drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
>  create mode 100644
> drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.h
>=20
> diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile
> b/drivers/gpu/drm/amd/display/dc/dml/Makefile
> index 56055df2e8d2e..9009b92490f34 100644
> --- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
> @@ -70,6 +70,7 @@
> CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_mode_vba_30.o :=3D
> $(dml_ccflags) $(fram
> CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_rq_dlg_calc_30.o :=3D
> $(dml_ccflags)
> CFLAGS_$(AMDDALPATH)/dc/dml/dcn31/display_mode_vba_31.o :=3D
> $(dml_ccflags) $(frame_warn_flag)
> CFLAGS_$(AMDDALPATH)/dc/dml/dcn31/display_rq_dlg_calc_31.o :=3D
> $(dml_ccflags)
> +CFLAGS_$(AMDDALPATH)/dc/dml/dsc/rc_calc_fpu.o :=3D $(dml_ccflags)
>  CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_lib.o :=3D $(dml_ccflags)
> CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/display_mode_vba.o :=3D
> $(dml_rcflags)  CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn2x/dcn2x.o
> :=3D $(dml_rcflags) @@ -84,6 +85,7 @@
> CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn30/display_rq_dlg_calc_30.
> o :=3D $(dml_rcfla
> CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn31/display_mode_vba_31.o
> :=3D $(dml_rcflags)
> CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn31/display_rq_dlg_calc_31.
> o :=3D $(dml_rcflags)
> CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/display_mode_lib.o :=3D
> $(dml_rcflags)
> +CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dsc/rc_calc_fpu.o  :=3D
> $(dml_rcflags)
>  endif
>  CFLAGS_$(AMDDALPATH)/dc/dml/dml1_display_rq_dlg_calc.o :=3D
> $(dml_ccflags)  CFLAGS_$(AMDDALPATH)/dc/dml/display_rq_dlg_helpers.o
> :=3D $(dml_ccflags) @@ -99,6 +101,7 @@ DML +=3D
> dcn20/display_rq_dlg_calc_20v2.o dcn20/display_mode_vba_20v2.o  DML
> +=3D dcn21/display_rq_dlg_calc_21.o dcn21/display_mode_vba_21.o  DML +=3D
> dcn30/display_mode_vba_30.o dcn30/display_rq_dlg_calc_30.o  DML +=3D
> dcn31/display_mode_vba_31.o dcn31/display_rq_dlg_calc_31.o
> +DML +=3D dsc/rc_calc_fpu.o
>  endif
>=20
>  AMD_DAL_DML =3D $(addprefix $(AMDDALPATH)/dc/dml/,$(DML)) diff --git
> a/drivers/gpu/drm/amd/display/dc/dsc/qp_tables.h
> b/drivers/gpu/drm/amd/display/dc/dml/dsc/qp_tables.h
> similarity index 100%
> rename from drivers/gpu/drm/amd/display/dc/dsc/qp_tables.h
> rename to drivers/gpu/drm/amd/display/dc/dml/dsc/qp_tables.h
> diff --git a/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
> b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
> new file mode 100644
> index 0000000000000..3ee858f311d12
> --- /dev/null
> +++ b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
> @@ -0,0 +1,291 @@
> +/*
> + * Copyright 2021 Advanced Micro Devices, Inc.
> + *
> + * Permission is hereby granted, free of charge, to any person
> +obtaining a
> + * copy of this software and associated documentation files (the
> +"Software"),
> + * to deal in the Software without restriction, including without
> +limitation
> + * the rights to use, copy, modify, merge, publish, distribute,
> +sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom
> +the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be
> +included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> +EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> +MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO
> EVENT
> +SHALL
> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM,
> +DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
> +OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
> THE USE
> +OR
> + * OTHER DEALINGS IN THE SOFTWARE.
> + *
> + * Authors: AMD
> + *
> + */
> +
> +#include "rc_calc_fpu.h"
> +
> +#include "qp_tables.h"
> +#include "amdgpu_dm/dc_fpu.h"
> +
> +#define table_hash(mode, bpc, max_min) ((mode << 16) | (bpc << 8) |
> +max_min)
> +
> +#define MODE_SELECT(val444, val422, val420) \
> +	(cm =3D=3D CM_444 || cm =3D=3D CM_RGB) ? (val444) : (cm =3D=3D CM_422 ?
> (val422) :
> +(val420))
> +
> +
> +#define TABLE_CASE(mode, bpc, max)   case (table_hash(mode,
> BPC_##bpc, max)): \
> +	table =3D qp_table_##mode##_##bpc##bpc_##max; \
> +	table_size =3D
> sizeof(qp_table_##mode##_##bpc##bpc_##max)/sizeof(*qp_table_##mo
> de##_##bpc##bpc_##max); \
> +	break
> +
> +static int median3(int a, int b, int c) {
> +	if (a > b)
> +		swap(a, b);
> +	if (b > c)
> +		swap(b, c);
> +	if (a > b)
> +		swap(b, c);
> +
> +	return b;
> +}
> +
> +static double dsc_roundf(double num)
> +{
> +	if (num < 0.0)
> +		num =3D num - 0.5;
> +	else
> +		num =3D num + 0.5;
> +
> +	return (int)(num);
> +}
> +
> +static double dsc_ceil(double num)
> +{
> +	double retval =3D (int)num;
> +
> +	if (retval !=3D num && num > 0)
> +		retval =3D num + 1;
> +
> +	return (int)retval;
> +}
> +
> +static void get_qp_set(qp_set qps, enum colour_mode cm, enum
> bits_per_comp bpc,
> +		       enum max_min max_min, float bpp) {
> +	int mode =3D MODE_SELECT(444, 422, 420);
> +	int sel =3D table_hash(mode, bpc, max_min);
> +	int table_size =3D 0;
> +	int index;
> +	const struct qp_entry *table =3D 0L;
> +
> +	// alias enum
> +	enum { min =3D DAL_MM_MIN, max =3D DAL_MM_MAX };
> +	switch (sel) {
> +		TABLE_CASE(444,  8, max);
> +		TABLE_CASE(444,  8, min);
> +		TABLE_CASE(444, 10, max);
> +		TABLE_CASE(444, 10, min);
> +		TABLE_CASE(444, 12, max);
> +		TABLE_CASE(444, 12, min);
> +		TABLE_CASE(422,  8, max);
> +		TABLE_CASE(422,  8, min);
> +		TABLE_CASE(422, 10, max);
> +		TABLE_CASE(422, 10, min);
> +		TABLE_CASE(422, 12, max);
> +		TABLE_CASE(422, 12, min);
> +		TABLE_CASE(420,  8, max);
> +		TABLE_CASE(420,  8, min);
> +		TABLE_CASE(420, 10, max);
> +		TABLE_CASE(420, 10, min);
> +		TABLE_CASE(420, 12, max);
> +		TABLE_CASE(420, 12, min);
> +	}
> +
> +	if (table =3D=3D 0)
> +		return;
> +
> +	index =3D (bpp - table[0].bpp) * 2;
> +
> +	/* requested size is bigger than the table */
> +	if (index >=3D table_size) {
> +		dm_error("ERROR: Requested rc_calc to find a bpp entry that
> exceeds the table size\n");
> +		return;
> +	}
> +
> +	memcpy(qps, table[index].qps, sizeof(qp_set)); }
> +
> +static void get_ofs_set(qp_set ofs, enum colour_mode mode, float bpp) {
> +	int   *p =3D ofs;
> +
> +	if (mode =3D=3D CM_444 || mode =3D=3D CM_RGB) {
> +		*p++ =3D (bpp <=3D  6) ? (0) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? (=
2)
> : ((bpp >=3D 15) ? (10) : ((((bpp > 6) && (bpp < 8))) ? (0 + dsc_roundf((=
bpp -  6) *
> (2 / 2.0))) : (2 + dsc_roundf((bpp - 12) * (8 / 3.0))))));
> +		*p++ =3D (bpp <=3D  6) ? (-2) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? =
(0)
> : ((bpp >=3D 15) ? (8) : ((((bpp > 6) && (bpp < 8))) ? (-2 + dsc_roundf((=
bpp -  6) *
> (2 / 2.0))) : (0 + dsc_roundf((bpp - 12) * (8 / 3.0))))));
> +		*p++ =3D (bpp <=3D  6) ? (-2) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? =
(0)
> : ((bpp >=3D 15) ? (6) : ((((bpp > 6) && (bpp < 8))) ? (-2 + dsc_roundf((=
bpp -  6) *
> (2 / 2.0))) : (0 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
> +		*p++ =3D (bpp <=3D  6) ? (-4) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? =
(-
> 2) : ((bpp >=3D 15) ? (4) : ((((bpp > 6) && (bpp < 8))) ? (-4 + dsc_round=
f((bpp -
> 6) * (2 / 2.0))) : (-2 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
> +		*p++ =3D (bpp <=3D  6) ? (-6) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? =
(-
> 4) : ((bpp >=3D 15) ? (2) : ((((bpp > 6) && (bpp < 8))) ? (-6 + dsc_round=
f((bpp -
> 6) * (2 / 2.0))) : (-4 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
> +		*p++ =3D (bpp <=3D 12) ? (-6) : ((bpp >=3D 15) ? (0) : (-6 +
> dsc_roundf((bpp - 12) * (6 / 3.0))));
> +		*p++ =3D (bpp <=3D 12) ? (-8) : ((bpp >=3D 15) ? (-2) : (-8 +
> dsc_roundf((bpp - 12) * (6 / 3.0))));
> +		*p++ =3D (bpp <=3D 12) ? (-8) : ((bpp >=3D 15) ? (-4) : (-8 +
> dsc_roundf((bpp - 12) * (4 / 3.0))));
> +		*p++ =3D (bpp <=3D 12) ? (-8) : ((bpp >=3D 15) ? (-6) : (-8 +
> dsc_roundf((bpp - 12) * (2 / 3.0))));
> +		*p++ =3D (bpp <=3D 12) ? (-10) : ((bpp >=3D 15) ? (-8) : (-10 +
> dsc_roundf((bpp - 12) * (2 / 3.0))));
> +		*p++ =3D -10;
> +		*p++ =3D (bpp <=3D  6) ? (-12) : ((bpp >=3D  8) ? (-10) : (-12 +
> dsc_roundf((bpp -  6) * (2 / 2.0))));
> +		*p++ =3D -12;
> +		*p++ =3D -12;
> +		*p++ =3D -12;
> +	} else if (mode =3D=3D CM_422) {
> +		*p++ =3D (bpp <=3D  8) ? (2) : ((bpp >=3D 10) ? (10) : (2 +
> dsc_roundf((bpp -  8) * (8 / 2.0))));
> +		*p++ =3D (bpp <=3D  8) ? (0) : ((bpp >=3D 10) ? (8) : (0 +
> dsc_roundf((bpp -  8) * (8 / 2.0))));
> +		*p++ =3D (bpp <=3D  8) ? (0) : ((bpp >=3D 10) ? (6) : (0 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  8) ? (-2) : ((bpp >=3D 10) ? (4) : (-2 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  8) ? (-4) : ((bpp >=3D 10) ? (2) : (-4 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  8) ? (-6) : ((bpp >=3D 10) ? (0) : (-6 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  8) ? (-8) : ((bpp >=3D 10) ? (-2) : (-8 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  8) ? (-8) : ((bpp >=3D 10) ? (-4) : (-8 +
> dsc_roundf((bpp -  8) * (4 / 2.0))));
> +		*p++ =3D (bpp <=3D  8) ? (-8) : ((bpp >=3D 10) ? (-6) : (-8 +
> dsc_roundf((bpp -  8) * (2 / 2.0))));
> +		*p++ =3D (bpp <=3D  8) ? (-10) : ((bpp >=3D 10) ? (-8) : (-10 +
> dsc_roundf((bpp -  8) * (2 / 2.0))));
> +		*p++ =3D -10;
> +		*p++ =3D (bpp <=3D  6) ? (-12) : ((bpp >=3D 7) ? (-10) : (-12 +
> dsc_roundf((bpp -  6) * (2.0 / 1))));
> +		*p++ =3D -12;
> +		*p++ =3D -12;
> +		*p++ =3D -12;
> +	} else {
> +		*p++ =3D (bpp <=3D  6) ? (2) : ((bpp >=3D  8) ? (10) : (2 +
> dsc_roundf((bpp -  6) * (8 / 2.0))));
> +		*p++ =3D (bpp <=3D  6) ? (0) : ((bpp >=3D  8) ? (8) : (0 +
> dsc_roundf((bpp -  6) * (8 / 2.0))));
> +		*p++ =3D (bpp <=3D  6) ? (0) : ((bpp >=3D  8) ? (6) : (0 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  6) ? (-2) : ((bpp >=3D  8) ? (4) : (-2 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  6) ? (-4) : ((bpp >=3D  8) ? (2) : (-4 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  6) ? (-6) : ((bpp >=3D  8) ? (0) : (-6 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  6) ? (-8) : ((bpp >=3D  8) ? (-2) : (-8 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> +		*p++ =3D (bpp <=3D  6) ? (-8) : ((bpp >=3D  8) ? (-4) : (-8 +
> dsc_roundf((bpp -  6) * (4 / 2.0))));
> +		*p++ =3D (bpp <=3D  6) ? (-8) : ((bpp >=3D  8) ? (-6) : (-8 +
> dsc_roundf((bpp -  6) * (2 / 2.0))));
> +		*p++ =3D (bpp <=3D  6) ? (-10) : ((bpp >=3D  8) ? (-8) : (-10 +
> dsc_roundf((bpp -  6) * (2 / 2.0))));
> +		*p++ =3D -10;
> +		*p++ =3D (bpp <=3D  4) ? (-12) : ((bpp >=3D  5) ? (-10) : (-12 +
> dsc_roundf((bpp -  4) * (2 / 1.0))));
> +		*p++ =3D -12;
> +		*p++ =3D -12;
> +		*p++ =3D -12;
> +	}
> +}
> +
> +void _do_calc_rc_params(struct rc_params *rc,
> +		enum colour_mode cm,
> +		enum bits_per_comp bpc,
> +		u16 drm_bpp,
> +		bool is_navite_422_or_420,
> +		int slice_width,
> +		int slice_height,
> +		int minor_version)
> +{
> +	float bpp;
> +	float bpp_group;
> +	float initial_xmit_delay_factor;
> +	int padding_pixels;
> +	int i;
> +
> +	dc_assert_fp_enabled();
> +
> +	bpp =3D ((float)drm_bpp / 16.0);
> +	/* in native_422 or native_420 modes, the bits_per_pixel is double
> the
> +	 * target bpp (the latter is what calc_rc_params expects)
> +	 */
> +	if (is_navite_422_or_420)
> +		bpp /=3D 2.0;
> +
> +	rc->rc_quant_incr_limit0 =3D ((bpc =3D=3D BPC_8) ? 11 : (bpc =3D=3D BPC=
_10 ? 15
> : 19)) - ((minor_version =3D=3D 1 && cm =3D=3D CM_444) ? 1 : 0);
> +	rc->rc_quant_incr_limit1 =3D ((bpc =3D=3D BPC_8) ? 11 : (bpc =3D=3D BPC=
_10 ? 15
> +: 19)) - ((minor_version =3D=3D 1 && cm =3D=3D CM_444) ? 1 : 0);
> +
> +	bpp_group =3D MODE_SELECT(bpp, bpp * 2.0, bpp * 2.0);
> +
> +	switch (cm) {
> +	case CM_420:
> +		rc->initial_fullness_offset =3D (bpp >=3D  6) ? (2048) : ((bpp <=3D  4=
)
> ? (6144) : ((((bpp >  4) && (bpp <=3D  5))) ? (6144 - dsc_roundf((bpp - 4=
) *
> (512))) : (5632 - dsc_roundf((bpp -  5) * (3584)))));
> +		rc->first_line_bpg_offset   =3D median3(0, (12 + (int) (0.09 *
> min(34, slice_height - 8))), (int)((3 * bpc * 3) - (3 * bpp_group)));
> +		rc->second_line_bpg_offset  =3D median3(0, 12, (int)((3 * bpc *
> 3) - (3 * bpp_group)));
> +		break;
> +	case CM_422:
> +		rc->initial_fullness_offset =3D (bpp >=3D  8) ? (2048) : ((bpp <=3D  7=
)
> ? (5632) : (5632 - dsc_roundf((bpp - 7) * (3584))));
> +		rc->first_line_bpg_offset   =3D median3(0, (12 + (int) (0.09 *
> min(34, slice_height - 8))), (int)((3 * bpc * 4) - (3 * bpp_group)));
> +		rc->second_line_bpg_offset  =3D 0;
> +		break;
> +	case CM_444:
> +	case CM_RGB:
> +		rc->initial_fullness_offset =3D (bpp >=3D 12) ? (2048) : ((bpp <=3D  8=
)
> ? (6144) : ((((bpp >  8) && (bpp <=3D 10))) ? (6144 - dsc_roundf((bpp - 8=
) * (512 /
> 2))) : (5632 - dsc_roundf((bpp - 10) * (3584 / 2)))));
> +		rc->first_line_bpg_offset   =3D median3(0, (12 + (int) (0.09 *
> min(34, slice_height - 8))), (int)(((3 * bpc + (cm =3D=3D CM_444 ? 0 : 2)=
) * 3) - (3 *
> bpp_group)));
> +		rc->second_line_bpg_offset  =3D 0;
> +		break;
> +	}
> +
> +	initial_xmit_delay_factor =3D (cm =3D=3D CM_444 || cm =3D=3D CM_RGB) ? =
1.0 :
> 2.0;
> +	rc->initial_xmit_delay =3D
> +dsc_roundf(8192.0/2.0/bpp/initial_xmit_delay_factor);
> +
> +	if (cm =3D=3D CM_422 || cm =3D=3D CM_420)
> +		slice_width /=3D 2;
> +
> +	padding_pixels =3D ((slice_width % 3) !=3D 0) ? (3 - (slice_width % 3))=
 *
> (rc->initial_xmit_delay / slice_width) : 0;
> +	if (3 * bpp_group >=3D (((rc->initial_xmit_delay + 2) / 3) * (3 + (cm =
=3D=3D
> CM_422)))) {
> +		if ((rc->initial_xmit_delay + padding_pixels) % 3 =3D=3D 1)
> +			rc->initial_xmit_delay++;
> +	}
> +
> +	rc->flatness_min_qp     =3D ((bpc =3D=3D BPC_8) ?  (3) : ((bpc =3D=3D B=
PC_10) ?
> (7)  : (11))) - ((minor_version =3D=3D 1 && cm =3D=3D CM_444) ? 1 : 0);
> +	rc->flatness_max_qp     =3D ((bpc =3D=3D BPC_8) ? (12) : ((bpc =3D=3D B=
PC_10) ?
> (16) : (20))) - ((minor_version =3D=3D 1 && cm =3D=3D CM_444) ? 1 : 0);
> +	rc->flatness_det_thresh =3D 2 << (bpc - 8);
> +
> +	get_qp_set(rc->qp_min, cm, bpc, DAL_MM_MIN, bpp);
> +	get_qp_set(rc->qp_max, cm, bpc, DAL_MM_MAX, bpp);
> +	if (cm =3D=3D CM_444 && minor_version =3D=3D 1) {
> +		for (i =3D 0; i < QP_SET_SIZE; ++i) {
> +			rc->qp_min[i] =3D rc->qp_min[i] > 0 ? rc->qp_min[i] - 1 :
> 0;
> +			rc->qp_max[i] =3D rc->qp_max[i] > 0 ? rc->qp_max[i] -
> 1 : 0;
> +		}
> +	}
> +	get_ofs_set(rc->ofs, cm, bpp);
> +
> +	/* fixed parameters */
> +	rc->rc_model_size    =3D 8192;
> +	rc->rc_edge_factor   =3D 6;
> +	rc->rc_tgt_offset_hi =3D 3;
> +	rc->rc_tgt_offset_lo =3D 3;
> +
> +	rc->rc_buf_thresh[0] =3D 896;
> +	rc->rc_buf_thresh[1] =3D 1792;
> +	rc->rc_buf_thresh[2] =3D 2688;
> +	rc->rc_buf_thresh[3] =3D 3584;
> +	rc->rc_buf_thresh[4] =3D 4480;
> +	rc->rc_buf_thresh[5] =3D 5376;
> +	rc->rc_buf_thresh[6] =3D 6272;
> +	rc->rc_buf_thresh[7] =3D 6720;
> +	rc->rc_buf_thresh[8] =3D 7168;
> +	rc->rc_buf_thresh[9] =3D 7616;
> +	rc->rc_buf_thresh[10] =3D 7744;
> +	rc->rc_buf_thresh[11] =3D 7872;
> +	rc->rc_buf_thresh[12] =3D 8000;
> +	rc->rc_buf_thresh[13] =3D 8064;
> +}
> +
> +u32 _do_bytes_per_pixel_calc(int slice_width,
> +		u16 drm_bpp,
> +		bool is_navite_422_or_420)
> +{
> +	float bpp;
> +	u32 bytes_per_pixel;
> +	double d_bytes_per_pixel;
> +
> +	dc_assert_fp_enabled();
> +
> +	bpp =3D ((float)drm_bpp / 16.0);
> +	d_bytes_per_pixel =3D dsc_ceil(bpp * slice_width / 8.0) / slice_width;
> +	// TODO: Make sure the formula for calculating this is precise (ceiling
> +	// vs. floor, and at what point they should be applied)
> +	if (is_navite_422_or_420)
> +		d_bytes_per_pixel /=3D 2;
> +
> +	bytes_per_pixel =3D (u32)dsc_ceil(d_bytes_per_pixel * 0x10000000);
> +
> +	return bytes_per_pixel;
> +}
> diff --git a/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.h
> b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.h
> new file mode 100644
> index 0000000000000..b93b95409fbe2
> --- /dev/null
> +++ b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.h
> @@ -0,0 +1,94 @@
> +/*
> + * Copyright 2021 Advanced Micro Devices, Inc.
> + *
> + * Permission is hereby granted, free of charge, to any person
> +obtaining a
> + * copy of this software and associated documentation files (the
> +"Software"),
> + * to deal in the Software without restriction, including without
> +limitation
> + * the rights to use, copy, modify, merge, publish, distribute,
> +sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom
> +the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be
> +included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> +EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> +MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO
> EVENT
> +SHALL
> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM,
> +DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
> +OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
> THE USE
> +OR
> + * OTHER DEALINGS IN THE SOFTWARE.
> + *
> + * Authors: AMD
> + *
> + */
> +
> +#ifndef __RC_CALC_FPU_H__
> +#define __RC_CALC_FPU_H__
> +
> +#include "os_types.h"
> +#include <drm/drm_dsc.h>
> +
> +#define QP_SET_SIZE 15
> +
> +typedef int qp_set[QP_SET_SIZE];
> +
> +struct rc_params {
> +	int      rc_quant_incr_limit0;
> +	int      rc_quant_incr_limit1;
> +	int      initial_fullness_offset;
> +	int      initial_xmit_delay;
> +	int      first_line_bpg_offset;
> +	int      second_line_bpg_offset;
> +	int      flatness_min_qp;
> +	int      flatness_max_qp;
> +	int      flatness_det_thresh;
> +	qp_set   qp_min;
> +	qp_set   qp_max;
> +	qp_set   ofs;
> +	int      rc_model_size;
> +	int      rc_edge_factor;
> +	int      rc_tgt_offset_hi;
> +	int      rc_tgt_offset_lo;
> +	int      rc_buf_thresh[QP_SET_SIZE - 1];
> +};
> +
> +enum colour_mode {
> +	CM_RGB,   /* 444 RGB */
> +	CM_444,   /* 444 YUV or simple 422 */
> +	CM_422,   /* native 422 */
> +	CM_420    /* native 420 */
> +};
> +
> +enum bits_per_comp {
> +	BPC_8  =3D  8,
> +	BPC_10 =3D 10,
> +	BPC_12 =3D 12
> +};
> +
> +enum max_min {
> +	DAL_MM_MIN =3D 0,
> +	DAL_MM_MAX =3D 1
> +};
> +
> +struct qp_entry {
> +	float         bpp;
> +	const qp_set  qps;
> +};
> +
> +typedef struct qp_entry qp_table[];
> +
> +u32 _do_bytes_per_pixel_calc(int slice_width,
> +		u16 drm_bpp,
> +		bool is_navite_422_or_420);
> +
> +void _do_calc_rc_params(struct rc_params *rc,
> +		enum colour_mode cm,
> +		enum bits_per_comp bpc,
> +		u16 drm_bpp,
> +		bool is_navite_422_or_420,
> +		int slice_width,
> +		int slice_height,
> +		int minor_version);
> +
> +#endif
> diff --git a/drivers/gpu/drm/amd/display/dc/dsc/Makefile
> b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
> index 8d31eb75c6a6e..a2537229ee88b 100644
> --- a/drivers/gpu/drm/amd/display/dc/dsc/Makefile
> +++ b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
> @@ -1,35 +1,6 @@
>  # SPDX-License-Identifier: MIT
>  #
>  # Makefile for the 'dsc' sub-component of DAL.
> -
> -ifdef CONFIG_X86
> -dsc_ccflags :=3D -mhard-float -msse
> -endif
> -
> -ifdef CONFIG_PPC64
> -dsc_ccflags :=3D -mhard-float -maltivec
> -endif
> -
> -ifdef CONFIG_CC_IS_GCC
> -ifeq ($(call cc-ifversion, -lt, 0701, y), y) -IS_OLD_GCC =3D 1 -endif -e=
ndif
> -
> -ifdef CONFIG_X86
> -ifdef IS_OLD_GCC
> -# Stack alignment mismatch, proceed with caution.
> -# GCC < 7.1 cannot compile code using `double` and -mpreferred-stack-
> boundary=3D3 -# (8B stack alignment).
> -dsc_ccflags +=3D -mpreferred-stack-boundary=3D4 -else -dsc_ccflags +=3D =
-msse2 -
> endif -endif
> -
> -CFLAGS_$(AMDDALPATH)/dc/dsc/rc_calc.o :=3D $(dsc_ccflags) -
> CFLAGS_REMOVE_$(AMDDALPATH)/dc/dsc/rc_calc.o :=3D $(dsc_rcflags)
> -
>  DSC =3D dc_dsc.o rc_calc.o rc_calc_dpi.o
>=20
>  AMD_DAL_DSC =3D $(addprefix $(AMDDALPATH)/dc/dsc/,$(DSC)) diff --git
> a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
> b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
> index 7b294f637881a..b19d3aeb5962c 100644
> --- a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
> +++ b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
> @@ -23,266 +23,7 @@
>   * Authors: AMD
>   *
>   */
> -#include <drm/drm_dsc.h>
> -
> -#include "os_types.h"
>  #include "rc_calc.h"
> -#include "qp_tables.h"
> -
> -#define table_hash(mode, bpc, max_min) ((mode << 16) | (bpc << 8) |
> max_min)
> -
> -#define MODE_SELECT(val444, val422, val420) \
> -	(cm =3D=3D CM_444 || cm =3D=3D CM_RGB) ? (val444) : (cm =3D=3D CM_422 ?
> (val422) : (val420))
> -
> -
> -#define TABLE_CASE(mode, bpc, max)   case (table_hash(mode,
> BPC_##bpc, max)): \
> -	table =3D qp_table_##mode##_##bpc##bpc_##max; \
> -	table_size =3D
> sizeof(qp_table_##mode##_##bpc##bpc_##max)/sizeof(*qp_table_##mo
> de##_##bpc##bpc_##max); \
> -	break
> -
> -
> -static void get_qp_set(qp_set qps, enum colour_mode cm, enum
> bits_per_comp bpc,
> -		       enum max_min max_min, float bpp)
> -{
> -	int mode =3D MODE_SELECT(444, 422, 420);
> -	int sel =3D table_hash(mode, bpc, max_min);
> -	int table_size =3D 0;
> -	int index;
> -	const struct qp_entry *table =3D 0L;
> -
> -	// alias enum
> -	enum { min =3D DAL_MM_MIN, max =3D DAL_MM_MAX };
> -	switch (sel) {
> -		TABLE_CASE(444,  8, max);
> -		TABLE_CASE(444,  8, min);
> -		TABLE_CASE(444, 10, max);
> -		TABLE_CASE(444, 10, min);
> -		TABLE_CASE(444, 12, max);
> -		TABLE_CASE(444, 12, min);
> -		TABLE_CASE(422,  8, max);
> -		TABLE_CASE(422,  8, min);
> -		TABLE_CASE(422, 10, max);
> -		TABLE_CASE(422, 10, min);
> -		TABLE_CASE(422, 12, max);
> -		TABLE_CASE(422, 12, min);
> -		TABLE_CASE(420,  8, max);
> -		TABLE_CASE(420,  8, min);
> -		TABLE_CASE(420, 10, max);
> -		TABLE_CASE(420, 10, min);
> -		TABLE_CASE(420, 12, max);
> -		TABLE_CASE(420, 12, min);
> -	}
> -
> -	if (table =3D=3D 0)
> -		return;
> -
> -	index =3D (bpp - table[0].bpp) * 2;
> -
> -	/* requested size is bigger than the table */
> -	if (index >=3D table_size) {
> -		dm_error("ERROR: Requested rc_calc to find a bpp entry that
> exceeds the table size\n");
> -		return;
> -	}
> -
> -	memcpy(qps, table[index].qps, sizeof(qp_set));
> -}
> -
> -static double dsc_roundf(double num)
> -{
> -	if (num < 0.0)
> -		num =3D num - 0.5;
> -	else
> -		num =3D num + 0.5;
> -
> -	return (int)(num);
> -}
> -
> -static double dsc_ceil(double num)
> -{
> -	double retval =3D (int)num;
> -
> -	if (retval !=3D num && num > 0)
> -		retval =3D num + 1;
> -
> -	return (int)retval;
> -}
> -
> -static void get_ofs_set(qp_set ofs, enum colour_mode mode, float bpp) -{
> -	int   *p =3D ofs;
> -
> -	if (mode =3D=3D CM_444 || mode =3D=3D CM_RGB) {
> -		*p++ =3D (bpp <=3D  6) ? (0) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? (=
2)
> : ((bpp >=3D 15) ? (10) : ((((bpp > 6) && (bpp < 8))) ? (0 + dsc_roundf((=
bpp -  6) *
> (2 / 2.0))) : (2 + dsc_roundf((bpp - 12) * (8 / 3.0))))));
> -		*p++ =3D (bpp <=3D  6) ? (-2) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? =
(0)
> : ((bpp >=3D 15) ? (8) : ((((bpp > 6) && (bpp < 8))) ? (-2 + dsc_roundf((=
bpp -  6) *
> (2 / 2.0))) : (0 + dsc_roundf((bpp - 12) * (8 / 3.0))))));
> -		*p++ =3D (bpp <=3D  6) ? (-2) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? =
(0)
> : ((bpp >=3D 15) ? (6) : ((((bpp > 6) && (bpp < 8))) ? (-2 + dsc_roundf((=
bpp -  6) *
> (2 / 2.0))) : (0 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
> -		*p++ =3D (bpp <=3D  6) ? (-4) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? =
(-
> 2) : ((bpp >=3D 15) ? (4) : ((((bpp > 6) && (bpp < 8))) ? (-4 + dsc_round=
f((bpp -
> 6) * (2 / 2.0))) : (-2 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
> -		*p++ =3D (bpp <=3D  6) ? (-6) : ((((bpp >=3D  8) && (bpp <=3D 12))) ? =
(-
> 4) : ((bpp >=3D 15) ? (2) : ((((bpp > 6) && (bpp < 8))) ? (-6 + dsc_round=
f((bpp -
> 6) * (2 / 2.0))) : (-4 + dsc_roundf((bpp - 12) * (6 / 3.0))))));
> -		*p++ =3D (bpp <=3D 12) ? (-6) : ((bpp >=3D 15) ? (0) : (-6 +
> dsc_roundf((bpp - 12) * (6 / 3.0))));
> -		*p++ =3D (bpp <=3D 12) ? (-8) : ((bpp >=3D 15) ? (-2) : (-8 +
> dsc_roundf((bpp - 12) * (6 / 3.0))));
> -		*p++ =3D (bpp <=3D 12) ? (-8) : ((bpp >=3D 15) ? (-4) : (-8 +
> dsc_roundf((bpp - 12) * (4 / 3.0))));
> -		*p++ =3D (bpp <=3D 12) ? (-8) : ((bpp >=3D 15) ? (-6) : (-8 +
> dsc_roundf((bpp - 12) * (2 / 3.0))));
> -		*p++ =3D (bpp <=3D 12) ? (-10) : ((bpp >=3D 15) ? (-8) : (-10 +
> dsc_roundf((bpp - 12) * (2 / 3.0))));
> -		*p++ =3D -10;
> -		*p++ =3D (bpp <=3D  6) ? (-12) : ((bpp >=3D  8) ? (-10) : (-12 +
> dsc_roundf((bpp -  6) * (2 / 2.0))));
> -		*p++ =3D -12;
> -		*p++ =3D -12;
> -		*p++ =3D -12;
> -	} else if (mode =3D=3D CM_422) {
> -		*p++ =3D (bpp <=3D  8) ? (2) : ((bpp >=3D 10) ? (10) : (2 +
> dsc_roundf((bpp -  8) * (8 / 2.0))));
> -		*p++ =3D (bpp <=3D  8) ? (0) : ((bpp >=3D 10) ? (8) : (0 +
> dsc_roundf((bpp -  8) * (8 / 2.0))));
> -		*p++ =3D (bpp <=3D  8) ? (0) : ((bpp >=3D 10) ? (6) : (0 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  8) ? (-2) : ((bpp >=3D 10) ? (4) : (-2 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  8) ? (-4) : ((bpp >=3D 10) ? (2) : (-4 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  8) ? (-6) : ((bpp >=3D 10) ? (0) : (-6 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  8) ? (-8) : ((bpp >=3D 10) ? (-2) : (-8 +
> dsc_roundf((bpp -  8) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  8) ? (-8) : ((bpp >=3D 10) ? (-4) : (-8 +
> dsc_roundf((bpp -  8) * (4 / 2.0))));
> -		*p++ =3D (bpp <=3D  8) ? (-8) : ((bpp >=3D 10) ? (-6) : (-8 +
> dsc_roundf((bpp -  8) * (2 / 2.0))));
> -		*p++ =3D (bpp <=3D  8) ? (-10) : ((bpp >=3D 10) ? (-8) : (-10 +
> dsc_roundf((bpp -  8) * (2 / 2.0))));
> -		*p++ =3D -10;
> -		*p++ =3D (bpp <=3D  6) ? (-12) : ((bpp >=3D 7) ? (-10) : (-12 +
> dsc_roundf((bpp -  6) * (2.0 / 1))));
> -		*p++ =3D -12;
> -		*p++ =3D -12;
> -		*p++ =3D -12;
> -	} else {
> -		*p++ =3D (bpp <=3D  6) ? (2) : ((bpp >=3D  8) ? (10) : (2 +
> dsc_roundf((bpp -  6) * (8 / 2.0))));
> -		*p++ =3D (bpp <=3D  6) ? (0) : ((bpp >=3D  8) ? (8) : (0 +
> dsc_roundf((bpp -  6) * (8 / 2.0))));
> -		*p++ =3D (bpp <=3D  6) ? (0) : ((bpp >=3D  8) ? (6) : (0 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  6) ? (-2) : ((bpp >=3D  8) ? (4) : (-2 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  6) ? (-4) : ((bpp >=3D  8) ? (2) : (-4 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  6) ? (-6) : ((bpp >=3D  8) ? (0) : (-6 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  6) ? (-8) : ((bpp >=3D  8) ? (-2) : (-8 +
> dsc_roundf((bpp -  6) * (6 / 2.0))));
> -		*p++ =3D (bpp <=3D  6) ? (-8) : ((bpp >=3D  8) ? (-4) : (-8 +
> dsc_roundf((bpp -  6) * (4 / 2.0))));
> -		*p++ =3D (bpp <=3D  6) ? (-8) : ((bpp >=3D  8) ? (-6) : (-8 +
> dsc_roundf((bpp -  6) * (2 / 2.0))));
> -		*p++ =3D (bpp <=3D  6) ? (-10) : ((bpp >=3D  8) ? (-8) : (-10 +
> dsc_roundf((bpp -  6) * (2 / 2.0))));
> -		*p++ =3D -10;
> -		*p++ =3D (bpp <=3D  4) ? (-12) : ((bpp >=3D  5) ? (-10) : (-12 +
> dsc_roundf((bpp -  4) * (2 / 1.0))));
> -		*p++ =3D -12;
> -		*p++ =3D -12;
> -		*p++ =3D -12;
> -	}
> -}
> -
> -static int median3(int a, int b, int c) -{
> -	if (a > b)
> -		swap(a, b);
> -	if (b > c)
> -		swap(b, c);
> -	if (a > b)
> -		swap(b, c);
> -
> -	return b;
> -}
> -
> -static void _do_calc_rc_params(struct rc_params *rc, enum colour_mode
> cm,
> -			       enum bits_per_comp bpc, u16 drm_bpp,
> -			       bool is_navite_422_or_420,
> -			       int slice_width, int slice_height,
> -			       int minor_version)
> -{
> -	float bpp;
> -	float bpp_group;
> -	float initial_xmit_delay_factor;
> -	int padding_pixels;
> -	int i;
> -
> -	bpp =3D ((float)drm_bpp / 16.0);
> -	/* in native_422 or native_420 modes, the bits_per_pixel is double
> the
> -	 * target bpp (the latter is what calc_rc_params expects)
> -	 */
> -	if (is_navite_422_or_420)
> -		bpp /=3D 2.0;
> -
> -	rc->rc_quant_incr_limit0 =3D ((bpc =3D=3D BPC_8) ? 11 : (bpc =3D=3D BPC=
_10 ? 15
> : 19)) - ((minor_version =3D=3D 1 && cm =3D=3D CM_444) ? 1 : 0);
> -	rc->rc_quant_incr_limit1 =3D ((bpc =3D=3D BPC_8) ? 11 : (bpc =3D=3D BPC=
_10 ? 15
> : 19)) - ((minor_version =3D=3D 1 && cm =3D=3D CM_444) ? 1 : 0);
> -
> -	bpp_group =3D MODE_SELECT(bpp, bpp * 2.0, bpp * 2.0);
> -
> -	switch (cm) {
> -	case CM_420:
> -		rc->initial_fullness_offset =3D (bpp >=3D  6) ? (2048) : ((bpp <=3D  4=
)
> ? (6144) : ((((bpp >  4) && (bpp <=3D  5))) ? (6144 - dsc_roundf((bpp - 4=
) *
> (512))) : (5632 - dsc_roundf((bpp -  5) * (3584)))));
> -		rc->first_line_bpg_offset   =3D median3(0, (12 + (int) (0.09 *
> min(34, slice_height - 8))), (int)((3 * bpc * 3) - (3 * bpp_group)));
> -		rc->second_line_bpg_offset  =3D median3(0, 12, (int)((3 * bpc *
> 3) - (3 * bpp_group)));
> -		break;
> -	case CM_422:
> -		rc->initial_fullness_offset =3D (bpp >=3D  8) ? (2048) : ((bpp <=3D  7=
)
> ? (5632) : (5632 - dsc_roundf((bpp - 7) * (3584))));
> -		rc->first_line_bpg_offset   =3D median3(0, (12 + (int) (0.09 *
> min(34, slice_height - 8))), (int)((3 * bpc * 4) - (3 * bpp_group)));
> -		rc->second_line_bpg_offset  =3D 0;
> -		break;
> -	case CM_444:
> -	case CM_RGB:
> -		rc->initial_fullness_offset =3D (bpp >=3D 12) ? (2048) : ((bpp <=3D  8=
)
> ? (6144) : ((((bpp >  8) && (bpp <=3D 10))) ? (6144 - dsc_roundf((bpp - 8=
) * (512 /
> 2))) : (5632 - dsc_roundf((bpp - 10) * (3584 / 2)))));
> -		rc->first_line_bpg_offset   =3D median3(0, (12 + (int) (0.09 *
> min(34, slice_height - 8))), (int)(((3 * bpc + (cm =3D=3D CM_444 ? 0 : 2)=
) * 3) - (3 *
> bpp_group)));
> -		rc->second_line_bpg_offset  =3D 0;
> -		break;
> -	}
> -
> -	initial_xmit_delay_factor =3D (cm =3D=3D CM_444 || cm =3D=3D CM_RGB) ? =
1.0 :
> 2.0;
> -	rc->initial_xmit_delay =3D
> dsc_roundf(8192.0/2.0/bpp/initial_xmit_delay_factor);
> -
> -	if (cm =3D=3D CM_422 || cm =3D=3D CM_420)
> -		slice_width /=3D 2;
> -
> -	padding_pixels =3D ((slice_width % 3) !=3D 0) ? (3 - (slice_width % 3))=
 *
> (rc->initial_xmit_delay / slice_width) : 0;
> -	if (3 * bpp_group >=3D (((rc->initial_xmit_delay + 2) / 3) * (3 + (cm =
=3D=3D
> CM_422)))) {
> -		if ((rc->initial_xmit_delay + padding_pixels) % 3 =3D=3D 1)
> -			rc->initial_xmit_delay++;
> -	}
> -
> -	rc->flatness_min_qp     =3D ((bpc =3D=3D BPC_8) ?  (3) : ((bpc =3D=3D B=
PC_10) ?
> (7)  : (11))) - ((minor_version =3D=3D 1 && cm =3D=3D CM_444) ? 1 : 0);
> -	rc->flatness_max_qp     =3D ((bpc =3D=3D BPC_8) ? (12) : ((bpc =3D=3D B=
PC_10) ?
> (16) : (20))) - ((minor_version =3D=3D 1 && cm =3D=3D CM_444) ? 1 : 0);
> -	rc->flatness_det_thresh =3D 2 << (bpc - 8);
> -
> -	get_qp_set(rc->qp_min, cm, bpc, DAL_MM_MIN, bpp);
> -	get_qp_set(rc->qp_max, cm, bpc, DAL_MM_MAX, bpp);
> -	if (cm =3D=3D CM_444 && minor_version =3D=3D 1) {
> -		for (i =3D 0; i < QP_SET_SIZE; ++i) {
> -			rc->qp_min[i] =3D rc->qp_min[i] > 0 ? rc->qp_min[i] - 1 :
> 0;
> -			rc->qp_max[i] =3D rc->qp_max[i] > 0 ? rc->qp_max[i] -
> 1 : 0;
> -		}
> -	}
> -	get_ofs_set(rc->ofs, cm, bpp);
> -
> -	/* fixed parameters */
> -	rc->rc_model_size    =3D 8192;
> -	rc->rc_edge_factor   =3D 6;
> -	rc->rc_tgt_offset_hi =3D 3;
> -	rc->rc_tgt_offset_lo =3D 3;
> -
> -	rc->rc_buf_thresh[0] =3D 896;
> -	rc->rc_buf_thresh[1] =3D 1792;
> -	rc->rc_buf_thresh[2] =3D 2688;
> -	rc->rc_buf_thresh[3] =3D 3584;
> -	rc->rc_buf_thresh[4] =3D 4480;
> -	rc->rc_buf_thresh[5] =3D 5376;
> -	rc->rc_buf_thresh[6] =3D 6272;
> -	rc->rc_buf_thresh[7] =3D 6720;
> -	rc->rc_buf_thresh[8] =3D 7168;
> -	rc->rc_buf_thresh[9] =3D 7616;
> -	rc->rc_buf_thresh[10] =3D 7744;
> -	rc->rc_buf_thresh[11] =3D 7872;
> -	rc->rc_buf_thresh[12] =3D 8000;
> -	rc->rc_buf_thresh[13] =3D 8064;
> -}
> -
> -static u32 _do_bytes_per_pixel_calc(int slice_width, u16 drm_bpp,
> -				    bool is_navite_422_or_420)
> -{
> -	float bpp;
> -	u32 bytes_per_pixel;
> -	double d_bytes_per_pixel;
> -
> -	bpp =3D ((float)drm_bpp / 16.0);
> -	d_bytes_per_pixel =3D dsc_ceil(bpp * slice_width / 8.0) / slice_width;
> -	// TODO: Make sure the formula for calculating this is precise (ceiling
> -	// vs. floor, and at what point they should be applied)
> -	if (is_navite_422_or_420)
> -		d_bytes_per_pixel /=3D 2;
> -
> -	bytes_per_pixel =3D (u32)dsc_ceil(d_bytes_per_pixel * 0x10000000);
> -
> -	return bytes_per_pixel;
> -}
>=20
>  /**
>   * calc_rc_params - reads the user's cmdline mode diff --git
> a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
> b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
> index 262f06afcbf95..c2340e001b578 100644
> --- a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
> +++ b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
> @@ -27,55 +27,7 @@
>  #ifndef __RC_CALC_H__
>  #define __RC_CALC_H__
>=20
> -
> -#define QP_SET_SIZE 15
> -
> -typedef int qp_set[QP_SET_SIZE];
> -
> -struct rc_params {
> -	int      rc_quant_incr_limit0;
> -	int      rc_quant_incr_limit1;
> -	int      initial_fullness_offset;
> -	int      initial_xmit_delay;
> -	int      first_line_bpg_offset;
> -	int      second_line_bpg_offset;
> -	int      flatness_min_qp;
> -	int      flatness_max_qp;
> -	int      flatness_det_thresh;
> -	qp_set   qp_min;
> -	qp_set   qp_max;
> -	qp_set   ofs;
> -	int      rc_model_size;
> -	int      rc_edge_factor;
> -	int      rc_tgt_offset_hi;
> -	int      rc_tgt_offset_lo;
> -	int      rc_buf_thresh[QP_SET_SIZE - 1];
> -};
> -
> -enum colour_mode {
> -	CM_RGB,   /* 444 RGB */
> -	CM_444,   /* 444 YUV or simple 422 */
> -	CM_422,   /* native 422 */
> -	CM_420    /* native 420 */
> -};
> -
> -enum bits_per_comp {
> -	BPC_8  =3D  8,
> -	BPC_10 =3D 10,
> -	BPC_12 =3D 12
> -};
> -
> -enum max_min {
> -	DAL_MM_MIN =3D 0,
> -	DAL_MM_MAX =3D 1
> -};
> -
> -struct qp_entry {
> -	float         bpp;
> -	const qp_set  qps;
> -};
> -
> -typedef struct qp_entry qp_table[];
> +#include "dml/dsc/rc_calc_fpu.h"
>=20
>  void calc_rc_params(struct rc_params *rc, const struct drm_dsc_config
> *pps);
>  u32 calc_dsc_bytes_per_pixel(const struct drm_dsc_config *pps); diff --g=
it
> a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c
> b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c
> index ef830aded5b1c..1e19dd674e5a2 100644
> --- a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c
> +++ b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc_dpi.c
> @@ -22,7 +22,6 @@
>   * Authors: AMD
>   *
>   */
> -#include "os_types.h"
>  #include <drm/drm_dsc.h>
>  #include "dscc_types.h"
>  #include "rc_calc.h"
> --
> 2.34.1
>=20
>=20
