Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C97501C7E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 22:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346205AbiDNUT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 16:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbiDNUTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 16:19:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D38EB0A3;
        Thu, 14 Apr 2022 13:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F53261ECB;
        Thu, 14 Apr 2022 20:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FEDC385A1;
        Thu, 14 Apr 2022 20:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649967448;
        bh=9wFoZvxctteNY0ku76s0j2cfjUOViAsXz3arNOYcvJU=;
        h=Date:To:From:Subject:From;
        b=jTPfs5rCj1PdUxwEIx7x+bbg3aBLhq9ixUT5qwodj8nOKiRYqAiWd0/bS2odmu0C+
         x21zBHxOLMqqVnTaMYR0vPNca0K9wkOzIqjW/yzXoAFzUO+OGUqLDaCYGmSoEq5+uv
         soGtzJgE20iXG97lp4HqxbXwYylfXKrCVrREDt78=
Date:   Thu, 14 Apr 2022 13:17:27 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shuah@kernel.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-verify-remap-destination-address-in-mremap_test.patch added to -mm tree
Message-Id: <20220414201728.62FEDC385A1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: selftest/vm: verify remap destination address in mremap_test
has been added to the -mm tree.  Its filename is
     selftest-vm-verify-remap-destination-address-in-mremap_test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-verify-remap-destination-address-in-mremap_test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-verify-remap-destination-address-in-mremap_test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: selftest/vm: verify remap destination address in mremap_test

Because mremap does not have a NOREPLACE flag, it can destroy existing
mappings.  This can cause a segfault if regions such as text are
destroyed.  Verify the requested mremap destination address does not
overlap any existing mappings by using mmap's FIXED_NOREPLACE flag and
checking for the EEXIST error code.  Keep incrementing the destination
address until a valid mapping is found or max address is reached.

Link: https://lkml.kernel.org/r/20220414171529.62058-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/vm/mremap_test.c~selftest-vm-verify-remap-destination-address-in-mremap_test
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <sys/mman.h>
 #include <time.h>
+#include <limits.h>
 
 #include "../kselftest.h"
 
@@ -64,6 +65,34 @@ enum {
 	.expect_failure = should_fail				\
 }
 
+/*
+ * Returns 0 if the requested remap region overlaps with an
+ * existing mapping (e.g text, stack) else returns 1.
+ */
+static int remap_region_valid(void *addr, unsigned long long size)
+{
+	void *remap_addr = NULL;
+	int ret = 1;
+
+	if ((unsigned long long) addr > ULLONG_MAX - size) {
+		ksft_print_msg("Can't find a valid region to remap to\n");
+		exit(KSFT_SKIP);
+	}
+
+	/* Use MAP_FIXED_NOREPLACE flag to ensure region is not mapped */
+	remap_addr = mmap(addr, size, PROT_READ | PROT_WRITE,
+			MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+			-1, 0);
+	if (remap_addr == MAP_FAILED) {
+		if (errno == EEXIST)
+			ret = 0;
+	} else {
+		munmap(remap_addr, size);
+	}
+
+	return ret;
+}
+
 /* Returns mmap_min_addr sysctl */
 static unsigned long long get_mmap_min_addr(void)
 {
@@ -179,6 +208,13 @@ static long long remap_region(struct con
 	if (!((unsigned long long) addr & c.dest_alignment))
 		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
 
+	/* Don't destroy existing mappings unless expected to overlap */
+	while (!remap_region_valid(addr, c.region_size)) {
+		if (c.overlapping)
+			break;
+		addr += c.src_alignment;
+	}
+
 	clock_gettime(CLOCK_MONOTONIC, &t_start);
 	dest_addr = mremap(src_addr, c.region_size, c.region_size,
 			MREMAP_MAYMOVE|MREMAP_FIXED, (char *) addr);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

selftest-vm-verify-mmap-addr-in-mremap_test.patch
selftest-vm-verify-remap-destination-address-in-mremap_test.patch
selftest-vm-support-xfail-in-mremap_test.patch
selftest-vm-add-skip-support-to-mremap_test.patch
selftest-vm-clarify-error-statement-in-gup_test.patch

