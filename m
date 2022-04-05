Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F994F3350
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiDEI0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239256AbiDEIT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB3F7E0A6;
        Tue,  5 Apr 2022 01:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89777609AD;
        Tue,  5 Apr 2022 08:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9978AC385A1;
        Tue,  5 Apr 2022 08:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146242;
        bh=wTZLCXNOjVt+S6FiSZPMEAOxnXnFypP8IM3fxUsZe+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRDeZM/B9RKMBycW19IKmxHe1r0lqXr1Ub/ilBAX6IRBWT1rGQQloL//CoGvjmUJX
         5Tlg+pHHebBuJleQqeXo68PvYsGlfNgBT9OCzqTJJfD214s53uZrzYlu699vTH0N9n
         8HtFvllGcKxVsexcM3m+7RddVaNqEGctRWzJo1ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Dai <zdai@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0693/1126] powerpc/pseries: Fix use after free in remove_phb_dynamic()
Date:   Tue,  5 Apr 2022 09:24:00 +0200
Message-Id: <20220405070427.953152752@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit fe2640bd7a62f1f7c3f55fbda31084085075bc30 ]

In remove_phb_dynamic() we use &phb->io_resource, after we've called
device_unregister(&host_bridge->dev). But the unregister may have freed
phb, because pcibios_free_controller_deferred() is the release function
for the host_bridge.

If there are no outstanding references when we call device_unregister()
then phb will be freed out from under us.

This has gone mainly unnoticed, but with slub_debug and page_poison
enabled it can lead to a crash:

  PID: 7574   TASK: c0000000d492cb80  CPU: 13  COMMAND: "drmgr"
   #0 [c0000000e4f075a0] crash_kexec at c00000000027d7dc
   #1 [c0000000e4f075d0] oops_end at c000000000029608
   #2 [c0000000e4f07650] __bad_page_fault at c0000000000904b4
   #3 [c0000000e4f076c0] do_bad_slb_fault at c00000000009a5a8
   #4 [c0000000e4f076f0] data_access_slb_common_virt at c000000000008b30
   Data SLB Access [380] exception frame:
   R0:  c000000000167250    R1:  c0000000e4f07a00    R2:  c000000002a46100
   R3:  c000000002b39ce8    R4:  00000000000000c0    R5:  00000000000000a9
   R6:  3894674d000000c0    R7:  0000000000000000    R8:  00000000000000ff
   R9:  0000000000000100    R10: 6b6b6b6b6b6b6b6b    R11: 0000000000008000
   R12: c00000000023da80    R13: c0000009ffd38b00    R14: 0000000000000000
   R15: 000000011c87f0f0    R16: 0000000000000006    R17: 0000000000000003
   R18: 0000000000000002    R19: 0000000000000004    R20: 0000000000000005
   R21: 000000011c87ede8    R22: 000000011c87c5a8    R23: 000000011c87d3a0
   R24: 0000000000000000    R25: 0000000000000001    R26: c0000000e4f07cc8
   R27: c00000004d1cc400    R28: c0080000031d00e8    R29: c00000004d23d800
   R30: c00000004d1d2400    R31: c00000004d1d2540
   NIP: c000000000167258    MSR: 8000000000009033    OR3: c000000000e9f474
   CTR: 0000000000000000    LR:  c000000000167250    XER: 0000000020040003
   CCR: 0000000024088420    MQ:  0000000000000000    DAR: 6b6b6b6b6b6b6ba3
   DSISR: c0000000e4f07920     Syscall Result: fffffffffffffff2
   [NIP  : release_resource+56]
   [LR   : release_resource+48]
   #5 [c0000000e4f07a00] release_resource at c000000000167258  (unreliable)
   #6 [c0000000e4f07a30] remove_phb_dynamic at c000000000105648
   #7 [c0000000e4f07ab0] dlpar_remove_slot at c0080000031a09e8 [rpadlpar_io]
   #8 [c0000000e4f07b50] remove_slot_store at c0080000031a0b9c [rpadlpar_io]
   #9 [c0000000e4f07be0] kobj_attr_store at c000000000817d8c
  #10 [c0000000e4f07c00] sysfs_kf_write at c00000000063e504
  #11 [c0000000e4f07c20] kernfs_fop_write_iter at c00000000063d868
  #12 [c0000000e4f07c70] new_sync_write at c00000000054339c
  #13 [c0000000e4f07d10] vfs_write at c000000000546624
  #14 [c0000000e4f07d60] ksys_write at c0000000005469f4
  #15 [c0000000e4f07db0] system_call_exception at c000000000030840
  #16 [c0000000e4f07e10] system_call_vectored_common at c00000000000c168

To avoid it, we can take a reference to the host_bridge->dev until we're
done using phb. Then when we drop the reference the phb will be freed.

Fixes: 2dd9c11b9d4d ("powerpc/pseries: use pci_host_bridge.release_fn() to kfree(phb)")
Reported-by: David Dai <zdai@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Link: https://lore.kernel.org/r/20220318034219.1188008-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/pci_dlpar.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index 90c9d3531694..4ba824568119 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -78,6 +78,9 @@ int remove_phb_dynamic(struct pci_controller *phb)
 
 	pseries_msi_free_domains(phb);
 
+	/* Keep a reference so phb isn't freed yet */
+	get_device(&host_bridge->dev);
+
 	/* Remove the PCI bus and unregister the bridge device from sysfs */
 	phb->bus = NULL;
 	pci_remove_bus(b);
@@ -101,6 +104,7 @@ int remove_phb_dynamic(struct pci_controller *phb)
 	 * the pcibios_free_controller_deferred() callback;
 	 * see pseries_root_bridge_prepare().
 	 */
+	put_device(&host_bridge->dev);
 
 	return 0;
 }
-- 
2.34.1



