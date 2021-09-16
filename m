Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDDE40DF72
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhIPQJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234516AbhIPQIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:08:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C922E6127B;
        Thu, 16 Sep 2021 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808442;
        bh=cCKSvXZkqM7clWimlyOr/Tje9lTN/5iVbAtjvido9SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bl2ZIaMFEWZ6WtDD2NUiYEnHLTTlDL20wUpBTx01DfImk66VAX0+6ajE+j2zhtedH
         k8Dnhwb2+4zF3KBx4zQ92Q1zxl/RI5fPzf+kVwoaqD1meZIxrUYFBGRG/pnT42RzfF
         sMcxEauX3er+GX1nXiKphhBRGeVXx4MV/Z4DLkL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/306] KVM: PPC: Book3S HV: Fix copy_tofrom_guest routines
Date:   Thu, 16 Sep 2021 17:57:17 +0200
Message-Id: <20210916155757.201773895@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

[ Upstream commit 5d7d6dac8fe99ed59eee2300e4a03370f94d5222 ]

The __kvmhv_copy_tofrom_guest_radix function was introduced along with
nested HV guest support. It uses the platform's Radix MMU quadrants to
provide a nested hypervisor with fast access to its nested guests
memory (H_COPY_TOFROM_GUEST hypercall). It has also since been added
as a fast path for the kvmppc_ld/st routines which are used during
instruction emulation.

The commit def0bfdbd603 ("powerpc: use probe_user_read() and
probe_user_write()") changed the low level copy function from
raw_copy_from_user to probe_user_read, which adds a check to
access_ok. In powerpc that is:

 static inline bool __access_ok(unsigned long addr, unsigned long size)
 {
         return addr < TASK_SIZE_MAX && size <= TASK_SIZE_MAX - addr;
 }

and TASK_SIZE_MAX is 0x0010000000000000UL for 64-bit, which means that
setting the two MSBs of the effective address (which correspond to the
quadrant) now cause access_ok to reject the access.

This was not caught earlier because the most common code path via
kvmppc_ld/st contains a fallback (kvm_read_guest) that is likely to
succeed for L1 guests. For nested guests there is no fallback.

Another issue is that probe_user_read (now __copy_from_user_nofault)
does not return the number of bytes not copied in case of failure, so
the destination memory is not being cleared anymore in
kvmhv_copy_from_guest_radix:

 ret = kvmhv_copy_tofrom_guest_radix(vcpu, eaddr, to, NULL, n);
 if (ret > 0)                            <-- always false!
         memset(to + (n - ret), 0, ret);

This patch fixes both issues by skipping access_ok and open-coding the
low level __copy_to/from_user_inatomic.

Fixes: def0bfdbd603 ("powerpc: use probe_user_read() and probe_user_write()")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210805212616.2641017-2-farosas@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index bb35490400e9..04028f905e50 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -64,10 +64,12 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 	}
 	isync();
 
+	pagefault_disable();
 	if (is_load)
-		ret = copy_from_user_nofault(to, (const void __user *)from, n);
+		ret = __copy_from_user_inatomic(to, (const void __user *)from, n);
 	else
-		ret = copy_to_user_nofault((void __user *)to, from, n);
+		ret = __copy_to_user_inatomic((void __user *)to, from, n);
+	pagefault_enable();
 
 	/* switch the pid first to avoid running host with unallocated pid */
 	if (quadrant == 1 && pid != old_pid)
-- 
2.30.2



