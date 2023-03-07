Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2886AF528
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbjCGTWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbjCGTW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:22:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC646A769E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:07:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59D77CE1B2F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1DCC433EF;
        Tue,  7 Mar 2023 19:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216045;
        bh=tWrxZm5sp9FheXzdVQaf6pRhAfFHsWhD/g6bWrw3Szg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l42GdEWf7+/5ysDLYzETUM04gTmca856vFrqeIQo9gDUxP+0owef8uiJ490ea6ISF
         2KoqsXENBbQytJhiuZB86cub8BC3NeLT9W1gcTZcGgyKS8EU2x0usNXe4BzRnJdc2U
         p0qZWUpXpR9Trn9Z3JZgkaTsDfH5IA3aVR7MTz7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Xu <jeffxu@google.com>,
        Guenter Roeck <groeck@chromium.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 457/567] selftests/landlock: Skip overlayfs tests when not supported
Date:   Tue,  7 Mar 2023 18:03:13 +0100
Message-Id: <20230307165925.705784139@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Xu <jeffxu@google.com>

commit 366617a69e60610912836570546f118006ebc7cb upstream.

overlayfs may be disabled in the kernel configuration, causing related
tests to fail.  Check that overlayfs is supported at runtime, so we can
skip layout2_overlay.* accordingly.

Signed-off-by: Jeff Xu <jeffxu@google.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230113053229.1281774-2-jeffxu@google.com
[mic: Reword comments and constify variables]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/fs_test.c |   47 +++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -11,6 +11,7 @@
 #include <fcntl.h>
 #include <linux/landlock.h>
 #include <sched.h>
+#include <stdio.h>
 #include <string.h>
 #include <sys/capability.h>
 #include <sys/mount.h>
@@ -87,6 +88,40 @@ static const char dir_s3d3[] = TMP_DIR "
  *         └── s3d3
  */
 
+static bool fgrep(FILE *const inf, const char *const str)
+{
+	char line[32];
+	const int slen = strlen(str);
+
+	while (!feof(inf)) {
+		if (!fgets(line, sizeof(line), inf))
+			break;
+		if (strncmp(line, str, slen))
+			continue;
+
+		return true;
+	}
+
+	return false;
+}
+
+static bool supports_overlayfs(void)
+{
+	bool res;
+	FILE *const inf = fopen("/proc/filesystems", "r");
+
+	/*
+	 * Consider that the filesystem is supported if we cannot get the
+	 * supported ones.
+	 */
+	if (!inf)
+		return true;
+
+	res = fgrep(inf, "nodev\toverlay\n");
+	fclose(inf);
+	return res;
+}
+
 static void mkdir_parents(struct __test_metadata *const _metadata,
 			  const char *const path)
 {
@@ -2650,6 +2685,9 @@ FIXTURE(layout2_overlay) {};
 
 FIXTURE_SETUP(layout2_overlay)
 {
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	prepare_layout(_metadata);
 
 	create_directory(_metadata, LOWER_BASE);
@@ -2686,6 +2724,9 @@ FIXTURE_SETUP(layout2_overlay)
 
 FIXTURE_TEARDOWN(layout2_overlay)
 {
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	EXPECT_EQ(0, remove_path(lower_do1_fl3));
 	EXPECT_EQ(0, remove_path(lower_dl1_fl2));
 	EXPECT_EQ(0, remove_path(lower_fl1));
@@ -2717,6 +2758,9 @@ FIXTURE_TEARDOWN(layout2_overlay)
 
 TEST_F_FORK(layout2_overlay, no_restriction)
 {
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	ASSERT_EQ(0, test_open(lower_fl1, O_RDONLY));
 	ASSERT_EQ(0, test_open(lower_dl1, O_RDONLY));
 	ASSERT_EQ(0, test_open(lower_dl1_fl2, O_RDONLY));
@@ -2880,6 +2924,9 @@ TEST_F_FORK(layout2_overlay, same_conten
 	size_t i;
 	const char *path_entry;
 
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	/* Sets rules on base directories (i.e. outside overlay scope). */
 	ruleset_fd = create_ruleset(_metadata, ACCESS_RW, layer1_base);
 	ASSERT_LE(0, ruleset_fd);


