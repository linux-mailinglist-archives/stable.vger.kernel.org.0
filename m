Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4D53786BA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhEJLKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234445AbhEJLDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:03:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92532617C9;
        Mon, 10 May 2021 10:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644068;
        bh=sxdG9erlraFQgNi9ASTWqHeMNHqt4H+GmvkuDd2xkrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wO7+UsL+Jt0mfG9CWsIUYArOJaVvQn02Qmc3d+7CeCVta48mNwMG2MoGGB0Eau800
         U3XmurvBDx47S+Ob+BqZIQ9XOkF0hvcl6jexpm3dtS35p8IEH6+BA6t7hpQ4DIkl7T
         1IRGurfExJpQm4xlZXqi6REs0DOnlZIDO8oDw3MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dominic DeMarco <ddemarc@us.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.11 274/342] powerpc/eeh: Fix EEH handling for hugepages in ioremap space.
Date:   Mon, 10 May 2021 12:21:04 +0200
Message-Id: <20210510102019.155517745@linuxfoundation.org>
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

From: Mahesh Salgaonkar <mahesh@linux.ibm.com>

commit 5ae5bc12d0728db60a0aa9b62160ffc038875f1a upstream.

During the EEH MMIO error checking, the current implementation fails to map
the (virtual) MMIO address back to the pci device on radix with hugepage
mappings for I/O. This results into failure to dispatch EEH event with no
recovery even when EEH capability has been enabled on the device.

eeh_check_failure(token)		# token = virtual MMIO address
  addr = eeh_token_to_phys(token);
  edev = eeh_addr_cache_get_dev(addr);
  if (!edev)
	return 0;
  eeh_dev_check_failure(edev);	<= Dispatch the EEH event

In case of hugepage mappings, eeh_token_to_phys() has a bug in virt -> phys
translation that results in wrong physical address, which is then passed to
eeh_addr_cache_get_dev() to match it against cached pci I/O address ranges
to get to a PCI device. Hence, it fails to find a match and the EEH event
never gets dispatched leaving the device in failed state.

The commit 33439620680be ("powerpc/eeh: Handle hugepages in ioremap space")
introduced following logic to translate virt to phys for hugepage mappings:

eeh_token_to_phys():
+	pa = pte_pfn(*ptep);
+
+	/* On radix we can do hugepage mappings for io, so handle that */
+       if (hugepage_shift) {
+               pa <<= hugepage_shift;			<= This is wrong
+               pa |= token & ((1ul << hugepage_shift) - 1);
+       }

This patch fixes the virt -> phys translation in eeh_token_to_phys()
function.

  $ cat /sys/kernel/debug/powerpc/eeh_address_cache
  mem addr range [0x0000040080000000-0x00000400807fffff]: 0030:01:00.1
  mem addr range [0x0000040080800000-0x0000040080ffffff]: 0030:01:00.1
  mem addr range [0x0000040081000000-0x00000400817fffff]: 0030:01:00.0
  mem addr range [0x0000040081800000-0x0000040081ffffff]: 0030:01:00.0
  mem addr range [0x0000040082000000-0x000004008207ffff]: 0030:01:00.1
  mem addr range [0x0000040082080000-0x00000400820fffff]: 0030:01:00.0
  mem addr range [0x0000040082100000-0x000004008210ffff]: 0030:01:00.1
  mem addr range [0x0000040082110000-0x000004008211ffff]: 0030:01:00.0

Above is the list of cached io address ranges of pci 0030:01:00.<fn>.

Before this patch:

Tracing 'arg1' of function eeh_addr_cache_get_dev() during error injection
clearly shows that 'addr=' contains wrong physical address:

   kworker/u16:0-7       [001] ....   108.883775: eeh_addr_cache_get_dev:
	   (eeh_addr_cache_get_dev+0xc/0xf0) addr=0x80103000a510

dmesg shows no EEH recovery messages:

  [  108.563768] bnx2x: [bnx2x_timer:5801(eth2)]MFW seems hanged: drv_pulse (0x9ae) != mcp_pulse (0x7fff)
  [  108.563788] bnx2x: [bnx2x_hw_stats_update:870(eth2)]NIG timer max (4294967295)
  [  108.883788] bnx2x: [bnx2x_acquire_hw_lock:2013(eth1)]lock_status 0xffffffff  resource_bit 0x1
  [  108.884407] bnx2x 0030:01:00.0 eth1: MDC/MDIO access timeout
  [  108.884976] bnx2x 0030:01:00.0 eth1: MDC/MDIO access timeout
  <..>

After this patch:

eeh_addr_cache_get_dev() trace shows correct physical address:

  <idle>-0       [001] ..s.  1043.123828: eeh_addr_cache_get_dev:
	  (eeh_addr_cache_get_dev+0xc/0xf0) addr=0x40080bc7cd8

dmesg logs shows EEH recovery getting triggerred:

  [  964.323980] bnx2x: [bnx2x_timer:5801(eth2)]MFW seems hanged: drv_pulse (0x746f) != mcp_pulse (0x7fff)
  [  964.323991] EEH: Recovering PHB#30-PE#10000
  [  964.324002] EEH: PE location: N/A, PHB location: N/A
  [  964.324006] EEH: Frozen PHB#30-PE#10000 detected
  <..>

Fixes: 33439620680b ("powerpc/eeh: Handle hugepages in ioremap space")
Cc: stable@vger.kernel.org # v5.3+
Reported-by: Dominic DeMarco <ddemarc@us.ibm.com>
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/161821396263.48361.2796709239866588652.stgit@jupiter
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/eeh.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -362,14 +362,11 @@ static inline unsigned long eeh_token_to
 	pa = pte_pfn(*ptep);
 
 	/* On radix we can do hugepage mappings for io, so handle that */
-	if (hugepage_shift) {
-		pa <<= hugepage_shift;
-		pa |= token & ((1ul << hugepage_shift) - 1);
-	} else {
-		pa <<= PAGE_SHIFT;
-		pa |= token & (PAGE_SIZE - 1);
-	}
+	if (!hugepage_shift)
+		hugepage_shift = PAGE_SHIFT;
 
+	pa <<= PAGE_SHIFT;
+	pa |= token & ((1ul << hugepage_shift) - 1);
 	return pa;
 }
 


