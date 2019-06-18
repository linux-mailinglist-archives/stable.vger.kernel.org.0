Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1794A3F5
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbfFRO3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:29:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50522 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729465AbfFRO3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:29:07 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6e-0007nH-6j; Tue, 18 Jun 2019 15:29:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6d-0000HV-G3; Tue, 18 Jun 2019 15:29:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        "Sumit Saxena" <sumit.saxena@broadcom.com>
Date:   Tue, 18 Jun 2019 15:28:02 +0100
Message-ID: <lsq.1560868082.882723914@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 04/10] scsi: megaraid_sas: return error when create
 DMA pool failed
In-Reply-To: <lsq.1560868079.359853905@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.69-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Yan <yanaijie@huawei.com>

commit bcf3b67d16a4c8ffae0aa79de5853435e683945c upstream.

when create DMA pool for cmd frames failed, we should return -ENOMEM,
instead of 0.
In some case in:

    megasas_init_adapter_fusion()

    -->megasas_alloc_cmds()
       -->megasas_create_frame_pool
          create DMA pool failed,
        --> megasas_free_cmds() [1]

    -->megasas_alloc_cmds_fusion()
       failed, then goto fail_alloc_cmds.
    -->megasas_free_cmds() [2]

we will call megasas_free_cmds twice, [1] will kfree cmd_list,
[2] will use cmd_list.it will cause a problem:

Unable to handle kernel NULL pointer dereference at virtual address
00000000
pgd = ffffffc000f70000
[00000000] *pgd=0000001fbf893003, *pud=0000001fbf893003,
*pmd=0000001fbf894003, *pte=006000006d000707
Internal error: Oops: 96000005 [#1] SMP
 Modules linked in:
 CPU: 18 PID: 1 Comm: swapper/0 Not tainted
 task: ffffffdfb9290000 ti: ffffffdfb923c000 task.ti: ffffffdfb923c000
 PC is at megasas_free_cmds+0x30/0x70
 LR is at megasas_free_cmds+0x24/0x70
 ...
 Call trace:
 [<ffffffc0005b779c>] megasas_free_cmds+0x30/0x70
 [<ffffffc0005bca74>] megasas_init_adapter_fusion+0x2f4/0x4d8
 [<ffffffc0005b926c>] megasas_init_fw+0x2dc/0x760
 [<ffffffc0005b9ab0>] megasas_probe_one+0x3c0/0xcd8
 [<ffffffc0004a5abc>] local_pci_probe+0x4c/0xb4
 [<ffffffc0004a5c40>] pci_device_probe+0x11c/0x14c
 [<ffffffc00053a5e4>] driver_probe_device+0x1ec/0x430
 [<ffffffc00053a92c>] __driver_attach+0xa8/0xb0
 [<ffffffc000538178>] bus_for_each_dev+0x74/0xc8
  [<ffffffc000539e88>] driver_attach+0x28/0x34
 [<ffffffc000539a18>] bus_add_driver+0x16c/0x248
 [<ffffffc00053b234>] driver_register+0x6c/0x138
 [<ffffffc0004a5350>] __pci_register_driver+0x5c/0x6c
 [<ffffffc000ce3868>] megasas_init+0xc0/0x1a8
 [<ffffffc000082a58>] do_one_initcall+0xe8/0x1ec
 [<ffffffc000ca7be8>] kernel_init_freeable+0x1c8/0x284
 [<ffffffc0008d90b8>] kernel_init+0x1c/0xe4

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3489,6 +3489,7 @@ int megasas_alloc_cmds(struct megasas_in
 	if (megasas_create_frame_pool(instance)) {
 		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
 		megasas_free_cmds(instance);
+		return -ENOMEM;
 	}
 
 	return 0;

