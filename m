Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8521B53818F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240786AbiE3OUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241087AbiE3ORN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DD51116CE;
        Mon, 30 May 2022 06:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23BC660FB4;
        Mon, 30 May 2022 13:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DD5C3411C;
        Mon, 30 May 2022 13:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918275;
        bh=2LFwGuCsKCuYENEjOsRcLSDeb9bv9mIq1XjW2w4MUhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igp3cOtb4Jw2neGZdTK8k/HnXt+jvH+U/oJ+eLQvdD4Ug0rkbNNzZ4stFJWV5JMs2
         pQC8K0gS9Z18my8OEvWwRfH1L2UsrEg0Ghh2DI1dMPsh7on+2c+8SYgVTMNzxM5lnp
         gKBDOuELFFFZx/NG8YlXEin3BNIv8n3k3CjmdNj5T1jYER/uehelIbvD5i2Kk8gGpw
         rhvXAkqroZ0p3sm0gxfd4BtmNrhJILotKGxXAzyMFQ9tEuZsGcCPY+FTE1Aw+y/16V
         M306FxMmpg7Gyu70h/T5yZc+usiH/rO/U7/WsoS3xhuq7v4k+QCZIOpCfr285RBApT
         hG4EkNbQkaq9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liviu Dudau <liviu.dudau@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>, james.qian.wang@arm.com,
        mihail.atanassov@arm.com, brian.starkey@arm.com, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 12/76] drm/komeda: return early if drm_universal_plane_init() fails.
Date:   Mon, 30 May 2022 09:43:02 -0400
Message-Id: <20220530134406.1934928-12-sashal@kernel.org>
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

From: Liviu Dudau <liviu.dudau@arm.com>

[ Upstream commit c8f76c37cc3668ee45e081e76a15f24a352ebbdd ]

If drm_universal_plane_init() fails early we jump to the common cleanup code
that calls komeda_plane_destroy() which in turn could access the uninitalised
drm_plane and crash. Return early if an error is detected without going through
the common code.

Reported-by: Steven Price <steven.price@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/dri-devel/20211203100946.2706922-1-liviu.dudau@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_plane.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
index 98e915e325dd..a5f57b38d193 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
@@ -274,8 +274,10 @@ static int komeda_plane_add(struct komeda_kms_dev *kms,
 
 	komeda_put_fourcc_list(formats);
 
-	if (err)
-		goto cleanup;
+	if (err) {
+		kfree(kplane);
+		return err;
+	}
 
 	drm_plane_helper_add(plane, &komeda_plane_helper_funcs);
 
-- 
2.35.1

