Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7C53788E8
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbhEJLYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233546AbhEJLMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:12:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1942961361;
        Mon, 10 May 2021 11:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645002;
        bh=ynGX6hjLtJpTGKDlMnPQuVaQmjutGvkT0Qhi1CfW3qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0WmSEvK/JQASzy+J/hbBw7/BZFW+xjTzYzGyKZkoPYquzaH2XATwl7yw9Ap9DHWD
         eaku56kbdx0B/Gal1MWqFMzGu6tu9uDvppSsV8Qfj79i/zoyuqbVSQ5FxLyEwMBUNI
         lSuMtz+lSXNtQR/NTrJu0ynBEMDEuvrMHEcs4Mzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.12 312/384] powerpc/kvm: Fix build error when PPC_MEM_KEYS/PPC_PSERIES=n
Date:   Mon, 10 May 2021 12:21:41 +0200
Message-Id: <20210510102025.081971325@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit ee1bc694fbaec1a662770703fc34a74abf418938 upstream.

lkp reported a randconfig failure:

     In file included from arch/powerpc/include/asm/book3s/64/pkeys.h:6,
                    from arch/powerpc/kvm/book3s_64_mmu_host.c:15:
     arch/powerpc/include/asm/book3s/64/hash-pkey.h: In function 'hash__vmflag_to_pte_pkey_bits':
  >> arch/powerpc/include/asm/book3s/64/hash-pkey.h:10:23: error: 'VM_PKEY_BIT0' undeclared
        10 |  return (((vm_flags & VM_PKEY_BIT0) ? H_PTE_PKEY_BIT0 : 0x0UL) |
         |                       ^~~~~~~~~~~~

We added the include of book3s/64/pkeys.h for pte_to_hpte_pkey_bits(),
but that header on its own should only be included when PPC_MEM_KEYS=y.
Instead include linux/pkeys.h, which brings in the right definitions
when PPC_MEM_KEYS=y and also provides empty stubs when PPC_MEM_KEYS=n.

Fixes: e4e8bc1df691 ("powerpc/kvm: Fix PR KVM with KUAP/MEM_KEYS enabled")
Cc: stable@vger.kernel.org # v5.11+
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210425115831.2818434-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_64_mmu_host.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -8,11 +8,11 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/pkeys.h>
 
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
 #include <asm/book3s/64/mmu-hash.h>
-#include <asm/book3s/64/pkeys.h>
 #include <asm/machdep.h>
 #include <asm/mmu_context.h>
 #include <asm/hw_irq.h>


