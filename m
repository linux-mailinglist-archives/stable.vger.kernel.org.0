Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880FC6810BB
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbjA3OGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbjA3OGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2F23B3ED
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DF17B81132
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941D3C433EF;
        Mon, 30 Jan 2023 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087564;
        bh=RYGBw4iF8YP5daCzuYM8BQBQVP8zZYEz5c0rqqyIiCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaqW9SI6E0QyJNnbTHkmx6+EH4YKbVmFlk+Z+yJFbPRymYmr7DFlp7Y4fS8/sHZV8
         RgblAFprRBMIC0lZrnY2UUtwn2tKjrc0sN3ddatZlzUlFBF3q1McQgfiSKWuZL/Cu5
         BgQYWHqSx3nu2nAtCd11UtF9Vo2ndnIcyv3+opeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/313] drm/drm_vma_manager: Add drm_vma_node_allow_once()
Date:   Mon, 30 Jan 2023 14:51:25 +0100
Message-Id: <20230130134348.358434849@linuxfoundation.org>
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

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 899d3a3c19ac0e5da013ce34833dccb97d19b5e4 ]

Currently there is no easy way for a drm driver to safely check and allow
drm_vma_offset_node for a drm file just once. Allow drm drivers to call
non-refcounted version of drm_vma_node_allow() so that a driver doesn't
need to keep track of each drm_vma_node_allow() to call subsequent
drm_vma_node_revoke() to prevent memory leak.

Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>

Suggested-by: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://lore.kernel.org/r/20230117175236.22317-1-nirmoy.das@intel.com
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_vma_manager.c | 76 ++++++++++++++++++++++---------
 include/drm/drm_vma_manager.h     |  1 +
 2 files changed, 55 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/drm_vma_manager.c b/drivers/gpu/drm/drm_vma_manager.c
index 7de37f8c68fd..83229a031af0 100644
--- a/drivers/gpu/drm/drm_vma_manager.c
+++ b/drivers/gpu/drm/drm_vma_manager.c
@@ -240,27 +240,8 @@ void drm_vma_offset_remove(struct drm_vma_offset_manager *mgr,
 }
 EXPORT_SYMBOL(drm_vma_offset_remove);
 
-/**
- * drm_vma_node_allow - Add open-file to list of allowed users
- * @node: Node to modify
- * @tag: Tag of file to remove
- *
- * Add @tag to the list of allowed open-files for this node. If @tag is
- * already on this list, the ref-count is incremented.
- *
- * The list of allowed-users is preserved across drm_vma_offset_add() and
- * drm_vma_offset_remove() calls. You may even call it if the node is currently
- * not added to any offset-manager.
- *
- * You must remove all open-files the same number of times as you added them
- * before destroying the node. Otherwise, you will leak memory.
- *
- * This is locked against concurrent access internally.
- *
- * RETURNS:
- * 0 on success, negative error code on internal failure (out-of-mem)
- */
-int drm_vma_node_allow(struct drm_vma_offset_node *node, struct drm_file *tag)
+static int vma_node_allow(struct drm_vma_offset_node *node,
+			  struct drm_file *tag, bool ref_counted)
 {
 	struct rb_node **iter;
 	struct rb_node *parent = NULL;
@@ -282,7 +263,8 @@ int drm_vma_node_allow(struct drm_vma_offset_node *node, struct drm_file *tag)
 		entry = rb_entry(*iter, struct drm_vma_offset_file, vm_rb);
 
 		if (tag == entry->vm_tag) {
-			entry->vm_count++;
+			if (ref_counted)
+				entry->vm_count++;
 			goto unlock;
 		} else if (tag > entry->vm_tag) {
 			iter = &(*iter)->rb_right;
@@ -307,8 +289,58 @@ int drm_vma_node_allow(struct drm_vma_offset_node *node, struct drm_file *tag)
 	kfree(new);
 	return ret;
 }
+
+/**
+ * drm_vma_node_allow - Add open-file to list of allowed users
+ * @node: Node to modify
+ * @tag: Tag of file to remove
+ *
+ * Add @tag to the list of allowed open-files for this node. If @tag is
+ * already on this list, the ref-count is incremented.
+ *
+ * The list of allowed-users is preserved across drm_vma_offset_add() and
+ * drm_vma_offset_remove() calls. You may even call it if the node is currently
+ * not added to any offset-manager.
+ *
+ * You must remove all open-files the same number of times as you added them
+ * before destroying the node. Otherwise, you will leak memory.
+ *
+ * This is locked against concurrent access internally.
+ *
+ * RETURNS:
+ * 0 on success, negative error code on internal failure (out-of-mem)
+ */
+int drm_vma_node_allow(struct drm_vma_offset_node *node, struct drm_file *tag)
+{
+	return vma_node_allow(node, tag, true);
+}
 EXPORT_SYMBOL(drm_vma_node_allow);
 
+/**
+ * drm_vma_node_allow_once - Add open-file to list of allowed users
+ * @node: Node to modify
+ * @tag: Tag of file to remove
+ *
+ * Add @tag to the list of allowed open-files for this node.
+ *
+ * The list of allowed-users is preserved across drm_vma_offset_add() and
+ * drm_vma_offset_remove() calls. You may even call it if the node is currently
+ * not added to any offset-manager.
+ *
+ * This is not ref-counted unlike drm_vma_node_allow() hence drm_vma_node_revoke()
+ * should only be called once after this.
+ *
+ * This is locked against concurrent access internally.
+ *
+ * RETURNS:
+ * 0 on success, negative error code on internal failure (out-of-mem)
+ */
+int drm_vma_node_allow_once(struct drm_vma_offset_node *node, struct drm_file *tag)
+{
+	return vma_node_allow(node, tag, false);
+}
+EXPORT_SYMBOL(drm_vma_node_allow_once);
+
 /**
  * drm_vma_node_revoke - Remove open-file from list of allowed users
  * @node: Node to modify
diff --git a/include/drm/drm_vma_manager.h b/include/drm/drm_vma_manager.h
index 4f8c35206f7c..6c2a2f21dbf0 100644
--- a/include/drm/drm_vma_manager.h
+++ b/include/drm/drm_vma_manager.h
@@ -74,6 +74,7 @@ void drm_vma_offset_remove(struct drm_vma_offset_manager *mgr,
 			   struct drm_vma_offset_node *node);
 
 int drm_vma_node_allow(struct drm_vma_offset_node *node, struct drm_file *tag);
+int drm_vma_node_allow_once(struct drm_vma_offset_node *node, struct drm_file *tag);
 void drm_vma_node_revoke(struct drm_vma_offset_node *node,
 			 struct drm_file *tag);
 bool drm_vma_node_is_allowed(struct drm_vma_offset_node *node,
-- 
2.39.0



