Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC9D540F87
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353948AbiFGTIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354126AbiFGTI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:08:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF952190D31;
        Tue,  7 Jun 2022 11:05:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A89EB82182;
        Tue,  7 Jun 2022 18:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80358C385A5;
        Tue,  7 Jun 2022 18:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625148;
        bh=XP3Mb+1/rM2xKkSYEbOakwN+wCNqt6xuKKFApfb3IVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqnoBVDZUb23liCwZUnpNuk4wmvy9J23L8uMUwgmefi6olfy//XYf0XQFe0mfWxls
         rMvbTpLNsQMFjl59m6ZBuoJQ9lUFH6y17t85tYlAeIJTz+qks9N2IMmw80K6yY5Qfr
         Ifb6ROajdz12UeRJYajAFhZhTTuOs8R1D41grMeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 584/667] landlock: Define access_mask_t to enforce a consistent access mask size
Date:   Tue,  7 Jun 2022 19:04:09 +0200
Message-Id: <20220607164952.199743355@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mickaël Salaün <mic@digikod.net>

commit 5f2ff33e10843ef51275c8611bdb7b49537aba5d upstream.

Create and use the access_mask_t typedef to enforce a consistent access
mask size and uniformly use a 16-bits type.  This will helps transition
to a 32-bits value one day.

Add a build check to make sure all (filesystem) access rights fit in.
This will be extended with a following commit.

Reviewed-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20220506161102.525323-2-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c      |   19 +++++++++++--------
 security/landlock/fs.h      |    2 +-
 security/landlock/limits.h  |    2 ++
 security/landlock/ruleset.c |    6 ++++--
 security/landlock/ruleset.h |   16 ++++++++++++----
 5 files changed, 30 insertions(+), 15 deletions(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -152,7 +152,8 @@ retry:
  * @path: Should have been checked by get_path_from_fd().
  */
 int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
-			    const struct path *const path, u32 access_rights)
+			    const struct path *const path,
+			    access_mask_t access_rights)
 {
 	int err;
 	struct landlock_object *object;
@@ -184,7 +185,8 @@ int landlock_append_fs_rule(struct landl
 
 static inline u64 unmask_layers(const struct landlock_ruleset *const domain,
 				const struct path *const path,
-				const u32 access_request, u64 layer_mask)
+				const access_mask_t access_request,
+				u64 layer_mask)
 {
 	const struct landlock_rule *rule;
 	const struct inode *inode;
@@ -224,7 +226,8 @@ static inline u64 unmask_layers(const st
 }
 
 static int check_access_path(const struct landlock_ruleset *const domain,
-			     const struct path *const path, u32 access_request)
+			     const struct path *const path,
+			     const access_mask_t access_request)
 {
 	bool allowed = false;
 	struct path walker_path;
@@ -309,7 +312,7 @@ jump_up:
 }
 
 static inline int current_check_access_path(const struct path *const path,
-					    const u32 access_request)
+					    const access_mask_t access_request)
 {
 	const struct landlock_ruleset *const dom =
 		landlock_get_current_domain();
@@ -512,7 +515,7 @@ static int hook_sb_pivotroot(const struc
 
 /* Path hooks */
 
-static inline u32 get_mode_access(const umode_t mode)
+static inline access_mask_t get_mode_access(const umode_t mode)
 {
 	switch (mode & S_IFMT) {
 	case S_IFLNK:
@@ -565,7 +568,7 @@ static int hook_path_link(struct dentry
 		get_mode_access(d_backing_inode(old_dentry)->i_mode));
 }
 
-static inline u32 maybe_remove(const struct dentry *const dentry)
+static inline access_mask_t maybe_remove(const struct dentry *const dentry)
 {
 	if (d_is_negative(dentry))
 		return 0;
@@ -635,9 +638,9 @@ static int hook_path_rmdir(const struct
 
 /* File hooks */
 
-static inline u32 get_file_access(const struct file *const file)
+static inline access_mask_t get_file_access(const struct file *const file)
 {
-	u32 access = 0;
+	access_mask_t access = 0;
 
 	if (file->f_mode & FMODE_READ) {
 		/* A directory can only be opened in read mode. */
--- a/security/landlock/fs.h
+++ b/security/landlock/fs.h
@@ -66,6 +66,6 @@ __init void landlock_add_fs_hooks(void);
 
 int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 			    const struct path *const path,
-			    u32 access_hierarchy);
+			    access_mask_t access_hierarchy);
 
 #endif /* _SECURITY_LANDLOCK_FS_H */
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
 
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -45,7 +45,8 @@ static struct landlock_ruleset *create_r
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


