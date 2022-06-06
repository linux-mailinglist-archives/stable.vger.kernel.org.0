Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E023153E347
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiFFHuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiFFHuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95430B8BDE
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19529611B9
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E7AC385A9;
        Mon,  6 Jun 2022 07:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501846;
        bh=jbDFItgo17VlNltGE+rgDC+bU9RjFKVJe2G64deT0I8=;
        h=Subject:To:Cc:From:Date:From;
        b=g0Hld5qLj9E9Pkv6dlEtvDThwz7bn5MoOem5fWBIYkSscM+lNscvLRqxj3GPTQnKT
         KekS3RLQcJdEYcDOGrE8+XtuujGvFVHqIUQGF7YeI38r1n+P4R6kX7GvFET3kU+QMG
         T/pFyvz8mxQSDb8daXWLxLeQmIXbKF2xP5qWk0gc=
Subject: WTF: patch "[PATCH] selftests/landlock: Test landlock_create_ruleset(2) argument" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:50:33 +0200
Message-ID: <1654501833220120@kroah.com>
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

From 6533d0c3a86ee1cc74ff37ac92ca597deb87015c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:20 +0200
Subject: [PATCH] selftests/landlock: Test landlock_create_ruleset(2) argument
 check ordering
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add inval_create_ruleset_arguments, extension of
inval_create_ruleset_flags, to also check error ordering for
landlock_create_ruleset(2).

This is similar to the previous commit checking landlock_add_rule(2).

Test coverage for security/landlock is 94.4% of 504 lines accorging to
gcc/gcov-11.

Link: https://lore.kernel.org/r/20220506160820.524344-11-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
index 21fb33581419..35f64832b869 100644
--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -97,14 +97,17 @@ TEST(abi_version)
 	ASSERT_EQ(EINVAL, errno);
 }
 
-TEST(inval_create_ruleset_flags)
+/* Tests ordering of syscall argument checks. */
+TEST(create_ruleset_checks_ordering)
 {
 	const int last_flag = LANDLOCK_CREATE_RULESET_VERSION;
 	const int invalid_flag = last_flag << 1;
+	int ruleset_fd;
 	const struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
 	};
 
+	/* Checks priority for invalid flags. */
 	ASSERT_EQ(-1, landlock_create_ruleset(NULL, 0, invalid_flag));
 	ASSERT_EQ(EINVAL, errno);
 
@@ -119,6 +122,22 @@ TEST(inval_create_ruleset_flags)
 		  landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr),
 					  invalid_flag));
 	ASSERT_EQ(EINVAL, errno);
+
+	/* Checks too big ruleset_attr size. */
+	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, -1, 0));
+	ASSERT_EQ(E2BIG, errno);
+
+	/* Checks too small ruleset_attr size. */
+	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0, 0));
+	ASSERT_EQ(EINVAL, errno);
+	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 1, 0));
+	ASSERT_EQ(EINVAL, errno);
+
+	/* Checks valid call. */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
 }
 
 /* Tests ordering of syscall argument checks. */

