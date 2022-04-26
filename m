Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2D251082B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353856AbiDZTGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353778AbiDZTFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827D51999F0;
        Tue, 26 Apr 2022 12:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F5FE619C0;
        Tue, 26 Apr 2022 19:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65473C385B2;
        Tue, 26 Apr 2022 19:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999749;
        bh=uU32vsAIlQhNOwiz7baeDmqduhS8jWk8Pq/Li7uhVgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOxfkei9PuHjOX+C1ynXKtSebr2Qg3tU7of6QoT90N4YsnuQXR/O+G9hWIJbaeJQd
         iwkFIdM0hTcEgJB2Tusw5R+jVLHqdccdp8aoIORXe4Ys65KUwRYdX56n+s3PqaDrgD
         pOCxiG5x19ExTKle/xl3V4uTLEEh3ZnohgR5eQ06N2a6Iw67bhDtRR47iNX7vGrB6k
         5AYOLBVEB98/+hoG1lKxiTiuSLUJ5cWy0BM5AvuW9VT+TVhyY7hE1VK4Ga5gUc8tzN
         ktHFpYmsVyiI44M+igBimpCSOF6GpBVBJUGpy9c7cdQKekOYPC3kRUzu17fRoqb0LV
         PGwzz2EBNgXqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/15] selftest/vm: verify mmap addr in mremap_test
Date:   Tue, 26 Apr 2022 15:02:13 -0400
Message-Id: <20220426190216.2351413-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190216.2351413-1-sashal@kernel.org>
References: <20220426190216.2351413-1-sashal@kernel.org>
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
index 0624d1bd71b5..2b3b4f15185f 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -6,6 +6,7 @@
 
 #include <errno.h>
 #include <stdlib.h>
+#include <stdio.h>
 #include <string.h>
 #include <sys/mman.h>
 #include <time.h>
@@ -64,6 +65,35 @@ enum {
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
@@ -72,8 +102,15 @@ static void *get_source_mapping(struct config c)
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
@@ -91,8 +128,10 @@ static void *get_source_mapping(struct config c)
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

