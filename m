Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD144D82ED
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbiCNMLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240808AbiCNMHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9021725C6B;
        Mon, 14 Mar 2022 05:03:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1606061260;
        Mon, 14 Mar 2022 12:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24589C340E9;
        Mon, 14 Mar 2022 12:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259436;
        bh=wKepa4VZBNA7+1tHrTub0cf2Vg7PKMogZSVkDZHOF1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StUlOs4WxPnNxmZbMBLl/PwrEMDFhAwREe0f+M2E7fbeUXaoy19NpXwhtEaVppwTB
         RWqXy9GUQaxSZX5CpiLMZXys7r2VYfRr1Z3wQEhL2JyKnNMFAa+tRT54Kq+jFd5E3B
         5llyd4x3nG9yoDd9mTybYtG5o2InHP/wTCsTKKQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/71] selftest/vm: fix map_fixed_noreplace test failure
Date:   Mon, 14 Mar 2022 12:53:40 +0100
Message-Id: <20220314112739.247985601@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit f39c58008dee7ab5fc94c3f1995a21e886801df0 ]

On the latest RHEL the test fails due to executable mapped at 256MB
address

     # ./map_fixed_noreplace
    mmap() @ 0x10000000-0x10050000 p=0xffffffffffffffff result=File exists
    10000000-10010000 r-xp 00000000 fd:04 34905657                           /root/rpmbuild/BUILD/kernel-5.14.0-56.el9/linux-5.14.0-56.el9.ppc64le/tools/testing/selftests/vm/map_fixed_noreplace
    10010000-10020000 r--p 00000000 fd:04 34905657                           /root/rpmbuild/BUILD/kernel-5.14.0-56.el9/linux-5.14.0-56.el9.ppc64le/tools/testing/selftests/vm/map_fixed_noreplace
    10020000-10030000 rw-p 00010000 fd:04 34905657                           /root/rpmbuild/BUILD/kernel-5.14.0-56.el9/linux-5.14.0-56.el9.ppc64le/tools/testing/selftests/vm/map_fixed_noreplace
    10029b90000-10029bc0000 rw-p 00000000 00:00 0                            [heap]
    7fffbb510000-7fffbb750000 r-xp 00000000 fd:04 24534                      /usr/lib64/libc.so.6
    7fffbb750000-7fffbb760000 r--p 00230000 fd:04 24534                      /usr/lib64/libc.so.6
    7fffbb760000-7fffbb770000 rw-p 00240000 fd:04 24534                      /usr/lib64/libc.so.6
    7fffbb780000-7fffbb7a0000 r--p 00000000 00:00 0                          [vvar]
    7fffbb7a0000-7fffbb7b0000 r-xp 00000000 00:00 0                          [vdso]
    7fffbb7b0000-7fffbb800000 r-xp 00000000 fd:04 24514                      /usr/lib64/ld64.so.2
    7fffbb800000-7fffbb810000 r--p 00040000 fd:04 24514                      /usr/lib64/ld64.so.2
    7fffbb810000-7fffbb820000 rw-p 00050000 fd:04 24514                      /usr/lib64/ld64.so.2
    7fffd93f0000-7fffd9420000 rw-p 00000000 00:00 0                          [stack]
    Error: couldn't map the space we need for the test

Fix this by finding a free address using mmap instead of hardcoding
BASE_ADDRESS.

Link: https://lkml.kernel.org/r/20220217083417.373823-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jann Horn <jannh@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/vm/map_fixed_noreplace.c        | 49 ++++++++++++++-----
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/vm/map_fixed_noreplace.c b/tools/testing/selftests/vm/map_fixed_noreplace.c
index d91bde511268..eed44322d1a6 100644
--- a/tools/testing/selftests/vm/map_fixed_noreplace.c
+++ b/tools/testing/selftests/vm/map_fixed_noreplace.c
@@ -17,9 +17,6 @@
 #define MAP_FIXED_NOREPLACE 0x100000
 #endif
 
-#define BASE_ADDRESS	(256ul * 1024 * 1024)
-
-
 static void dump_maps(void)
 {
 	char cmd[32];
@@ -28,18 +25,46 @@ static void dump_maps(void)
 	system(cmd);
 }
 
+static unsigned long find_base_addr(unsigned long size)
+{
+	void *addr;
+	unsigned long flags;
+
+	flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	addr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
+	if (addr == MAP_FAILED) {
+		printf("Error: couldn't map the space we need for the test\n");
+		return 0;
+	}
+
+	if (munmap(addr, size) != 0) {
+		printf("Error: couldn't map the space we need for the test\n");
+		return 0;
+	}
+	return (unsigned long)addr;
+}
+
 int main(void)
 {
+	unsigned long base_addr;
 	unsigned long flags, addr, size, page_size;
 	char *p;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 
+	//let's find a base addr that is free before we start the tests
+	size = 5 * page_size;
+	base_addr = find_base_addr(size);
+	if (!base_addr) {
+		printf("Error: couldn't map the space we need for the test\n");
+		return 1;
+	}
+
 	flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE;
 
 	// Check we can map all the areas we need below
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 5 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 
@@ -60,7 +85,7 @@ int main(void)
 	printf("unmap() successful\n");
 
 	errno = 0;
-	addr = BASE_ADDRESS + page_size;
+	addr = base_addr + page_size;
 	size = 3 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -80,7 +105,7 @@ int main(void)
 	 *     +4 |  free  | new
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 5 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -101,7 +126,7 @@ int main(void)
 	 *     +4 |  free  |
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS + (2 * page_size);
+	addr = base_addr + (2 * page_size);
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -121,7 +146,7 @@ int main(void)
 	 *     +4 |  free  | new
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS + (3 * page_size);
+	addr = base_addr + (3 * page_size);
 	size = 2 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -141,7 +166,7 @@ int main(void)
 	 *     +4 |  free  |
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 2 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -161,7 +186,7 @@ int main(void)
 	 *     +4 |  free  |
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -181,7 +206,7 @@ int main(void)
 	 *     +4 |  free  |  new
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS + (4 * page_size);
+	addr = base_addr + (4 * page_size);
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -192,7 +217,7 @@ int main(void)
 		return 1;
 	}
 
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 5 * page_size;
 	if (munmap((void *)addr, size) != 0) {
 		dump_maps();
-- 
2.34.1



