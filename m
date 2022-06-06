Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E367F53E3B0
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiFFHv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiFFHvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:51:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E6BC0E24
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:51:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE9A4B80DCA
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C990C385A9;
        Mon,  6 Jun 2022 07:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501881;
        bh=yWBs4VkpHTnmE/sgwiZrgCXyYJCYD0GBl2jsjkB1hZk=;
        h=Subject:To:Cc:From:Date:From;
        b=AFrdnmgbrMwoKMsXcQcxS+J88hO8W293zQcuJziLQfEwejaOO1a0lE46jxzXJQzEB
         YVW4xUBjq72FEAvdcYtlV+0p+x88WRT8rpp8GNz6svR5/MMRcyafN7heZDqIoZsoKz
         3frUiIMxYYaqXAdVAFqNPt2xweDYQBkee9Wr7qvM=
Subject: WTF: patch "[PATCH] landlock: Change landlock_restrict_self(2) check ordering" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:51:07 +0200
Message-ID: <165450186787153@kroah.com>
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

From eba39ca4b155c54adf471a69e91799cc1727873f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:19 +0200
Subject: [PATCH] landlock: Change landlock_restrict_self(2) check ordering
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

According to the Landlock goal to be a security feature available to
unprivileges processes, it makes more sense to first check for
no_new_privs before checking anything else (i.e. syscall arguments).

Merge inval_fd_enforce and unpriv_enforce_without_no_new_privs tests
into the new restrict_self_checks_ordering.  This is similar to the
previous commit checking other syscalls.

Link: https://lore.kernel.org/r/20220506160820.524344-10-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index a7396220c9d4..507d43827afe 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -405,10 +405,6 @@ SYSCALL_DEFINE2(landlock_restrict_self, const int, ruleset_fd, const __u32,
 	if (!landlock_initialized)
 		return -EOPNOTSUPP;
 
-	/* No flag for now. */
-	if (flags)
-		return -EINVAL;
-
 	/*
 	 * Similar checks as for seccomp(2), except that an -EPERM may be
 	 * returned.
@@ -417,6 +413,10 @@ SYSCALL_DEFINE2(landlock_restrict_self, const int, ruleset_fd, const __u32,
 	    !ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* No flag for now. */
+	if (flags)
+		return -EINVAL;
+
 	/* Gets and checks the ruleset. */
 	ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_READ);
 	if (IS_ERR(ruleset))
diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
index 18b779471dcb..21fb33581419 100644
--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -168,22 +168,49 @@ TEST(add_rule_checks_ordering)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
-TEST(inval_fd_enforce)
+/* Tests ordering of syscall argument and permission checks. */
+TEST(restrict_self_checks_ordering)
 {
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_fs = LANDLOCK_ACCESS_FS_EXECUTE,
+	};
+	struct landlock_path_beneath_attr path_beneath_attr = {
+		.allowed_access = LANDLOCK_ACCESS_FS_EXECUTE,
+		.parent_fd = -1,
+	};
+	const int ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+
+	ASSERT_LE(0, ruleset_fd);
+	path_beneath_attr.parent_fd =
+		open("/tmp", O_PATH | O_NOFOLLOW | O_DIRECTORY | O_CLOEXEC);
+	ASSERT_LE(0, path_beneath_attr.parent_fd);
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
+				       &path_beneath_attr, 0));
+	ASSERT_EQ(0, close(path_beneath_attr.parent_fd));
+
+	/* Checks unprivileged enforcement without no_new_privs. */
+	drop_caps(_metadata);
+	ASSERT_EQ(-1, landlock_restrict_self(-1, -1));
+	ASSERT_EQ(EPERM, errno);
+	ASSERT_EQ(-1, landlock_restrict_self(-1, 0));
+	ASSERT_EQ(EPERM, errno);
+	ASSERT_EQ(-1, landlock_restrict_self(ruleset_fd, 0));
+	ASSERT_EQ(EPERM, errno);
+
 	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
 
+	/* Checks invalid flags. */
+	ASSERT_EQ(-1, landlock_restrict_self(-1, -1));
+	ASSERT_EQ(EINVAL, errno);
+
+	/* Checks invalid ruleset FD. */
 	ASSERT_EQ(-1, landlock_restrict_self(-1, 0));
 	ASSERT_EQ(EBADF, errno);
-}
-
-TEST(unpriv_enforce_without_no_new_privs)
-{
-	int err;
 
-	drop_caps(_metadata);
-	err = landlock_restrict_self(-1, 0);
-	ASSERT_EQ(EPERM, errno);
-	ASSERT_EQ(err, -1);
+	/* Checks valid call. */
+	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0));
+	ASSERT_EQ(0, close(ruleset_fd));
 }
 
 TEST(ruleset_fd_io)

