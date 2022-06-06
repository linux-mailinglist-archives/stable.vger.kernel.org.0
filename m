Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB2E53E2F0
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiFFHuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiFFHuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:50:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90FBB7170
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 239D4B811CC
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74186C385A9;
        Mon,  6 Jun 2022 07:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501835;
        bh=X6Kl+VdHJAHbZRVpxZgkjSsBuE3E7SiBddyiiuAMYLY=;
        h=Subject:To:Cc:From:Date:From;
        b=MfCxecUglF+ktFwFAICjgeV//qu+Dnx8vbc1eFI1/7iXfTReVJL7TzHi5ttUe/IgI
         5osIsdXP0NEhMrPuOpR+njcbN4snQ4R6Eda45vONZPK1oPCMgO21gMWncmNGaV4dKj
         wS/3+ouGSa6gVLFLlBCb8EUhZDsAlGDbsN9wXJeI=
Subject: WTF: patch "[PATCH] selftests/landlock: Extend access right tests to directories" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net, shuah@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:50:32 +0200
Message-ID: <1654501832177250@kroah.com>
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

From d18955d094d09a220cf8f533f5e896a2fe31575a Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:15 +0200
Subject: [PATCH] selftests/landlock: Extend access right tests to directories
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make sure that all filesystem access rights can be tied to directories.

Rename layout1.file_access_rights to layout1.file_and_dir_access_rights
to reflect this change.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-6-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index f293b7e2a1a7..75f9358512df 100644
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

