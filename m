Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613BF3CDE75
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245449AbhGSPDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344882AbhGSPBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F7BF610A5;
        Mon, 19 Jul 2021 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709310;
        bh=Yk4C3BLLAdIEdYekruoz0XI+8YhRHT61p0DV1dBQjYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NH4Tr0ztz6q19i1Zkj/YCMxSHb/IFiiRtrotkgye6lexEROWu5J0HZAWLCxMVywSR
         Ll+rlM+MjHxxb9PHjY8id4gBSzmr+oLh2Zk2CXNZ2GENYp4UzFwY1AyUxNr9984SKy
         EcQ24w2TRgMhqJVAA2mj6sCq7rjfvMNhEahhCafo=
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
Subject: [PATCH 4.19 289/421] drm/msm/mdp4: Fix modifier support enabling
Date:   Mon, 19 Jul 2021 16:51:40 +0200
Message-Id: <20210719144956.351860614@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
@@ -96,8 +96,6 @@ static int mdp4_hw_init(struct msm_kms *
 	if (mdp4_kms->rev > 1)
 		mdp4_write(mdp4_kms, REG_MDP4_RESET_STATUS, 1);
 
-	dev->mode_config.allow_fb_modifiers = true;
-
 out:
 	pm_runtime_put_sync(dev->dev);
 
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c
@@ -356,6 +356,12 @@ enum mdp4_pipe mdp4_plane_pipe(struct dr
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
@@ -384,7 +390,7 @@ struct drm_plane *mdp4_plane_init(struct
 	type = private_plane ? DRM_PLANE_TYPE_PRIMARY : DRM_PLANE_TYPE_OVERLAY;
 	ret = drm_universal_plane_init(dev, plane, 0xff, &mdp4_plane_funcs,
 				 mdp4_plane->formats, mdp4_plane->nformats,
-				 NULL, type, NULL);
+				 supported_format_modifiers, type, NULL);
 	if (ret)
 		goto fail;
 


