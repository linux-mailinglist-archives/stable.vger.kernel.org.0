Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F2B19DFA6
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 22:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgDCUlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 16:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgDCUlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Apr 2020 16:41:05 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7187D21655;
        Fri,  3 Apr 2020 20:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585946464;
        bh=PwqbPLYgDc32XcSgjjQbVPp4gaybLR8feQjKJE/VpOA=;
        h=Date:From:To:Subject:From;
        b=QHVdBTVm4k38oOFH/T3oH+Ty1LMREg/OS4MjgUgbR53LVqIaDqM5AKYg86Cob/bLq
         kMHz+/a7Nncq8cJpx0OMOINLxShESyVf8H9bMKMRiGCbg1HskstSGQ8jYxMphp20NA
         CoN/x0pM/lGZKIscId4oAivpfBwUEf2TVUJ1VPYU=
Date:   Fri, 03 Apr 2020 13:41:04 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@c-s.fr, leonardo@linux.ibm.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, shuah@kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 selftests-vm-fix-map_hugetlb-length-used-for-testing-read-and-write.patch
 removed from -mm tree
Message-ID: <20200403204104.r_AEPAWvK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix map_hugetlb length used for testing read and write
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-map_hugetlb-length-used-for-testing-read-and-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


