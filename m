Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C4B510801
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353287AbiDZTFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353721AbiDZTFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1A019916B;
        Tue, 26 Apr 2022 12:02:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2081CE20E6;
        Tue, 26 Apr 2022 19:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C037C385AD;
        Tue, 26 Apr 2022 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999733;
        bh=YZK3UpV4c8YazR2b40tUH2JL2rStNLtVLCBp2JIEX9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psI4ufPmRjvssMHDR8sQGb+qstnhcfHREQPlnR9TZRoo5yMlzaPhx6HCHxW3MgwDB
         OcDKC8Z9SVqZ4BLqPchYRRNScGxikP7dm7bml9YY+iiAvkVEx5r33FRNftJ+KGWXW9
         ELbZJkcrtsQf8fB7fKdLYIqnsVuIg82ioyQFW93JgOTT4ZWtAo1s1MPAe7+2QIdeYM
         Ady4qUxfT1JtVYJGLcHQLDLa4f/8R2l9hSYHQFjWm7VOQamgiRMd0RFXkkxq0dY16r
         jyeZPD94yTMhjtBUZSj/cNf41mXXl4bMXwFRGyc3hJzZ2AP5vqdSjm16OoUJ9vOlXQ
         w7hJo8iBiCXMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 21/22] selftest/vm: verify mmap addr in mremap_test
Date:   Tue, 26 Apr 2022 15:01:44 -0400
Message-Id: <20220426190145.2351135-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
References: <20220426190145.2351135-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

[ Upstream commit 9c85a9bae267f6b5e5e374d0d023bbbe9db096d3 ]

Avoid calling mmap with requested addresses that are less than the
system's mmap_min_addr.  When run as root, mmap returns EACCES when
trying to map addresses < mmap_min_addr.  This is not one of the error
codes for the condition to retry the mmap in the test.

Rather than arbitrarily retrying on EACCES, don't attempt an mmap until
addr > vm.mmap_min_addr.

Add a munmap call after an alignment check as the mappings are retained
after the retry and can reach the vm.max_map_count sysctl.

Link: https://lkml.kernel.org/r/20220420215721.4868-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/mremap_test.c | 41 +++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index 7c0b0617b9f8..9a518fee6306 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -6,6 +6,7 @@
 
 #include <errno.h>
 #include <stdlib.h>
+#include <stdio.h>
 #include <string.h>
 #include <sys/mman.h>
 #include <time.h>
@@ -63,6 +64,35 @@ enum {
 	.expect_failure = should_fail				\
 }
 
+/* Returns mmap_min_addr sysctl tunable from procfs */
+static unsigned long long get_mmap_min_addr(void)
+{
+	FILE *fp;
+	int n_matched;
+	static unsigned long long addr;
+
+	if (addr)
+		return addr;
+
+	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
+	if (fp == NULL) {
+		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
+			strerror(errno));
+		exit(KSFT_SKIP);
+	}
+
+	n_matched = fscanf(fp, "%llu", &addr);
+	if (n_matched != 1) {
+		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
+			strerror(errno));
+		fclose(fp);
+		exit(KSFT_SKIP);
+	}
+
+	fclose(fp);
+	return addr;
+}
+
 /*
  * Returns the start address of the mapping on success, else returns
  * NULL on failure.
@@ -71,8 +101,15 @@ static void *get_source_mapping(struct config c)
 {
 	unsigned long long addr = 0ULL;
 	void *src_addr = NULL;
+	unsigned long long mmap_min_addr;
+
+	mmap_min_addr = get_mmap_min_addr();
+
 retry:
 	addr += c.src_alignment;
+	if (addr < mmap_min_addr)
+		goto retry;
+
 	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
 			MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
 			-1, 0);
@@ -90,8 +127,10 @@ static void *get_source_mapping(struct config c)
 	 * alignment in the tests.
 	 */
 	if (((unsigned long long) src_addr & (c.src_alignment - 1)) ||
-			!((unsigned long long) src_addr & c.src_alignment))
+			!((unsigned long long) src_addr & c.src_alignment)) {
+		munmap(src_addr, c.region_size);
 		goto retry;
+	}
 
 	if (!src_addr)
 		goto error;
-- 
2.35.1

