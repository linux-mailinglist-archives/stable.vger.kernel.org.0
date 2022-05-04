Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A4151A8FB
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245717AbiEDRQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355789AbiEDRIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:08:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432BA51E6F;
        Wed,  4 May 2022 09:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B930618A8;
        Wed,  4 May 2022 16:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971B3C385A5;
        Wed,  4 May 2022 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683273;
        bh=V4+udKpGUEb7EfiAhVQ52/X71aaDypSDTq4SjL343KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPKuDyl1lseDGwXW1Uo4SrFDNkuDjK64zlTaoafn73/2n5QFNom5N/ZiMBAzUhZee
         RApL548aEjYC+7EGYchD6h+M8herj2PhipFDn87IriGC0tjWs34hGLE+f3wXUQgCOY
         C48Xhj8zigkNandxiycMzfIMZIjDWjZcpSYIM0Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/177] selftest/vm: verify remap destination address in mremap_test
Date:   Wed,  4 May 2022 18:45:32 +0200
Message-Id: <20220504153105.675996205@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 2b3b4f15185f..e3ce33a9954e 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <sys/mman.h>
 #include <time.h>
+#include <stdbool.h>
 
 #include "../kselftest.h"
 
@@ -65,6 +66,30 @@ enum {
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
@@ -112,8 +137,8 @@ static void *get_source_mapping(struct config c)
 		goto retry;
 
 	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
-			MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
-			-1, 0);
+					MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+					-1, 0);
 	if (src_addr == MAP_FAILED) {
 		if (errno == EPERM || errno == EEXIST)
 			goto retry;
@@ -180,9 +205,20 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
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



