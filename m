Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA083786BE
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbhEJLK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232210AbhEJLDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:03:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7583C6192A;
        Mon, 10 May 2021 10:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644081;
        bh=cccvPXStjqd+9m62K0FQoCSB956SlMxdLxO/1zn/KMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QVmArCv6lWXvtlXFo/10gOmj94/PzgKPVOgrKyF6+yxQm1w1WX05v3GKsBZeWayI
         Aqaiutlmi1Bs5yPW16ayH28AzUryq6vPjmkuRCxQO0bnVmdtcqeWh4DYahdl4GgGWD
         xyonRxW+B+oHcL258XfTvS36tK/3ExJR4CUsf4JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.11 278/342] powerpc/kvm: Fix PR KVM with KUAP/MEM_KEYS enabled
Date:   Mon, 10 May 2021 12:21:08 +0200
Message-Id: <20210510102019.286635261@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit e4e8bc1df691ba5ba749d1e2b67acf9827e51a35 upstream.

The changes to add KUAP support with the hash MMU broke booting of KVM
PR guests. The symptom is no visible progress of the guest, or possibly
just "SLOF" being printed to the qemu console.

Host code is still executing, but breaking into xmon might show a stack
trace such as:

  __might_fault+0x84/0xe0 (unreliable)
  kvm_read_guest+0x1c8/0x2f0 [kvm]
  kvmppc_ld+0x1b8/0x2d0 [kvm]
  kvmppc_load_last_inst+0x50/0xa0 [kvm]
  kvmppc_exit_pr_progint+0x178/0x220 [kvm_pr]
  kvmppc_handle_exit_pr+0x31c/0xe30 [kvm_pr]
  after_sprg3_load+0x80/0x90 [kvm_pr]
  kvmppc_vcpu_run_pr+0x104/0x260 [kvm_pr]
  kvmppc_vcpu_run+0x34/0x48 [kvm]
  kvm_arch_vcpu_ioctl_run+0x340/0x450 [kvm]
  kvm_vcpu_ioctl+0x2ac/0x8c0 [kvm]
  sys_ioctl+0x320/0x1060
  system_call_exception+0x160/0x270
  system_call_common+0xf0/0x27c

Bisect points to commit b2ff33a10c8b ("powerpc/book3s64/hash/kuap:
Enable kuap on hash"), but that's just the commit that enabled KUAP with
hash and made the bug visible.

The root cause seems to be that KVM PR is creating kernel mappings that
don't use the correct key, since we switched to using key 3.

We have a helper for adding the right key value, however it's designed
to take a pteflags variable, which the KVM code doesn't have. But we can
make it work by passing 0 for the pteflags, and tell it explicitly that
it should use the kernel key.

With that changed guests boot successfully.

Fixes: d94b827e89dc ("powerpc/book3s64/kuap: Use Key 3 for kernel mapping with hash translation")
Cc: stable@vger.kernel.org # v5.11+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210419120139.1455937-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_64_mmu_host.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -12,6 +12,7 @@
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
 #include <asm/book3s/64/mmu-hash.h>
+#include <asm/book3s/64/pkeys.h>
 #include <asm/machdep.h>
 #include <asm/mmu_context.h>
 #include <asm/hw_irq.h>
@@ -133,6 +134,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu
 	else
 		kvmppc_mmu_flush_icache(pfn);
 
+	rflags |= pte_to_hpte_pkey_bits(0, HPTE_USE_KERNEL_KEY);
 	rflags = (rflags & ~HPTE_R_WIMG) | orig_pte->wimg;
 
 	/*


