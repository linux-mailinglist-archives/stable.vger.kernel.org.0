Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B421621FA11
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgGNStN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730067AbgGNStM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:49:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C10222E9;
        Tue, 14 Jul 2020 18:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752552;
        bh=99IkoKqYal1+CgiFJUp043LhO+ehrbzZwOrkNWk7qI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXhXcujrXroj0F/BTVvWOlH5eAdZcIv4JGnI/spyPrBFCXGU771KQhMOcv/oL/1SZ
         A1PBBkY5FjjebkC2RSfkp0fJN8nb21EhTnG2hrhvLm0+mQomhV3T3N/0CcjBrDqlvU
         iZTx3SJGQA7zvaGlvZf6+9hQk336SEOJw3zwZHCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/109] powerpc/kvm/book3s64: Fix kernel crash with nested kvm & DEBUG_VIRTUAL
Date:   Tue, 14 Jul 2020 20:43:24 +0200
Message-Id: <20200714184106.543814586@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit c1ed1754f271f6b7acb1bfdc8cfb62220fbed423 ]

With CONFIG_DEBUG_VIRTUAL=y, __pa() checks for addr value and if it's
less than PAGE_OFFSET it leads to a BUG().

  #define __pa(x)
  ({
  	VIRTUAL_BUG_ON((unsigned long)(x) < PAGE_OFFSET);
  	(unsigned long)(x) & 0x0fffffffffffffffUL;
  })

  kernel BUG at arch/powerpc/kvm/book3s_64_mmu_radix.c:43!
  cpu 0x70: Vector: 700 (Program Check) at [c0000018a2187360]
      pc: c000000000161b30: __kvmhv_copy_tofrom_guest_radix+0x130/0x1f0
      lr: c000000000161d5c: kvmhv_copy_from_guest_radix+0x3c/0x80
  ...
  kvmhv_copy_from_guest_radix+0x3c/0x80
  kvmhv_load_from_eaddr+0x48/0xc0
  kvmppc_ld+0x98/0x1e0
  kvmppc_load_last_inst+0x50/0x90
  kvmppc_hv_emulate_mmio+0x288/0x2b0
  kvmppc_book3s_radix_page_fault+0xd8/0x2b0
  kvmppc_book3s_hv_page_fault+0x37c/0x1050
  kvmppc_vcpu_run_hv+0xbb8/0x1080
  kvmppc_vcpu_run+0x34/0x50
  kvm_arch_vcpu_ioctl_run+0x2fc/0x410
  kvm_vcpu_ioctl+0x2b4/0x8f0
  ksys_ioctl+0xf4/0x150
  sys_ioctl+0x28/0x80
  system_call_exception+0x104/0x1d0
  system_call_common+0xe8/0x214

kvmhv_copy_tofrom_guest_radix() uses a NULL value for to/from to
indicate direction of copy.

Avoid calling __pa() if the value is NULL to avoid the BUG().

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
[mpe: Massage change log a bit to mention CONFIG_DEBUG_VIRTUAL]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200611120159.680284-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 43b56f8f6bebd..da8375437d161 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -38,7 +38,8 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 	/* Can't access quadrants 1 or 2 in non-HV mode, call the HV to do it */
 	if (kvmhv_on_pseries())
 		return plpar_hcall_norets(H_COPY_TOFROM_GUEST, lpid, pid, eaddr,
-					  __pa(to), __pa(from), n);
+					  (to != NULL) ? __pa(to): 0,
+					  (from != NULL) ? __pa(from): 0, n);
 
 	quadrant = 1;
 	if (!pid)
-- 
2.25.1



