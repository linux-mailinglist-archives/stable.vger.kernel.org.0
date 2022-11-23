Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE02635813
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbiKWJuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237953AbiKWJtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13665115D07
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71780B81EF6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6952C433D6;
        Wed, 23 Nov 2022 09:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196799;
        bh=i9YKgbz66W62bTZZ/sYKnXQ31Al/E83J/H6hI2xMtM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooJ920U/iNZQ/jOLvKGhBXNo5skgdIvxm4QjTeuG+IWtA8GVpye90jAQQmQvYVdNl
         HGfNb2rb35JCSU8rKVeM6UmSNLR3LzT943x73lVSRMcmhu7urpoRnHe/xMJXteXfFq
         2LK4nTF7MphFlMimoMD8gNw2UZmR+CyGjoUFmeBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 127/314] drm/vc4: kms: Fix IS_ERR() vs NULL check for vc4_kms
Date:   Wed, 23 Nov 2022 09:49:32 +0100
Message-Id: <20221123084631.288197046@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit dba9e3467425800f9d3a14e8b6a0f85c731c1650 ]

The drm_atomic_get_new_private_obj_state() function returns NULL
on error path, drm_atomic_get_old_private_obj_state() function
returns NULL on error path, too, they does not return error pointers.

By the way, vc4_hvs_get_new/old_global_state() should return
ERR_PTR(-EINVAL), otherwise there will be null-ptr-defer issue,
such as follows:

In function vc4_atomic_commit_tail():
  |-- old_hvs_state = vc4_hvs_get_old_global_state(state); <-- return NULL
  |-- if (WARN_ON(IS_ERR(old_hvs_state))) <-- no return
  |-- unsigned long state_rate = max(old_hvs_state->core_clock_rate,
	new_hvs_state->core_clock_rate); <-- null-ptr-defer

Fixes: 9ec03d7f1ed3 ("drm/vc4: kms: Wait on previous FIFO users before a commit")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20221110094445.2930509-6-cuigaosheng1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_kms.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_kms.c b/drivers/gpu/drm/vc4/vc4_kms.c
index b45dcdfd7306..a3678178b022 100644
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -198,8 +198,8 @@ vc4_hvs_get_new_global_state(struct drm_atomic_state *state)
 	struct drm_private_state *priv_state;
 
 	priv_state = drm_atomic_get_new_private_obj_state(state, &vc4->hvs_channels);
-	if (IS_ERR(priv_state))
-		return ERR_CAST(priv_state);
+	if (!priv_state)
+		return ERR_PTR(-EINVAL);
 
 	return to_vc4_hvs_state(priv_state);
 }
@@ -211,8 +211,8 @@ vc4_hvs_get_old_global_state(struct drm_atomic_state *state)
 	struct drm_private_state *priv_state;
 
 	priv_state = drm_atomic_get_old_private_obj_state(state, &vc4->hvs_channels);
-	if (IS_ERR(priv_state))
-		return ERR_CAST(priv_state);
+	if (!priv_state)
+		return ERR_PTR(-EINVAL);
 
 	return to_vc4_hvs_state(priv_state);
 }
-- 
2.35.1



