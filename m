Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC1E3E485C
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 17:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhHIPKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 11:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235284AbhHIPKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 11:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628521790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Cz/OjkiJV+Jis1cff9B5JIt1Qzucd6eUIIOwKG7RT8I=;
        b=Rhy986clx5wbfE14L3Sg8g78kJ0wa1Rp62uFTMLt0k3ozsvXNIKoLSY4oEXWd84jvdVDTQ
        zScKXVIRErrYTw2Rir0Ycw/PdpxsjnavRWddGY4LL5PtV1XUW6UO2goAiNl8oGoQo8xwkK
        DFPTIqIkNoWE+Hw0i3NUWwPw+LgSXLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601--QQiEgCzNH2lywXpR6CrOg-1; Mon, 09 Aug 2021 11:09:49 -0400
X-MC-Unique: -QQiEgCzNH2lywXpR6CrOg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 559561853025;
        Mon,  9 Aug 2021 15:09:48 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA5F05DA60;
        Mon,  9 Aug 2021 15:09:47 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     stable@vger.kernel.org, james.smart@broadcom.com,
        dick.kennedy@broadcom.com
Subject: [PATCH] lpfc: move initialization of phba->poll_list earlier to avoid crash
Date:   Mon,  9 Aug 2021 11:09:47 -0400
Message-Id: <20210809150947.18104-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The phba->poll_list is traversed in case of an error in lpfc_sli4_hba_setup(),
so it must be initialized earlier in case the error path is taken.

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

Fixes: 93a4d6f40198 ("scsi: lpfc: Add registration for CPU Offline/Online events")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
 
-- 
2.20.1

