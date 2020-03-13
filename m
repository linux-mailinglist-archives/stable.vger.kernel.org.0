Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A786183FA1
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 04:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgCMDZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 23:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgCMDZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 23:25:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B65DA20724;
        Fri, 13 Mar 2020 03:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584069928;
        bh=h9xSio8NrD4I+Rqc4yCMm9RwOW9ZTy8D+D2lUzrahAE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tJ+LVwOKn1iOSyUeGevv9fVK0wxFfPt0zXKK2RmN4ANThbBeZbhTD59mbDBJhAXvF
         5fEqfgsG7glh5KGBCPQqjcmpcwytqfBVbTUk6QjQqJt4+8lXiUSYGdtoRziU5/DXBG
         eZpSMVCbWnDsTYEb6fwNhw5Pdbb/Nf4tlpMtqPXc=
Date:   Thu, 12 Mar 2020 20:25:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     christophe.leroy@c-s.fr, leonardo@linux.ibm.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, shuah@kernel.org,
        stable@vger.kernel.org
Subject:  +
 selftests-vm-fix-map_hugetlb-length-used-for-testing-read-and-write.patch
 added to -mm tree
Message-ID: <20200313032528.pzqoIWk0K%akpm@linux-foundation.org>
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix map_hugetlb length used for testing read and write
has been added to the -mm tree.  Its filename is
     selftests-vm-fix-map_hugetlb-length-used-for-testing-read-and-write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-fix-map_hugetlb-length-used-for-testing-read-and-write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-fix-map_hugetlb-length-used-for-testing-read-and-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: selftests/vm: fix map_hugetlb length used for testing read and write

Commit fa7b9a805c79 ("tools/selftest/vm: allow choosing mem size and page
size in map_hugetlb") added the possibility to change the size of memory
mapped for the test, but left the read and write test using the default
value.  This is unnoticed when mapping a length greater than the default
one, but segfaults otherwise.

Fix read_bytes() and write_bytes() by giving them the real length.

Also fix the call to munmap().

Link: http://lkml.kernel.org/r/9a404a13c871c4bd0ba9ede68f69a1225180dd7e.1580978385.git.christophe.leroy@c-s.fr
Fixes: fa7b9a805c79 ("tools/selftest/vm: allow choosing mem size and page size in map_hugetlb")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reviewed-by: Leonardo Bras <leonardo@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/map_hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/vm/map_hugetlb.c~selftests-vm-fix-map_hugetlb-length-used-for-testing-read-and-write
+++ a/tools/testing/selftests/vm/map_hugetlb.c
@@ -45,20 +45,20 @@ static void check_bytes(char *addr)
 	printf("First hex is %x\n", *((unsigned int *)addr));
 }
 
-static void write_bytes(char *addr)
+static void write_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < length; i++)
 		*(addr + i) = (char)i;
 }
 
-static int read_bytes(char *addr)
+static int read_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
 	check_bytes(addr);
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < length; i++)
 		if (*(addr + i) != (char)i) {
 			printf("Mismatch at %lu\n", i);
 			return 1;
@@ -96,11 +96,11 @@ int main(int argc, char **argv)
 
 	printf("Returned address is %p\n", addr);
 	check_bytes(addr);
-	write_bytes(addr);
-	ret = read_bytes(addr);
+	write_bytes(addr, length);
+	ret = read_bytes(addr, length);
 
 	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, LENGTH)) {
+	if (munmap(addr, length)) {
 		perror("munmap");
 		exit(1);
 	}
_

Patches currently in -mm which might be from christophe.leroy@c-s.fr are

selftests-vm-fix-map_hugetlb-length-used-for-testing-read-and-write.patch

