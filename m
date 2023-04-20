Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F48D6E97AC
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 16:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjDTOv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 10:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjDTOvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 10:51:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E797ED5;
        Thu, 20 Apr 2023 07:51:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMz0GSIxBGNxqWppHJqhh8Q/FWaGF2v14wAbGZKkeS+or/kTdMPmx49yVNu0JsLScwXhKlZjro7DYdNDged8rcuTSV81neycD+/5N+XdB8tXEF/KczJcInR+ePThIKIxW+DT72vSYASXSjODaMFBInhyXa3Gh9QGP4nrK8nqRDq2kPRx9oQY8Dcls3/H/hE9iZxBwVUrHvNJF0mXwwFuWZRJHm8Xa49Nm7Al7nrJDCc21KMdqnHP1bKiIwrbJaaWxUC5luBepgKYz2iF/Q2ZGvp1X5hSMF0Va8Stb8Hjag0vICcD/b4tqxnUbLXrk+ktrmTM5eCLyOlSokGdtCrReg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAljY8gJXpiLYeHSX5v3xuQ7FPY3/GYWPN7F0zfAuXw=;
 b=TCGgHO6S7mZ+JmwDr0yYQs3CDA/D+Ljpq8Dyjb2zs0BkeVrCGZGG0xeY0qQqvwnNEDlQFFQyPJoL/LAM8giCPBspztz7RRPVoMIm77vC/c4obffyPzQxurGuTQCbYetHcCJYJg9unWTuyXF0hA90WsjpwCmwuKUfDBnEvW76nDHB9qxAT0DGXoeiDeYpibIFRgAs7SyHDP9vj7T05e4KWsZ1OzK/Fd0ggiSy+cHpW1UWKcPCn3tDfeOYUxbghkQrQwE8SBMGaF+rMp7Je/xzXVKMnLuOP0Y6FfH8dFKLMMsA6n2TrYUHN3B5yNuSD+38U9NkxQCOpAhV5estVOFz9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAljY8gJXpiLYeHSX5v3xuQ7FPY3/GYWPN7F0zfAuXw=;
 b=xzjG9DJjJaowz95zgmJDDAJniY9r3MFUFPsLVJja/AACZJSYpRgsgwUdYp9yFpVj7b4q7DV/uLf6BLSEZTZ8ZTSNPZQbAUxsPxqmuXgnEgBN6j75176xJDXNF/vg3mLYYyCkvbwTJL2hgEiSIgf8jBZM1o/xAGLuKX+AYmyh/cY=
Received: from CY8PR12MB8193.namprd12.prod.outlook.com (2603:10b6:930:71::22)
 by BL1PR12MB5969.namprd12.prod.outlook.com (2603:10b6:208:398::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 14:51:29 +0000
Received: from CY8PR12MB8193.namprd12.prod.outlook.com
 ([fe80::57b4:c54f:f569:87c6]) by CY8PR12MB8193.namprd12.prod.outlook.com
 ([fe80::57b4:c54f:f569:87c6%7]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:51:29 +0000
From:   "Li, Roman" <Roman.Li@amd.com>
To:     "Mahfooz, Hamza" <Hamza.Mahfooz@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>,
        "Tuikov, Luben" <Luben.Tuikov@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        David Airlie <airlied@gmail.com>,
        "Zhuo, Qingqing (Lillian)" <Qingqing.Zhuo@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        "Wu, Hersen" <hersenxs.wu@amd.com>,
        "Mahfooz, Hamza" <Hamza.Mahfooz@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [PATCH v3] drm/amd/display: fix flickering caused by S/G mode
Thread-Topic: [PATCH v3] drm/amd/display: fix flickering caused by S/G mode
Thread-Index: AQHZc44UphO80f4k9E2EWH4AfM2QFK80R9Dg
Date:   Thu, 20 Apr 2023 14:51:29 +0000
Message-ID: <CY8PR12MB81939B1AAE1DD7604D32BD5E89639@CY8PR12MB8193.namprd12.prod.outlook.com>
References: <20230420134414.44538-1-hamza.mahfooz@amd.com>
In-Reply-To: <20230420134414.44538-1-hamza.mahfooz@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=c213a279-5216-41c6-8260-96959f0d0ee9;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP
 2.0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-20T14:50:50Z;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR12MB8193:EE_|BL1PR12MB5969:EE_
x-ms-office365-filtering-correlation-id: 06392b2b-fa9e-4403-d2ef-08db41aeb95b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UwvqlJPxPYmvFQHjhvdCCMFCKVE7RqTBmrE1sYNAfPOMSTe94nd0ZmAwSGMU+gTJnqbG3CBoJ6SkaIuhD5M3Lilj19mKc3XsdjWbd+X45MKAOaFEmpM7bBi+4OPsPMPPHTu294xGNlhMFjs57BPzJPz72MAImwefMll41AK6YoSsxh1umq/uDtiHWM/JYaDd0N731UH2TGwSKhLKTfr07zhjSaLpAJnSJAoRnB8qpPiDW5niykGzgQXK2qNxAIfOjJJH7fWmMKl8MGJH/14rxRTVBZ+RYHPNj+KmpYunmT5bQ3nbpGL1dJjGYnDScTUIu5Qlr/TMjd/PN42mWPgSAk8jkwFnkMPKUKa/RZEzkYMbaHzpbWIOcg39nKXSYi3vxGLR3tMUkksTDDXPbUsF99i/OsJ9JPykTHjakrpOVKMttMQghCpZ1myRBx6pGpthGIJcIWGGu9OkmDBl2N5X3l1HYEEcAj+CwE6TSxFdFPbGxwisPXZ8i9X44C+7FPkqkcYode26bPGBUDveMy+KQ9JJFRfTdkH2pLBDQsICw+zyX9WURmcty+1+ydRmKPOF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8193.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199021)(122000001)(4326008)(316002)(110136005)(54906003)(966005)(64756008)(76116006)(66946007)(66556008)(66476007)(66446008)(186003)(26005)(9686003)(6506007)(53546011)(38100700002)(83380400001)(5660300002)(41300700001)(8676002)(55016003)(8936002)(478600001)(7696005)(71200400001)(38070700005)(33656002)(86362001)(2906002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xHlrTjnMIwzCncoD1HBuJ5dFEnq5RXdWUQtOrxv1hf1gTNss6Q1lcUxUyytd?=
 =?us-ascii?Q?o/aGaZy32cbQYudSVB4akHYFizxR3mgie9xDQTDyckLb5v5r5vBB/S6hUF5m?=
 =?us-ascii?Q?O3b5YFIqXubVO/mbt/Eljva0XFPjiXm0Q8YzMv3idRiZiNubeX6/Z/BJpiNj?=
 =?us-ascii?Q?HkD9X1AywB/pifVcEFcnRrUAwRrKQqlf47QvoLygegGNI4uGsBAArMoLcpYv?=
 =?us-ascii?Q?Hf+sHhYjzq1BEEpKoPWffhjIPgijN41IqPnT7BxNAS+C/0dA/Uca7Apm9FZt?=
 =?us-ascii?Q?nRSNHuivPXTMCbCUn1SYwrW3VmrO3jrl2/eomcLOzljxGonwemJ4ryW6yh1K?=
 =?us-ascii?Q?wLHLT2k4+x9YHvwEdbYKUcP8Y5eatnieU0J6GGZXbvs6G/sm8mGW7mZH7oVU?=
 =?us-ascii?Q?37iTOecgE7ZAR8UXrf8osNcOQFJcXllXrKGiX14zHkOCGjfFTL2obmvWp/yJ?=
 =?us-ascii?Q?nUjgKmaiSMn5xtKaJALjmycy3MBs1g5WtlLIPNlO7xAmy4Ww0t6ExLmMNsXv?=
 =?us-ascii?Q?BhA3vZiDedQkC0xTN0g0ITxprlnUXw2llr8l1oRhI/CVOoBO7kVdg0H8R9Kn?=
 =?us-ascii?Q?btzpc0EbuG6kp7Fu6kGoSxUIydzTF3a4LrXb/yrMYGe1ryRH+GZXQZqb1oE9?=
 =?us-ascii?Q?Ieaxy92Eo/yvNWeriY+d0Sl1cChYggK/h6vEnZjt5cHE20G/qY+pMMEhe5rg?=
 =?us-ascii?Q?+88mc+YdMlzLisoWp1qIqmVd24ve0hlr8vX+RwSVEdAza0DwiWViXazkt/B1?=
 =?us-ascii?Q?Bw/kyY0WaouULqyHf3003qSbXioLsUsQBFIWSlDQ5iTm5aHB0vdpi9v1Q9CB?=
 =?us-ascii?Q?w5JWQWOAGwAF0NkA/YH7mOaaXK5Hdx74gzHBNvwMI83fmThiniav/J001yfM?=
 =?us-ascii?Q?cUCTt2PZaam26AcvE4AcgdcD5zU0ndbhAiXHNLQJuHRn9sX05Xk6ab2sno5V?=
 =?us-ascii?Q?ZCqxij6eh4opNl2JqTDQhKyZs0Fklklg1kxbIHkzwjwWEoMJNz9N4WbYWaEh?=
 =?us-ascii?Q?biuta+7v2/vlKizVw0HoC5V5Cc0u/9joZuIfx+4o0GOIpVG5u0mtnenQG3N7?=
 =?us-ascii?Q?dw9Ytx6FNLMK2dBANKpQEBHvBhw+rPWtJ+IXz7HJfpi3BufoyillPVZvLncA?=
 =?us-ascii?Q?/zyrzaECglF466z0ertyjtmznqBHv2cH3EWybv4rchmZV+2TM6DiMcCdZ4N5?=
 =?us-ascii?Q?wyGzDPEeNlP1EOM/U5CTqpw4rJe/61mrpl+4ZEvTD6AHl/I972w3ICQ61FHV?=
 =?us-ascii?Q?ipllQcTQxjmyJyWJ+Siks42fUGuFivWaNCHImobSmTF6kJFuduK/AvHCc1Nn?=
 =?us-ascii?Q?p4N0JBQIs/U9DoyLIExLMKhC9JYUgJgHDHC//XVg73P8UuTczBL8SnJPNaJ9?=
 =?us-ascii?Q?szk//+uMFXfQ8jjWsa6q8phBwYDrQSdhvnrM2u3Im5L2jqNWjuWkZsKMleBe?=
 =?us-ascii?Q?k3J2ZyrPQZUmIZc283R/6gglrtvPjZvD+JRcXST6MIQcddSOuDMHmJ82hdgd?=
 =?us-ascii?Q?iVrcm6Kzv4PQMVZtqJnwlydwfk4Yfntuw9HZ/1jOREnxFNVCicZQ8/Nl4bFt?=
 =?us-ascii?Q?GSh+mqGhW7EGvEblbWM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8193.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06392b2b-fa9e-4403-d2ef-08db41aeb95b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 14:51:29.2654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pCSe7efK/TL9uC8NyRsjIYxGPo0bLvGKY3Mq3GZMt64LPON7BO6zcxSiSNKKdUbK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5969
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Reviewed-by: Roman Li <Roman.Li@amd.com>

> -----Original Message-----
> From: amd-gfx <amd-gfx-bounces@lists.freedesktop.org> On Behalf Of Hamza
> Mahfooz
> Sent: Thursday, April 20, 2023 9:44 AM
> To: amd-gfx@lists.freedesktop.org
> Cc: Wang, Chao-kai (Stylon) <Stylon.Wang@amd.com>; Tuikov, Luben
> <Luben.Tuikov@amd.com>; dri-devel@lists.freedesktop.org; Li, Sun peng (Le=
o)
> <Sunpeng.Li@amd.com>; David Airlie <airlied@gmail.com>; Zhuo, Qingqing
> (Lillian) <Qingqing.Zhuo@amd.com>; Pan, Xinhui <Xinhui.Pan@amd.com>;
> Siqueira, Rodrigo <Rodrigo.Siqueira@amd.com>; linux-kernel@vger.kernel.or=
g;
> stable@vger.kernel.org; Hans de Goede <hdegoede@redhat.com>; Pillai,
> Aurabindo <Aurabindo.Pillai@amd.com>; Wu, Hersen
> <hersenxs.wu@amd.com>; Mahfooz, Hamza <Hamza.Mahfooz@amd.com>;
> Daniel Vetter <daniel@ffwll.ch>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Wentland, Harry
> <Harry.Wentland@amd.com>; Koenig, Christian <Christian.Koenig@amd.com>
> Subject: [PATCH v3] drm/amd/display: fix flickering caused by S/G mode
>
> Currently, on a handful of ASICs. We allow the framebuffer for a given pl=
ane to
> exist in either VRAM or GTT. However, if the plane's new framebuffer is i=
n a
> different memory domain than it's previous framebuffer, flipping between
> them can cause the screen to flicker. So, to fix this, don't perform an
> immediate flip in the aforementioned case.
>
> Cc: stable@vger.kernel.org
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2354
> Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible (v2)=
")
> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
> ---
> v2: make a number of clarifications to the commit message and drop
>     locking.
> v3: use a stronger check
> ---
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    | 16 ++++++++++++++-
> -
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index dfcb9815b5a8..875111340203 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -7900,6 +7900,13 @@ static void amdgpu_dm_commit_cursors(struct
> drm_atomic_state *state)
>                       amdgpu_dm_plane_handle_cursor_update(plane,
> old_plane_state);  }
>
> +static inline uint32_t get_mem_type(struct drm_framebuffer *fb) {
> +     struct amdgpu_bo *abo =3D gem_to_amdgpu_bo(fb->obj[0]);
> +
> +     return abo->tbo.resource ? abo->tbo.resource->mem_type : 0; }
> +
>  static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>                                   struct dc_state *dc_state,
>                                   struct drm_device *dev,
> @@ -7919,6 +7926,7 @@ static void amdgpu_dm_commit_planes(struct
> drm_atomic_state *state,
>
>       to_dm_crtc_state(drm_atomic_get_old_crtc_state(state, pcrtc));
>       int planes_count =3D 0, vpos, hpos;
>       unsigned long flags;
> +     uint32_t mem_type;
>       u32 target_vblank, last_flip_vblank;
>       bool vrr_active =3D amdgpu_dm_crtc_vrr_active(acrtc_state);
>       bool cursor_update =3D false;
> @@ -8040,13 +8048,17 @@ static void amdgpu_dm_commit_planes(struct
> drm_atomic_state *state,
>                       }
>               }
>
> +             mem_type =3D get_mem_type(old_plane_state->fb);
> +
>               /*
>                * Only allow immediate flips for fast updates that don't
> -              * change FB pitch, DCC state, rotation or mirroing.
> +              * change memory domain, FB pitch, DCC state, rotation or
> +              * mirroring.
>                */
>               bundle->flip_addrs[planes_count].flip_immediate =3D
>                       crtc->state->async_flip &&
> -                     acrtc_state->update_type =3D=3D UPDATE_TYPE_FAST;
> +                     acrtc_state->update_type =3D=3D UPDATE_TYPE_FAST &&
> +                     mem_type && get_mem_type(fb) =3D=3D mem_type;
>
>               timestamp_ns =3D ktime_get_ns();
>               bundle->flip_addrs[planes_count].flip_timestamp_in_us =3D
> div_u64(timestamp_ns, 1000);
> --
> 2.40.0

