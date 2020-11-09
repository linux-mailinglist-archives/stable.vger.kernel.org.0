Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B3D2ABA07
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733266AbgKINPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:15:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731267AbgKINPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8095C20663;
        Mon,  9 Nov 2020 13:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927700;
        bh=lhJw9MLSxeuMlKwr7XJWbLBrhen8ZwYinPn9KBaU/dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBz/o7ub1u1/p0Ib4uGbKwgSBapq56u0V4IeVFY70z/cBkucQCWCNKdcTu2jZ47QR
         YbU6rpKIl8A8sYaW/2nOzLjtw9gvQ/yREeY8hgIx13ckgpyNHCN4t9QinQaqiP+9vo
         olttbGArJJ6nkdid1MOfeH5Zuy+brV8Wsmw79l0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.4 78/85] drm/panfrost: Fix a deadlock between the shrinker and madvise path
Date:   Mon,  9 Nov 2020 13:56:15 +0100
Message-Id: <20201109125026.325891765@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 7d2d6d01293e6d9b42a6cb410be4158571f7fe9d upstream.

panfrost_ioctl_madvise() and panfrost_gem_purge() acquire the mappings
and shmem locks in different orders, thus leading to a potential
the mappings lock first.

Fixes: bdefca2d8dc0 ("drm/panfrost: Add the panfrost_gem_mapping concept")
Cc: <stable@vger.kernel.org>
Cc: Christian Hewitt <christianshewitt@gmail.com>
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201101174016.839110-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_gem.c          |    4 +---
 drivers/gpu/drm/panfrost/panfrost_gem.h          |    2 +-
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c |   14 +++++++++++---
 3 files changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -105,14 +105,12 @@ void panfrost_gem_mapping_put(struct pan
 	kref_put(&mapping->refcount, panfrost_gem_mapping_release);
 }
 
-void panfrost_gem_teardown_mappings(struct panfrost_gem_object *bo)
+void panfrost_gem_teardown_mappings_locked(struct panfrost_gem_object *bo)
 {
 	struct panfrost_gem_mapping *mapping;
 
-	mutex_lock(&bo->mappings.lock);
 	list_for_each_entry(mapping, &bo->mappings.list, node)
 		panfrost_gem_teardown_mapping(mapping);
-	mutex_unlock(&bo->mappings.lock);
 }
 
 int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv)
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -82,7 +82,7 @@ struct panfrost_gem_mapping *
 panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
 			 struct panfrost_file_priv *priv);
 void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping);
-void panfrost_gem_teardown_mappings(struct panfrost_gem_object *bo);
+void panfrost_gem_teardown_mappings_locked(struct panfrost_gem_object *bo);
 
 void panfrost_gem_shrinker_init(struct drm_device *dev);
 void panfrost_gem_shrinker_cleanup(struct drm_device *dev);
--- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
@@ -40,18 +40,26 @@ static bool panfrost_gem_purge(struct dr
 {
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
 	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
+	bool ret = false;
 
 	if (atomic_read(&bo->gpu_usecount))
 		return false;
 
-	if (!mutex_trylock(&shmem->pages_lock))
+	if (!mutex_trylock(&bo->mappings.lock))
 		return false;
 
-	panfrost_gem_teardown_mappings(bo);
+	if (!mutex_trylock(&shmem->pages_lock))
+		goto unlock_mappings;
+
+	panfrost_gem_teardown_mappings_locked(bo);
 	drm_gem_shmem_purge_locked(obj);
+	ret = true;
 
 	mutex_unlock(&shmem->pages_lock);
-	return true;
+
+unlock_mappings:
+	mutex_unlock(&bo->mappings.lock);
+	return ret;
 }
 
 static unsigned long


