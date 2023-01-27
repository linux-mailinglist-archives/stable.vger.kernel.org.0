Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C097367E741
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbjA0N6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbjA0N6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:09 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7FACDE7;
        Fri, 27 Jan 2023 05:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827882;
        bh=XtGhJWHrIaWJmV8UD8TraYwxhka01PtAUbXZqWumiTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLsz4KzvjEDDAEPZ5TbIQgq61r+oyYiBsMCemJfhx/FMU9kMTNU1Sqkg1hsqczaBY
         WI8a6n42m+9s0ytw0j7whkl3cYKR0cNLLNPJJmpqOQpeTrFpIQ3aggsHfnrW4qQB3v
         8ckIU3tIBVB4mVdbyV3iH+KKVSrG19aC2h0B/cjZTsBLBBE4YIwhmUaa0fB3NctXuM
         mlPnxH1ef8gIyXjZRLSt5VtPNKWnrpvIWdCl22EuRI4oV2REjSPNMO8SSzDyWfZ45b
         AIcAatPvJLinPdUrTJFsSZCMjwCkIcoiaiSEgixM8m3enSXVOLRc06qSnLQBxEIXCz
         93ymKr1Ds8KXA==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0V5wCxzhxP;
        Fri, 27 Jan 2023 08:58:02 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 08/34] selftests: filesystems: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:29 -0500
Message-Id: <20230127135755.79929-9-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>    [5.18+]
---
 tools/testing/selftests/filesystems/Makefile          | 2 +-
 tools/testing/selftests/filesystems/binderfs/Makefile | 2 +-
 tools/testing/selftests/filesystems/epoll/Makefile    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/filesystems/Makefile b/tools/testing/selftests/filesystems/Makefile
index 129880fb42d3..c647fd6a0446 100644
--- a/tools/testing/selftests/filesystems/Makefile
+++ b/tools/testing/selftests/filesystems/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 TEST_GEN_PROGS := devpts_pts
 TEST_GEN_PROGS_EXTENDED := dnotify_test
 
diff --git a/tools/testing/selftests/filesystems/binderfs/Makefile b/tools/testing/selftests/filesystems/binderfs/Makefile
index 8af25ae96049..c2f7cef919c0 100644
--- a/tools/testing/selftests/filesystems/binderfs/Makefile
+++ b/tools/testing/selftests/filesystems/binderfs/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/ -pthread
+CFLAGS += $(KHDR_INCLUDES) -pthread
 TEST_GEN_PROGS := binderfs_test
 
 binderfs_test: binderfs_test.c ../../kselftest.h ../../kselftest_harness.h
diff --git a/tools/testing/selftests/filesystems/epoll/Makefile b/tools/testing/selftests/filesystems/epoll/Makefile
index 78ae4aaf7141..0788a7dc8004 100644
--- a/tools/testing/selftests/filesystems/epoll/Makefile
+++ b/tools/testing/selftests/filesystems/epoll/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 LDLIBS += -lpthread
 TEST_GEN_PROGS := epoll_wakeup_test
 
-- 
2.25.1

