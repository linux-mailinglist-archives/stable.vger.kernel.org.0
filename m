Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07944582FFF
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbiG0Rcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242251AbiG0Ra3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:30:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD74F81B2F;
        Wed, 27 Jul 2022 09:48:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2871261479;
        Wed, 27 Jul 2022 16:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C2AC433C1;
        Wed, 27 Jul 2022 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940471;
        bh=9tCpcYupvaxeRANDUq8GCP66gANHEGG8QwCZcmAUZjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biiGTC1kaQnp34+WnNnKB/EyJmK9nJodVUdoso4tFv8yZ7hR0U6eGhzs5G/AmM2xn
         DPfNO6J38mi1h4PDbuXC3aaQonOQq+2KQSeoA7LJIy3JP0ntqiNdRd+yCsotOZJygR
         y0AbqkIjjzEdsMJlXN0qpuNSuap+kefc5B/Qh8oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 5.18 008/158] drm/ttm: fix locking in vmap/vunmap TTM GEM helpers
Date:   Wed, 27 Jul 2022 18:11:12 +0200
Message-Id: <20220727161021.764692072@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit dbd0da2453c694f2f74651834d90fb280b57f151 upstream.

I've stumbled over this while reviewing patches for DMA-buf and it looks
like we completely messed the locking up here.

In general most TTM function should only be called while holding the
appropriate BO resv lock. Without this we could break the internal
buffer object state here.

Only compile tested!

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 43676605f890 ("drm/ttm: Add vmap/vunmap to TTM and TTM GEM helpers")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220715111533.467012-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_ttm_helper.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gem_ttm_helper.c
+++ b/drivers/gpu/drm/drm_gem_ttm_helper.c
@@ -64,8 +64,13 @@ int drm_gem_ttm_vmap(struct drm_gem_obje
 		     struct iosys_map *map)
 {
 	struct ttm_buffer_object *bo = drm_gem_ttm_of_gem(gem);
+	int ret;
 
-	return ttm_bo_vmap(bo, map);
+	dma_resv_lock(gem->resv, NULL);
+	ret = ttm_bo_vmap(bo, map);
+	dma_resv_unlock(gem->resv);
+
+	return ret;
 }
 EXPORT_SYMBOL(drm_gem_ttm_vmap);
 
@@ -82,7 +87,9 @@ void drm_gem_ttm_vunmap(struct drm_gem_o
 {
 	struct ttm_buffer_object *bo = drm_gem_ttm_of_gem(gem);
 
+	dma_resv_lock(gem->resv, NULL);
 	ttm_bo_vunmap(bo, map);
+	dma_resv_unlock(gem->resv);
 }
 EXPORT_SYMBOL(drm_gem_ttm_vunmap);
 


