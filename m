Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB9419756
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 17:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhI0PKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 11:10:37 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:59729 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbhI0PKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 11:10:37 -0400
Date:   Mon, 27 Sep 2021 15:08:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail; t=1632755333;
        bh=LfVEJw8buJFUVGC6WlCq3Ogw2Xoapxa28fb0vc8GTN8=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=sN9CdwhzKjfyPG8jLaIff69v2njJjw7MZPTznlc6n/LBZo+K1IHYu62HNC4KShWgs
         Tw1MUrB7fM9M0Z2Hy/G6ggYLUi6Jfd8xBZMHbZDfQJAUmmQhY1ETVnoUaQ8x1zFpCr
         i+aSBw5Tn3vTr1g+rq1IFKid3fNNgA3gAbQ5xKn4nedk7SyP51m+psrwR3sATur4gG
         VRQ5SkgfvtnmxmEQ4G2midrLjUD0+wJEvmps+/g4Ass5436eLLo0TjMeYSA5CNIowY
         dekiavWOdLSWIKGEJvI511VOn2uOJ164ByygJYd1+BCP/Qdg425AL1SlGoFw0jasra
         AhiSWAMStjXUA==
To:     amd-gfx@lists.freedesktop.org
From:   Simon Ser <contact@emersion.fr>
Cc:     stable@vger.kernel.org,
        =?utf-8?Q?Michel_D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reply-To: Simon Ser <contact@emersion.fr>
Subject: [PATCH v2] amdgpu: check tiling flags when creating FB on GFX8-
Message-ID: <20210927150821.389427-1-contact@emersion.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On GFX9+, format modifiers are always enabled and ensure the
frame-buffers can be scanned out at ADDFB2 time.

On GFX8-, format modifiers are not supported and no other check
is performed. This means ADDFB2 IOCTLs will succeed even if the
tiling isn't supported for scan-out, and will result in garbage
displayed on screen [1].

Fix this by adding a check for tiling flags for GFX8 and older.
The check is taken from radeonsi in Mesa (see how is_displayable
is populated in gfx6_compute_surface).

Changes in v2: use drm_WARN_ONCE instead of drm_WARN (Michel)

[1]: https://github.com/swaywm/wlroots/issues/3185

Signed-off-by: Simon Ser <contact@emersion.fr>
Cc: stable@vger.kernel.org
Acked-by: Michel D=C3=A4nzer <mdaenzer@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 31 +++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/=
amd/amdgpu/amdgpu_display.c
index 58bfc7f00d76..5faf3ef28080 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -837,6 +837,28 @@ static int convert_tiling_flags_to_modifier(struct amd=
gpu_framebuffer *afb)
 =09return 0;
 }
=20
+/* Mirrors the is_displayable check in radeonsi's gfx6_compute_surface */
+static int check_tiling_flags_gfx6(struct amdgpu_framebuffer *afb)
+{
+=09u64 micro_tile_mode;
+
+=09/* Zero swizzle mode means linear */
+=09if (AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) =3D=3D 0)
+=09=09return 0;
+
+=09micro_tile_mode =3D AMDGPU_TILING_GET(afb->tiling_flags, MICRO_TILE_MOD=
E);
+=09switch (micro_tile_mode) {
+=09case 0: /* DISPLAY */
+=09case 3: /* RENDER */
+=09=09return 0;
+=09default:
+=09=09drm_dbg_kms(afb->base.dev,
+=09=09=09    "Micro tile mode %llu not supported for scanout\n",
+=09=09=09    micro_tile_mode);
+=09=09return -EINVAL;
+=09}
+}
+
 static void get_block_dimensions(unsigned int block_log2, unsigned int cpp=
,
 =09=09=09=09 unsigned int *width, unsigned int *height)
 {
@@ -1103,6 +1125,7 @@ int amdgpu_display_framebuffer_init(struct drm_device=
 *dev,
 =09=09=09=09    const struct drm_mode_fb_cmd2 *mode_cmd,
 =09=09=09=09    struct drm_gem_object *obj)
 {
+=09struct amdgpu_device *adev =3D drm_to_adev(dev);
 =09int ret, i;
=20
 =09/*
@@ -1122,6 +1145,14 @@ int amdgpu_display_framebuffer_init(struct drm_devic=
e *dev,
 =09if (ret)
 =09=09return ret;
=20
+=09if (!dev->mode_config.allow_fb_modifiers) {
+=09=09drm_WARN_ONCE(dev, adev->family >=3D AMDGPU_FAMILY_AI,
+=09=09=09      "GFX9+ requires FB check based on format modifier\n");
+=09=09ret =3D check_tiling_flags_gfx6(rfb);
+=09=09if (ret)
+=09=09=09return ret;
+=09}
+
 =09if (dev->mode_config.allow_fb_modifiers &&
 =09    !(rfb->base.flags & DRM_MODE_FB_MODIFIERS)) {
 =09=09ret =3D convert_tiling_flags_to_modifier(rfb);
--=20
2.33.0


