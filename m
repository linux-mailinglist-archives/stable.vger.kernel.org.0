Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3885A540F7C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352139AbiFGTJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354767AbiFGTIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:08:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A661912FD;
        Tue,  7 Jun 2022 11:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D894B82340;
        Tue,  7 Jun 2022 18:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD83C385A5;
        Tue,  7 Jun 2022 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625159;
        bh=BbuWhrL/u/3VAlTjq8bBwrn0D7c8Xia0hI4fobjEowI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFBw5xdQUqIqCZzdx7Zz5TLsyqu+DtbA96un8r8PLddT3RvGhdfKsf3VHyW0nCSJm
         Ep80TNjE5S4EiSSLcVlBdnfUe9It7JG6mVnzOwehDoaI030sqQVM5BqI8DbpNOZ9gb
         IwcGqL0T7zuH+hngah9EzJR9fCaU1yXILEgNLnJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 587/667] landlock: Fix same-layer rule unions
Date:   Tue,  7 Jun 2022 19:04:12 +0200
Message-Id: <20220607164952.290457428@linuxfoundation.org>
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

commit 8ba0005ff418ec356e176b26eaa04a6ac755d05b upstream.

The original behavior was to check if the full set of requested accesses
was allowed by at least a rule of every relevant layer.  This didn't
take into account requests for multiple accesses and same-layer rules
allowing the union of these accesses in a complementary way.  As a
result, multiple accesses requested on a file hierarchy matching rules
that, together, allowed these accesses, but without a unique rule
allowing all of them, was illegitimately denied.  This case should be
rare in practice and it can only be triggered by the path_rename or
file_open hook implementations.

For instance, if, for the same layer, a rule allows execution
beneath /a/b and another rule allows read beneath /a, requesting access
to read and execute at the same time for /a/b should be allowed for this
layer.

This was an inconsistency because the union of same-layer rule accesses
was already allowed if requested once at a time anyway.

This fix changes the way allowed accesses are gathered over a path walk.
To take into account all these rule accesses, we store in a matrix all
layer granting the set of requested accesses, according to the handled
accesses.  To avoid heap allocation, we use an array on the stack which
is 2*13 bytes.  A following commit bringing the LANDLOCK_ACCESS_FS_REFER
access right will increase this size to reach 112 bytes (2*14*4) in case
of link or rename actions.

Add a new layout1.layer_rule_unions test to check that accesses from
different rules pertaining to the same layer are ORed in a file
hierarchy.  Also test that it is not the case for rules from different
layers.

Reviewed-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20220506161102.525323-5-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c                     |   80 ++++++++++++++-------
 security/landlock/ruleset.h                |    2 
 tools/testing/selftests/landlock/fs_test.c |  107 +++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+), 27 deletions(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -207,45 +207,67 @@ find_rule(const struct landlock_ruleset
 	return rule;
 }
 
-static inline layer_mask_t unmask_layers(const struct landlock_rule *const rule,
-					 const access_mask_t access_request,
-					 layer_mask_t layer_mask)
+/*
+ * @layer_masks is read and may be updated according to the access request and
+ * the matching rule.
+ *
+ * Returns true if the request is allowed (i.e. relevant layer masks for the
+ * request are empty).
+ */
+static inline bool
+unmask_layers(const struct landlock_rule *const rule,
+	      const access_mask_t access_request,
+	      layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
 {
 	size_t layer_level;
 
+	if (!access_request || !layer_masks)
+		return true;
 	if (!rule)
-		return layer_mask;
+		return false;
 
 	/*
 	 * An access is granted if, for each policy layer, at least one rule
-	 * encountered on the pathwalk grants the requested accesses,
-	 * regardless of their position in the layer stack.  We must then check
+	 * encountered on the pathwalk grants the requested access,
+	 * regardless of its position in the layer stack.  We must then check
 	 * the remaining layers for each inode, from the first added layer to
-	 * the last one.
+	 * the last one.  When there is multiple requested accesses, for each
+	 * policy layer, the full set of requested accesses may not be granted
+	 * by only one rule, but by the union (binary OR) of multiple rules.
+	 * E.g. /a/b <execute> + /a <read> => /a/b <execute + read>
 	 */
 	for (layer_level = 0; layer_level < rule->num_layers; layer_level++) {
 		const struct landlock_layer *const layer =
 			&rule->layers[layer_level];
 		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
-
-		/* Checks that the layer grants access to the full request. */
-		if ((layer->access & access_request) == access_request) {
-			layer_mask &= ~layer_bit;
-
-			if (layer_mask == 0)
-				return layer_mask;
+		const unsigned long access_req = access_request;
+		unsigned long access_bit;
+		bool is_empty;
+
+		/*
+		 * Records in @layer_masks which layer grants access to each
+		 * requested access.
+		 */
+		is_empty = true;
+		for_each_set_bit(access_bit, &access_req,
+				 ARRAY_SIZE(*layer_masks)) {
+			if (layer->access & BIT_ULL(access_bit))
+				(*layer_masks)[access_bit] &= ~layer_bit;
+			is_empty = is_empty && !(*layer_masks)[access_bit];
 		}
+		if (is_empty)
+			return true;
 	}
-	return layer_mask;
+	return false;
 }
 
 static int check_access_path(const struct landlock_ruleset *const domain,
 			     const struct path *const path,
 			     const access_mask_t access_request)
 {
-	bool allowed = false;
+	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};
+	bool allowed = false, has_access = false;
 	struct path walker_path;
-	layer_mask_t layer_mask;
 	size_t i;
 
 	if (!access_request)
@@ -265,13 +287,20 @@ static int check_access_path(const struc
 		return -EACCES;
 
 	/* Saves all layers handling a subset of requested accesses. */
-	layer_mask = 0;
 	for (i = 0; i < domain->num_layers; i++) {
-		if (domain->fs_access_masks[i] & access_request)
-			layer_mask |= BIT_ULL(i);
+		const unsigned long access_req = access_request;
+		unsigned long access_bit;
+
+		for_each_set_bit(access_bit, &access_req,
+				 ARRAY_SIZE(layer_masks)) {
+			if (domain->fs_access_masks[i] & BIT_ULL(access_bit)) {
+				layer_masks[access_bit] |= BIT_ULL(i);
+				has_access = true;
+			}
+		}
 	}
 	/* An access request not handled by the domain is allowed. */
-	if (layer_mask == 0)
+	if (!has_access)
 		return 0;
 
 	walker_path = *path;
@@ -283,14 +312,11 @@ static int check_access_path(const struc
 	while (true) {
 		struct dentry *parent_dentry;
 
-		layer_mask =
-			unmask_layers(find_rule(domain, walker_path.dentry),
-				      access_request, layer_mask);
-		if (layer_mask == 0) {
+		allowed = unmask_layers(find_rule(domain, walker_path.dentry),
+					access_request, &layer_masks);
+		if (allowed)
 			/* Stops when a rule from each layer grants access. */
-			allowed = true;
 			break;
-		}
 
 jump_up:
 		if (walker_path.dentry == walker_path.mnt->mnt_root) {
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -22,6 +22,8 @@
 typedef u16 access_mask_t;
 /* Makes sure all filesystem access rights can be stored. */
 static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
+/* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
+static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
 
 typedef u16 layer_mask_t;
 /* Makes sure all layers can be checked. */
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -758,6 +758,113 @@ TEST_F_FORK(layout1, ruleset_overlap)
 	ASSERT_EQ(0, test_open(dir_s1d3, O_RDONLY | O_DIRECTORY));
 }
 
+TEST_F_FORK(layout1, layer_rule_unions)
+{
+	const struct rule layer1[] = {
+		{
+			.path = dir_s1d2,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE,
+		},
+		/* dir_s1d3 should allow READ_FILE and WRITE_FILE (O_RDWR). */
+		{
+			.path = dir_s1d3,
+			.access = LANDLOCK_ACCESS_FS_WRITE_FILE,
+		},
+		{},
+	};
+	const struct rule layer2[] = {
+		/* Doesn't change anything from layer1. */
+		{
+			.path = dir_s1d2,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_WRITE_FILE,
+		},
+		{},
+	};
+	const struct rule layer3[] = {
+		/* Only allows write (but not read) to dir_s1d3. */
+		{
+			.path = dir_s1d2,
+			.access = LANDLOCK_ACCESS_FS_WRITE_FILE,
+		},
+		{},
+	};
+	int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, layer1);
+
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Checks s1d1 hierarchy with layer1. */
+	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_RDONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_WRONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_RDWR));
+	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY | O_DIRECTORY));
+
+	/* Checks s1d2 hierarchy with layer1. */
+	ASSERT_EQ(0, test_open(file1_s1d2, O_RDONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d2, O_WRONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d2, O_RDWR));
+	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY | O_DIRECTORY));
+
+	/* Checks s1d3 hierarchy with layer1. */
+	ASSERT_EQ(0, test_open(file1_s1d3, O_RDONLY));
+	ASSERT_EQ(0, test_open(file1_s1d3, O_WRONLY));
+	/* dir_s1d3 should allow READ_FILE and WRITE_FILE (O_RDWR). */
+	ASSERT_EQ(0, test_open(file1_s1d3, O_RDWR));
+	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY | O_DIRECTORY));
+
+	/* Doesn't change anything from layer1. */
+	ruleset_fd = create_ruleset(_metadata, ACCESS_RW, layer2);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Checks s1d1 hierarchy with layer2. */
+	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_RDONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_WRONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_RDWR));
+	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY | O_DIRECTORY));
+
+	/* Checks s1d2 hierarchy with layer2. */
+	ASSERT_EQ(0, test_open(file1_s1d2, O_RDONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d2, O_WRONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d2, O_RDWR));
+	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY | O_DIRECTORY));
+
+	/* Checks s1d3 hierarchy with layer2. */
+	ASSERT_EQ(0, test_open(file1_s1d3, O_RDONLY));
+	ASSERT_EQ(0, test_open(file1_s1d3, O_WRONLY));
+	/* dir_s1d3 should allow READ_FILE and WRITE_FILE (O_RDWR). */
+	ASSERT_EQ(0, test_open(file1_s1d3, O_RDWR));
+	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY | O_DIRECTORY));
+
+	/* Only allows write (but not read) to dir_s1d3. */
+	ruleset_fd = create_ruleset(_metadata, ACCESS_RW, layer3);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Checks s1d1 hierarchy with layer3. */
+	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_RDONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_WRONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_RDWR));
+	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY | O_DIRECTORY));
+
+	/* Checks s1d2 hierarchy with layer3. */
+	ASSERT_EQ(EACCES, test_open(file1_s1d2, O_RDONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d2, O_WRONLY));
+	ASSERT_EQ(EACCES, test_open(file1_s1d2, O_RDWR));
+	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY | O_DIRECTORY));
+
+	/* Checks s1d3 hierarchy with layer3. */
+	ASSERT_EQ(EACCES, test_open(file1_s1d3, O_RDONLY));
+	ASSERT_EQ(0, test_open(file1_s1d3, O_WRONLY));
+	/* dir_s1d3 should now deny READ_FILE and WRITE_FILE (O_RDWR). */
+	ASSERT_EQ(EACCES, test_open(file1_s1d3, O_RDWR));
+	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY | O_DIRECTORY));
+}
+
 TEST_F_FORK(layout1, non_overlapping_accesses)
 {
 	const struct rule layer1[] = {


