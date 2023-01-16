Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457D566CC2A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbjAPRWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbjAPRW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEC538B66
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 955E1B81091
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE665C433D2;
        Mon, 16 Jan 2023 17:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888412;
        bh=WadvrxBh0Mgo+NVjzOxnuuu0fEO/OhVa6YQhUAVMWcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1v0OxmP2hD0qN0iwWEEVPqySNrPYiBWtQKG6oxfCGNUasL3T904wlzXzBrgR+0lwL
         Fe4vR8mN1f7GpjJmfASeEOmYsSCBhUl/14YQ5N690jNtEACO5d4pFNLr+Z4/L72ymk
         EzeLLZu6K07rHstGG16cd6XAd5Rf1XfPONw2biuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 517/521] pseries/eeh: Fix the kdump kernel crash during eeh_pseries_init
Date:   Mon, 16 Jan 2023 16:52:59 +0100
Message-Id: <20230116154910.338035731@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.ibm.com>

commit eb8257a12192f43ffd41bd90932c39dade958042 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -957,6 +957,10 @@ static int __init eeh_pseries_init(void)
 	if (is_kdump_kernel() || reset_devices) {
 		pr_info("Issue PHB reset ...\n");
 		list_for_each_entry(phb, &hose_list, list_node) {
+			// Skip if the slot is empty
+			if (list_empty(&PCI_DN(phb->dn)->child_list))
+				continue;
+
 			pdn = list_first_entry(&PCI_DN(phb->dn)->child_list, struct pci_dn, list);
 			addr = (pdn->busno << 16) | (pdn->devfn << 8);
 			config_addr = pseries_eeh_get_config_addr(phb, addr);


