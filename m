Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19643EC908
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 14:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhHOMha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 08:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhHOMha (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 08:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDA9761103;
        Sun, 15 Aug 2021 12:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629031020;
        bh=MC7pG3NEFgo08yHCdGFUtEqfLIavmxg5Mt3gsmZwF+k=;
        h=Subject:To:Cc:From:Date:From;
        b=J8gbSrAewv3jiPBLyyz8+oOrlF6VY8A6KElC9x/YamLxVbrQY4JjiCHunRh+0fD5Y
         CXgjoZsCLlfWBwaBa/XXg3kmGUCs8wyaqOETAJ5yCNKz9+47FgnSjpdIrI37aNUhkF
         qhlDY8srgQoMpoH1TnUhXpphjrXU9v5ABobYu1z0=
Subject: FAILED: patch "[PATCH] scsi: lpfc: Move initialization of phba->poll_list earlier to" failed to apply to 5.4-stable tree
To:     emilne@redhat.com, jsmart2021@gmail.com, martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Aug 2021 14:36:57 +0200
Message-ID: <162903101716872@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9977d880f7a3c233db9165a75a3a14defc2a4aee Mon Sep 17 00:00:00 2001
From: "Ewan D. Milne" <emilne@redhat.com>
Date: Mon, 9 Aug 2021 11:09:47 -0400
Subject: [PATCH] scsi: lpfc: Move initialization of phba->poll_list earlier to
 avoid crash

The phba->poll_list is traversed in case of an error in
lpfc_sli4_hba_setup(), so it must be initialized earlier in case the error
path is taken.

[  490.030738] lpfc 0000:65:00.0: 0:1413 Failed to init iocb list.
[  490.036661] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[  490.044485] PGD 0 P4D 0
[  490.047027] Oops: 0000 [#1] SMP PTI
[  490.050518] CPU: 0 PID: 7 Comm: kworker/0:1 Kdump: loaded Tainted: G          I      --------- -  - 4.18.
[  490.060511] Hardware name: Dell Inc. PowerEdge R440/0WKGTH, BIOS 1.4.8 05/22/2018
[  490.067994] Workqueue: events work_for_cpu_fn
[  490.072371] RIP: 0010:lpfc_sli4_cleanup_poll_list+0x20/0xb0 [lpfc]
[  490.078546] Code: cf e9 04 f7 fe ff 0f 1f 40 00 0f 1f 44 00 00 41 57 49 89 ff 41 56 41 55 41 54 4d 8d a79
[  490.097291] RSP: 0018:ffffbd1a463dbcc8 EFLAGS: 00010246
[  490.102518] RAX: 0000000000008200 RBX: ffff945cdb8c0000 RCX: 0000000000000000
[  490.109649] RDX: 0000000000018200 RSI: ffff9468d0e16818 RDI: 0000000000000000
[  490.116783] RBP: ffff945cdb8c1740 R08: 00000000000015c5 R09: 0000000000000042
[  490.123915] R10: 0000000000000000 R11: ffffbd1a463dbab0 R12: ffff945cdb8c25c0
[  490.131049] R13: 00000000fffffff4 R14: 0000000000001800 R15: ffff945cdb8c0000
[  490.138182] FS:  0000000000000000(0000) GS:ffff9468d0e00000(0000) knlGS:0000000000000000
[  490.146267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  490.152013] CR2: 0000000000000000 CR3: 000000042ca10002 CR4: 00000000007706f0
[  490.159146] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  490.166277] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  490.173409] PKRU: 55555554
[  490.176123] Call Trace:
[  490.178598]  lpfc_sli4_queue_destroy+0x7f/0x3c0 [lpfc]
[  490.183745]  lpfc_sli4_hba_setup+0x1bc7/0x23e0 [lpfc]
[  490.188797]  ? kernfs_activate+0x63/0x80
[  490.192721]  ? kernfs_add_one+0xe7/0x130
[  490.196647]  ? __kernfs_create_file+0x80/0xb0
[  490.201020]  ? lpfc_pci_probe_one_s4.isra.48+0x46f/0x9e0 [lpfc]
[  490.206944]  lpfc_pci_probe_one_s4.isra.48+0x46f/0x9e0 [lpfc]
[  490.212697]  lpfc_pci_probe_one+0x179/0xb70 [lpfc]
[  490.217492]  local_pci_probe+0x41/0x90
[  490.221246]  work_for_cpu_fn+0x16/0x20
[  490.224994]  process_one_work+0x1a7/0x360
[  490.229009]  ? create_worker+0x1a0/0x1a0
[  490.232933]  worker_thread+0x1cf/0x390
[  490.236687]  ? create_worker+0x1a0/0x1a0
[  490.240612]  kthread+0x116/0x130
[  490.243846]  ? kthread_flush_work_fn+0x10/0x10
[  490.248293]  ret_from_fork+0x35/0x40
[  490.251869] Modules linked in: lpfc(+) xt_CHECKSUM ipt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4i
[  490.332609] CR2: 0000000000000000

Link: https://lore.kernel.org/r/20210809150947.18104-1-emilne@redhat.com
Fixes: 93a4d6f40198 ("scsi: lpfc: Add registration for CPU Offline/Online events")
Cc: stable@vger.kernel.org
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5983e05b648f..e29523a1b530 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13193,6 +13193,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	if (!phba)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&phba->poll_list);
+
 	/* Perform generic PCI device enabling operation */
 	error = lpfc_enable_pci_dev(phba);
 	if (error)
@@ -13327,7 +13329,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	/* Enable RAS FW log support */
 	lpfc_sli4_ras_setup(phba);
 
-	INIT_LIST_HEAD(&phba->poll_list);
 	timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
 	cpuhp_state_add_instance_nocalls(lpfc_cpuhp_state, &phba->cpuhp);
 

