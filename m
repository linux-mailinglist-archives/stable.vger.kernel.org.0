Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6026253E2C6
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiFFHuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiFFHuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F10BBCDA
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9509611BD
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6045C3411E;
        Mon,  6 Jun 2022 07:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501852;
        bh=Vw4vaTER/8zvIx9Kpy8KISlopgQFYZvchDTfUBn9lW0=;
        h=Subject:To:Cc:From:Date:From;
        b=dCZltQSY2UkSq9mlrLZqy61ldkrGgUrYFLSvOdR5h3PpE2BSY2Rq47TfG042FOHXD
         TZ3Qs9hTrC0Jx6ZTimp9ExLI7G/V5xIt9X76AoWwMRUnUKvyal2ECY9r02KDWbrrQS
         PWtLvZBPAiSWgVlChw3WDRQcRZoCTNyGSt5icjtI=
Subject: WTF: patch "[PATCH] selftests/landlock: Make tests build with old libc" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net, shuah@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:50:33 +0200
Message-ID: <165450183323712@kroah.com>
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

From 87129ef13603ae46c82bcd09eed948acf0506dbb Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:12 +0200
Subject: [PATCH] selftests/landlock: Make tests build with old libc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 28b01cb30c78..cc7fa7b17578 100644
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
 
@@ -1279,7 +1292,7 @@ TEST_F_FORK(layout1, rule_inside_mount_ns)
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

