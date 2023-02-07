Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF3868D8D3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjBGNN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjBGNNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:13:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6803CE24
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4559E61446
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B18DC433EF;
        Tue,  7 Feb 2023 13:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775480;
        bh=JfgcveZ4sA38yA9qOwt1LcPbq8cTaMUv8rnMV1T5eKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+40YM9qDRR4EeJB0JVXD/CAnF8FTOG7I3U3ey3p976WzQytBbD+fUADYSMjzOrxL
         CdvkADV4vpk0wJdClfc7OVoDsqSX2Zt7AXVdDWgiys1e07xUjGZ+8VMe5lj23tMAMe
         GGRLMDyNPlDmKWZ6sq0ABY2YXpXJVWmFwdhheQ08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        Ding Hui <dinghui@sangfor.com.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/120] scsi: iscsi_tcp: Fix UAF during logout when accessing the shost ipaddress
Date:   Tue,  7 Feb 2023 13:57:06 +0100
Message-Id: <20230207125621.108647673@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 6f1d64b13097e85abda0f91b5638000afc5f9a06 ]

Bug report and analysis from Ding Hui.

During iSCSI session logout, if another task accesses the shost ipaddress
attr, we can get a KASAN UAF report like this:

[  276.942144] BUG: KASAN: use-after-free in _raw_spin_lock_bh+0x78/0xe0
[  276.942535] Write of size 4 at addr ffff8881053b45b8 by task cat/4088
[  276.943511] CPU: 2 PID: 4088 Comm: cat Tainted: G            E      6.1.0-rc8+ #3
[  276.943997] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
[  276.944470] Call Trace:
[  276.944943]  <TASK>
[  276.945397]  dump_stack_lvl+0x34/0x48
[  276.945887]  print_address_description.constprop.0+0x86/0x1e7
[  276.946421]  print_report+0x36/0x4f
[  276.947358]  kasan_report+0xad/0x130
[  276.948234]  kasan_check_range+0x35/0x1c0
[  276.948674]  _raw_spin_lock_bh+0x78/0xe0
[  276.949989]  iscsi_sw_tcp_host_get_param+0xad/0x2e0 [iscsi_tcp]
[  276.951765]  show_host_param_ISCSI_HOST_PARAM_IPADDRESS+0xe9/0x130 [scsi_transport_iscsi]
[  276.952185]  dev_attr_show+0x3f/0x80
[  276.953005]  sysfs_kf_seq_show+0x1fb/0x3e0
[  276.953401]  seq_read_iter+0x402/0x1020
[  276.954260]  vfs_read+0x532/0x7b0
[  276.955113]  ksys_read+0xed/0x1c0
[  276.955952]  do_syscall_64+0x38/0x90
[  276.956347]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  276.956769] RIP: 0033:0x7f5d3a679222
[  276.957161] Code: c0 e9 b2 fe ff ff 50 48 8d 3d 32 c0 0b 00 e8 a5 fe 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[  276.958009] RSP: 002b:00007ffc864d16a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  276.958431] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f5d3a679222
[  276.958857] RDX: 0000000000020000 RSI: 00007f5d3a4fe000 RDI: 0000000000000003
[  276.959281] RBP: 00007f5d3a4fe000 R08: 00000000ffffffff R09: 0000000000000000
[  276.959682] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000020000
[  276.960126] R13: 0000000000000003 R14: 0000000000000000 R15: 0000557a26dada58
[  276.960536]  </TASK>
[  276.961357] Allocated by task 2209:
[  276.961756]  kasan_save_stack+0x1e/0x40
[  276.962170]  kasan_set_track+0x21/0x30
[  276.962557]  __kasan_kmalloc+0x7e/0x90
[  276.962923]  __kmalloc+0x5b/0x140
[  276.963308]  iscsi_alloc_session+0x28/0x840 [scsi_transport_iscsi]
[  276.963712]  iscsi_session_setup+0xda/0xba0 [libiscsi]
[  276.964078]  iscsi_sw_tcp_session_create+0x1fd/0x330 [iscsi_tcp]
[  276.964431]  iscsi_if_create_session.isra.0+0x50/0x260 [scsi_transport_iscsi]
[  276.964793]  iscsi_if_recv_msg+0xc5a/0x2660 [scsi_transport_iscsi]
[  276.965153]  iscsi_if_rx+0x198/0x4b0 [scsi_transport_iscsi]
[  276.965546]  netlink_unicast+0x4d5/0x7b0
[  276.965905]  netlink_sendmsg+0x78d/0xc30
[  276.966236]  sock_sendmsg+0xe5/0x120
[  276.966576]  ____sys_sendmsg+0x5fe/0x860
[  276.966923]  ___sys_sendmsg+0xe0/0x170
[  276.967300]  __sys_sendmsg+0xc8/0x170
[  276.967666]  do_syscall_64+0x38/0x90
[  276.968028]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  276.968773] Freed by task 2209:
[  276.969111]  kasan_save_stack+0x1e/0x40
[  276.969449]  kasan_set_track+0x21/0x30
[  276.969789]  kasan_save_free_info+0x2a/0x50
[  276.970146]  __kasan_slab_free+0x106/0x190
[  276.970470]  __kmem_cache_free+0x133/0x270
[  276.970816]  device_release+0x98/0x210
[  276.971145]  kobject_cleanup+0x101/0x360
[  276.971462]  iscsi_session_teardown+0x3fb/0x530 [libiscsi]
[  276.971775]  iscsi_sw_tcp_session_destroy+0xd8/0x130 [iscsi_tcp]
[  276.972143]  iscsi_if_recv_msg+0x1bf1/0x2660 [scsi_transport_iscsi]
[  276.972485]  iscsi_if_rx+0x198/0x4b0 [scsi_transport_iscsi]
[  276.972808]  netlink_unicast+0x4d5/0x7b0
[  276.973201]  netlink_sendmsg+0x78d/0xc30
[  276.973544]  sock_sendmsg+0xe5/0x120
[  276.973864]  ____sys_sendmsg+0x5fe/0x860
[  276.974248]  ___sys_sendmsg+0xe0/0x170
[  276.974583]  __sys_sendmsg+0xc8/0x170
[  276.974891]  do_syscall_64+0x38/0x90
[  276.975216]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

We can easily reproduce by two tasks:
1. while :; do iscsiadm -m node --login; iscsiadm -m node --logout; done
2. while :; do cat \
/sys/devices/platform/host*/iscsi_host/host*/ipaddress; done

            iscsid              |        cat
--------------------------------+---------------------------------------
|- iscsi_sw_tcp_session_destroy |
  |- iscsi_session_teardown     |
    |- device_release           |
      |- iscsi_session_release  ||- dev_attr_show
        |- kfree                |  |- show_host_param_
                                |             ISCSI_HOST_PARAM_IPADDRESS
                                |    |- iscsi_sw_tcp_host_get_param
                                |      |- r/w tcp_sw_host->session (UAF)
  |- iscsi_host_remove          |
  |- iscsi_host_free            |

Fix the above bug by splitting the session removal into 2 parts:

 1. removal from iSCSI class which includes sysfs and removal from host
    tracking.

 2. freeing of session.

During iscsi_tcp host and session removal we can remove the session from
sysfs then remove the host from sysfs. At this point we know userspace is
not accessing the kernel via sysfs so we can free the session and host.

Link: https://lore.kernel.org/r/20230117193937.21244-2-michael.christie@oracle.com
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Acked-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_tcp.c | 11 +++++++++--
 drivers/scsi/libiscsi.c  | 38 +++++++++++++++++++++++++++++++-------
 include/scsi/libiscsi.h  |  2 ++
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4d2f33087806..5c19e75c0e2f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -982,10 +982,17 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	if (WARN_ON_ONCE(session->leadconn))
 		return;
 
+	iscsi_session_remove(cls_session);
+	/*
+	 * Our get_host_param needs to access the session, so remove the
+	 * host from sysfs before freeing the session to make sure userspace
+	 * is no longer accessing the callout.
+	 */
+	iscsi_host_remove(shost, false);
+
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
-	iscsi_session_teardown(cls_session);
 
-	iscsi_host_remove(shost, false);
+	iscsi_session_free(cls_session);
 	iscsi_host_free(shost);
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 73d235540b98..d422e8fd7137 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3024,17 +3024,32 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_setup);
 
-/**
- * iscsi_session_teardown - destroy session, host, and cls_session
- * @cls_session: iscsi session
+/*
+ * issi_session_remove - Remove session from iSCSI class.
  */
-void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+void iscsi_session_remove(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = cls_session->dd_data;
-	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
 	iscsi_remove_session(cls_session);
+	/*
+	 * host removal only has to wait for its children to be removed from
+	 * sysfs, and iscsi_tcp needs to do iscsi_host_remove before freeing
+	 * the session, so drop the session count here.
+	 */
+	iscsi_host_dec_session_cnt(shost);
+}
+EXPORT_SYMBOL_GPL(iscsi_session_remove);
+
+/**
+ * iscsi_session_free - Free iscsi session and it's resources
+ * @cls_session: iscsi session
+ */
+void iscsi_session_free(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *session = cls_session->dd_data;
+	struct module *owner = cls_session->transport->owner;
 
 	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
@@ -3052,10 +3067,19 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->discovery_parent_type);
 
 	iscsi_free_session(cls_session);
-
-	iscsi_host_dec_session_cnt(shost);
 	module_put(owner);
 }
+EXPORT_SYMBOL_GPL(iscsi_session_free);
+
+/**
+ * iscsi_session_teardown - destroy session and cls_session
+ * @cls_session: iscsi session
+ */
+void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+{
+	iscsi_session_remove(cls_session);
+	iscsi_session_free(cls_session);
+}
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 
 /**
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 5cf84228b51d..c7ee5279e7fc 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -414,6 +414,8 @@ extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
 		    uint16_t, int, int, uint32_t, unsigned int);
+void iscsi_session_remove(struct iscsi_cls_session *cls_session);
+void iscsi_session_free(struct iscsi_cls_session *cls_session);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
-- 
2.39.0



