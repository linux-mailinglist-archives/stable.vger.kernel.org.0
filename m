Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F2E22690D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbgGTQEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732540AbgGTQEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:04:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD8120672;
        Mon, 20 Jul 2020 16:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261040;
        bh=cakMkwUssDNRGezxaxJHShMrS5+T/3cFdGtVNrDzmf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNudYKCo/56+aizx/BosqjyEg/qJHrpI/YZ/VVQiaxL2NFPqnSEfKj6uyzUfQBwzT
         FP6dlKkh5nN/GREW72USH1zZ+s6L/C14d3d13XFsZNCMKT2l7vJDBLE8k4KCbQbXVU
         3L5E90nNPTJRqnZOilRNdYymqjP27oQ3rBRb6u/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandipan Das <sandipan@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 187/215] powerpc/book3s64/pkeys: Fix pkey_access_permitted() for execute disable pkey
Date:   Mon, 20 Jul 2020 17:37:49 +0200
Message-Id: <20200720152829.075044632@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 192b6a780598976feb7321ff007754f8511a4129 upstream.

Even if the IAMR value denies execute access, the current code returns
true from pkey_access_permitted() for an execute permission check, if
the AMR read pkey bit is cleared.

This results in repeated page fault loop with a test like below:

  #define _GNU_SOURCE
  #include <errno.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <signal.h>
  #include <inttypes.h>

  #include <assert.h>
  #include <malloc.h>
  #include <unistd.h>
  #include <pthread.h>
  #include <sys/mman.h>

  #ifdef SYS_pkey_mprotect
  #undef SYS_pkey_mprotect
  #endif

  #ifdef SYS_pkey_alloc
  #undef SYS_pkey_alloc
  #endif

  #ifdef SYS_pkey_free
  #undef SYS_pkey_free
  #endif

  #undef PKEY_DISABLE_EXECUTE
  #define PKEY_DISABLE_EXECUTE	0x4

  #define SYS_pkey_mprotect	386
  #define SYS_pkey_alloc		384
  #define SYS_pkey_free		385

  #define PPC_INST_NOP		0x60000000
  #define PPC_INST_BLR		0x4e800020
  #define PROT_RWX		(PROT_READ | PROT_WRITE | PROT_EXEC)

  static int sys_pkey_mprotect(void *addr, size_t len, int prot, int pkey)
  {
  	return syscall(SYS_pkey_mprotect, addr, len, prot, pkey);
  }

  static int sys_pkey_alloc(unsigned long flags, unsigned long access_rights)
  {
  	return syscall(SYS_pkey_alloc, flags, access_rights);
  }

  static int sys_pkey_free(int pkey)
  {
  	return syscall(SYS_pkey_free, pkey);
  }

  static void do_execute(void *region)
  {
  	/* jump to region */
  	asm volatile(
  		"mtctr	%0;"
  		"bctrl"
  		: : "r"(region) : "ctr", "lr");
  }

  static void do_protect(void *region)
  {
  	size_t pgsize;
  	int i, pkey;

  	pgsize = getpagesize();

  	pkey = sys_pkey_alloc(0, PKEY_DISABLE_EXECUTE);
  	assert (pkey > 0);

  	/* perform mprotect */
  	assert(!sys_pkey_mprotect(region, pgsize, PROT_RWX, pkey));
  	do_execute(region);

  	/* free pkey */
  	assert(!sys_pkey_free(pkey));

  }

  int main(int argc, char **argv)
  {
  	size_t pgsize, numinsns;
  	unsigned int *region;
  	int i;

  	/* allocate memory region to protect */
  	pgsize = getpagesize();
  	region = memalign(pgsize, pgsize);
  	assert(region != NULL);
  	assert(!mprotect(region, pgsize, PROT_RWX));

  	/* fill page with NOPs with a BLR at the end */
  	numinsns = pgsize / sizeof(region[0]);
  	for (i = 0; i < numinsns - 1; i++)
  		region[i] = PPC_INST_NOP;
  	region[i] = PPC_INST_BLR;

  	do_protect(region);

  	return EXIT_SUCCESS;
  }

The fix is to only check the IAMR for an execute check, the AMR value
is not relevant.

Fixes: f2407ef3ba22 ("powerpc: helper to validate key-access permissions of a pte")
Cc: stable@vger.kernel.org # v4.16+
Reported-by: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
[mpe: Add detail to change log, tweak wording & formatting]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200712132047.1038594-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/book3s64/pkeys.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/powerpc/mm/book3s64/pkeys.c
+++ b/arch/powerpc/mm/book3s64/pkeys.c
@@ -367,12 +367,14 @@ static bool pkey_access_permitted(int pk
 		return true;
 
 	pkey_shift = pkeyshift(pkey);
-	if (execute && !(read_iamr() & (IAMR_EX_BIT << pkey_shift)))
-		return true;
+	if (execute)
+		return !(read_iamr() & (IAMR_EX_BIT << pkey_shift));
+
+	amr = read_amr();
+	if (write)
+		return !(amr & (AMR_WR_BIT << pkey_shift));
 
-	amr = read_amr(); /* Delay reading amr until absolutely needed */
-	return ((!write && !(amr & (AMR_RD_BIT << pkey_shift))) ||
-		(write &&  !(amr & (AMR_WR_BIT << pkey_shift))));
+	return !(amr & (AMR_RD_BIT << pkey_shift));
 }
 
 bool arch_pte_access_permitted(u64 pte, bool write, bool execute)


