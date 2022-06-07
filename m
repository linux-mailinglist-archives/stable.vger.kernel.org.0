Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806FE5421DF
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381999AbiFHBOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1841781AbiFHAIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:08:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674E2267CE4;
        Tue,  7 Jun 2022 12:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 789FAB823CC;
        Tue,  7 Jun 2022 19:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA7AC385A5;
        Tue,  7 Jun 2022 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629694;
        bh=GmrMzbqcZ2nl6Mbbuu93Fv32BUR3uWJx+cJ6lsJTsWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQL19/RCxBR47po3oG7o7UK7viVmjQS+zR/PO0AbinNyLLX/i36rehHQJI6q1zmn7
         TnCRgJJQQg0jBWMLSsLT+uT+ygsxImofP26Phc8XAHXSqIkZj70nxENiST0VjQS/Ho
         RbZn6N2Xk6Ron9mzw7qu782ijQANcxdUPbmX7E+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.18 783/879] selftests/landlock: Add tests for O_PATH
Date:   Tue,  7 Jun 2022 19:05:01 +0200
Message-Id: <20220607165025.597516138@linuxfoundation.org>
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

commit d1788ad990874734341b05ab8ccb6448c09c6422 upstream.

The O_PATH flag is currently not handled by Landlock.  Let's make sure
this behavior will remain consistent with the same ruleset over time.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-8-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/fs_test.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -654,17 +654,23 @@ TEST_F_FORK(layout1, effective_access)
 	enforce_ruleset(_metadata, ruleset_fd);
 	ASSERT_EQ(0, close(ruleset_fd));
 
-	/* Tests on a directory. */
+	/* Tests on a directory (with or without O_PATH). */
 	ASSERT_EQ(EACCES, test_open("/", O_RDONLY));
+	ASSERT_EQ(0, test_open("/", O_RDONLY | O_PATH));
 	ASSERT_EQ(EACCES, test_open(dir_s1d1, O_RDONLY));
+	ASSERT_EQ(0, test_open(dir_s1d1, O_RDONLY | O_PATH));
 	ASSERT_EQ(EACCES, test_open(file1_s1d1, O_RDONLY));
+	ASSERT_EQ(0, test_open(file1_s1d1, O_RDONLY | O_PATH));
+
 	ASSERT_EQ(0, test_open(dir_s1d2, O_RDONLY));
 	ASSERT_EQ(0, test_open(file1_s1d2, O_RDONLY));
 	ASSERT_EQ(0, test_open(dir_s1d3, O_RDONLY));
 	ASSERT_EQ(0, test_open(file1_s1d3, O_RDONLY));
 
-	/* Tests on a file. */
+	/* Tests on a file (with or without O_PATH). */
 	ASSERT_EQ(EACCES, test_open(dir_s2d2, O_RDONLY));
+	ASSERT_EQ(0, test_open(dir_s2d2, O_RDONLY | O_PATH));
+
 	ASSERT_EQ(0, test_open(file1_s2d2, O_RDONLY));
 
 	/* Checks effective read and write actions. */


