Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69155540F6E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354027AbiFGTIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354801AbiFGTGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:06:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E4F1900EE;
        Tue,  7 Jun 2022 11:05:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F11B5B82182;
        Tue,  7 Jun 2022 18:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E3BC385A5;
        Tue,  7 Jun 2022 18:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625134;
        bh=YdTQ0DxyDqXgO4kk5oAbF39iZyrEOqj+FEmQCwUfOSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYhU7fp9Ilg7QqodYTJc2Cf7tnLWWtKmDwYAGawU9z+c/axCnhZ23Lt75OrM/Mhz0
         UHDj49Jv02hULct7KCtOa2Xcp9gHlhROQgUgbRZfr0mnCRwR3AaXmzqGlkNiEkfAU1
         vAUdhHEJyc2RLDYXWVUTLOEd60JuSG1TMUAeWcXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 579/667] selftests/landlock: Fully test file rename with "remove" access
Date:   Tue,  7 Jun 2022 19:04:04 +0200
Message-Id: <20220607164952.054036584@linuxfoundation.org>
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

commit 6a1bdd4a0bfc30fa4fa2b3a979e6525f28996db9 upstream.

These tests were missing to check the check_access_path() call with all
combinations of maybe_remove(old_dentry) and maybe_remove(new_dentry).

Extend layout1.link with a new complementary test and check that
REMOVE_FILE is not required to link a file.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-7-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/fs_test.c |   41 ++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

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


