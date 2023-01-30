Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8289680FBC
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbjA3N4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbjA3N42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:56:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B9139BAB
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:56:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A96F961017
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98889C433D2;
        Mon, 30 Jan 2023 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086985;
        bh=cUU1aRo6HSj4DaLlkf/JYxR0YlomfgTIUj+GT8mhEoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7bBNJm8252K+lHq9uEgiHc45WH2sWB5tqqQayReiMnGIqhpT+aOe1J1QkVIkUZin
         W7nvRPAsBOxHPjlYKmMmMUZx3gMN/9p2kF1Uo7kVppjH71Mszo0r2GBxMwZ0bvXbw4
         6jh1huQgHo2OIWUO3NjvDs0RbmzJOQrVtYdWZ/7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/313] drm/vc4: bo: Fix drmm_mutex_init memory hog
Date:   Mon, 30 Jan 2023 14:48:16 +0100
Message-Id: <20230130134339.533874079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 07a2975c65f2be2e22591d795a9c39b00f95fd11 ]

Commit 374146cad469 ("drm/vc4: Switch to drmm_mutex_init") converted,
among other functions, vc4_create_object() to use drmm_mutex_init().

However, that function is used to allocate a BO, and therefore the
mutex needs to be freed much sooner than when the DRM device is removed
from the system.

For each buffer allocation we thus end up allocating a small structure
as part of the DRM-managed mechanism that is never freed, eventually
leading us to no longer having any free memory anymore.

Let's switch back to mutex_init/mutex_destroy to deal with it properly.

Fixes: 374146cad469 ("drm/vc4: Switch to drmm_mutex_init")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230112091243.490799-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 231add8b8e12..ab2573525d77 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -179,6 +179,7 @@ static void vc4_bo_destroy(struct vc4_bo *bo)
 		bo->validated_shader = NULL;
 	}
 
+	mutex_destroy(&bo->madv_lock);
 	drm_gem_dma_free(&bo->base);
 }
 
@@ -406,9 +407,7 @@ struct drm_gem_object *vc4_create_object(struct drm_device *dev, size_t size)
 	bo->madv = VC4_MADV_WILLNEED;
 	refcount_set(&bo->usecnt, 0);
 
-	ret = drmm_mutex_init(dev, &bo->madv_lock);
-	if (ret)
-		return ERR_PTR(ret);
+	mutex_init(&bo->madv_lock);
 
 	mutex_lock(&vc4->bo_lock);
 	bo->label = VC4_BO_TYPE_KERNEL;
-- 
2.39.0



