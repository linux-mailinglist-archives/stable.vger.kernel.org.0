Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD51A5382C5
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbiE3O2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240269AbiE3OZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:25:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2460A88A0;
        Mon, 30 May 2022 06:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF38960F22;
        Mon, 30 May 2022 13:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B50C341C5;
        Mon, 30 May 2022 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918610;
        bh=NhQIeyPX25gsV3OUwC5lhjgviB0f5JW/jJAS23Jt5uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ng0Sr++9zWzu9kmLIKsFCL3EQQ/QXRE4HdWCpIO6PztAs6hSgTdaHx4wD40hj514d
         VtTBy2FkmKYinKliE0YQr0cz0zcKJzLRblU6Wq9IhqB1XPehP7irP3t7/ebgAhmpzT
         BtEt9Ux72pyc08LGF5ASFEk0MY3ks1AQDvI0Fzn1luRB+atbS+qo433kCIzzdSM70z
         lva+B1qraVL+vH7fY4p6EkOV0IoggevRMYX6q4NQZSEEo6BbGidQvCwtYbVJSc/xUF
         dD51tEOzX7oAa0F8klW7ZkJ4QJo/SVuxbjsc2h9Pe2m7IW3nWq4L5zBzJDgvO0yMgH
         40ZegXMaI2vIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steven Price <steven.price@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 18/38] drm/plane: Move range check for format_count earlier
Date:   Mon, 30 May 2022 09:49:04 -0400
Message-Id: <20220530134924.1936816-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134924.1936816-1-sashal@kernel.org>
References: <20220530134924.1936816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit 4b674dd69701c2e22e8e7770c1706a69f3b17269 ]

While the check for format_count > 64 in __drm_universal_plane_init()
shouldn't be hit (it's a WARN_ON), in its current position it will then
leak the plane->format_types array and fail to call
drm_mode_object_unregister() leaking the modeset identifier. Move it to
the start of the function to avoid allocating those resources in the
first place.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/dri-devel/20211203102815.38624-1-steven.price@arm.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_plane.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
index 2411b6de055e..425e76e39b3b 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -177,6 +177,13 @@ int drm_universal_plane_init(struct drm_device *dev, struct drm_plane *plane,
 	if (WARN_ON(config->num_total_plane >= 32))
 		return -EINVAL;
 
+	/*
+	 * First driver to need more than 64 formats needs to fix this. Each
+	 * format is encoded as a bit and the current code only supports a u64.
+	 */
+	if (WARN_ON(format_count > 64))
+		return -EINVAL;
+
 	WARN_ON(drm_drv_uses_atomic_modeset(dev) &&
 		(!funcs->atomic_destroy_state ||
 		 !funcs->atomic_duplicate_state));
@@ -198,13 +205,6 @@ int drm_universal_plane_init(struct drm_device *dev, struct drm_plane *plane,
 		return -ENOMEM;
 	}
 
-	/*
-	 * First driver to need more than 64 formats needs to fix this. Each
-	 * format is encoded as a bit and the current code only supports a u64.
-	 */
-	if (WARN_ON(format_count > 64))
-		return -EINVAL;
-
 	if (format_modifiers) {
 		const uint64_t *temp_modifiers = format_modifiers;
 		while (*temp_modifiers++ != DRM_FORMAT_MOD_INVALID)
-- 
2.35.1

