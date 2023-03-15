Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E576BB249
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbjCOMfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbjCOMen (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE4F8F723
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E624F61D26
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FDDC4339B;
        Wed, 15 Mar 2023 12:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883596;
        bh=UrfXrAlNA8tQ7gBSmricQPBDXGO79E+j01rO+PreiIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2aRBxYfOu4UyavHDDEeQQ6kXSEAhQJ9qFzvelLFJFjGDuPUAF00l8T4U09ub+A9H
         E7dgnpNpoMmLY1rtyRmg3F5Ty3B5ajM1OBioKpI1Rw+Qu7/KuCpQVgCL/YVaAl63tI
         gBHYQMVKGlifoRKg+tKGR6ZL6hwqs/i5wx+6ayzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/143] drm/msm: Fix potential invalid ptr free
Date:   Wed, 15 Mar 2023 13:12:25 +0100
Message-Id: <20230315115742.314173170@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 7c2cc1262c05d..d8c9d184190bb 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -627,8 +627,8 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 	int ret = 0;
 	uint32_t i, j;
 
-	post_deps = kmalloc_array(nr_syncobjs, sizeof(*post_deps),
-	                          GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+	post_deps = kcalloc(nr_syncobjs, sizeof(*post_deps),
+			    GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (!post_deps)
 		return ERR_PTR(-ENOMEM);
 
@@ -643,7 +643,6 @@ static struct msm_submit_post_dep *msm_parse_post_deps(struct drm_device *dev,
 		}
 
 		post_deps[i].point = syncobj_desc.point;
-		post_deps[i].chain = NULL;
 
 		if (syncobj_desc.flags) {
 			ret = -EINVAL;
-- 
2.39.2



