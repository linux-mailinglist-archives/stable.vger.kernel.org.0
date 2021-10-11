Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED40428FAE
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhJKOAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237791AbhJKN7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C410C610C8;
        Mon, 11 Oct 2021 13:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960542;
        bh=9bx/C63d2E8667etsJXBPBFCeb/lT14oe5ktGq/A/cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSCYPLJMF24p1MA/J1SVMmr0FLx2SbQCkEyNZ+fxbB5HIu2iYccLWhisKxBTTriu/
         LpDlsG93tW9O9GS2jNrZneFfalZaTmTA0a0eH2NCcUpH5QRPWStckwtiFV9QIwIf3o
         xoZ2cMCbD3wWMgtXPAaUy+sOiSZZOaSaFThDN2TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 76/83] pseries/eeh: Fix the kdump kernel crash during eeh_pseries_init
Date:   Mon, 11 Oct 2021 15:46:36 +0200
Message-Id: <20211011134511.000129257@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.ibm.com>

[ Upstream commit eb8257a12192f43ffd41bd90932c39dade958042 ]

On pseries LPAR when an empty slot is assigned to partition OR in single
LPAR mode, kdump kernel crashes during issuing PHB reset.

In the kdump scenario, we traverse all PHBs and issue reset using the
pe_config_addr of the first child device present under each PHB. However
the code assumes that none of the PHB slots can be empty and uses
list_first_entry() to get the first child device under the PHB. Since
list_first_entry() expects the list to be non-empty, it returns an
invalid pci_dn entry and ends up accessing NULL phb pointer under
pci_dn->phb causing kdump kernel crash.

This patch fixes the below kdump kernel crash by skipping empty slots:

  audit: initializing netlink subsys (disabled)
  thermal_sys: Registered thermal governor 'fair_share'
  thermal_sys: Registered thermal governor 'step_wise'
  cpuidle: using governor menu
  pstore: Registered nvram as persistent store backend
  Issue PHB reset ...
  audit: type=2000 audit(1631267818.000:1): state=initialized audit_enabled=0 res=1
  BUG: Kernel NULL pointer dereference on read at 0x00000268
  Faulting instruction address: 0xc000000008101fb0
  Oops: Kernel access of bad area, sig: 7 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
  Modules linked in:
  CPU: 7 PID: 1 Comm: swapper/7 Not tainted 5.14.0 #1
  NIP:  c000000008101fb0 LR: c000000009284ccc CTR: c000000008029d70
  REGS: c00000001161b840 TRAP: 0300   Not tainted  (5.14.0)
  MSR:  8000000002009033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 28000224  XER: 20040002
  CFAR: c000000008101f0c DAR: 0000000000000268 DSISR: 00080000 IRQMASK: 0
  ...
  NIP pseries_eeh_get_pe_config_addr+0x100/0x1b0
  LR  __machine_initcall_pseries_eeh_pseries_init+0x2cc/0x350
  Call Trace:
    0xc00000001161bb80 (unreliable)
    __machine_initcall_pseries_eeh_pseries_init+0x2cc/0x350
    do_one_initcall+0x60/0x2d0
    kernel_init_freeable+0x350/0x3f8
    kernel_init+0x3c/0x17c
    ret_from_kernel_thread+0x5c/0x64

Fixes: 5a090f7c363fd ("powerpc/pseries: PCIE PHB reset")
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
[mpe: Tweak wording and trim oops]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/163215558252.413351.8600189949820258982.stgit@jupiter
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index cf024fa37bda..7ed38ebd0c7b 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -868,6 +868,10 @@ static int __init eeh_pseries_init(void)
 	if (is_kdump_kernel() || reset_devices) {
 		pr_info("Issue PHB reset ...\n");
 		list_for_each_entry(phb, &hose_list, list_node) {
+			// Skip if the slot is empty
+			if (list_empty(&PCI_DN(phb->dn)->child_list))
+				continue;
+
 			pdn = list_first_entry(&PCI_DN(phb->dn)->child_list, struct pci_dn, list);
 			config_addr = pseries_eeh_get_pe_config_addr(pdn);
 
-- 
2.33.0



