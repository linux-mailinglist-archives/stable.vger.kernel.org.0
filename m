Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801496EEC59
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 04:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbjDZC1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 22:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbjDZC1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 22:27:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722948A42;
        Tue, 25 Apr 2023 19:27:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m663MJlU1iOQ5rcuotF5drvERY9/LqoXxnFmgdJt0pLoSzI2O16+VJv/pgCCtLUpqDQW850/FO6KKiroWkkKunfMr/OOXZCNLAMhd6h4H7N/YNEw3TzzZJraus5aCNq9Er7ytMK1mRAKttumMbgZzvxRaqP6qp3eYq/nSWEDyP0iVQwynvPDUjeaSRmz83d6VJ0SdU/8zsNYeb8OcBv0edbrApqdMOlx84i4fPr7ByXjGQAubgvaemqHwQUzX4BR8HMeRH2eT3RTUuBywrbFv9m3pOavSDKcX5SAqPe+qTYKjoCDuMvGDYOjUQO/BlQ/VTV3rt0Ctv5x2SOSGO+6ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKUYT5HZEaouZb1LFf2zpuN2Be0TyXXq/Ck0m1UF6BM=;
 b=Zk05gmVq4fm+T015dBmnI3tGHgqBFc/Y7xybMbliVtWbz+NfXxLkeWLa/B9Ou1L4jZB9rTZMbDRO6XBWk7F2zUatqb3FBNKHESF7OaQu5nYonsFFfDNf9nvI3OApr6IuEzXZsp3lMieFtJr9ukyakDSaATrCpH2WLZAPWuenjia3PCAbaQIVn/wTBV/v2a5WXBKEhq4C0EQoRA4oKAKOBVjSDNvew2HiNjQnZsHT6SFBvZcbyZtxwsV+HMr+uji4SZyyfr0iAVd4Tok1ARifQmumkh5nMPQVK3DgudcwzNTNs+48CCwGSBQdx9Sd7Pib5Nx4bGJeSaS9pQq0Vlu3kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKUYT5HZEaouZb1LFf2zpuN2Be0TyXXq/Ck0m1UF6BM=;
 b=FypGsgRmdKx9XNRMFRrIFoPvXegr/BifXxyjNln54hl/iRfE29MbaIYnD2yMB57dTZciGZzkHxwVJ0FMQj+w4RB/5R7n7ZcoLGkvnSHX49Ji3jpsNFpz7YxvGLzVmX9IJFlO2bTwI+XBK3du4ynLIY52Gkn/PnneXRFr79npnL4=
Received: from BL0PR12MB2465.namprd12.prod.outlook.com (2603:10b6:207:45::18)
 by DM4PR12MB5183.namprd12.prod.outlook.com (2603:10b6:5:396::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 02:27:44 +0000
Received: from BL0PR12MB2465.namprd12.prod.outlook.com
 ([fe80::de6e:6dca:30d6:3fe9]) by BL0PR12MB2465.namprd12.prod.outlook.com
 ([fe80::de6e:6dca:30d6:3fe9%7]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 02:27:44 +0000
From:   "Chen, Guchun" <Guchun.Chen@amd.com>
To:     Chia-I Wu <olvaffe@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        David Airlie <airlied@gmail.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [PATCH] drm/amdgpu: add a missing lock for AMDGPU_SCHED
Thread-Topic: [PATCH] drm/amdgpu: add a missing lock for AMDGPU_SCHED
Thread-Index: AQHZd9jgatvFSKtwKkKFnrTt6sEXka883PXg
Date:   Wed, 26 Apr 2023 02:27:44 +0000
Message-ID: <BL0PR12MB2465ACA3AC6D8CCDFA043239F1659@BL0PR12MB2465.namprd12.prod.outlook.com>
References: <20230426004831.650908-1-olvaffe@gmail.com>
In-Reply-To: <20230426004831.650908-1-olvaffe@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR12MB2465:EE_|DM4PR12MB5183:EE_
x-ms-office365-filtering-correlation-id: 8b8a96da-d352-4399-2d89-08db45fdd13c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +N5b4fcROfNMH83Wl9uvjlf5KexiPVpvGSX/Y1/LbsKKdiKEBvTVFJBLYi8Aeh7dF6ggcM/NtnlpUkqeuJLwA56szo299O8pOrHQzu/F5odxMMtESMwS1vGGBptrAPWAWy+8kgLVZMwXGa6WVTZvcgngTan/u3J3KbJAnDc7jbwS7BkkZ23sx+93DnadSaq1ixQhithfmGSKo6TwLIroOnCjrQJta+ftV1E6gPVcisWUh+uspbrYY4lKQ2rf9mnRyEtY4SrIfzAKyR7jyDdhS+Qd1Y1fl0w878gaNS9H1dNWOeMOxBLlzBtzk/Eh0hBPlH31zt4Zkc6RUIsnE8kYkPImdnfhNWI9I4ciZZxSmdkU/+zVeTC8lcGrbi2xvfcv9G0E7QmbSOjUNnoaT7UbXJrl5GpDmq0XcGaxxXhlBWBzjaRNlp36GLkwTr/R6d/jsGj1lZIRmhYa4QLl0D+P3vyiX2g6fyz0wLJBOfgQ5gIuCuLYR4nIQYDumjM0y2C71ubAI3NOdidrB71XEp9T6jNizXVnzJOMyDEgvDNfyGfd1nfFaN/dNb+fxhssWYevcPtdTggFwBs5dYXqhECD/NeXjsNT9Sh7NgJn5Mgc0EUmhaapTFxNxyGjhQisQQAs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2465.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199021)(316002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(41300700001)(4326008)(478600001)(54906003)(52536014)(110136005)(5660300002)(2906002)(8936002)(8676002)(71200400001)(7696005)(6506007)(9686003)(26005)(186003)(53546011)(55016003)(83380400001)(33656002)(122000001)(38070700005)(86362001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5WYkHXKGaRUIKesBnDVPRRUEq1xqjPoVqqoxQKCeTjFVqPdBTMFvLcnI3C8e?=
 =?us-ascii?Q?X7FspnDu7xu9na9jtwtWZGVSPEzmHqFf3yGHNulEXE+SXsLpGjcR8Jfyk4gh?=
 =?us-ascii?Q?WwfQ7T/cXNYFwefdESjgt1zQlPLrQCFI+UfXEQzWz8q0haQzpGmfM6DITE0G?=
 =?us-ascii?Q?7nPH43ZmZeBQjq2dehEOdPmvq94trGuIVocpCOapblNHOurfbYR1FEKDAgXs?=
 =?us-ascii?Q?mJs7Y4n9hIBbgxljaY094+ZcqrDYhQTOJW9+SrZiToiY+QNmoOm/hiyTQqSg?=
 =?us-ascii?Q?3R6Ba/P3zAfHBQf3BhlHSXCiIBVIGriDdWcFpGf289VygTxOqn7UvsNHItPr?=
 =?us-ascii?Q?G+XL6bJNwQE9oH4PGwJfuYRC/Ao197OqCshCSYqXB9wvYjH/6FMS+Hloh7/f?=
 =?us-ascii?Q?O+wSD2YSJM7rOPgG3dswatkYghrFMQ+9kLfl7fDUvaZuHcO4/N/jwcdi7yPR?=
 =?us-ascii?Q?MGUVp1K9L5CzyfpiwbeLqKyDCbbRM9IHYhREm10+tmU/sN/euuR5xMM97Gy/?=
 =?us-ascii?Q?LDjqBVwEjWQuLoNdunvh47vynzacil9A1R4r1ShziIDAKWPAl/+zeoouDnhF?=
 =?us-ascii?Q?WmyweL4+zTA/Ml5IYJ+CR57JTM6y+rBDF460iaG5iJ1ZyHzokvkPAfd2pecN?=
 =?us-ascii?Q?Kvnb5s4qwaMcdQxX6Bjv8NovqZpnhwcktx83XwJ0NvCCmkmlm3VrPv5dCguJ?=
 =?us-ascii?Q?AXI8cah/eoAdRJAWxLR4hcIpQxEHXYWc5OuxpWTeeD7O2lZphpWOaCRDM94R?=
 =?us-ascii?Q?q/kb0ubRPrZt1E0c3lj0kNS5ZJdkQ4iHCNNxiUQWn/S2Fn2RzzpKJKbwf3U1?=
 =?us-ascii?Q?lWCjfpbAHrlIw1UIugqqO+9GxTiI8NNoqQqzNWj+ZD6YHVIPexrDtPcQgjvX?=
 =?us-ascii?Q?oPQ4qeUtH9sEBujHmgllfiT+yGpDr8EkTUxJbMpSQIfaDJA5dSbPIrZu+HKo?=
 =?us-ascii?Q?mrTkrSHDWYluX358841cREftwlIfzfeMQq0px+4gwQIQJx8YRoSpjRJFzV+U?=
 =?us-ascii?Q?IjA3dPfJJ11HwKC1xv86PGwSMGrIoO/V9FxygUBgpOdj8m5Zqm9n4OsBf79x?=
 =?us-ascii?Q?1us7Ah0+1uw7mNIzy8z5cqlD/39in29KHq2rhNai97Vjd0tZIHbHGxi7NUIq?=
 =?us-ascii?Q?e7x1kbBKByLNw22WaoXRR560NIUe2qxwg9shTZ80mmOWz7MYoiKMjsS2xwdo?=
 =?us-ascii?Q?XBAxxPe466y2Hqrdzj0Rx2PwFjbusHyZoGpME4/hzQXogBb82mXMSfFvZpHl?=
 =?us-ascii?Q?ZRbafKIVxHDJYOr1YXyN0VOVnDmcD+26MDvIBiruDGMQjz0VwueN8XO50Bv1?=
 =?us-ascii?Q?VpSECKu867ZMsNgKjBttz97S1NP318PXcQ63OXyurrjhWIrHxzITbmEGxvRX?=
 =?us-ascii?Q?E2zNmzLbqYZCz3zSInopT325fLzDQcEVIUTpYdX/R6Fa0jGT04hVwmfQQkXO?=
 =?us-ascii?Q?21cH/xQjz5xXtoEAZL6+8zn5AyKRwu7942rpuPpHu9kvqnpE/KgWM7Z9hGAN?=
 =?us-ascii?Q?ndRNXUs6KJKCBk3yafLJGcgG8Jy8u6w07H4gvLJw4tK2TiqxLUH0ZPh1WRes?=
 =?us-ascii?Q?vLGELZsOWpz+RvpblQU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2465.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8a96da-d352-4399-2d89-08db45fdd13c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 02:27:44.2350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FAp7aS47RZyXFf05zoXwrg9CUwN2/MtVrTWiF3VG8iD0mP+i8EB9e7Cg7xASxUWyrrzdwY2oQbzAAGrAjFBpSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5183
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

From coding style's perspective, this lock/unlock handling should be put in=
to amdgpu_ctx_priority_override.

Regards,
Guchun

> -----Original Message-----
> From: amd-gfx <amd-gfx-bounces@lists.freedesktop.org> On Behalf Of Chia-
> I Wu
> Sent: Wednesday, April 26, 2023 8:48 AM
> To: dri-devel@lists.freedesktop.org
> Cc: Pan, Xinhui <Xinhui.Pan@amd.com>; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org; amd-gfx@lists.freedesktop.org; Daniel Vetter
> <daniel@ffwll.ch>; Deucher, Alexander <Alexander.Deucher@amd.com>;
> David Airlie <airlied@gmail.com>; Koenig, Christian
> <Christian.Koenig@amd.com>
> Subject: [PATCH] drm/amdgpu: add a missing lock for AMDGPU_SCHED
>=20
> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> index e9b45089a28a6..863b2a34b2d64 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> @@ -38,6 +38,7 @@ static int
> amdgpu_sched_process_priority_override(struct amdgpu_device *adev,  {
>  	struct fd f =3D fdget(fd);
>  	struct amdgpu_fpriv *fpriv;
> +	struct amdgpu_ctx_mgr *mgr;
>  	struct amdgpu_ctx *ctx;
>  	uint32_t id;
>  	int r;
> @@ -51,8 +52,11 @@ static int
> amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
>  		return r;
>  	}
>=20
> -	idr_for_each_entry(&fpriv->ctx_mgr.ctx_handles, ctx, id)
> +	mgr =3D &fpriv->ctx_mgr;
> +	mutex_lock(&mgr->lock);
> +	idr_for_each_entry(&mgr->ctx_handles, ctx, id)
>  		amdgpu_ctx_priority_override(ctx, priority);
> +	mutex_unlock(&mgr->lock);
>=20
>  	fdput(f);
>  	return 0;
> --
> 2.40.0.634.g4ca3ef3211-goog

