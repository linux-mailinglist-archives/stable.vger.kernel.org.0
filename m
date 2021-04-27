Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EF436C18C
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 11:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhD0JVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 05:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbhD0JVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 05:21:11 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88829C061574
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 02:20:26 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a4so58712809wrr.2
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 02:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CGUka0sVW6wFNgc+ztoFeb2OUOiG/y4ojkNNplTLBt0=;
        b=lHcSeuO8JXlioU0SoJkhNjeUMSk697hQ5zjRlICZIdlcoCD+gtNxmqtsqVaoejeIqF
         JVkbZ4vwo0H7UnWI6b/SRN11ITJY5qZrNUtNBWPwhSqHZ0aDzFYt65GC1/dJLw4AR9d5
         kPi4sCxP4h02OO5vhQbXsNHkUWX1w1OD5rfsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CGUka0sVW6wFNgc+ztoFeb2OUOiG/y4ojkNNplTLBt0=;
        b=VwTG7cyaZhExDmQdIrctmVOwWTkaCcuoV7yJ4jZ015MutN9+KvBAhJfGebkbJjXNHo
         ieIZu+DJrK7bcBcVriyqAIuuzSdzxgW08CnQYtAtILWlVmi3axXzoI0gbrw+tSfg53kN
         eq/IPBjd03afJpPk1cpFT9n6sJdrnKuqsj1bNuUMVBuuTciWA8yXeOTzxOt3PwfLm4dS
         89EDQyY/J45vKvdHf3IrWiSh56kmvf+zcAeXwb2qzEaElVjXyvT7aTSAmHRlXxH2+/Ab
         fHHkdSaHJc1TUH06EQxv1G5tL0Idn4tw+q0b23jjIWwBIrw7h/v4JwSQeMlWmXQeR5+K
         3Zww==
X-Gm-Message-State: AOAM532SA+7sLbSeGparHnfYDzPVJq/IMjBDvsw6IXvjHkEb7dc6B0cY
        eS4N8mNNLWPVupyl5ysbQBAFmUgRVpuz+A==
X-Google-Smtp-Source: ABdhPJzvyNyHijFaOxhyQ5XBzpoVz9wyxCqtYwON0mcdqndBwfa9nQPuaqV5R5FcJKMQq7TH0Bmpog==
X-Received: by 2002:a5d:444d:: with SMTP id x13mr28571123wrr.406.1619515225336;
        Tue, 27 Apr 2021 02:20:25 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id r24sm1939816wmh.8.2021.04.27.02.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 02:20:24 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 2/8] drm/arm/malidp: Always list modifiers
Date:   Tue, 27 Apr 2021 11:20:12 +0200
Message-Id: <20210427092018.832258-2-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210427092018.832258-1-daniel.vetter@ffwll.ch>
References: <20210427092018.832258-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Even when all we support is linear, make that explicit. Otherwise the
uapi is rather confusing.

Cc: stable@vger.kernel.org
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Brian Starkey <brian.starkey@arm.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/arm/malidp_planes.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index ddbba67f0283..8c2ab3d653b7 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -927,6 +927,11 @@ static const struct drm_plane_helper_funcs malidp_de_plane_helper_funcs = {
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
@@ -990,8 +995,8 @@ int malidp_de_planes_init(struct drm_device *drm)
 		 */
 		ret = drm_universal_plane_init(drm, &plane->base, crtcs,
 				&malidp_de_plane_funcs, formats, n,
-				(id == DE_SMART) ? NULL : modifiers, plane_type,
-				NULL);
+				(id == DE_SMART) ? linear_only_modifiers : modifiers,
+				plane_type, NULL);
 
 		if (ret < 0)
 			goto cleanup;
-- 
2.31.0

