Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD9B540F79
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346585AbiFGTIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352879AbiFGTGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:06:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534C4190D23;
        Tue,  7 Jun 2022 11:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A7A0B82340;
        Tue,  7 Jun 2022 18:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC00C34115;
        Tue,  7 Jun 2022 18:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625142;
        bh=g87Y1uGDdJzNQpe0rlFlHuESKO6QUlZYQPzLsH/O1Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFZKp37jOc8jU044LRDbUuQeJY/G6h8tkQELIIUFRChqIwKDRQ69MoZs/4G1bdnbB
         f+zArD4VAZwcBJlXiORzvfSxuGcjtHNb772yAEUL2gfPmkyh1PfsLHL6kFWT8Q0swa
         OUIdzru7Aq4t1A2An04CkNSNTnUKg97Hl+zCGWFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 582/667] landlock: Change landlock_restrict_self(2) check ordering
Date:   Tue,  7 Jun 2022 19:04:07 +0200
Message-Id: <20220607164952.140641075@linuxfoundation.org>
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

commit eba39ca4b155c54adf471a69e91799cc1727873f upstream.

According to the Landlock goal to be a security feature available to
unprivileges processes, it makes more sense to first check for
no_new_privs before checking anything else (i.e. syscall arguments).

Merge inval_fd_enforce and unpriv_enforce_without_no_new_privs tests
into the new restrict_self_checks_ordering.  This is similar to the
previous commit checking other syscalls.

Link: https://lore.kernel.org/r/20220506160820.524344-10-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/syscalls.c                 |    8 ++--
 tools/testing/selftests/landlock/base_test.c |   47 +++++++++++++++++++++------
 2 files changed, 41 insertions(+), 14 deletions(-)

--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -405,10 +405,6 @@ SYSCALL_DEFINE2(landlock_restrict_self,
 	if (!landlock_initialized)
 		return -EOPNOTSUPP;
 
-	/* No flag for now. */
-	if (flags)
-		return -EINVAL;
-
 	/*
 	 * Similar checks as for seccomp(2), except that an -EPERM may be
 	 * returned.
@@ -417,6 +413,10 @@ SYSCALL_DEFINE2(landlock_restrict_self,
 	    !ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* No flag for now. */
+	if (flags)
+		return -EINVAL;
+
 	/* Gets and checks the ruleset. */
 	ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_READ);
 	if (IS_ERR(ruleset))
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


