Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2274540F76
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354785AbiFGTIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352852AbiFGTGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:06:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF09946B08;
        Tue,  7 Jun 2022 11:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31DAC6171C;
        Tue,  7 Jun 2022 18:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0A8C385A5;
        Tue,  7 Jun 2022 18:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625145;
        bh=5eZbs3RUyx8krHHab6EXWvD9mRyJfw/nCvHv1W7UiA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqSNTRZWuKtriQ04x6J5XQXk8rI6Cik+qPH/aMKSSjZG0d45Ns9NeynW6Dmb4oxVC
         CWX4F5gyFAfJI5gkRSv9XN9SLoy5O/QWfNY7bVyIjpEJ9ffceLKWP6dSMr3h+RFxof
         up4BTh6acQD+UqbDDjymzB/HmmNMd/PCvcflQ0bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 583/667] selftests/landlock: Test landlock_create_ruleset(2) argument check ordering
Date:   Tue,  7 Jun 2022 19:04:08 +0200
Message-Id: <20220607164952.170204250@linuxfoundation.org>
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

commit 6533d0c3a86ee1cc74ff37ac92ca597deb87015c upstream.

Add inval_create_ruleset_arguments, extension of
inval_create_ruleset_flags, to also check error ordering for
landlock_create_ruleset(2).

This is similar to the previous commit checking landlock_add_rule(2).

Test coverage for security/landlock is 94.4% of 504 lines accorging to
gcc/gcov-11.

Link: https://lore.kernel.org/r/20220506160820.524344-11-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/base_test.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

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


