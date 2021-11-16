Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D0F4539F7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhKPTU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhKPTUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:20:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A506322C;
        Tue, 16 Nov 2021 19:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637090278;
        bh=pJvfaUrErvbkJy1Pyta/U5BnafakH527rjx1wndzuxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iE64KSyn7noGPkoF1jRRKUMRa5F7TNG2Yxe2ycvKiYv7DBs132D8KW7jvPXO1Qve4
         kvrXzvYF/UwG9mIygLCuywWD02n4yvefHlU7o+PsOP9fB+/zIE3ewBB8a1a5YkSvo4
         FDz3F7PcIRr3jGn+Pr2f/9iyjV5/G9aKJi4lhRoAXETwaRaSmd//lohDCD/MowW/du
         0x4BCvYZBzS4XeD2Q6Cifphje5Sz8wIvRXOJmVGn/Uk+Dis/2KUUeaynpHsdUPKtKG
         tSj25NbVqo06XMaQVoltcD/23BHlPKkrdI1cJOsQA0bW5CRPcyKnMSGUYQk4SS+xsv
         Buz4bYw5kgb8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Elver <elver@google.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, kasan-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.15 02/65] kcsan: test: Fix flaky test case
Date:   Tue, 16 Nov 2021 14:16:47 -0500
Message-Id: <20211116191754.2419097-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116191754.2419097-1-sashal@kernel.org>
References: <20211116191754.2419097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit ade3a58b2d40555701143930ead3d44d0b52ca9e ]

If CONFIG_KCSAN_REPORT_VALUE_CHANGE_ONLY=n, then we may also see data
races between the writers only. If we get unlucky and never capture a
read-write data race, but only the write-write data races, then the
test_no_value_change* test cases may incorrectly fail.

The second problem is that the initial value needs to be reset, as
otherwise we might actually observe a value change at the start.

Fix it by also looking for the write-write data races, and resetting the
value to what will be written.

Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcsan/kcsan_test.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/kcsan/kcsan_test.c b/kernel/kcsan/kcsan_test.c
index dc55fd5a36fcc..ada4a7a403b8d 100644
--- a/kernel/kcsan/kcsan_test.c
+++ b/kernel/kcsan/kcsan_test.c
@@ -488,17 +488,24 @@ static void test_concurrent_races(struct kunit *test)
 __no_kcsan
 static void test_novalue_change(struct kunit *test)
 {
-	const struct expect_report expect = {
+	const struct expect_report expect_rw = {
 		.access = {
 			{ test_kernel_write_nochange, &test_var, sizeof(test_var), KCSAN_ACCESS_WRITE },
 			{ test_kernel_read, &test_var, sizeof(test_var), 0 },
 		},
 	};
+	const struct expect_report expect_ww = {
+		.access = {
+			{ test_kernel_write_nochange, &test_var, sizeof(test_var), KCSAN_ACCESS_WRITE },
+			{ test_kernel_write_nochange, &test_var, sizeof(test_var), KCSAN_ACCESS_WRITE },
+		},
+	};
 	bool match_expect = false;
 
+	test_kernel_write_nochange(); /* Reset value. */
 	begin_test_checks(test_kernel_write_nochange, test_kernel_read);
 	do {
-		match_expect = report_matches(&expect);
+		match_expect = report_matches(&expect_rw) || report_matches(&expect_ww);
 	} while (!end_test_checks(match_expect));
 	if (IS_ENABLED(CONFIG_KCSAN_REPORT_VALUE_CHANGE_ONLY))
 		KUNIT_EXPECT_FALSE(test, match_expect);
@@ -513,17 +520,24 @@ static void test_novalue_change(struct kunit *test)
 __no_kcsan
 static void test_novalue_change_exception(struct kunit *test)
 {
-	const struct expect_report expect = {
+	const struct expect_report expect_rw = {
 		.access = {
 			{ test_kernel_write_nochange_rcu, &test_var, sizeof(test_var), KCSAN_ACCESS_WRITE },
 			{ test_kernel_read, &test_var, sizeof(test_var), 0 },
 		},
 	};
+	const struct expect_report expect_ww = {
+		.access = {
+			{ test_kernel_write_nochange_rcu, &test_var, sizeof(test_var), KCSAN_ACCESS_WRITE },
+			{ test_kernel_write_nochange_rcu, &test_var, sizeof(test_var), KCSAN_ACCESS_WRITE },
+		},
+	};
 	bool match_expect = false;
 
+	test_kernel_write_nochange_rcu(); /* Reset value. */
 	begin_test_checks(test_kernel_write_nochange_rcu, test_kernel_read);
 	do {
-		match_expect = report_matches(&expect);
+		match_expect = report_matches(&expect_rw) || report_matches(&expect_ww);
 	} while (!end_test_checks(match_expect));
 	KUNIT_EXPECT_TRUE(test, match_expect);
 }
-- 
2.33.0

