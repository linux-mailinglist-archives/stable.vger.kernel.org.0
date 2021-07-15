Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F163CA642
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbhGOSqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235772AbhGOSqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5084F613D6;
        Thu, 15 Jul 2021 18:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374635;
        bh=a6833TJ0mkZ/v03O42FFwRWBA1BZaCeWzqtkI87+qAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyvgWW8vvONTNchB5FJP2nFCAZGY29R/ULwXKx3KnFr7bvWNAeRqdemIYuzMudVCQ
         Ix7gDxEHhY3/5TxVrXqcAo8VmestYBfwmZJrsr2s5trvpD2BVJTjnUc/kRf+wh93Xx
         w+/jc/GAx7E+8U4Q/nNSPOlQ1yc7bB7t66Dsg/Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Lyude Paul <lyude@redhat.com>,
        Rob Clark <robdclark@chromium.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>,
        Emil Velikov <emil.velikov@collabora.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 5.4 084/122] drm/msm/mdp4: Fix modifier support enabling
Date:   Thu, 15 Jul 2021 20:38:51 +0200
Message-Id: <20210715182512.942844406@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 35cbb8c91e9cf310277d3dfb4d046df8edf2df33 upstream.

Setting the cap without the modifier list is very confusing to
userspace. Fix that by listing the ones we support explicitly.

Stable backport so that userspace can rely on this working in a
reasonable way, i.e. that the cap set implies IN_FORMATS is available.

Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Cc: Rob Clark <robdclark@chromium.org>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210427092018.832258-5-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c   |    2 --
 drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c |    8 +++++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -88,8 +88,6 @@ static int mdp4_hw_init(struct msm_kms *
 	if (mdp4_kms->rev > 1)
 		mdp4_write(mdp4_kms, REG_MDP4_RESET_STATUS, 1);
 
-	dev->mode_config.allow_fb_modifiers = true;
-
 out:
 	pm_runtime_put_sync(dev->dev);
 
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c
@@ -347,6 +347,12 @@ enum mdp4_pipe mdp4_plane_pipe(struct dr
 	return mdp4_plane->pipe;
 }
 
+static const uint64_t supported_format_modifiers[] = {
+	DRM_FORMAT_MOD_SAMSUNG_64_32_TILE,
+	DRM_FORMAT_MOD_LINEAR,
+	DRM_FORMAT_MOD_INVALID
+};
+
 /* initialize plane */
 struct drm_plane *mdp4_plane_init(struct drm_device *dev,
 		enum mdp4_pipe pipe_id, bool private_plane)
@@ -375,7 +381,7 @@ struct drm_plane *mdp4_plane_init(struct
 	type = private_plane ? DRM_PLANE_TYPE_PRIMARY : DRM_PLANE_TYPE_OVERLAY;
 	ret = drm_universal_plane_init(dev, plane, 0xff, &mdp4_plane_funcs,
 				 mdp4_plane->formats, mdp4_plane->nformats,
-				 NULL, type, NULL);
+				 supported_format_modifiers, type, NULL);
 	if (ret)
 		goto fail;
 


