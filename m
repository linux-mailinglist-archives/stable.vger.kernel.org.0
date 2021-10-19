Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AFF433EA5
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbhJSSl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234979AbhJSSl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAB0B610E5;
        Tue, 19 Oct 2021 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668784;
        bh=7JuqS1OTvICtFjiNviUanQuixTtcnJmtC29D5lNBmA8=;
        h=Date:From:To:Subject:From;
        b=yF+yl9uc6YhM16E+B24JX/vNevJob78w35TF8NNYqusxzq3mq/fZW7fjS429l+D9v
         CsIIKe1fn2frLwEO1WtiWsno7tH+bC001QZ702/z7oAG4AYVTgN1jwsCU8hG/hQIgv
         6dYlmGspaD7JUgEXCLbWSfjziA46Naxrvr4WG+O8=
Date:   Tue, 19 Oct 2021 11:39:43 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, djwong@kernel.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, seanjc@google.com, stable@vger.kernel.org,
        stephenackerman16@gmail.com
Subject:  [merged]
 mm-fix-null-page-mapping-dereference-in-page_is_secretmem.patch removed
 from -mm tree
Message-ID: <20211019183943.kZxOht11E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/secretmem: fix NULL page->mapping dereference in page_is_secretmem()
has been removed from the -mm tree.  Its filename was
     mm-fix-null-page-mapping-dereference-in-page_is_secretmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sean Christopherson <seanjc@google.com>
Subject: mm/secretmem: fix NULL page->mapping dereference in page_is_secretmem()

Check for a NULL page->mapping before dereferencing the mapping in
page_is_secretmem(), as the page's mapping can be nullified while gup() is
running, e.g.  by reclaim or truncation.

  BUG: kernel NULL pointer dereference, address: 0000000000000068
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 6 PID: 4173897 Comm: CPU 3/KVM Tainted: G        W
  RIP: 0010:internal_get_user_pages_fast+0x621/0x9d0
  Code: <48> 81 7a 68 80 08 04 bc 0f 85 21 ff ff 8 89 c7 be
  RSP: 0018:ffffaa90087679b0 EFLAGS: 00010046
  RAX: ffffe3f37905b900 RBX: 00007f2dd561e000 RCX: ffffe3f37905b934
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffe3f37905b900
  ...
  CR2: 0000000000000068 CR3: 00000004c5898003 CR4: 00000000001726e0
  Call Trace:
   get_user_pages_fast_only+0x13/0x20
   hva_to_pfn+0xa9/0x3e0
   try_async_pf+0xa1/0x270
   direct_page_fault+0x113/0xad0
   kvm_mmu_page_fault+0x69/0x680
   vmx_handle_exit+0xe1/0x5d0
   kvm_arch_vcpu_ioctl_run+0xd81/0x1c70
   kvm_vcpu_ioctl+0x267/0x670
   __x64_sys_ioctl+0x83/0xa0
   do_syscall_64+0x56/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Link: https://lkml.kernel.org/r/20211007231502.3552715-1-seanjc@google.com
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reported-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Stephen <stephenackerman16@gmail.com>
Tested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/secretmem.h~mm-fix-null-page-mapping-dereference-in-page_is_secretmem
+++ a/include/linux/secretmem.h
@@ -23,7 +23,7 @@ static inline bool page_is_secretmem(str
 	mapping = (struct address_space *)
 		((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
 
-	if (mapping != page->mapping)
+	if (!mapping || mapping != page->mapping)
 		return false;
 
 	return mapping->a_ops == &secretmem_aops;
_

Patches currently in -mm which might be from seanjc@google.com are


