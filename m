Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F013053E336
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiFFHuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiFFHt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:49:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07908B1C20
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97203611BC
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7320C385A9;
        Mon,  6 Jun 2022 07:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501796;
        bh=tJqqykTKLw2A8SqTDQON7akKy/5LLx7pl0GCXeb2FG8=;
        h=Subject:To:Cc:From:Date:From;
        b=I2rY0IQkUHhzw2iP5H5LRQ8zxURZDQsAFQJVR8ePpTF1j06JOkNxxoT+8cwIWcush
         NrbmosQNNPgPzPHn0zpgK9izRLjeSdq+mp6vQuXC67j6YUtvLlMATXTHIPARfo/L9V
         trUU3FIx8Hv9K+Hg43IXa1fWUTZEWiiK1ziiTinM=
Subject: WTF: patch "[PATCH] selftests/landlock: Fully test file rename with "remove"" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net, shuah@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:49:42 +0200
Message-ID: <165450178278128@kroah.com>
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

From 6a1bdd4a0bfc30fa4fa2b3a979e6525f28996db9 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:16 +0200
Subject: [PATCH] selftests/landlock: Fully test file rename with "remove"
 access
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These tests were missing to check the check_access_path() call with all
combinations of maybe_remove(old_dentry) and maybe_remove(new_dentry).

Extend layout1.link with a new complementary test and check that
REMOVE_FILE is not required to link a file.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-7-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 75f9358512df..9165f6adf7b9 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -1659,15 +1659,21 @@ TEST_F_FORK(layout1, execute)
 
 TEST_F_FORK(layout1, link)
 {
-	const struct rule rules[] = {
+	const struct rule layer1[] = {
 		{
 			.path = dir_s1d2,
 			.access = LANDLOCK_ACCESS_FS_MAKE_REG,
 		},
 		{},
 	};
-	const int ruleset_fd =
-		create_ruleset(_metadata, rules[0].access, rules);
+	const struct rule layer2[] = {
+		{
+			.path = dir_s1d3,
+			.access = LANDLOCK_ACCESS_FS_REMOVE_FILE,
+		},
+		{},
+	};
+	int ruleset_fd = create_ruleset(_metadata, layer1[0].access, layer1);
 
 	ASSERT_LE(0, ruleset_fd);
 
@@ -1680,14 +1686,30 @@ TEST_F_FORK(layout1, link)
 
 	ASSERT_EQ(-1, link(file2_s1d1, file1_s1d1));
 	ASSERT_EQ(EACCES, errno);
+
 	/* Denies linking because of reparenting. */
 	ASSERT_EQ(-1, link(file1_s2d1, file1_s1d2));
 	ASSERT_EQ(EXDEV, errno);
 	ASSERT_EQ(-1, link(file2_s1d2, file1_s1d3));
 	ASSERT_EQ(EXDEV, errno);
+	ASSERT_EQ(-1, link(file2_s1d3, file1_s1d2));
+	ASSERT_EQ(EXDEV, errno);
 
 	ASSERT_EQ(0, link(file2_s1d2, file1_s1d2));
 	ASSERT_EQ(0, link(file2_s1d3, file1_s1d3));
+
+	/* Prepares for next unlinks. */
+	ASSERT_EQ(0, unlink(file2_s1d2));
+	ASSERT_EQ(0, unlink(file2_s1d3));
+
+	ruleset_fd = create_ruleset(_metadata, layer2[0].access, layer2);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* Checks that linkind doesn't require the ability to delete a file. */
+	ASSERT_EQ(0, link(file1_s1d2, file2_s1d2));
+	ASSERT_EQ(0, link(file1_s1d3, file2_s1d3));
 }
 
 TEST_F_FORK(layout1, rename_file)
@@ -1708,7 +1730,6 @@ TEST_F_FORK(layout1, rename_file)
 
 	ASSERT_LE(0, ruleset_fd);
 
-	ASSERT_EQ(0, unlink(file1_s1d1));
 	ASSERT_EQ(0, unlink(file1_s1d2));
 
 	enforce_ruleset(_metadata, ruleset_fd);
@@ -1744,9 +1765,15 @@ TEST_F_FORK(layout1, rename_file)
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, dir_s2d2, AT_FDCWD, file1_s2d1,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EACCES, errno);
+	/* Checks that file1_s2d1 cannot be removed (instead of ENOTDIR). */
+	ASSERT_EQ(-1, rename(dir_s2d2, file1_s2d1));
+	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, file1_s2d1, AT_FDCWD, dir_s2d2,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EACCES, errno);
+	/* Checks that file1_s1d1 cannot be removed (instead of EISDIR). */
+	ASSERT_EQ(-1, rename(file1_s1d1, dir_s1d2));
+	ASSERT_EQ(EACCES, errno);
 
 	/* Renames files with different parents. */
 	ASSERT_EQ(-1, rename(file1_s2d2, file1_s1d2));
@@ -1809,9 +1836,15 @@ TEST_F_FORK(layout1, rename_dir)
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, dir_s1d1, AT_FDCWD, dir_s2d1,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EACCES, errno);
+	/* Checks that dir_s1d2 cannot be removed (instead of ENOTDIR). */
+	ASSERT_EQ(-1, rename(dir_s1d2, file1_s1d1));
+	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, file1_s1d1, AT_FDCWD, dir_s1d2,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EACCES, errno);
+	/* Checks that dir_s1d2 cannot be removed (instead of EISDIR). */
+	ASSERT_EQ(-1, rename(file1_s1d1, dir_s1d2));
+	ASSERT_EQ(EACCES, errno);
 
 	/*
 	 * Exchanges and renames directory to the same parent, which allows

