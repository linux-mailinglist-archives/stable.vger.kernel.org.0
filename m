Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580795416C9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358597AbiFGU4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378002AbiFGUvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:51:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6E11FDEA2;
        Tue,  7 Jun 2022 11:41:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 316D061295;
        Tue,  7 Jun 2022 18:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E8DC385A2;
        Tue,  7 Jun 2022 18:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627273;
        bh=5or48Sd0+2qQPDKl+woFHQA/id1AA8D8c0YmSyWFprU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXXxSVLTqOQfNEpAaMgmvJfx+IzRIEtzZHZbihO/2xoA+LB7tJDVT+4H4/kixqkZk
         OODr5D7U+wEmLA01N4abCbvC2ozKkt7a+HuJ5in56nH8NygYgdv6cOW7HkyCnvyOrw
         VbNJBkF4cE0qy9H/McbmVMPQ0SlAiEsjZCAVfVvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.17 679/772] selftests/landlock: Extend access right tests to directories
Date:   Tue,  7 Jun 2022 19:04:31 +0200
Message-Id: <20220607165009.065451258@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

commit d18955d094d09a220cf8f533f5e896a2fe31575a upstream.

Make sure that all filesystem access rights can be tied to directories.

Rename layout1.file_access_rights to layout1.file_and_dir_access_rights
to reflect this change.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-6-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/fs_test.c |   30 +++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -418,11 +418,12 @@ TEST_F_FORK(layout1, inval)
 
 /* clang-format on */
 
-TEST_F_FORK(layout1, file_access_rights)
+TEST_F_FORK(layout1, file_and_dir_access_rights)
 {
 	__u64 access;
 	int err;
-	struct landlock_path_beneath_attr path_beneath = {};
+	struct landlock_path_beneath_attr path_beneath_file = {},
+					  path_beneath_dir = {};
 	struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = ACCESS_ALL,
 	};
@@ -432,20 +433,33 @@ TEST_F_FORK(layout1, file_access_rights)
 	ASSERT_LE(0, ruleset_fd);
 
 	/* Tests access rights for files. */
-	path_beneath.parent_fd = open(file1_s1d2, O_PATH | O_CLOEXEC);
-	ASSERT_LE(0, path_beneath.parent_fd);
+	path_beneath_file.parent_fd = open(file1_s1d2, O_PATH | O_CLOEXEC);
+	ASSERT_LE(0, path_beneath_file.parent_fd);
+
+	/* Tests access rights for directories. */
+	path_beneath_dir.parent_fd =
+		open(dir_s1d2, O_PATH | O_DIRECTORY | O_CLOEXEC);
+	ASSERT_LE(0, path_beneath_dir.parent_fd);
+
 	for (access = 1; access <= ACCESS_LAST; access <<= 1) {
-		path_beneath.allowed_access = access;
+		path_beneath_dir.allowed_access = access;
+		ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
+					       LANDLOCK_RULE_PATH_BENEATH,
+					       &path_beneath_dir, 0));
+
+		path_beneath_file.allowed_access = access;
 		err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
-					&path_beneath, 0);
-		if ((access | ACCESS_FILE) == ACCESS_FILE) {
+					&path_beneath_file, 0);
+		if (access & ACCESS_FILE) {
 			ASSERT_EQ(0, err);
 		} else {
 			ASSERT_EQ(-1, err);
 			ASSERT_EQ(EINVAL, errno);
 		}
 	}
-	ASSERT_EQ(0, close(path_beneath.parent_fd));
+	ASSERT_EQ(0, close(path_beneath_file.parent_fd));
+	ASSERT_EQ(0, close(path_beneath_dir.parent_fd));
+	ASSERT_EQ(0, close(ruleset_fd));
 }
 
 TEST_F_FORK(layout1, unknown_access_rights)


