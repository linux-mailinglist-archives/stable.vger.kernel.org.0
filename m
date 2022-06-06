Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE8F53E2A2
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiFFHvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiFFHvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:51:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE3F5B88E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD03EB81218
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3784CC385A9;
        Mon,  6 Jun 2022 07:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501878;
        bh=ejmrB3EyxlBmoZoBdARZfxC9LAhoZpeKjEZOKYUTzWE=;
        h=Subject:To:Cc:From:Date:From;
        b=LTvrQofXVv2tFB2Rb2RcBZ03fteJXM0cLE4jjs9Eb4vcG9rRgKO/WUhiRJ/xHtnn1
         pmH0OaruGX9NzxxLivPIsjYZ55HBR7oDrXpdcIGHo2R7VStr94XRfdNqaiLZBXq1iL
         Q27vc5zO4RLE+h8T82kasnckpySaNFZ+65W30p+I=
Subject: WTF: patch "[PATCH] landlock: Define access_mask_t to enforce a consistent access" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net, paul@paul-moore.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:51:07 +0200
Message-ID: <1654501867182210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.18-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5f2ff33e10843ef51275c8611bdb7b49537aba5d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:10:51 +0200
Subject: [PATCH] landlock: Define access_mask_t to enforce a consistent access
 mask size
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Create and use the access_mask_t typedef to enforce a consistent access
mask size and uniformly use a 16-bits type.  This will helps transition
to a 32-bits value one day.

Add a build check to make sure all (filesystem) access rights fit in.
This will be extended with a following commit.

Reviewed-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20220506161102.525323-2-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index eeecf5b2fa89..d4006add8bdf 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -152,7 +152,8 @@ static struct landlock_object *get_inode_object(struct inode *const inode)
  * @path: Should have been checked by get_path_from_fd().
  */
 int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
-			    const struct path *const path, u32 access_rights)
+			    const struct path *const path,
+			    access_mask_t access_rights)
 {
 	int err;
 	struct landlock_object *object;
@@ -184,7 +185,8 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 
 static inline u64 unmask_layers(const struct landlock_ruleset *const domain,
 				const struct path *const path,
-				const u32 access_request, u64 layer_mask)
+				const access_mask_t access_request,
+				u64 layer_mask)
 {
 	const struct landlock_rule *rule;
 	const struct inode *inode;
@@ -224,7 +226,8 @@ static inline u64 unmask_layers(const struct landlock_ruleset *const domain,
 }
 
 static int check_access_path(const struct landlock_ruleset *const domain,
-			     const struct path *const path, u32 access_request)
+			     const struct path *const path,
+			     const access_mask_t access_request)
 {
 	bool allowed = false;
 	struct path walker_path;
@@ -309,7 +312,7 @@ static int check_access_path(const struct landlock_ruleset *const domain,
 }
 
 static inline int current_check_access_path(const struct path *const path,
-					    const u32 access_request)
+					    const access_mask_t access_request)
 {
 	const struct landlock_ruleset *const dom =
 		landlock_get_current_domain();
@@ -512,7 +515,7 @@ static int hook_sb_pivotroot(const struct path *const old_path,
 
 /* Path hooks */
 
-static inline u32 get_mode_access(const umode_t mode)
+static inline access_mask_t get_mode_access(const umode_t mode)
 {
 	switch (mode & S_IFMT) {
 	case S_IFLNK:
@@ -565,7 +568,7 @@ static int hook_path_link(struct dentry *const old_dentry,
 		get_mode_access(d_backing_inode(old_dentry)->i_mode));
 }
 
-static inline u32 maybe_remove(const struct dentry *const dentry)
+static inline access_mask_t maybe_remove(const struct dentry *const dentry)
 {
 	if (d_is_negative(dentry))
 		return 0;
@@ -635,9 +638,9 @@ static int hook_path_rmdir(const struct path *const dir,
 
 /* File hooks */
 
-static inline u32 get_file_access(const struct file *const file)
+static inline access_mask_t get_file_access(const struct file *const file)
 {
-	u32 access = 0;
+	access_mask_t access = 0;
 
 	if (file->f_mode & FMODE_READ) {
 		/* A directory can only be opened in read mode. */
diff --git a/security/landlock/fs.h b/security/landlock/fs.h
index 03f746e74e9e..8db7acf9109b 100644
--- a/security/landlock/fs.h
+++ b/security/landlock/fs.h
@@ -66,6 +66,6 @@ __init void landlock_add_fs_hooks(void);
 
 int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 			    const struct path *const path,
-			    u32 access_hierarchy);
+			    access_mask_t access_hierarchy);
 
 #endif /* _SECURITY_LANDLOCK_FS_H */
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index a274ae6b5570..41372f22837f 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -9,6 +9,7 @@
 #ifndef _SECURITY_LANDLOCK_LIMITS_H
 #define _SECURITY_LANDLOCK_LIMITS_H
 
+#include <linux/bitops.h>
 #include <linux/limits.h>
 #include <uapi/linux/landlock.h>
 
@@ -19,6 +20,7 @@
 
 #define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_MAKE_SYM
 #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
+#define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
 
 /* clang-format on */
 
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 4d33359addbd..996484f98bfd 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -45,7 +45,8 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	return new_ruleset;
 }
 
-struct landlock_ruleset *landlock_create_ruleset(const u32 fs_access_mask)
+struct landlock_ruleset *
+landlock_create_ruleset(const access_mask_t fs_access_mask)
 {
 	struct landlock_ruleset *new_ruleset;
 
@@ -228,7 +229,8 @@ static void build_check_layer(void)
 
 /* @ruleset must be locked by the caller. */
 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-			 struct landlock_object *const object, const u32 access)
+			 struct landlock_object *const object,
+			 const access_mask_t access)
 {
 	struct landlock_layer layers[] = { {
 		.access = access,
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index e9ba47045aca..8d5717594931 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -9,13 +9,20 @@
 #ifndef _SECURITY_LANDLOCK_RULESET_H
 #define _SECURITY_LANDLOCK_RULESET_H
 
+#include <linux/bitops.h>
+#include <linux/build_bug.h>
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
 #include <linux/refcount.h>
 #include <linux/workqueue.h>
 
+#include "limits.h"
 #include "object.h"
 
+typedef u16 access_mask_t;
+/* Makes sure all filesystem access rights can be stored. */
+static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
+
 /**
  * struct landlock_layer - Access rights for a given layer
  */
@@ -28,7 +35,7 @@ struct landlock_layer {
 	 * @access: Bitfield of allowed actions on the kernel object.  They are
 	 * relative to the object type (e.g. %LANDLOCK_ACTION_FS_READ).
 	 */
-	u16 access;
+	access_mask_t access;
 };
 
 /**
@@ -135,19 +142,20 @@ struct landlock_ruleset {
 			 * layers are set once and never changed for the
 			 * lifetime of the ruleset.
 			 */
-			u16 fs_access_masks[];
+			access_mask_t fs_access_masks[];
 		};
 	};
 };
 
-struct landlock_ruleset *landlock_create_ruleset(const u32 fs_access_mask);
+struct landlock_ruleset *
+landlock_create_ruleset(const access_mask_t fs_access_mask);
 
 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
 
 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
 			 struct landlock_object *const object,
-			 const u32 access);
+			 const access_mask_t access);
 
 struct landlock_ruleset *
 landlock_merge_ruleset(struct landlock_ruleset *const parent,

