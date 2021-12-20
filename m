Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33F947AEA3
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbhLTPB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49710 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240086AbhLTO7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:59:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DB5C611A9;
        Mon, 20 Dec 2021 14:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E568C36AE7;
        Mon, 20 Dec 2021 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012393;
        bh=wwX9H1S0sfjFl5lVvalHqLcRZ6+E3liP+qzUEorD4s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfQ70bqEROXhzDQlAzlW5ma4nuL8HV/9cNZ4PfBfs1F5RjK/at2uJ7C7A0ftPtKMm
         OZdXaEMCRCuiNC+t7t7SyKLbRPZlXpP+omzABcQuWw4LkMjHmF/8/OpZ0sLGLjXuxD
         rCKUgl3K1CZbyJg0QXPkK2N3BFx3q7pTjlzCoIeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 171/177] selftests/damon: test debugfs file reads/writes with huge count
Date:   Mon, 20 Dec 2021 15:35:21 +0100
Message-Id: <20211220143045.824941936@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

commit b4a002889d24979295ed3c2bf1d5fcfb3901026a upstream.

DAMON debugfs interface users were able to trigger warning by writing
some files with arbitrarily large 'count' parameter.  The issue is fixed
with commit db7a347b26fe ("mm/damon/dbgfs: use '__GFP_NOWARN' for
user-specified size buffer allocation").  This commit adds a test case
for the issue in DAMON selftests to avoid future regressions.

Link: https://lkml.kernel.org/r/20211201150440.1088-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/damon/.gitignore              |    2 
 tools/testing/selftests/damon/Makefile                |    2 
 tools/testing/selftests/damon/debugfs_attrs.sh        |   18 ++++++++
 tools/testing/selftests/damon/huge_count_read_write.c |   39 ++++++++++++++++++
 4 files changed, 61 insertions(+)
 create mode 100644 tools/testing/selftests/damon/.gitignore
 create mode 100644 tools/testing/selftests/damon/huge_count_read_write.c

--- /dev/null
+++ b/tools/testing/selftests/damon/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+huge_count_read_write
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for damon selftests
 
+TEST_GEN_FILES += huge_count_read_write
+
 TEST_FILES = _chk_dependency.sh
 TEST_PROGS = debugfs_attrs.sh
 
--- a/tools/testing/selftests/damon/debugfs_attrs.sh
+++ b/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -72,4 +72,22 @@ test_write_succ "$file" "" "$orig_conten
 test_content "$file" "$orig_content" "" "empty input written"
 echo "$orig_content" > "$file"
 
+# Test huge count read write
+# ==========================
+
+dmesg -C
+
+for file in "$DBGFS/"*
+do
+	./huge_count_read_write "$file"
+done
+
+if dmesg | grep -q WARNING
+then
+	dmesg
+	exit 1
+else
+	exit 0
+fi
+
 echo "PASS"
--- /dev/null
+++ b/tools/testing/selftests/damon/huge_count_read_write.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include <fcntl.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+
+void write_read_with_huge_count(char *file)
+{
+	int filedesc = open(file, O_RDWR);
+	char buf[25];
+	int ret;
+
+	printf("%s %s\n", __func__, file);
+	if (filedesc < 0) {
+		fprintf(stderr, "failed opening %s\n", file);
+		exit(1);
+	}
+
+	write(filedesc, "", 0xfffffffful);
+	perror("after write: ");
+	ret = read(filedesc, buf, 0xfffffffful);
+	perror("after read: ");
+	close(filedesc);
+}
+
+int main(int argc, char *argv[])
+{
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <file>\n", argv[0]);
+		exit(1);
+	}
+	write_read_with_huge_count(argv[1]);
+
+	return 0;
+}


