Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF9611B2DF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388553AbfLKPjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:39:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388479AbfLKPir (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2222C24671;
        Wed, 11 Dec 2019 15:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078725;
        bh=VoCUi5nlKQkaTtyr2nE+itJl04Cr4IH8KXcomS6Dj0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAjCLQeTOS8k1rYCjHmInBztwA8N/gZW+s3NGxMABCrgwSBW+YAjKutx7/7B1aMv5
         aOeDs7vrvWtONl4ED2Khb/wV72NUCND4cSorVN+YO+WPypctjESJAoJY+EzzyHMXZN
         fniE8d2ABp0AkT6h7RfpuNKZwRahgVM5AGn8QaBk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <mchristi@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, open-iscsi@googlegroups.com
Subject: [PATCH AUTOSEL 4.4 29/37] scsi: target: iscsi: Wait for all commands to finish before freeing a session
Date:   Wed, 11 Dec 2019 10:38:05 -0500
Message-Id: <20191211153813.24126-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e9d3009cb936bd0faf0719f68d98ad8afb1e613b ]

The iSCSI target driver is the only target driver that does not wait for
ongoing commands to finish before freeing a session. Make the iSCSI target
driver wait for ongoing commands to finish before freeing a session. This
patch fixes the following KASAN complaint:

BUG: KASAN: use-after-free in __lock_acquire+0xb1a/0x2710
Read of size 8 at addr ffff8881154eca70 by task kworker/0:2/247

CPU: 0 PID: 247 Comm: kworker/0:2 Not tainted 5.4.0-rc1-dbg+ #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Workqueue: target_completion target_complete_ok_work [target_core_mod]
Call Trace:
 dump_stack+0x8a/0xd6
 print_address_description.constprop.0+0x40/0x60
 __kasan_report.cold+0x1b/0x33
 kasan_report+0x16/0x20
 __asan_load8+0x58/0x90
 __lock_acquire+0xb1a/0x2710
 lock_acquire+0xd3/0x200
 _raw_spin_lock_irqsave+0x43/0x60
 target_release_cmd_kref+0x162/0x7f0 [target_core_mod]
 target_put_sess_cmd+0x2e/0x40 [target_core_mod]
 lio_check_stop_free+0x12/0x20 [iscsi_target_mod]
 transport_cmd_check_stop_to_fabric+0xd8/0xe0 [target_core_mod]
 target_complete_ok_work+0x1b0/0x790 [target_core_mod]
 process_one_work+0x549/0xa40
 worker_thread+0x7a/0x5d0
 kthread+0x1bc/0x210
 ret_from_fork+0x24/0x30

Allocated by task 889:
 save_stack+0x23/0x90
 __kasan_kmalloc.constprop.0+0xcf/0xe0
 kasan_slab_alloc+0x12/0x20
 kmem_cache_alloc+0xf6/0x360
 transport_alloc_session+0x29/0x80 [target_core_mod]
 iscsi_target_login_thread+0xcd6/0x18f0 [iscsi_target_mod]
 kthread+0x1bc/0x210
 ret_from_fork+0x24/0x30

Freed by task 1025:
 save_stack+0x23/0x90
 __kasan_slab_free+0x13a/0x190
 kasan_slab_free+0x12/0x20
 kmem_cache_free+0x146/0x400
 transport_free_session+0x179/0x2f0 [target_core_mod]
 transport_deregister_session+0x130/0x180 [target_core_mod]
 iscsit_close_session+0x12c/0x350 [iscsi_target_mod]
 iscsit_logout_post_handler+0x136/0x380 [iscsi_target_mod]
 iscsit_response_queue+0x8de/0xbe0 [iscsi_target_mod]
 iscsi_target_tx_thread+0x27f/0x370 [iscsi_target_mod]
 kthread+0x1bc/0x210
 ret_from_fork+0x24/0x30

The buggy address belongs to the object at ffff8881154ec9c0
 which belongs to the cache se_sess_cache of size 352
The buggy address is located 176 bytes inside of
 352-byte region [ffff8881154ec9c0, ffff8881154ecb20)
The buggy address belongs to the page:
page:ffffea0004553b00 refcount:1 mapcount:0 mapping:ffff888101755400 index:0x0 compound_mapcount: 0
flags: 0x2fff000000010200(slab|head)
raw: 2fff000000010200 dead000000000100 dead000000000122 ffff888101755400
raw: 0000000000000000 0000000080130013 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881154ec900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881154ec980: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
>ffff8881154eca00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff8881154eca80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881154ecb00: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc

Cc: Mike Christie <mchristi@redhat.com>
Link: https://lore.kernel.org/r/20191113220508.198257-3-bvanassche@acm.org
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 10 ++++++++--
 include/scsi/iscsi_proto.h          |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index cbb4414edd71b..564828554ca02 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -993,7 +993,9 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
 		conn->cid);
 
-	target_get_sess_cmd(&cmd->se_cmd, true);
+	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
+		return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
 
 	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
 						     scsilun_to_int(&hdr->lun));
@@ -1804,7 +1806,9 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			      conn->sess->se_sess, 0, DMA_NONE,
 			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2);
 
-	target_get_sess_cmd(&cmd->se_cmd, true);
+	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
+		return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
 
 	/*
 	 * TASK_REASSIGN for ERL=2 / connection stays inside of
@@ -4390,6 +4394,8 @@ int iscsit_close_connection(
 	 * must wait until they have completed.
 	 */
 	iscsit_check_conn_usage_count(conn);
+	target_sess_cmd_list_set_waiting(sess->se_sess);
+	target_wait_for_sess_cmds(sess->se_sess);
 
 	if (conn->conn_rx_hash.tfm)
 		crypto_free_hash(conn->conn_rx_hash.tfm);
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index c1260d80ef30d..1a2ae0862e23a 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -638,6 +638,7 @@ struct iscsi_reject {
 #define ISCSI_REASON_BOOKMARK_INVALID	9
 #define ISCSI_REASON_BOOKMARK_NO_RESOURCES	10
 #define ISCSI_REASON_NEGOTIATION_RESET	11
+#define ISCSI_REASON_WAITING_FOR_LOGOUT	12
 
 /* Max. number of Key=Value pairs in a text message */
 #define MAX_KEY_VALUE_PAIRS	8192
-- 
2.20.1

