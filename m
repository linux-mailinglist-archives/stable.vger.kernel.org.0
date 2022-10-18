Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCF66023FC
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 07:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiJRFnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 01:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiJRFnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 01:43:39 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B27A3F56
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 22:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dk5KMrmBVKfdroYydAzE4AD/cW79pgKgX070BjCmK3yfN543bVQ5vcuKc+CrdItYUev/cWkOH85AMsNGCosrbueQ7wefAnx2q55supxKQZq6n5w3CceylKgZzpUVD3wciX6Zn9ts67RkwJBZUISQwPj0U2S4cDUzimm3CGr2pq7j9deN6aoQrd72QVZEVA8bjpn4qViFboirzPVIrFvwhoZDQQ4o6ItQIt0uPR39e71GStoWaJEb6fZxRyg9v7qJQy6GXgplktVyXZJb6t37FJjvSt6VQAEaQuo/Tfmd3t14Tr48eKdP0HJDE/4HYzGExlL1246wBzj8IvsVR57n3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccY7fAwhVMg41pTxht5SOZ1aThZyEuiThKL8oMQwLFQ=;
 b=Ho/9KU7zsThAC3YQKa0K33lA07i2Y9Rn0WMk2IR3NoGirMrrjJLOOcp83fk+3qakLW6vsn+q3xj+DFNECKIc5K7sGN1UP3915L6F/cRJ+P61r9JNDIpoAauRdMaoY4SA7ou3j/nnQYjsflAimwSVqDimh0UYMvKcbmnrDLxtN7qsnjfwfn2f3QL/bLRCF7QQk1ChXPj82kAGjlqk+d43QhK3eQqMz8sMVii5fFUwLob+tmHCxqHuc/SShMyBqi6Zqc5iJil9vbnLgJlLjGWyHvP8iAA8xqKoAUb4xbKd9DY1SiEywV0LJJs5pwQp7IYgtzN9Sc3o0w+3tOacqOvUeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccY7fAwhVMg41pTxht5SOZ1aThZyEuiThKL8oMQwLFQ=;
 b=o27PNn2LT46I/qYae8Qt8Hiz71b7t7XDpPZA+sWASPJExiSePx4ivr6sC4YmZfaUIwqmxHVk36Vaq320QquAFxFVZsWgxPsnfRwgsDZPEZD87q5KfdVI9rBeoTujoraT59lrVEkgMQqYGK2mHut+9kURqLCKwFkRs8xxk0ITLkY=
Received: from DM5PR12MB2469.namprd12.prod.outlook.com (2603:10b6:4:af::38) by
 CH2PR12MB4264.namprd12.prod.outlook.com (2603:10b6:610:a4::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.30; Tue, 18 Oct 2022 05:43:26 +0000
Received: from DM5PR12MB2469.namprd12.prod.outlook.com
 ([fe80::78b6:27fc:c590:d2c0]) by DM5PR12MB2469.namprd12.prod.outlook.com
 ([fe80::78b6:27fc:c590:d2c0%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 05:43:25 +0000
From:   "Chen, Guchun" <Guchun.Chen@amd.com>
To:     "Lazar, Lijo" <Lijo.Lazar@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Zhang, Hawking" <Hawking.Zhang@amd.com>
Subject: RE: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x
Thread-Topic: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x
Thread-Index: AQHY4rRd6q3uapm8qU6xwCmbw1XYu64To4eg
Date:   Tue, 18 Oct 2022 05:43:25 +0000
Message-ID: <DM5PR12MB246996A4A7238D706992961CF1289@DM5PR12MB2469.namprd12.prod.outlook.com>
References: <20221018054050.86703-1-lijo.lazar@amd.com>
In-Reply-To: <20221018054050.86703-1-lijo.lazar@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR12MB2469:EE_|CH2PR12MB4264:EE_
x-ms-office365-filtering-correlation-id: 388f1aa4-713f-4bb9-ecc3-08dab0cbad54
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vd010MhgHuF6bcHxXKs2hcOrcMZ/4FIiHfzX80IzHxHXQwNkyu8S25xOhwNKhC6Ty19XvOjRp1/rSJQntLjRxtOSKAcPspqna4Op/0zgVm1dc8WW/RJb5tO6VPb6TZJW0CeqXchU3BNBY4L5Qswjv/3kenCTFWXOrWnFgKfzEGx2nAzmaPn1BCnRx1ESD2pxKwEIZ01NramAWpv/4ZK2rEq8Dgqtmghjq9tRiYlup4v0oQipqcisYM6ZsB6/aKwludTZADCh4l4bMZCGwOnQg8u1XJkIsLmkAYfg4SKcgVO7ppbLjU7DLLn3AyWAIIDMUtPWs9zyXKeG55S+EzcS6k5i2y4IDzvMrDSP/ud25thRWB02zUcULQwmDU5Sb7jde9djKSvIDeKayLja1SNG7G4L4hL3YQU3Ia6b6NEP57DuC3tgBux3yvqpVRieFnWAyJa8UIeuezp1piOOXtORpeKJpiViA3tagZa7fVJ11lhJ6xI4MD3W8Nw95yElihGwclfAFkMGxfQImGhHZwQBcujcQcBAOUE9FEKEAWdOLzrOTBoe0hdvGSUU5HczxbCMzxNRHEEmmtqo++LMUGzY/cyqWGFKhFN0qeeX27d50H5sgLxOuJaVKMX8VUXInLz6CaPK8d1j45k+mGQbVCuQm4uYW2bMGK/1XATaYC0hWbsaBTEehbsv3qI6Y9Q1P1BSSx6rOQ9knmgJ6/IO+apQTWTQzCMbxJ3/C/SYPz8iqCt1WDbj86IIVS1jBPODXT8VM1bEaoHpDhMyqTs/4jyCQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2469.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199015)(38070700005)(122000001)(86362001)(33656002)(55016003)(38100700002)(83380400001)(66946007)(76116006)(110136005)(64756008)(66476007)(19627235002)(316002)(54906003)(66446008)(8676002)(66556008)(5660300002)(2906002)(186003)(71200400001)(8936002)(7696005)(4326008)(478600001)(9686003)(26005)(53546011)(52536014)(41300700001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d/Qigf/3BbDL9EjwPEoJGFyfWl2Vux7+oRvoHJ5u7Cg5Y+SYfAsGgbewMjOI?=
 =?us-ascii?Q?PyaKVfksXldIq+jHn+wT+2Fm3y7eBYsd+ZAV4czkphJ42yPXVsau0aaiGiGV?=
 =?us-ascii?Q?i8dldlPm2p66x9kOmLo5B9wlMGA84bcdm/X2EZdmAALBITEEJJS5WUf+V8jt?=
 =?us-ascii?Q?JmQtbGmiAQDrlVEVlMlftGPnCGbmlokfsrDGmmiwmGtrJcY837aDEakZdazZ?=
 =?us-ascii?Q?EIB36tV4M2bHZqZXQET7yui8QNUWeGMVrVnzQ/V6oDDmKycFQsqvbkaMiMSr?=
 =?us-ascii?Q?AYwGQzwm0I5VXrGQwv56JxdFxqgjXcHDaCuNQeC45y75BXn/JM2B2I5KmFwE?=
 =?us-ascii?Q?ryrtsiO/lrlEBoJrIhuMdeJNSF/vVXdG8boI5NUomJUqE8SI3nh5LhBS+q3B?=
 =?us-ascii?Q?Azf45Ueb0loXjDcZbXCa5vKOlu6cNjmSuos01tRoNEa9gCPn661rY4bC5ywM?=
 =?us-ascii?Q?lDtfaVRxMyHEO1DrKJsjz5hX0yFImJsosMtjZ6WqybX6JqpgxgAlCTnYL7bU?=
 =?us-ascii?Q?u3GJ9BTXkenROsYwOpfuQoZsdw1IxyYfAVLBRVtWwLzrnyFo6BOMoqvJYfrP?=
 =?us-ascii?Q?cfwxY+f32u0cU40VoYKL00quOAudhEeRGdvN/mwtHmM25vSxFg2T6Da6ld/v?=
 =?us-ascii?Q?9XwQRF7u8twhuZREviFSpM7Lds1Of/CGCIghe1QOFXA0NtIrr0jwdtAvqNbS?=
 =?us-ascii?Q?GysfgfywUqspLrZq9L7EGvziomc6iltiGUs8wluifqiQNHAzt9p5IhLoywfi?=
 =?us-ascii?Q?HEI0oPwtpxHyO8hmUWc4jyhnKYgUWJkMFJScG5mY8G4EN3FiYpL9ksFgwjfH?=
 =?us-ascii?Q?Xo9ybQI2YoxalIh5mLH9cUlxqIRcUo/Xtqd998Jlxx2vYfT6rGGC2CIL5ZbC?=
 =?us-ascii?Q?kkZI9ax3OzKMWwSBK5c/wlvoJTTYbosgD9Qv2Sp9BVi/zlgV3SWWPaZcKNul?=
 =?us-ascii?Q?tgzm85/M2vw3Fcn4yCd6qpPQDCFvBCASW00OU1YbjIPom9+qwxIcauFhWHFH?=
 =?us-ascii?Q?IiicB505rtE5RDSOYypOePxBPk29zlz57jeuqqEIep0okrWv08+yfAgfNEDl?=
 =?us-ascii?Q?n1Tlx0WPy8+XaPvAXZGOyJ8+hx9b+4lYOZMlnVOd5BZN9jxzpd8AW/xIFzrV?=
 =?us-ascii?Q?z2Wy86vDduyt+VUJgoLd2oRYjlHlZa1vxncyf3biYvzIUk5aZ0mQAf283VTy?=
 =?us-ascii?Q?m8Yc8fLlhArtuQceBOdISiHHp0IYp/jHbG7p0mNZmFnfQka4ORwEM8UO4FoP?=
 =?us-ascii?Q?ozQMn0F+/h55pU/miJIdL1CdyO/Wb8xVxMJA/SMKpXP71gUwQlrWF4yC2cVT?=
 =?us-ascii?Q?uYYr6nvaJu+bRtH5yuk5GtLA5IgALHXbSshZq98/EQKu3h4YfZj4CkYbeYyv?=
 =?us-ascii?Q?32qutH+0LcQoO69KYVmmhrSywJUsP+OlpcGt+058sKL1yNeaNcnS6v0xMANZ?=
 =?us-ascii?Q?GOnjmkCaRVJpI3KPwRJXkuLKGZWhYnIzhywNeNQ4CyT4uXTqyGGIzKdeeg1I?=
 =?us-ascii?Q?7DyP/LIB8258JguktPxW/sU+E/pz8BywZZqyPus9IhjE0j23fK5Yiulyx2wf?=
 =?us-ascii?Q?/6J9sHejUhSdaVVpUs51DPUT74507HmkY9i/0xPu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2469.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 388f1aa4-713f-4bb9-ecc3-08dab0cbad54
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 05:43:25.8751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N5WZ/kZheVO6/Fn+bY/GqS0poSUPHsYNiRvph2Jy+9vQ3QPuihVkFSP7k/6hpU3UbS3uMCZedJ7+ZjR8RP5kHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4264
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Guchun Chen <guchun.chen@amd.com>

Regards,
Guchun

-----Original Message-----
From: amd-gfx <amd-gfx-bounces@lists.freedesktop.org> On Behalf Of Lijo Laz=
ar
Sent: Tuesday, October 18, 2022 1:41 PM
To: amd-gfx@lists.freedesktop.org
Cc: Deucher, Alexander <Alexander.Deucher@amd.com>; helgaas@kernel.org; sta=
ble@vger.kernel.org; Chen, Guchun <Guchun.Chen@amd.com>; Zhang, Hawking <Ha=
wking.Zhang@amd.com>
Subject: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x

MMHUB 2.1.x versions don't have ATCL2. Remove accesses to ATCL2 registers.

Since they are non-existing registers, read access will cause a 'Completer =
Abort' and gets reported when AER is enabled with the below patch.
Tagging with the patch so that this is backported along with it.

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_=
device_capability()")

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c | 28 +++++++------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c b/drivers/gpu/drm/amd/=
amdgpu/mmhub_v2_0.c
index 4d304f22889e..5ec6d17fed09 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -32,8 +32,6 @@
 #include "gc/gc_10_1_0_offset.h"
 #include "soc15_common.h"
=20
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid                      0x064d
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid_BASE_IDX             0
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid                       0x0070
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid_BASE_IDX              0
=20
@@ -574,7 +572,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating=
(struct amdgpu_device *ad
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  =3D data  =3D RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cic=
hlid);
 		def1 =3D data1 =3D RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cich=
lid);
 		break;
 	default:
@@ -608,8 +605,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating=
(struct amdgpu_device *ad
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		if (def !=3D data)
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
 		if (def1 !=3D data1)
 			WREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid, data1);
 		break;
@@ -634,8 +629,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep(=
struct amdgpu_device *ade
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  =3D data  =3D RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cic=
hlid);
-		break;
+		/* There is no ATCL2 in MMHUB for 2.1.x */
+		return;
 	default:
 		def  =3D data  =3D RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG);
 		break;
@@ -646,18 +641,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep=
(struct amdgpu_device *ade
 	else
 		data &=3D ~MM_ATC_L2_MISC_CG__MEM_LS_ENABLE_MASK;
=20
-	if (def !=3D data) {
-		switch (adev->ip_versions[MMHUB_HWIP][0]) {
-		case IP_VERSION(2, 1, 0):
-		case IP_VERSION(2, 1, 1):
-		case IP_VERSION(2, 1, 2):
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
-			break;
-		default:
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
-			break;
-		}
-	}
+	if (def !=3D data)
+		WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
 }
=20
 static int mmhub_v2_0_set_clockgating(struct amdgpu_device *adev, @@ -695,=
7 +680,10 @@ static void mmhub_v2_0_get_clockgating(struct amdgpu_device *a=
dev, u64 *flags)
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		data  =3D RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
+		/* There is no ATCL2 in MMHUB for 2.1.x. Keep the status
+		 * based on DAGB
+		 */
+		data |=3D MM_ATC_L2_MISC_CG__ENABLE_MASK;
 		data1 =3D RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
 		break;
 	default:
--
2.25.1

