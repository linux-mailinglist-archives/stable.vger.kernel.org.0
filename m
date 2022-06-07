Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533355416E5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358864AbiFGU43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377974AbiFGUvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:51:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619AA18486A;
        Tue,  7 Jun 2022 11:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF7C5615CE;
        Tue,  7 Jun 2022 18:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC05DC385A2;
        Tue,  7 Jun 2022 18:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627265;
        bh=6nJBrccheWnM5ciNkIqxjkMTEOgsOFsh5eV64RSSDek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y93O+ebF5WkEfF7EezaG7DpwWj9ee1trbBc0mt2cg2EhjVCH8IN8YB9qfhdbWYwSK
         S9Q6Yt0wWDP1pWhF+4uvCMLi8oQ7TpDy7G78ZRCPtKqsaRBECZz4GPilzvn9n3pZOa
         K5r/7DxZ5IlU7Sft1Cvs3/a5fhQ5i7eBPmx7gG80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.17 676/772] selftests/landlock: Make tests build with old libc
Date:   Tue,  7 Jun 2022 19:04:28 +0200
Message-Id: <20220607165008.978316216@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

commit 87129ef13603ae46c82bcd09eed948acf0506dbb upstream.

Replace SYS_<syscall> with __NR_<syscall>.  Using the __NR_<syscall>
notation, provided by UAPI, is useful to build tests on systems without
the SYS_<syscall> definitions.

Replace SYS_pivot_root with __NR_pivot_root, and SYS_move_mount with
__NR_move_mount.

Define renameat2() and RENAME_EXCHANGE if they are unknown to old build
systems.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-3-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/fs_test.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -22,6 +22,19 @@
 
 #include "common.h"
 
+#ifndef renameat2
+int renameat2(int olddirfd, const char *oldpath, int newdirfd,
+	      const char *newpath, unsigned int flags)
+{
+	return syscall(__NR_renameat2, olddirfd, oldpath, newdirfd, newpath,
+		       flags);
+}
+#endif
+
+#ifndef RENAME_EXCHANGE
+#define RENAME_EXCHANGE (1 << 1)
+#endif
+
 #define TMP_DIR "tmp"
 #define BINARY_PATH "./true"
 
@@ -1279,7 +1292,7 @@ TEST_F_FORK(layout1, rule_inside_mount_n
 	int ruleset_fd;
 
 	set_cap(_metadata, CAP_SYS_ADMIN);
-	ASSERT_EQ(0, syscall(SYS_pivot_root, dir_s3d2, dir_s3d3))
+	ASSERT_EQ(0, syscall(__NR_pivot_root, dir_s3d2, dir_s3d3))
 	{
 		TH_LOG("Failed to pivot root: %s", strerror(errno));
 	};
@@ -1313,7 +1326,7 @@ TEST_F_FORK(layout1, mount_and_pivot)
 	set_cap(_metadata, CAP_SYS_ADMIN);
 	ASSERT_EQ(-1, mount(NULL, dir_s3d2, NULL, MS_RDONLY, NULL));
 	ASSERT_EQ(EPERM, errno);
-	ASSERT_EQ(-1, syscall(SYS_pivot_root, dir_s3d2, dir_s3d3));
+	ASSERT_EQ(-1, syscall(__NR_pivot_root, dir_s3d2, dir_s3d3));
 	ASSERT_EQ(EPERM, errno);
 	clear_cap(_metadata, CAP_SYS_ADMIN);
 }
@@ -1332,13 +1345,13 @@ TEST_F_FORK(layout1, move_mount)
 	ASSERT_LE(0, ruleset_fd);
 
 	set_cap(_metadata, CAP_SYS_ADMIN);
-	ASSERT_EQ(0, syscall(SYS_move_mount, AT_FDCWD, dir_s3d2, AT_FDCWD,
+	ASSERT_EQ(0, syscall(__NR_move_mount, AT_FDCWD, dir_s3d2, AT_FDCWD,
 			     dir_s1d2, 0))
 	{
 		TH_LOG("Failed to move mount: %s", strerror(errno));
 	}
 
-	ASSERT_EQ(0, syscall(SYS_move_mount, AT_FDCWD, dir_s1d2, AT_FDCWD,
+	ASSERT_EQ(0, syscall(__NR_move_mount, AT_FDCWD, dir_s1d2, AT_FDCWD,
 			     dir_s3d2, 0));
 	clear_cap(_metadata, CAP_SYS_ADMIN);
 
@@ -1346,7 +1359,7 @@ TEST_F_FORK(layout1, move_mount)
 	ASSERT_EQ(0, close(ruleset_fd));
 
 	set_cap(_metadata, CAP_SYS_ADMIN);
-	ASSERT_EQ(-1, syscall(SYS_move_mount, AT_FDCWD, dir_s3d2, AT_FDCWD,
+	ASSERT_EQ(-1, syscall(__NR_move_mount, AT_FDCWD, dir_s3d2, AT_FDCWD,
 			      dir_s1d2, 0));
 	ASSERT_EQ(EPERM, errno);
 	clear_cap(_metadata, CAP_SYS_ADMIN);


