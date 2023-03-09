Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEE56B2B97
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 18:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCIRIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 12:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjCIRH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 12:07:59 -0500
Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fa9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D544FEBDA9
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 09:04:35 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PXb0Y6vhyzMqKmD;
        Thu,  9 Mar 2023 17:55:41 +0100 (CET)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PXb0Y37D8zMslrt;
        Thu,  9 Mar 2023 17:55:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1678380941;
        bh=LII+/DMiw8Bt9TUfIAxhk6BeSfZr6JmA0AsJRY7F0As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2HR3U/wRDnDPBht7VtTZv+B6N5QyotMTwm9oiD77MIXLoHYQqI8TH1m6vcfKMWXe
         21PDHffo6PaDF0xk73UQsUAXbk5gqcKa8t8HykuumF3v711Ovw0JxX2PbNVWuOobWD
         QT2CXqkqx85w9aYpJ3yJQs+nGlV3i3beoFFpp0yc=
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
Subject: [PATCH v1 4/5] selftests/landlock: Make mounts configurable
Date:   Thu,  9 Mar 2023 17:54:54 +0100
Message-Id: <20230309165455.175131-5-mic@digikod.net>
In-Reply-To: <20230309165455.175131-1-mic@digikod.net>
References: <20230309165455.175131-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a new struct mnt_opt to define a mount point with the mount_opt()
helper.  This doesn't change tests but prepare for the next commit.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20230309165455.175131-5-mic@digikod.net
---
 tools/testing/selftests/landlock/fs_test.c | 34 ++++++++++++++++++----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index c1e655fc06bb..de29c8c9e194 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -213,7 +213,26 @@ static int remove_path(const char *const path)
 	return err;
 }
 
-static void prepare_layout(struct __test_metadata *const _metadata)
+struct mnt_opt {
+	const char *const source;
+	const char *const type;
+	const unsigned long flags;
+	const char *const data;
+};
+
+const struct mnt_opt mnt_tmp = {
+	.type = "tmpfs",
+	.data = "size=4m,mode=700",
+};
+
+static int mount_opt(const struct mnt_opt *const mnt, const char *const target)
+{
+	return mount(mnt->source ?: mnt->type, target, mnt->type, mnt->flags,
+		     mnt->data);
+}
+
+static void prepare_layout_opt(struct __test_metadata *const _metadata,
+			       const struct mnt_opt *const mnt)
 {
 	disable_caps(_metadata);
 	umask(0077);
@@ -225,11 +244,16 @@ static void prepare_layout(struct __test_metadata *const _metadata)
 	 */
 	set_cap(_metadata, CAP_SYS_ADMIN);
 	ASSERT_EQ(0, unshare(CLONE_NEWNS));
-	ASSERT_EQ(0, mount("tmp", TMP_DIR, "tmpfs", 0, "size=4m,mode=700"));
+	ASSERT_EQ(0, mount_opt(mnt, TMP_DIR));
 	ASSERT_EQ(0, mount(NULL, TMP_DIR, NULL, MS_PRIVATE | MS_REC, NULL));
 	clear_cap(_metadata, CAP_SYS_ADMIN);
 }
 
+static void prepare_layout(struct __test_metadata *const _metadata)
+{
+	prepare_layout_opt(_metadata, &mnt_tmp);
+}
+
 static void cleanup_layout(struct __test_metadata *const _metadata)
 {
 	set_cap(_metadata, CAP_SYS_ADMIN);
@@ -269,7 +293,7 @@ static void create_layout1(struct __test_metadata *const _metadata)
 	create_file(_metadata, file1_s3d1);
 	create_directory(_metadata, dir_s3d2);
 	set_cap(_metadata, CAP_SYS_ADMIN);
-	ASSERT_EQ(0, mount("tmp", dir_s3d2, "tmpfs", 0, "size=4m,mode=700"));
+	ASSERT_EQ(0, mount_opt(&mnt_tmp, dir_s3d2));
 	clear_cap(_metadata, CAP_SYS_ADMIN);
 
 	ASSERT_EQ(0, mkdir(dir_s3d3, 0700));
@@ -4068,7 +4092,7 @@ FIXTURE_SETUP(layout2_overlay)
 	create_directory(_metadata, LOWER_BASE);
 	set_cap(_metadata, CAP_SYS_ADMIN);
 	/* Creates tmpfs mount points to get deterministic overlayfs. */
-	ASSERT_EQ(0, mount("tmp", LOWER_BASE, "tmpfs", 0, "size=4m,mode=700"));
+	ASSERT_EQ(0, mount_opt(&mnt_tmp, LOWER_BASE));
 	clear_cap(_metadata, CAP_SYS_ADMIN);
 	create_file(_metadata, lower_fl1);
 	create_file(_metadata, lower_dl1_fl2);
@@ -4078,7 +4102,7 @@ FIXTURE_SETUP(layout2_overlay)
 
 	create_directory(_metadata, UPPER_BASE);
 	set_cap(_metadata, CAP_SYS_ADMIN);
-	ASSERT_EQ(0, mount("tmp", UPPER_BASE, "tmpfs", 0, "size=4m,mode=700"));
+	ASSERT_EQ(0, mount_opt(&mnt_tmp, UPPER_BASE));
 	clear_cap(_metadata, CAP_SYS_ADMIN);
 	create_file(_metadata, upper_fu1);
 	create_file(_metadata, upper_du1_fu2);
-- 
2.39.2

