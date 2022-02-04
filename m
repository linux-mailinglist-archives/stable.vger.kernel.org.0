Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C8A4A9E9A
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 19:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbiBDSFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 13:05:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231192AbiBDSFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 13:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643997923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3geeNi6auu9RMXK+qX+povbGNqKkQUklc3EVJ4m95BM=;
        b=Wlk8BxjnANTgtHAMpSU9OMa8fLKr5BoUrJ1vzMCL9BD/KBLN04nXEqi/dy1lDoXjJjUiKG
        QMDqB8uHW1ZMoSYbFwEU2O0k3CcXtp30dbl90gOfjc7rY5HZ/p3CiyuFMpuHsga3i9BeOu
        5p3lL4UlXqX/KIQ/fd2kGuDQa++/ifg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-Q9qQZ_dYM8W6PKZi5n_QRg-1; Fri, 04 Feb 2022 13:05:22 -0500
X-MC-Unique: Q9qQZ_dYM8W6PKZi5n_QRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9C25345AE;
        Fri,  4 Feb 2022 18:05:20 +0000 (UTC)
Received: from emerald.lyude.net (unknown [10.22.11.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18BE27E22F;
        Fri,  4 Feb 2022 18:05:18 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm/nouveau/backlight: Fix LVDS backlight detection on some laptops
Date:   Fri,  4 Feb 2022 13:05:04 -0500
Message-Id: <20220204180504.328999-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It seems that some laptops will report having both an eDP and LVDS
connector, even though only the LVDS connector is actually hooked up. This
can lead to issues with backlight registration if the eDP connector ends up
getting registered before the LVDS connector, as the backlight device will
then be registered to the eDP connector instead of the LVDS connector.

So, fix this by only registering the backlight on connectors that are
reported as being connected.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 6eca310e8924 ("drm/nouveau/kms/nv50-: Add basic DPCD backlight support for nouveau")
Bugzilla: https://gitlab.freedesktop.org/drm/nouveau/-/issues/137
Cc: <stable@vger.kernel.org> # v5.15+
---
 drivers/gpu/drm/nouveau/nouveau_backlight.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index ae2f2abc8f5a..6af12dc99d7f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -294,7 +294,8 @@ nv50_backlight_init(struct nouveau_backlight *bl,
 	struct nouveau_drm *drm = nouveau_drm(nv_encoder->base.base.dev);
 	struct nvif_object *device = &drm->client.device.object;
 
-	if (!nvif_rd32(device, NV50_PDISP_SOR_PWM_CTL(ffs(nv_encoder->dcb->or) - 1)))
+	if (!nvif_rd32(device, NV50_PDISP_SOR_PWM_CTL(ffs(nv_encoder->dcb->or) - 1)) ||
+	    nv_conn->base.status != connector_status_connected)
 		return -ENODEV;
 
 	if (nv_conn->type == DCB_CONNECTOR_eDP) {
-- 
2.34.1

