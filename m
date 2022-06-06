Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500D053E301
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiFFHuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbiFFHux (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:50:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F64BBCD0
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6737B8115E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CBCC3411E;
        Mon,  6 Jun 2022 07:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501849;
        bh=0SLz17w+1uZFTTS2KTz84KP+xK62korP/U++2VsYV2I=;
        h=Subject:To:Cc:From:Date:From;
        b=ozAyQTP/2Yfwq9o07aVWRC7HTqLK0EEDd7HwmW4QrzC/Vr1F4Yanq433Kuhfy2EGc
         Hic8KH6sjdwLGzs+LLZAr+SwNRB/c4EIY7m00TPpmRVzF7uaWiS7hVVf3uGSYSX3ZB
         nOpH68CtoaEie6VL8Y3xv623o38Bdkk3qOTK6Xow=
Subject: WTF: patch "[PATCH] landlock: Change landlock_add_rule(2) argument check ordering" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:50:33 +0200
Message-ID: <165450183320093@kroah.com>
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

From 589172e5636c4d16c40b90e87543d43defe2d968 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:18 +0200
Subject: [PATCH] landlock: Change landlock_add_rule(2) argument check ordering
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This makes more sense to first check the ruleset FD and then the rule
attribute.  It will be useful to factor out code for other rule types.

Add inval_add_rule_arguments tests, extension of empty_path_beneath_attr
tests, to also check error ordering for landlock_add_rule(2).

Link: https://lore.kernel.org/r/20220506160820.524344-9-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 7edc1d50e2bf..a7396220c9d4 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -318,20 +318,24 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	if (flags)
 		return -EINVAL;
 
-	if (rule_type != LANDLOCK_RULE_PATH_BENEATH)
-		return -EINVAL;
-
-	/* Copies raw user space buffer, only one type for now. */
-	res = copy_from_user(&path_beneath_attr, rule_attr,
-			     sizeof(path_beneath_attr));
-	if (res)
-		return -EFAULT;
-
 	/* Gets and checks the ruleset. */
 	ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);
 
+	if (rule_type != LANDLOCK_RULE_PATH_BENEATH) {
+		err = -EINVAL;
+		goto out_put_ruleset;
+	}
+
+	/* Copies raw user space buffer, only one type for now. */
+	res = copy_from_user(&path_beneath_attr, rule_attr,
+			     sizeof(path_beneath_attr));
+	if (res) {
+		err = -EFAULT;
+		goto out_put_ruleset;
+	}
+
 	/*
 	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
 	 * are ignored in path walks.
diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
index be9b937256ac..18b779471dcb 100644
--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -121,20 +121,50 @@ TEST(inval_create_ruleset_flags)
 	ASSERT_EQ(EINVAL, errno);
 }
 
-TEST(empty_path_beneath_attr)
+/* Tests ordering of syscall argument checks. */
+TEST(add_rule_checks_ordering)
 {
 	const struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = LANDLOCK_ACCESS_FS_EXECUTE,
 	};
+	struct landlock_path_beneath_attr path_beneath_attr = {
+		.allowed_access = LANDLOCK_ACCESS_FS_EXECUTE,
+		.parent_fd = -1,
+	};
 	const int ruleset_fd =
 		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
 
 	ASSERT_LE(0, ruleset_fd);
 
-	/* Similar to struct landlock_path_beneath_attr.parent_fd = 0 */
+	/* Checks invalid flags. */
+	ASSERT_EQ(-1, landlock_add_rule(-1, 0, NULL, 1));
+	ASSERT_EQ(EINVAL, errno);
+
+	/* Checks invalid ruleset FD. */
+	ASSERT_EQ(-1, landlock_add_rule(-1, 0, NULL, 0));
+	ASSERT_EQ(EBADF, errno);
+
+	/* Checks invalid rule type. */
+	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, 0, NULL, 0));
+	ASSERT_EQ(EINVAL, errno);
+
+	/* Checks invalid rule attr. */
 	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
 					NULL, 0));
 	ASSERT_EQ(EFAULT, errno);
+
+	/* Checks invalid path_beneath.parent_fd. */
+	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
+					&path_beneath_attr, 0));
+	ASSERT_EQ(EBADF, errno);
+
+	/* Checks valid call. */
+	path_beneath_attr.parent_fd =
+		open("/tmp", O_PATH | O_NOFOLLOW | O_DIRECTORY | O_CLOEXEC);
+	ASSERT_LE(0, path_beneath_attr.parent_fd);
+	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
+				       &path_beneath_attr, 0));
+	ASSERT_EQ(0, close(path_beneath_attr.parent_fd));
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 

