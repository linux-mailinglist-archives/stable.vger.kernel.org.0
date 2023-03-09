Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED45A6B2B9D
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 18:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCIRIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 12:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjCIRIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 12:08:01 -0500
Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE10E9CE6;
        Thu,  9 Mar 2023 09:04:35 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PXb0X10dZzMqFtR;
        Thu,  9 Mar 2023 17:55:40 +0100 (CET)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PXb0W4yZ7zMslrt;
        Thu,  9 Mar 2023 17:55:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1678380940;
        bh=pCptYWbQi2ICTC6cr32sb1tNFxvAnX8FHrwxOftNfB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twWO4k1odNT2sJLEwqWC4UgmMHg7J6KEPbKleoZW24KfO2XtYkEkpLb/eUwQUHp1W
         xu7hr/3ftY01rg8j4GeFAR9j5sCb+piHCAZgxCrstx3GZEPKipCKHTTjHI7bFILEbA
         qTeBBFseb274yN/6N/XdU80W4g206+jK6cBTtAXQ=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Weinberger <richard@nod.at>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Christopher Obbard <chris.obbard@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>, Jeff Xu <jeffxu@google.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Moore <paul@paul-moore.com>,
        Ritesh Raj Sarraf <ritesh@collabora.com>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sjoerd Simons <sjoerd@collabora.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v1 2/5] selftests/landlock: Don't create useless file layouts
Date:   Thu,  9 Mar 2023 17:54:52 +0100
Message-Id: <20230309165455.175131-3-mic@digikod.net>
In-Reply-To: <20230309165455.175131-1-mic@digikod.net>
References: <20230309165455.175131-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add and use a layout0 test fixture to not populate the tmpfs filesystem
if it is not required for tests: unknown_access_rights, proc_nsfs,
unpriv and max_layers.

This doesn't change these tests but it speeds up their setup and makes
them less prone to error.  This prepare the ground for a next commit.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20230309165455.175131-3-mic@digikod.net
---
 tools/testing/selftests/landlock/fs_test.c | 26 +++++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index b6c4be3faf7a..0438651f61d2 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -231,6 +231,20 @@ static void cleanup_layout(struct __test_metadata *const _metadata)
 	EXPECT_EQ(0, remove_path(TMP_DIR));
 }
 
+/* clang-format off */
+FIXTURE(layout0) {};
+/* clang-format on */
+
+FIXTURE_SETUP(layout0)
+{
+	prepare_layout(_metadata);
+}
+
+FIXTURE_TEARDOWN(layout0)
+{
+	cleanup_layout(_metadata);
+}
+
 static void create_layout1(struct __test_metadata *const _metadata)
 {
 	create_file(_metadata, file1_s1d1);
@@ -510,7 +524,7 @@ TEST_F_FORK(layout1, file_and_dir_access_rights)
 	ASSERT_EQ(0, close(ruleset_fd));
 }
 
-TEST_F_FORK(layout1, unknown_access_rights)
+TEST_F_FORK(layout0, unknown_access_rights)
 {
 	__u64 access_mask;
 
@@ -608,7 +622,7 @@ static void enforce_ruleset(struct __test_metadata *const _metadata,
 	}
 }
 
-TEST_F_FORK(layout1, proc_nsfs)
+TEST_F_FORK(layout0, proc_nsfs)
 {
 	const struct rule rules[] = {
 		{
@@ -657,11 +671,11 @@ TEST_F_FORK(layout1, proc_nsfs)
 	ASSERT_EQ(0, close(path_beneath.parent_fd));
 }
 
-TEST_F_FORK(layout1, unpriv)
+TEST_F_FORK(layout0, unpriv)
 {
 	const struct rule rules[] = {
 		{
-			.path = dir_s1d2,
+			.path = TMP_DIR,
 			.access = ACCESS_RO,
 		},
 		{},
@@ -1301,12 +1315,12 @@ TEST_F_FORK(layout1, inherit_superset)
 	ASSERT_EQ(0, test_open(file1_s1d3, O_RDONLY));
 }
 
-TEST_F_FORK(layout1, max_layers)
+TEST_F_FORK(layout0, max_layers)
 {
 	int i, err;
 	const struct rule rules[] = {
 		{
-			.path = dir_s1d2,
+			.path = TMP_DIR,
 			.access = ACCESS_RO,
 		},
 		{},
-- 
2.39.2

