Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2B6542546
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350058AbiFHBMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442477AbiFHAye (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:54:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B56B267CEE;
        Tue,  7 Jun 2022 12:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2AAC60906;
        Tue,  7 Jun 2022 19:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CE7C385A2;
        Tue,  7 Jun 2022 19:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629697;
        bh=J9tuh9jTQAWUyz1dSmwcnH33w65DBg81WLoe1PgnrLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0y7qU7Jp6OZoXmBApXquVt06HrwR5zUJwiJEpmL0yRTR6NRTiDbumFAxblhIwJlc5
         /tLAbJxoU2ILXn2wQW3czC6MVJ8jFtPrgDcdjAGxqOkQgIzVhDXu8lQ/+JCSvWWymB
         d1V9Sz47xUeddW43dedAPXztqMe+6pwmyKhFbmy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.18 784/879] landlock: Change landlock_add_rule(2) argument check ordering
Date:   Tue,  7 Jun 2022 19:05:02 +0200
Message-Id: <20220607165025.626272356@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

commit 589172e5636c4d16c40b90e87543d43defe2d968 upstream.

This makes more sense to first check the ruleset FD and then the rule
attribute.  It will be useful to factor out code for other rule types.

Add inval_add_rule_arguments tests, extension of empty_path_beneath_attr
tests, to also check error ordering for landlock_add_rule(2).

Link: https://lore.kernel.org/r/20220506160820.524344-9-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/syscalls.c                 |   22 ++++++++++-------
 tools/testing/selftests/landlock/base_test.c |   34 +++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 11 deletions(-)

--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -318,20 +318,24 @@ SYSCALL_DEFINE4(landlock_add_rule, const
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
 


