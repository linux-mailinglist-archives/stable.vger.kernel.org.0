Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9761053E230
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiFFHqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiFFHqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:46:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7654899692
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09196611B5
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103B6C385A9;
        Mon,  6 Jun 2022 07:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501579;
        bh=dEJ1FR8SqSFq5xp3Rsi4ryGTZTKw3OoIAUg9K+dIRhQ=;
        h=Subject:To:Cc:From:Date:From;
        b=Dq2gi1t46t6jUzDQYvmnNbbEX1Wz2n8AOTv4sGKeJVuOg26WvSn9sywyOk4+CfxQh
         ApqqRN8M6Ez0RIQVBovFWYrJRS8UZf3wd+vMmhpll1MAMTKdIvZEl1guGCjLnRwzqv
         gfXYDue5wtDo72A/EqKFgFEAJEBuVyuTQf0YlzUQ=
Subject: WTF: patch "[PATCH] selftests/landlock: Add clang-format exceptions" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:46:15 +0200
Message-ID: <1654501575117211@kroah.com>
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

From 4598d9abf4215e1e371a35683350d50122793c80 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:05:09 +0200
Subject: [PATCH] selftests/landlock: Add clang-format exceptions
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In preparation to a following commit, add clang-format on and
clang-format off stanzas around constant definitions and the TEST_F_FORK
macro.  This enables to keep aligned values, which is much more readable
than packed definitions.

Add other clang-format exceptions for FIXTURE() and
FIXTURE_VARIANT_ADD() declarations to force space before open brace,
which is reported by checkpatch.pl .

Link: https://lore.kernel.org/r/20220506160513.523257-4-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 183b7e8e1b95..435ba6963756 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -25,6 +25,7 @@
  * this to be possible, we must not call abort() but instead exit smoothly
  * (hence the step print).
  */
+/* clang-format off */
 #define TEST_F_FORK(fixture_name, test_name) \
 	static void fixture_name##_##test_name##_child( \
 		struct __test_metadata *_metadata, \
@@ -71,6 +72,7 @@
 		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
 		const FIXTURE_VARIANT(fixture_name) \
 			__attribute__((unused)) *variant)
+/* clang-format on */
 
 #ifndef landlock_create_ruleset
 static inline int landlock_create_ruleset(
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 10c9a1e4ebd9..aef2eb3d07cd 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -221,8 +221,9 @@ static void remove_layout1(struct __test_metadata *const _metadata)
 	EXPECT_EQ(0, remove_path(dir_s3d2));
 }
 
-FIXTURE(layout1) {
-};
+/* clang-format off */
+FIXTURE(layout1) {};
+/* clang-format on */
 
 FIXTURE_SETUP(layout1)
 {
@@ -376,6 +377,8 @@ TEST_F_FORK(layout1, inval)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
+/* clang-format off */
+
 #define ACCESS_FILE ( \
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_WRITE_FILE | \
@@ -396,6 +399,8 @@ TEST_F_FORK(layout1, inval)
 	LANDLOCK_ACCESS_FS_MAKE_BLOCK | \
 	ACCESS_LAST)
 
+/* clang-format on */
+
 TEST_F_FORK(layout1, file_access_rights)
 {
 	__u64 access;
@@ -452,6 +457,8 @@ struct rule {
 	__u64 access;
 };
 
+/* clang-format off */
+
 #define ACCESS_RO ( \
 	LANDLOCK_ACCESS_FS_READ_FILE | \
 	LANDLOCK_ACCESS_FS_READ_DIR)
@@ -460,6 +467,8 @@ struct rule {
 	ACCESS_RO | \
 	LANDLOCK_ACCESS_FS_WRITE_FILE)
 
+/* clang-format on */
+
 static int create_ruleset(struct __test_metadata *const _metadata,
 		const __u64 handled_access_fs, const struct rule rules[])
 {
@@ -2070,8 +2079,9 @@ TEST_F_FORK(layout1, proc_pipe)
 	ASSERT_EQ(0, close(pipe_fds[1]));
 }
 
-FIXTURE(layout1_bind) {
-};
+/* clang-format off */
+FIXTURE(layout1_bind) {};
+/* clang-format on */
 
 FIXTURE_SETUP(layout1_bind)
 {
@@ -2411,8 +2421,9 @@ static const char (*merge_sub_files[])[] = {
  *         └── work
  */
 
-FIXTURE(layout2_overlay) {
-};
+/* clang-format off */
+FIXTURE(layout2_overlay) {};
+/* clang-format on */
 
 FIXTURE_SETUP(layout2_overlay)
 {
diff --git a/tools/testing/selftests/landlock/ptrace_test.c b/tools/testing/selftests/landlock/ptrace_test.c
index 15fbef9cc849..090adadfe2dc 100644
--- a/tools/testing/selftests/landlock/ptrace_test.c
+++ b/tools/testing/selftests/landlock/ptrace_test.c
@@ -59,7 +59,9 @@ static int test_ptrace_read(const pid_t pid)
 	return 0;
 }
 
-FIXTURE(hierarchy) { };
+/* clang-format off */
+FIXTURE(hierarchy) {};
+/* clang-format on */
 
 FIXTURE_VARIANT(hierarchy) {
 	const bool domain_both;
@@ -83,7 +85,9 @@ FIXTURE_VARIANT(hierarchy) {
  *       \              P2 -> P1 : allow
  *        'P2
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, allow_without_domain) {
+	/* clang-format on */
 	.domain_both = false,
 	.domain_parent = false,
 	.domain_child = false,
@@ -98,7 +102,9 @@ FIXTURE_VARIANT_ADD(hierarchy, allow_without_domain) {
  *        |  P2  |
  *        '------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, allow_with_one_domain) {
+	/* clang-format on */
 	.domain_both = false,
 	.domain_parent = false,
 	.domain_child = true,
@@ -112,7 +118,9 @@ FIXTURE_VARIANT_ADD(hierarchy, allow_with_one_domain) {
  *            '
  *            P2
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, deny_with_parent_domain) {
+	/* clang-format on */
 	.domain_both = false,
 	.domain_parent = true,
 	.domain_child = false,
@@ -127,7 +135,9 @@ FIXTURE_VARIANT_ADD(hierarchy, deny_with_parent_domain) {
  *         |  P2  |
  *         '------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, deny_with_sibling_domain) {
+	/* clang-format on */
 	.domain_both = false,
 	.domain_parent = true,
 	.domain_child = true,
@@ -142,7 +152,9 @@ FIXTURE_VARIANT_ADD(hierarchy, deny_with_sibling_domain) {
  * |         P2  |
  * '-------------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, allow_sibling_domain) {
+	/* clang-format on */
 	.domain_both = true,
 	.domain_parent = false,
 	.domain_child = false,
@@ -158,7 +170,9 @@ FIXTURE_VARIANT_ADD(hierarchy, allow_sibling_domain) {
  * |        '------' |
  * '-----------------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, allow_with_nested_domain) {
+	/* clang-format on */
 	.domain_both = true,
 	.domain_parent = false,
 	.domain_child = true,
@@ -174,7 +188,9 @@ FIXTURE_VARIANT_ADD(hierarchy, allow_with_nested_domain) {
  * |             P2  |
  * '-----------------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, deny_with_nested_and_parent_domain) {
+	/* clang-format on */
 	.domain_both = true,
 	.domain_parent = true,
 	.domain_child = false,
@@ -192,7 +208,9 @@ FIXTURE_VARIANT_ADD(hierarchy, deny_with_nested_and_parent_domain) {
  * |        '------' |
  * '-----------------'
  */
+/* clang-format off */
 FIXTURE_VARIANT_ADD(hierarchy, deny_with_forked_domain) {
+	/* clang-format on */
 	.domain_both = true,
 	.domain_parent = true,
 	.domain_child = true,

