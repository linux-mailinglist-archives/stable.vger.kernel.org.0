Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F169953817B
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbiE3OUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241326AbiE3ORa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABFF9BAEC;
        Mon, 30 May 2022 06:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC53860F24;
        Mon, 30 May 2022 13:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8CBC36AE9;
        Mon, 30 May 2022 13:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918319;
        bh=/EVIXbXHVhz6z6r4WZ74kyE/k9deasy2cPR5W3Pn0Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMc8lhqeczUB5i0sRSwCn9RT+Ci5ok+GTMjqAjLY86XHJnRfrY+sMl1qKF3xwagFa
         M5jTiivb4fTBdjAOpwiOFWqpsuenAojMIHmL+cvBEZZXNxdZ8gTtMlxKWiNOceg4hz
         72GHQq4IuQa50qHRj17+rfAE6WLqX+PZoacOwvpbUxvRG4OPV6UtE0X3/yzySta/r3
         9kcXIVWhZENNI84CXZYzS0aGdeBv9slUsE5ek65Sxfp34a3Lee5tXQlsshY/Y4JD++
         S6eWcegRgZL5FPGNIpchv6eexZHw3tHyBpAlLhEHVwg8HuoclNxzLgtgV6g/+JNZPK
         CbARBJ5KMf9zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steven Price <steven.price@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 33/76] drm/plane: Move range check for format_count earlier
Date:   Mon, 30 May 2022 09:43:23 -0400
Message-Id: <20220530134406.1934928-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
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
index affe1cfed009..24f643982903 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -186,6 +186,13 @@ int drm_universal_plane_init(struct drm_device *dev, struct drm_plane *plane,
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
@@ -207,13 +214,6 @@ int drm_universal_plane_init(struct drm_device *dev, struct drm_plane *plane,
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

