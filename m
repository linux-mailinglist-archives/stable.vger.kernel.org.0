Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A43211AF73
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731452AbfLKPNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731446AbfLKPNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 518DE24671;
        Wed, 11 Dec 2019 15:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077214;
        bh=MzlIvXr9+RGOexb48ThAFvhkwgmA9P8oKt1C0+tnpHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUFnv4ZkqTJ6rnFuPsFNolLSDbjwb2Q4MYf+KB7kquYNo9siCjAx5tlCtJnUg9AGZ
         LNabxGIyNr0yGijgUkvPPlHZGWuW7XFeg7HJHDoois4hftzoAJ241heoLwbikIokid
         D4mohKGAl4j4JlZWn3PI6+LlFBpAguu9GKPyd+Sw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <mchristi@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 5.4 095/134] scsi: target: core: Release SPC-2 reservations when closing a session
Date:   Wed, 11 Dec 2019 10:11:11 -0500
Message-Id: <20191211151150.19073-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 80647a89eaf3f2549741648f3230cd6ff68c23b4 ]

The SCSI specs require releasing SPC-2 reservations when a session is
closed. Make sure that the target core does this.

Running the libiscsi tests triggers the KASAN complaint shown below.  This
patch fixes that use-after-free.

BUG: KASAN: use-after-free in target_check_reservation+0x171/0x980 [target_core_mod]
Read of size 8 at addr ffff88802ecd1878 by task iscsi_trx/17200

CPU: 0 PID: 17200 Comm: iscsi_trx Not tainted 5.4.0-rc1-dbg+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0x8a/0xd6
 print_address_description.constprop.0+0x40/0x60
 __kasan_report.cold+0x1b/0x34
 kasan_report+0x16/0x20
 __asan_load8+0x58/0x90
 target_check_reservation+0x171/0x980 [target_core_mod]
 __target_execute_cmd+0xb1/0xf0 [target_core_mod]
 target_execute_cmd+0x22d/0x4d0 [target_core_mod]
 transport_generic_new_cmd+0x31f/0x5b0 [target_core_mod]
 transport_handle_cdb_direct+0x6f/0x90 [target_core_mod]
 iscsit_execute_cmd+0x381/0x3f0 [iscsi_target_mod]
 iscsit_sequence_cmd+0x13b/0x1f0 [iscsi_target_mod]
 iscsit_process_scsi_cmd+0x4c/0x130 [iscsi_target_mod]
 iscsit_get_rx_pdu+0x8e8/0x15f0 [iscsi_target_mod]
 iscsi_target_rx_thread+0x105/0x1b0 [iscsi_target_mod]
 kthread+0x1bc/0x210
 ret_from_fork+0x24/0x30

Allocated by task 1079:
 save_stack+0x23/0x90
 __kasan_kmalloc.constprop.0+0xcf/0xe0
 kasan_slab_alloc+0x12/0x20
 kmem_cache_alloc+0xfe/0x3a0
 transport_alloc_session+0x29/0x80 [target_core_mod]
 iscsi_target_login_thread+0xceb/0x1920 [iscsi_target_mod]
 kthread+0x1bc/0x210
 ret_from_fork+0x24/0x30

Freed by task 17193:
 save_stack+0x23/0x90
 __kasan_slab_free+0x13a/0x190
 kasan_slab_free+0x12/0x20
 kmem_cache_free+0xc8/0x3e0
 transport_free_session+0x179/0x2f0 [target_core_mod]
 transport_deregister_session+0x121/0x170 [target_core_mod]
 iscsit_close_session+0x12c/0x350 [iscsi_target_mod]
 iscsit_logout_post_handler+0x136/0x380 [iscsi_target_mod]
 iscsit_response_queue+0x8fa/0xc00 [iscsi_target_mod]
 iscsi_target_tx_thread+0x28e/0x390 [iscsi_target_mod]
 kthread+0x1bc/0x210
 ret_from_fork+0x24/0x30

The buggy address belongs to the object at ffff88802ecd1860
 which belongs to the cache se_sess_cache of size 352
The buggy address is located 24 bytes inside of
 352-byte region [ffff88802ecd1860, ffff88802ecd19c0)
The buggy address belongs to the page:
page:ffffea0000bb3400 refcount:1 mapcount:0 mapping:ffff8880bef2ed00 index:0x0 compound_mapcount: 0
flags: 0x1000000000010200(slab|head)
raw: 1000000000010200 dead000000000100 dead000000000122 ffff8880bef2ed00
raw: 0000000000000000 0000000080270027 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88802ecd1700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802ecd1780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802ecd1800: fb fb fb fb fc fc fc fc fc fc fc fc fb fb fb fb
                                                                ^
 ffff88802ecd1880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802ecd1900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Cc: Mike Christie <mchristi@redhat.com>
Link: https://lore.kernel.org/r/20191113220508.198257-2-bvanassche@acm.org
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7f06a62f8661d..eda8b4736c158 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -584,6 +584,15 @@ void transport_free_session(struct se_session *se_sess)
 }
 EXPORT_SYMBOL(transport_free_session);
 
+static int target_release_res(struct se_device *dev, void *data)
+{
+	struct se_session *sess = data;
+
+	if (dev->reservation_holder == sess)
+		target_release_reservation(dev);
+	return 0;
+}
+
 void transport_deregister_session(struct se_session *se_sess)
 {
 	struct se_portal_group *se_tpg = se_sess->se_tpg;
@@ -600,6 +609,12 @@ void transport_deregister_session(struct se_session *se_sess)
 	se_sess->fabric_sess_ptr = NULL;
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 
+	/*
+	 * Since the session is being removed, release SPC-2
+	 * reservations held by the session that is disappearing.
+	 */
+	target_for_each_device(target_release_res, se_sess);
+
 	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
 		se_tpg->se_tpg_tfo->fabric_name);
 	/*
-- 
2.20.1

