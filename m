Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45F36AEF86
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbjCGSYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjCGSXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE99C2384B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:19:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A73C614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECCAC4339B;
        Tue,  7 Mar 2023 18:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213140;
        bh=JL8FWiKFOfWk3h+VT1ug0sPxierfnzzUvRYELMr4JVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=causDadFLRVqcM00D6aFdnjBzf+ddu0KcQ1SHxGinQPy5ahbO1jAc7PEBk5Blec/n
         wA+pRcWCVSLHqCywDXw+pwoswvdajFUCwRP2so8MuuADHdZwn9xt7R/i+TG/9QajQg
         2B724wIxtkq+ZkPJhwraP+n6OW+Wh+2TezO8oOlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Asahi Lina <lina@asahilina.net>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 372/885] drm/shmem-helper: Fix locking for drm_gem_shmem_get_pages_sgt()
Date:   Tue,  7 Mar 2023 17:55:06 +0100
Message-Id: <20230307170018.478513666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Asahi Lina <lina@asahilina.net>

[ Upstream commit ddddedaa0db99481c5e5abe628ad54f65e8765bc ]

Other functions touching shmem->sgt take the pages lock, so do that here
too. drm_gem_shmem_get_pages() & co take the same lock, so move to the
_locked() variants to avoid recursive locking.

Discovered while auditing locking to write the Rust abstractions.

Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Fixes: 4fa3d66f132b ("drm/shmem: Do dma_unmap_sg before purging pages")
Signed-off-by: Asahi Lina <lina@asahilina.net>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230205125124.2260-1-lina@asahilina.net
(cherry picked from commit aa8c85affe3facd3842c8912186623415931cc72)
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 54 ++++++++++++++++----------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index b602cd72a1205..2c559b310cad3 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -681,23 +681,7 @@ struct sg_table *drm_gem_shmem_get_sg_table(struct drm_gem_shmem_object *shmem)
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_get_sg_table);
 
-/**
- * drm_gem_shmem_get_pages_sgt - Pin pages, dma map them, and return a
- *				 scatter/gather table for a shmem GEM object.
- * @shmem: shmem GEM object
- *
- * This function returns a scatter/gather table suitable for driver usage. If
- * the sg table doesn't exist, the pages are pinned, dma-mapped, and a sg
- * table created.
- *
- * This is the main function for drivers to get at backing storage, and it hides
- * and difference between dma-buf imported and natively allocated objects.
- * drm_gem_shmem_get_sg_table() should not be directly called by drivers.
- *
- * Returns:
- * A pointer to the scatter/gather table of pinned pages or errno on failure.
- */
-struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
+static struct sg_table *drm_gem_shmem_get_pages_sgt_locked(struct drm_gem_shmem_object *shmem)
 {
 	struct drm_gem_object *obj = &shmem->base;
 	int ret;
@@ -708,7 +692,7 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
 
 	WARN_ON(obj->import_attach);
 
-	ret = drm_gem_shmem_get_pages(shmem);
+	ret = drm_gem_shmem_get_pages_locked(shmem);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -730,10 +714,40 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
 	sg_free_table(sgt);
 	kfree(sgt);
 err_put_pages:
-	drm_gem_shmem_put_pages(shmem);
+	drm_gem_shmem_put_pages_locked(shmem);
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(drm_gem_shmem_get_pages_sgt);
+
+/**
+ * drm_gem_shmem_get_pages_sgt - Pin pages, dma map them, and return a
+ *				 scatter/gather table for a shmem GEM object.
+ * @shmem: shmem GEM object
+ *
+ * This function returns a scatter/gather table suitable for driver usage. If
+ * the sg table doesn't exist, the pages are pinned, dma-mapped, and a sg
+ * table created.
+ *
+ * This is the main function for drivers to get at backing storage, and it hides
+ * and difference between dma-buf imported and natively allocated objects.
+ * drm_gem_shmem_get_sg_table() should not be directly called by drivers.
+ *
+ * Returns:
+ * A pointer to the scatter/gather table of pinned pages or errno on failure.
+ */
+struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
+{
+	int ret;
+	struct sg_table *sgt;
+
+	ret = mutex_lock_interruptible(&shmem->pages_lock);
+	if (ret)
+		return ERR_PTR(ret);
+	sgt = drm_gem_shmem_get_pages_sgt_locked(shmem);
+	mutex_unlock(&shmem->pages_lock);
+
+	return sgt;
+}
+EXPORT_SYMBOL(drm_gem_shmem_get_pages_sgt);
 
 /**
  * drm_gem_shmem_prime_import_sg_table - Produce a shmem GEM object from
-- 
2.39.2



