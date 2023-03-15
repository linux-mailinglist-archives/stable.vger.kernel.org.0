Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6C26BB198
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjCOM2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbjCOM2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833EE9DE26
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:27:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0262561D43
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF3AC433D2;
        Wed, 15 Mar 2023 12:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883258;
        bh=aQRKw9r43lg8u/qbiiRKzFPOQlreOLY7JutcNueitGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RN0m1pZd3akgDQwToDL5JaC5NSJzo8jqPj9BLIFEGR5R+V5brIMfBqgImnMQtIRcn
         nnAYo80gxH8fKEmW1fF6Tfhtb/jJFmPvWaV7j+PtTDFo2vln0myuWxatUTnB1J2eYn
         tOGQpE8Eiebfdmh0CWClvM0mQzqs3K2YzaDPZ7EM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/145] drm/msm: Fix potential invalid ptr free
Date:   Wed, 15 Mar 2023 13:11:51 +0100
Message-Id: <20230315115740.562594957@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 8a86f213f4426f19511a16d886871805b35c3acf ]

The error path cleanup expects that chain and syncobj are either NULL or
valid pointers.  But post_deps was not allocated with __GFP_ZERO.

Fixes: ab723b7a992a ("drm/msm: Add syncobj support.")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Patchwork: https://patchwork.freedesktop.org/patch/523051/
Link: https://lore.kernel.org/r/20230215235048.1166484-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 83e6ccad77286..fc2fb1019ea1c 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -640,8 +640,8 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 	int ret = 0;
 	uint32_t i, j;
 
-	post_deps = kmalloc_array(nr_syncobjs, sizeof(*post_deps),
-	                          GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+	post_deps = kcalloc(nr_syncobjs, sizeof(*post_deps),
+			    GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (!post_deps)
 		return ERR_PTR(-ENOMEM);
 
@@ -656,7 +656,6 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 		}
 
 		post_deps[i].point = syncobj_desc.point;
-		post_deps[i].chain = NULL;
 
 		if (syncobj_desc.flags) {
 			ret = -EINVAL;
-- 
2.39.2



