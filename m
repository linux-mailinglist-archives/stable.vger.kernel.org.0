Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8FE24F817
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgHXJ0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbgHXIxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:53:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D05A92072D;
        Mon, 24 Aug 2020 08:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259186;
        bh=DicadsMPGxJ53mYrlhx9xMgac3jXJrx8fsEl9PLK5Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ihr9k4EryWT76gRWHG6TVx4vQ0/FGe/pbX22vw5aumUN+cb4K9JnDTW94uxMcchvp
         HGCPP1Tsew1VT1FMoWoJzp8FyIeEFFqYJsdKWq7XKwpgPfZFeBqzKJoloz08wLoe5y
         WN7BEOGTaRQ/4QYTs3SplYSG/ZC8+zNgLk7jDHfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/50] powerpc/mm: Only read faulting instruction when necessary in do_page_fault()
Date:   Mon, 24 Aug 2020 10:31:06 +0200
Message-Id: <20200824082352.178041484@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 0e36b0d12501e278686634712975b785bae11641 ]

Commit a7a9dcd882a67 ("powerpc: Avoid taking a data miss on every
userspace instruction miss") has shown that limiting the read of
faulting instruction to likely cases improves performance.

This patch goes further into this direction by limiting the read
of the faulting instruction to the only cases where it is likely
needed.

On an MPC885, with the same benchmark app as in the commit referred
above, we see a reduction of about 3900 dTLB misses (approx 3%):

Before the patch:
 Performance counter stats for './fault 500' (10 runs):

         683033312      cpu-cycles                                                    ( +-  0.03% )
            134538      dTLB-load-misses                                              ( +-  0.03% )
             46099      iTLB-load-misses                                              ( +-  0.02% )
             19681      faults                                                        ( +-  0.02% )

       5.389747878 seconds time elapsed                                          ( +-  0.06% )

With the patch:

 Performance counter stats for './fault 500' (10 runs):

         682112862      cpu-cycles                                                    ( +-  0.03% )
            130619      dTLB-load-misses                                              ( +-  0.03% )
             46073      iTLB-load-misses                                              ( +-  0.05% )
             19681      faults                                                        ( +-  0.01% )

       5.381342641 seconds time elapsed                                          ( +-  0.07% )

The proper work of the huge stack expansion was tested with the
following app:

int main(int argc, char **argv)
{
	char buf[1024 * 1025];

	sprintf(buf, "Hello world !\n");
	printf(buf);

	exit(0);
}

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Add include of pagemap.h to fix build errors]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/fault.c | 50 ++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 5fc8a010fdf07..998c77e600a43 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/pagemap.h>
 #include <linux/ptrace.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
@@ -66,15 +67,11 @@ static inline bool notify_page_fault(struct pt_regs *regs)
 }
 
 /*
- * Check whether the instruction at regs->nip is a store using
+ * Check whether the instruction inst is a store using
  * an update addressing form which will update r1.
  */
-static bool store_updates_sp(struct pt_regs *regs)
+static bool store_updates_sp(unsigned int inst)
 {
-	unsigned int inst;
-
-	if (get_user(inst, (unsigned int __user *)regs->nip))
-		return false;
 	/* check for 1 in the rA field */
 	if (((inst >> 16) & 0x1f) != 1)
 		return false;
@@ -228,8 +225,8 @@ static bool bad_kernel_fault(bool is_exec, unsigned long error_code,
 }
 
 static bool bad_stack_expansion(struct pt_regs *regs, unsigned long address,
-				struct vm_area_struct *vma,
-				bool store_update_sp)
+				struct vm_area_struct *vma, unsigned int flags,
+				bool *must_retry)
 {
 	/*
 	 * N.B. The POWER/Open ABI allows programs to access up to
@@ -241,6 +238,7 @@ static bool bad_stack_expansion(struct pt_regs *regs, unsigned long address,
 	 * expand to 1MB without further checks.
 	 */
 	if (address + 0x100000 < vma->vm_end) {
+		unsigned int __user *nip = (unsigned int __user *)regs->nip;
 		/* get user regs even if this fault is in kernel mode */
 		struct pt_regs *uregs = current->thread.regs;
 		if (uregs == NULL)
@@ -258,8 +256,22 @@ static bool bad_stack_expansion(struct pt_regs *regs, unsigned long address,
 		 * between the last mapped region and the stack will
 		 * expand the stack rather than segfaulting.
 		 */
-		if (address + 2048 < uregs->gpr[1] && !store_update_sp)
-			return true;
+		if (address + 2048 >= uregs->gpr[1])
+			return false;
+
+		if ((flags & FAULT_FLAG_WRITE) && (flags & FAULT_FLAG_USER) &&
+		    access_ok(VERIFY_READ, nip, sizeof(*nip))) {
+			unsigned int inst;
+			int res;
+
+			pagefault_disable();
+			res = __get_user_inatomic(inst, nip);
+			pagefault_enable();
+			if (!res)
+				return !store_updates_sp(inst);
+			*must_retry = true;
+		}
+		return true;
 	}
 	return false;
 }
@@ -392,7 +404,7 @@ static int __do_page_fault(struct pt_regs *regs, unsigned long address,
 	int is_user = user_mode(regs);
 	int is_write = page_fault_is_write(error_code);
 	int fault, major = 0;
-	bool store_update_sp = false;
+	bool must_retry = false;
 
 	if (notify_page_fault(regs))
 		return 0;
@@ -439,9 +451,6 @@ static int __do_page_fault(struct pt_regs *regs, unsigned long address,
 	 * can result in fault, which will cause a deadlock when called with
 	 * mmap_sem held
 	 */
-	if (is_write && is_user)
-		store_update_sp = store_updates_sp(regs);
-
 	if (is_user)
 		flags |= FAULT_FLAG_USER;
 	if (is_write)
@@ -488,8 +497,17 @@ retry:
 		return bad_area(regs, address);
 
 	/* The stack is being expanded, check if it's valid */
-	if (unlikely(bad_stack_expansion(regs, address, vma, store_update_sp)))
-		return bad_area(regs, address);
+	if (unlikely(bad_stack_expansion(regs, address, vma, flags,
+					 &must_retry))) {
+		if (!must_retry)
+			return bad_area(regs, address);
+
+		up_read(&mm->mmap_sem);
+		if (fault_in_pages_readable((const char __user *)regs->nip,
+					    sizeof(unsigned int)))
+			return bad_area_nosemaphore(regs, address);
+		goto retry;
+	}
 
 	/* Try to expand it */
 	if (unlikely(expand_stack(vma, address)))
-- 
2.25.1



