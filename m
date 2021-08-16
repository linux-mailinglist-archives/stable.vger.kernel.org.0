Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7E03ED50F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbhHPNHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236812AbhHPNG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76880632AD;
        Mon, 16 Aug 2021 13:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119152;
        bh=sO7VJKkzi1ZcUz4iMjz9Ira+jOxytXzpCa+AQvFXM/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDBwOEzlnYdqiBG4iJ9A5SvWLzx0NzYL7TgYGKx4QjF3FcegnJzEb/7/edshwQN0H
         7mSUa0dflsVbUoubwlUz9I86vAjJNXaz27O83JX9b2EGz8SUExmPgoG93NyUwL4gPb
         R9rg1xtKcwn0Tc05qz7DC+e6NeGS7RU9m1/GpgZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 12/96] scsi: lpfc: Move initialization of phba->poll_list earlier to avoid crash
Date:   Mon, 16 Aug 2021 15:01:22 +0200
Message-Id: <20210816125435.333947697@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ewan D. Milne <emilne@redhat.com>

commit 9977d880f7a3c233db9165a75a3a14defc2a4aee upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13080,6 +13080,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	if (!phba)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&phba->poll_list);
+
 	/* Perform generic PCI device enabling operation */
 	error = lpfc_enable_pci_dev(phba);
 	if (error)
@@ -13214,7 +13216,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	/* Enable RAS FW log support */
 	lpfc_sli4_ras_setup(phba);
 
-	INIT_LIST_HEAD(&phba->poll_list);
 	timer_setup(&phba->cpuhp_poll_timer, lpfc_sli4_poll_hbtimer, 0);
 	cpuhp_state_add_instance_nocalls(lpfc_cpuhp_state, &phba->cpuhp);
 


