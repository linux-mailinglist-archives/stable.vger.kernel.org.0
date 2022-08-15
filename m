Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237DA593654
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243392AbiHOSoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiHOSmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:42:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C462AC6E;
        Mon, 15 Aug 2022 11:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6403560F23;
        Mon, 15 Aug 2022 18:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFFDC433D7;
        Mon, 15 Aug 2022 18:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587974;
        bh=HCDTP6YCyVvWZ0zXAbXHOSnCidLQo2cVAidr/dDN0dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ALCVUzH2oBn9izkjXO2emnzIAw9+WLvYfwMMsXcTYGoVYzLS4QzLIX4nPPIp5Nnf
         1r4RV4ba4ydMuY99YwTKNsjdk8wsfhML7ff5ze4hMz/7TjE12XKyq0D2ObivHu0NVN
         SG7tlVXEGDe/WAfJns4n09pnf7nZXmcybKQSSsBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/779] drm/shmem-helper: Unexport drm_gem_shmem_create_with_handle()
Date:   Mon, 15 Aug 2022 19:58:18 +0200
Message-Id: <20220815180348.189902912@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 5a363c20673308e968b6640deb73d7bf77e8b463 ]

Turn drm_gem_shmem_create_with_handle() into an internal helper
function. It's not used outside of the compilation unit.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20211108093149.7226-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 3 +--
 include/drm/drm_gem_shmem_helper.h     | 5 -----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 3eb580d76559..15e53674ed54 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -391,7 +391,7 @@ void drm_gem_shmem_vunmap(struct drm_gem_object *obj, struct dma_buf_map *map)
 }
 EXPORT_SYMBOL(drm_gem_shmem_vunmap);
 
-struct drm_gem_shmem_object *
+static struct drm_gem_shmem_object *
 drm_gem_shmem_create_with_handle(struct drm_file *file_priv,
 				 struct drm_device *dev, size_t size,
 				 uint32_t *handle)
@@ -415,7 +415,6 @@ drm_gem_shmem_create_with_handle(struct drm_file *file_priv,
 
 	return shmem;
 }
-EXPORT_SYMBOL(drm_gem_shmem_create_with_handle);
 
 /* Update madvise status, returns true if not purged, else
  * false or -errno.
diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
index 434328d8a0d9..6b47eb7d9f76 100644
--- a/include/drm/drm_gem_shmem_helper.h
+++ b/include/drm/drm_gem_shmem_helper.h
@@ -128,11 +128,6 @@ static inline bool drm_gem_shmem_is_purgeable(struct drm_gem_shmem_object *shmem
 void drm_gem_shmem_purge_locked(struct drm_gem_object *obj);
 bool drm_gem_shmem_purge(struct drm_gem_object *obj);
 
-struct drm_gem_shmem_object *
-drm_gem_shmem_create_with_handle(struct drm_file *file_priv,
-				 struct drm_device *dev, size_t size,
-				 uint32_t *handle);
-
 int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
 			      struct drm_mode_create_dumb *args);
 
-- 
2.35.1



