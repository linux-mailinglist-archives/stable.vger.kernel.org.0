Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2EE5107FE
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353761AbiDZTFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353711AbiDZTFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640F9199168;
        Tue, 26 Apr 2022 12:02:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 060BFB8224A;
        Tue, 26 Apr 2022 19:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89551C385AF;
        Tue, 26 Apr 2022 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999733;
        bh=o3fwiYNUByskOnAIx26ubpASTmCmxwMLzU8e5rSfD0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0Wy/Ncb/n0uLyBGZPvVpU45AlM4qDdBv3f51lYLOjcFr65/G68LgGeC3I54y7nwV
         FLifrpwRcF3dnao2BWhNnGhIJkbxnqH6B4jen7w3aCvwTvtatiHn6gg6JwuGTmzufV
         DGb/UZaEpT3jA0iKxSecif6UUcpHL/aGBPUrrM78UN8B/5bn3dLFMP1aVSiUQM6aki
         XxK34w7Pgz4SIJsPF3auD+kt464rrTyIR9sSTmdvNRrtZdKl+CIt4Bc/qVjBSgrWyO
         lOjUWsU2Vf6jb7vx4yMuQUKqnvAu4uJ2bGZcy4cqfaQ5i7Va6Q9urMGszRVslqPKWp
         kU7eWJC4w5gBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 22/22] selftest/vm: verify remap destination address in mremap_test
Date:   Tue, 26 Apr 2022 15:01:45 -0400
Message-Id: <20220426190145.2351135-22-sashal@kernel.org>
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

[ Upstream commit 18d609daa546c919fd36b62a7b510c18de4b4af8 ]

Because mremap does not have a MAP_FIXED_NOREPLACE flag, it can destroy
existing mappings.  This causes a segfault when regions such as text are
remapped and the permissions are changed.

Verify the requested mremap destination address does not overlap any
existing mappings by using mmap's MAP_FIXED_NOREPLACE flag.  Keep
incrementing the destination address until a valid mapping is found or
fail the current test once the max address is reached.

Link: https://lkml.kernel.org/r/20220420215721.4868-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/mremap_test.c | 42 ++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index 9a518fee6306..58775dab3cc6 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <sys/mman.h>
 #include <time.h>
+#include <stdbool.h>
 
 #include "../kselftest.h"
 
@@ -64,6 +65,30 @@ enum {
 	.expect_failure = should_fail				\
 }
 
+/*
+ * Returns false if the requested remap region overlaps with an
+ * existing mapping (e.g text, stack) else returns true.
+ */
+static bool is_remap_region_valid(void *addr, unsigned long long size)
+{
+	void *remap_addr = NULL;
+	bool ret = true;
+
+	/* Use MAP_FIXED_NOREPLACE flag to ensure region is not mapped */
+	remap_addr = mmap(addr, size, PROT_READ | PROT_WRITE,
+					 MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+					 -1, 0);
+
+	if (remap_addr == MAP_FAILED) {
+		if (errno == EEXIST)
+			ret = false;
+	} else {
+		munmap(remap_addr, size);
+	}
+
+	return ret;
+}
+
 /* Returns mmap_min_addr sysctl tunable from procfs */
 static unsigned long long get_mmap_min_addr(void)
 {
@@ -111,8 +136,8 @@ static void *get_source_mapping(struct config c)
 		goto retry;
 
 	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
-			MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
-			-1, 0);
+					MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+					-1, 0);
 	if (src_addr == MAP_FAILED) {
 		if (errno == EPERM || errno == EEXIST)
 			goto retry;
@@ -179,9 +204,20 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 	if (!((unsigned long long) addr & c.dest_alignment))
 		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
 
+	/* Don't destroy existing mappings unless expected to overlap */
+	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
+		/* Check for unsigned overflow */
+		if (addr + c.dest_alignment < addr) {
+			ksft_print_msg("Couldn't find a valid region to remap to\n");
+			ret = -1;
+			goto out;
+		}
+		addr += c.dest_alignment;
+	}
+
 	clock_gettime(CLOCK_MONOTONIC, &t_start);
 	dest_addr = mremap(src_addr, c.region_size, c.region_size,
-			MREMAP_MAYMOVE|MREMAP_FIXED, (char *) addr);
+					  MREMAP_MAYMOVE|MREMAP_FIXED, (char *) addr);
 	clock_gettime(CLOCK_MONOTONIC, &t_end);
 
 	if (dest_addr == MAP_FAILED) {
-- 
2.35.1

