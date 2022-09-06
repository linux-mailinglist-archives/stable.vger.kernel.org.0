Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EEC5AEB96
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbiIFOKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241265AbiIFOJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:09:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E082C7F0AD;
        Tue,  6 Sep 2022 06:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E02376155C;
        Tue,  6 Sep 2022 13:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51FDC433D7;
        Tue,  6 Sep 2022 13:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471896;
        bh=Z+47WfzXgQGbIFJ7YbI60LHkdJTVE2NmVpxR34X8j24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IadmicO0AKXLq8+P8mawtnULYqrv9wacm+XEUt4bYvhVtg7xsWJxvwXWav5FvBY3f
         mPMRbGasZDxoAP5Y25MBncZavBh4GMNkm/YazFQNhse/phCU3hxXKPKUJ0vWj0YCZ4
         /KZDTKoM2JgAqkxHEzRXIUW67cd6dZNMEYEzZ/rE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.19 077/155] landlock: Fix file reparenting without explicit LANDLOCK_ACCESS_FS_REFER
Date:   Tue,  6 Sep 2022 15:30:25 +0200
Message-Id: <20220906132832.684849541@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Mickaël Salaün <mic@digikod.net>

commit 55e55920bbe3ccf516022c51f5527e7d026b8f1d upstream.

This change fixes a mis-handling of the LANDLOCK_ACCESS_FS_REFER right
when multiple rulesets/domains are stacked. The expected behaviour was
that an additional ruleset can only restrict the set of permitted
operations, but in this particular case, it was potentially possible to
re-gain the LANDLOCK_ACCESS_FS_REFER right.

With the introduction of LANDLOCK_ACCESS_FS_REFER, we added the first
globally denied-by-default access right.  Indeed, this lifted an initial
Landlock limitation to rename and link files, which was initially always
denied when the source or the destination were different directories.

This led to an inconsistent backward compatibility behavior which was
only taken into account if no domain layer were using the new
LANDLOCK_ACCESS_FS_REFER right. However, when restricting a thread with
a new ruleset handling LANDLOCK_ACCESS_FS_REFER, all inherited parent
rulesets/layers not explicitly handling LANDLOCK_ACCESS_FS_REFER would
behave as if they were handling this access right and with all their
rules allowing it. This means that renaming and linking files could
became allowed by these parent layers, but all the other required
accesses must also be granted: all layers must allow file removal or
creation, and renaming and linking operations cannot lead to privilege
escalation according to the Landlock policy.  See detailed explanation
in commit b91c3e4ea756 ("landlock: Add support for file reparenting with
LANDLOCK_ACCESS_FS_REFER").

To say it another way, this bug may lift the renaming and linking
limitations of the initial Landlock version, and a same ruleset can
enforce different restrictions depending on previous or next enforced
ruleset (i.e. inconsistent behavior). The LANDLOCK_ACCESS_FS_REFER right
cannot give access to data not already allowed, but this doesn't follow
the contract of the first Landlock ABI. This fix puts back the
limitation for sandboxes that didn't opt-in for this additional right.

For instance, if a first ruleset allows LANDLOCK_ACCESS_FS_MAKE_REG on
/dst and LANDLOCK_ACCESS_FS_REMOVE_FILE on /src, renaming /src/file to
/dst/file is denied. However, without this fix, stacking a new ruleset
which allows LANDLOCK_ACCESS_FS_REFER on / would now permit the
sandboxed thread to rename /src/file to /dst/file .

This change fixes the (absolute) rule access rights, which now always
forbid LANDLOCK_ACCESS_FS_REFER except when it is explicitly allowed
when creating a rule.

Making all domain handle LANDLOCK_ACCESS_FS_REFER was an initial
approach but there is two downsides:
* it makes the code more complex because we still want to check that a
  rule allowing LANDLOCK_ACCESS_FS_REFER is legitimate according to the
  ruleset's handled access rights (i.e. ABI v1 != ABI v2);
* it would not allow to identify if the user created a ruleset
  explicitly handling LANDLOCK_ACCESS_FS_REFER or not, which will be an
  issue to audit Landlock.

Instead, this change adds an ACCESS_INITIALLY_DENIED list of
denied-by-default rights, which (only) contains
LANDLOCK_ACCESS_FS_REFER.  All domains are treated as if they are also
handling this list, but without modifying their fs_access_masks field.

A side effect is that the errno code returned by rename(2) or link(2)
*may* be changed from EXDEV to EACCES according to the enforced
restrictions.  Indeed, we now have the mechanic to identify if an access
is denied because of a required right (e.g. LANDLOCK_ACCESS_FS_MAKE_REG,
LANDLOCK_ACCESS_FS_REMOVE_FILE) or if it is denied because of missing
LANDLOCK_ACCESS_FS_REFER rights.  This may result in different errno
codes than for the initial Landlock version, but this approach is more
consistent and better for rename/link compatibility reasons, and it
wasn't possible before (hence no backport to ABI v1).  The
layout1.rename_file test reflects this change.

Add 4 layout1.refer_denied_by_default* test suites to check that the
behavior of a ruleset not handling LANDLOCK_ACCESS_FS_REFER (ABI v1) is
unchanged even if another layer handles LANDLOCK_ACCESS_FS_REFER (i.e.
ABI v1 precedence).  Make sure rule's absolute access rights are correct
by testing with and without a matching path.  Add test_rename() and
test_exchange() helpers.

Extend layout1.inval tests to check that a denied-by-default access
right is not necessarily part of a domain's handled access rights.

Test coverage for security/landlock is 95.3% of 599 lines according to
gcc/gcov-11.

Fixes: b91c3e4ea756 ("landlock: Add support for file reparenting with LANDLOCK_ACCESS_FS_REFER")
Reviewed-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20220831203840.1370732-1-mic@digikod.net
Cc: stable@vger.kernel.org
[mic: Constify and slightly simplify test helpers]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c                     |  48 ++++---
 tools/testing/selftests/landlock/fs_test.c | 155 +++++++++++++++++++--
 2 files changed, 170 insertions(+), 33 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index ec5a6247cd3e..a9dbd99d9ee7 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -149,6 +149,16 @@ retry:
 	LANDLOCK_ACCESS_FS_READ_FILE)
 /* clang-format on */
 
+/*
+ * All access rights that are denied by default whether they are handled or not
+ * by a ruleset/layer.  This must be ORed with all ruleset->fs_access_masks[]
+ * entries when we need to get the absolute handled access masks.
+ */
+/* clang-format off */
+#define ACCESS_INITIALLY_DENIED ( \
+	LANDLOCK_ACCESS_FS_REFER)
+/* clang-format on */
+
 /*
  * @path: Should have been checked by get_path_from_fd().
  */
@@ -167,7 +177,9 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 		return -EINVAL;
 
 	/* Transforms relative access rights to absolute ones. */
-	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->fs_access_masks[0];
+	access_rights |=
+		LANDLOCK_MASK_ACCESS_FS &
+		~(ruleset->fs_access_masks[0] | ACCESS_INITIALLY_DENIED);
 	object = get_inode_object(d_backing_inode(path->dentry));
 	if (IS_ERR(object))
 		return PTR_ERR(object);
@@ -277,23 +289,12 @@ static inline bool is_nouser_or_private(const struct dentry *dentry)
 static inline access_mask_t
 get_handled_accesses(const struct landlock_ruleset *const domain)
 {
-	access_mask_t access_dom = 0;
-	unsigned long access_bit;
-
-	for (access_bit = 0; access_bit < LANDLOCK_NUM_ACCESS_FS;
-	     access_bit++) {
-		size_t layer_level;
+	access_mask_t access_dom = ACCESS_INITIALLY_DENIED;
+	size_t layer_level;
 
-		for (layer_level = 0; layer_level < domain->num_layers;
-		     layer_level++) {
-			if (domain->fs_access_masks[layer_level] &
-			    BIT_ULL(access_bit)) {
-				access_dom |= BIT_ULL(access_bit);
-				break;
-			}
-		}
-	}
-	return access_dom;
+	for (layer_level = 0; layer_level < domain->num_layers; layer_level++)
+		access_dom |= domain->fs_access_masks[layer_level];
+	return access_dom & LANDLOCK_MASK_ACCESS_FS;
 }
 
 static inline access_mask_t
@@ -316,8 +317,13 @@ init_layer_masks(const struct landlock_ruleset *const domain,
 
 		for_each_set_bit(access_bit, &access_req,
 				 ARRAY_SIZE(*layer_masks)) {
-			if (domain->fs_access_masks[layer_level] &
-			    BIT_ULL(access_bit)) {
+			/*
+			 * Artificially handles all initially denied by default
+			 * access rights.
+			 */
+			if (BIT_ULL(access_bit) &
+			    (domain->fs_access_masks[layer_level] |
+			     ACCESS_INITIALLY_DENIED)) {
 				(*layer_masks)[access_bit] |=
 					BIT_ULL(layer_level);
 				handled_accesses |= BIT_ULL(access_bit);
@@ -857,10 +863,6 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 					      NULL, NULL);
 	}
 
-	/* Backward compatibility: no reparenting support. */
-	if (!(get_handled_accesses(dom) & LANDLOCK_ACCESS_FS_REFER))
-		return -EXDEV;
-
 	access_request_parent1 |= LANDLOCK_ACCESS_FS_REFER;
 	access_request_parent2 |= LANDLOCK_ACCESS_FS_REFER;
 
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 21a2ce8fa739..45de42a027c5 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -4,7 +4,7 @@
  *
  * Copyright © 2017-2020 Mickaël Salaün <mic@digikod.net>
  * Copyright © 2020 ANSSI
- * Copyright © 2020-2021 Microsoft Corporation
+ * Copyright © 2020-2022 Microsoft Corporation
  */
 
 #define _GNU_SOURCE
@@ -371,6 +371,13 @@ TEST_F_FORK(layout1, inval)
 	ASSERT_EQ(EINVAL, errno);
 	path_beneath.allowed_access &= ~LANDLOCK_ACCESS_FS_EXECUTE;
 
+	/* Tests with denied-by-default access right. */
+	path_beneath.allowed_access |= LANDLOCK_ACCESS_FS_REFER;
+	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
+					&path_beneath, 0));
+	ASSERT_EQ(EINVAL, errno);
+	path_beneath.allowed_access &= ~LANDLOCK_ACCESS_FS_REFER;
+
 	/* Test with unknown (64-bits) value. */
 	path_beneath.allowed_access |= (1ULL << 60);
 	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
@@ -1826,6 +1833,20 @@ TEST_F_FORK(layout1, link)
 	ASSERT_EQ(0, link(file1_s1d3, file2_s1d3));
 }
 
+static int test_rename(const char *const oldpath, const char *const newpath)
+{
+	if (rename(oldpath, newpath))
+		return errno;
+	return 0;
+}
+
+static int test_exchange(const char *const oldpath, const char *const newpath)
+{
+	if (renameat2(AT_FDCWD, oldpath, AT_FDCWD, newpath, RENAME_EXCHANGE))
+		return errno;
+	return 0;
+}
+
 TEST_F_FORK(layout1, rename_file)
 {
 	const struct rule rules[] = {
@@ -1867,10 +1888,10 @@ TEST_F_FORK(layout1, rename_file)
 	 * to a different directory (which allows file removal).
 	 */
 	ASSERT_EQ(-1, rename(file1_s2d1, file1_s1d3));
-	ASSERT_EQ(EXDEV, errno);
+	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, file1_s2d1, AT_FDCWD, file1_s1d3,
 				RENAME_EXCHANGE));
-	ASSERT_EQ(EXDEV, errno);
+	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, dir_s2d2, AT_FDCWD, file1_s1d3,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EXDEV, errno);
@@ -1894,7 +1915,7 @@ TEST_F_FORK(layout1, rename_file)
 	ASSERT_EQ(EXDEV, errno);
 	ASSERT_EQ(0, unlink(file1_s1d3));
 	ASSERT_EQ(-1, rename(file1_s2d1, file1_s1d3));
-	ASSERT_EQ(EXDEV, errno);
+	ASSERT_EQ(EACCES, errno);
 
 	/* Exchanges and renames files with same parent. */
 	ASSERT_EQ(0, renameat2(AT_FDCWD, file2_s2d3, AT_FDCWD, file1_s2d3,
@@ -2014,6 +2035,115 @@ TEST_F_FORK(layout1, reparent_refer)
 	ASSERT_EQ(0, rename(dir_s1d3, dir_s2d3));
 }
 
+/* Checks renames beneath dir_s1d1. */
+static void refer_denied_by_default(struct __test_metadata *const _metadata,
+				    const struct rule layer1[],
+				    const int layer1_err,
+				    const struct rule layer2[])
+{
+	int ruleset_fd;
+
+	ASSERT_EQ(0, unlink(file1_s1d2));
+
+	ruleset_fd = create_ruleset(_metadata, layer1[0].access, layer1);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * If the first layer handles LANDLOCK_ACCESS_FS_REFER (according to
+	 * layer1_err), then it allows some different-parent renames and links.
+	 */
+	ASSERT_EQ(layer1_err, test_rename(file1_s1d1, file1_s1d2));
+	if (layer1_err == 0)
+		ASSERT_EQ(layer1_err, test_rename(file1_s1d2, file1_s1d1));
+	ASSERT_EQ(layer1_err, test_exchange(file2_s1d1, file2_s1d2));
+	ASSERT_EQ(layer1_err, test_exchange(file2_s1d2, file2_s1d1));
+
+	ruleset_fd = create_ruleset(_metadata, layer2[0].access, layer2);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * Now, either the first or the second layer does not handle
+	 * LANDLOCK_ACCESS_FS_REFER, which means that any different-parent
+	 * renames and links are denied, thus making the layer handling
+	 * LANDLOCK_ACCESS_FS_REFER null and void.
+	 */
+	ASSERT_EQ(EXDEV, test_rename(file1_s1d1, file1_s1d2));
+	ASSERT_EQ(EXDEV, test_exchange(file2_s1d1, file2_s1d2));
+	ASSERT_EQ(EXDEV, test_exchange(file2_s1d2, file2_s1d1));
+}
+
+const struct rule layer_dir_s1d1_refer[] = {
+	{
+		.path = dir_s1d1,
+		.access = LANDLOCK_ACCESS_FS_REFER,
+	},
+	{},
+};
+
+const struct rule layer_dir_s1d1_execute[] = {
+	{
+		/* Matches a parent directory. */
+		.path = dir_s1d1,
+		.access = LANDLOCK_ACCESS_FS_EXECUTE,
+	},
+	{},
+};
+
+const struct rule layer_dir_s2d1_execute[] = {
+	{
+		/* Does not match a parent directory. */
+		.path = dir_s2d1,
+		.access = LANDLOCK_ACCESS_FS_EXECUTE,
+	},
+	{},
+};
+
+/*
+ * Tests precedence over renames: denied by default for different parent
+ * directories, *with* a rule matching a parent directory, but not directly
+ * denying access (with MAKE_REG nor REMOVE).
+ */
+TEST_F_FORK(layout1, refer_denied_by_default1)
+{
+	refer_denied_by_default(_metadata, layer_dir_s1d1_refer, 0,
+				layer_dir_s1d1_execute);
+}
+
+/*
+ * Same test but this time turning around the ABI version order: the first
+ * layer does not handle LANDLOCK_ACCESS_FS_REFER.
+ */
+TEST_F_FORK(layout1, refer_denied_by_default2)
+{
+	refer_denied_by_default(_metadata, layer_dir_s1d1_execute, EXDEV,
+				layer_dir_s1d1_refer);
+}
+
+/*
+ * Tests precedence over renames: denied by default for different parent
+ * directories, *without* a rule matching a parent directory, but not directly
+ * denying access (with MAKE_REG nor REMOVE).
+ */
+TEST_F_FORK(layout1, refer_denied_by_default3)
+{
+	refer_denied_by_default(_metadata, layer_dir_s1d1_refer, 0,
+				layer_dir_s2d1_execute);
+}
+
+/*
+ * Same test but this time turning around the ABI version order: the first
+ * layer does not handle LANDLOCK_ACCESS_FS_REFER.
+ */
+TEST_F_FORK(layout1, refer_denied_by_default4)
+{
+	refer_denied_by_default(_metadata, layer_dir_s2d1_execute, EXDEV,
+				layer_dir_s1d1_refer);
+}
+
 TEST_F_FORK(layout1, reparent_link)
 {
 	const struct rule layer1[] = {
@@ -2336,11 +2466,12 @@ TEST_F_FORK(layout1, reparent_exdev_layers_rename1)
 	ASSERT_EQ(EXDEV, errno);
 
 	/*
-	 * However, moving the file2_s1d3 file below dir_s2d3 is allowed
-	 * because it cannot inherit MAKE_REG nor MAKE_DIR rights (which are
-	 * dedicated to directories).
+	 * Moving the file2_s1d3 file below dir_s2d3 is denied because the
+	 * second layer does not handle REFER, which is always denied by
+	 * default.
 	 */
-	ASSERT_EQ(0, rename(file2_s1d3, file1_s2d3));
+	ASSERT_EQ(-1, rename(file2_s1d3, file1_s2d3));
+	ASSERT_EQ(EXDEV, errno);
 }
 
 TEST_F_FORK(layout1, reparent_exdev_layers_rename2)
@@ -2373,8 +2504,12 @@ TEST_F_FORK(layout1, reparent_exdev_layers_rename2)
 	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, rename(file1_s1d1, file1_s2d3));
 	ASSERT_EQ(EXDEV, errno);
-	/* Modify layout! */
-	ASSERT_EQ(0, rename(file2_s1d2, file1_s2d3));
+	/*
+	 * Modifying the layout is now denied because the second layer does not
+	 * handle REFER, which is always denied by default.
+	 */
+	ASSERT_EQ(-1, rename(file2_s1d2, file1_s2d3));
+	ASSERT_EQ(EXDEV, errno);
 
 	/* Without REFER source, EACCES wins over EXDEV. */
 	ASSERT_EQ(-1, rename(dir_s1d1, file1_s2d2));
-- 
2.37.3



