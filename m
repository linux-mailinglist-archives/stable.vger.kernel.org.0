Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155BF537FAC
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiE3OJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238918AbiE3OEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:04:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D7B994EE;
        Mon, 30 May 2022 06:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62BE760F2A;
        Mon, 30 May 2022 13:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B896C3411C;
        Mon, 30 May 2022 13:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918060;
        bh=Nk3kL6bonCgW2p1suaJIp+npmeYoouMji55NiDP4wXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rI6DuyLvcBqZieCEq4WPYThwiSvpAbmdil+sFRK86I1I4ybYWTOYplQUv8wuwhkXN
         PLV29PGzSuun7XF3xGhSbnnBhZQuCkbf8zG8IYvf7LrrmuE8AqTgEomWkt9OXgUFvl
         4BoycgIBdaTHBe/CWSh1i7Wibgu+N+M8Zcb42J1a7zaFsnsBfXIOIuw1xx+l/yc+F5
         UhYqHv96C8nSfbYKopa5BPVx6C8OWwRl+3gP94iq1Kd9pbzf218aP5StWNArcX2NHE
         ONCfM3Ar9u6dK5T2vrn+SUKkIiZuwqBgnLa0ZKgKJftkkrnchJt1yWmboZtCsNsJyF
         Db6kCtxUIOZvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steven Price <steven.price@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 046/109] drm/plane: Move range check for format_count earlier
Date:   Mon, 30 May 2022 09:37:22 -0400
Message-Id: <20220530133825.1933431-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
index 82afb854141b..fd0bf90fb4c2 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -249,6 +249,13 @@ static int __drm_universal_plane_init(struct drm_device *dev,
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
@@ -270,13 +277,6 @@ static int __drm_universal_plane_init(struct drm_device *dev,
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
 
-- 
2.35.1

