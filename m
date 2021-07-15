Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98B63CA7A7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241715AbhGOSzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241900AbhGOSyl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:54:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FC68613CC;
        Thu, 15 Jul 2021 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375106;
        bh=jSKqkZ+UU4PmhEyzCaosrPO3qLRJWJGjTNDb4ZWQLdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykMjRaW+a8NiPAofeM82UEcFHkg+S9B+WZClhuxP8O6L1+uLOpT+kCoZDhxBDs1UA
         x7lmurF35M4Kfm7pfOeB2nKGtT8zq7j4CGkVUxJShpuTATTwUBynKWbe/Y09X1iEdA
         0HfgrG6R2Ms7PCt3HaFHDEY+3N6kWoggC9b+Qesk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liviu Dudau <liviu.dudau@arm.com>,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Lyude Paul <lyude@redhat.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 5.10 163/215] drm/arm/malidp: Always list modifiers
Date:   Thu, 15 Jul 2021 20:38:55 +0200
Message-Id: <20210715182628.344430770@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 26c3e7fd5a3499e408915dadae5d5360790aae9a upstream.

Even when all we support is linear, make that explicit. Otherwise the
uapi is rather confusing.

Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Brian Starkey <brian.starkey@arm.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210427092018.832258-2-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/arm/malidp_planes.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -922,6 +922,11 @@ static const struct drm_plane_helper_fun
 	.atomic_disable = malidp_de_plane_disable,
 };
 
+static const uint64_t linear_only_modifiers[] = {
+	DRM_FORMAT_MOD_LINEAR,
+	DRM_FORMAT_MOD_INVALID
+};
+
 int malidp_de_planes_init(struct drm_device *drm)
 {
 	struct malidp_drm *malidp = drm->dev_private;
@@ -985,8 +990,8 @@ int malidp_de_planes_init(struct drm_dev
 		 */
 		ret = drm_universal_plane_init(drm, &plane->base, crtcs,
 				&malidp_de_plane_funcs, formats, n,
-				(id == DE_SMART) ? NULL : modifiers, plane_type,
-				NULL);
+				(id == DE_SMART) ? linear_only_modifiers : modifiers,
+				plane_type, NULL);
 
 		if (ret < 0)
 			goto cleanup;


