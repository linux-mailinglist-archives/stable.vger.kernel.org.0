Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58414383146
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239709AbhEQOgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240120AbhEQOdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:33:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9622A6191E;
        Mon, 17 May 2021 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260979;
        bh=BpCL0viZhH9bxMtROzboNIzeeXlkGKzr0IWjnlfVBC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4+LCHxNXdJtbTXIiPpICzRba2gj3Mc4TRF8o1faKB7CYlxvPBDLeTWyVHoj5KsWv
         emthmxL6HwofNfq6tPwAjDLbbA4GRu8KGeEEe4aWEWNhl2X3tTiuk7iUNI2INmcX69
         G+Z5M4IdSnbYlBX9/qvw8h7io6K6BcV1Y156DLZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 021/329] fs: dlm: add shutdown hook
Date:   Mon, 17 May 2021 15:58:52 +0200
Message-Id: <20210517140302.779951716@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 9d232469bcd772dbedb9e75a165c681b920524ee ]

This patch fixes issues which occurs when dlm lowcomms synchronize their
workqueues but dlm application layer already released the lockspace. In
such cases messages like:

dlm: gfs2: release_lockspace final free
dlm: invalid lockspace 3841231384 from 1 cmd 1 type 11

are printed on the kernel log. This patch is solving this issue by
introducing a new "shutdown" hook before calling "stop" hook when the
lockspace is going to be released finally. This should pretend any
dlm messages sitting in the workqueues during or after lockspace
removal.

It's necessary to call dlm_scand_stop() as I instrumented
dlm_lowcomms_get_buffer() code to report a warning after it's called after
dlm_midcomms_shutdown() functionality, see below:

WARNING: CPU: 1 PID: 3794 at fs/dlm/midcomms.c:1003 dlm_midcomms_get_buffer+0x167/0x180
Modules linked in: joydev iTCO_wdt intel_pmc_bxt iTCO_vendor_support drm_ttm_helper ttm pcspkr serio_raw i2c_i801 i2c_smbus drm_kms_helper virtio_scsi lpc_ich virtio_balloon virtio_console xhci_pci xhci_pci_renesas cec qemu_fw_cfg drm [last unloaded: qxl]
CPU: 1 PID: 3794 Comm: dlm_scand Tainted: G        W         5.11.0+ #26
Hardware name: Red Hat KVM/RHEL-AV, BIOS 1.13.0-2.module+el8.3.0+7353+9de0a3cc 04/01/2014
RIP: 0010:dlm_midcomms_get_buffer+0x167/0x180
Code: 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b 45 31 e4 5b 5d 4c 89 e0 41 5c 41 5d 41 5e 41 5f c3 4c 89 e7 45 31 e4 e8 3b f1 ec ff eb 86 <0f> 0b 4c 89 e7 45 31 e4 e8 2c f1 ec ff e9 74 ff ff ff 0f 1f 80 00
RSP: 0018:ffffa81503f8fe60 EFLAGS: 00010202
RAX: 0000000000000008 RBX: ffff8f969827f200 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffffad1e89a0 RDI: ffff8f96a5294160
RBP: 0000000000000001 R08: 0000000000000000 R09: ffff8f96a250bc60
R10: 00000000000045d3 R11: 0000000000000000 R12: ffff8f96a250bc60
R13: ffffa81503f8fec8 R14: 0000000000000070 R15: 0000000000000c40
FS:  0000000000000000(0000) GS:ffff8f96fbc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055aa3351c000 CR3: 000000010bf22000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 dlm_scan_rsbs+0x420/0x670
 ? dlm_uevent+0x20/0x20
 dlm_scand+0xbf/0xe0
 kthread+0x13a/0x150
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30

To synchronize all dlm scand messages we stop it right before shutdown
hook.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 20 +++++++++++---------
 fs/dlm/lowcomms.c  | 42 +++++++++++++++++++++++-------------------
 fs/dlm/lowcomms.h  |  1 +
 3 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 561dcad08ad6..c14cf2b7faab 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -404,12 +404,6 @@ static int threads_start(void)
 	return error;
 }
 
-static void threads_stop(void)
-{
-	dlm_scand_stop();
-	dlm_lowcomms_stop();
-}
-
 static int new_lockspace(const char *name, const char *cluster,
 			 uint32_t flags, int lvblen,
 			 const struct dlm_lockspace_ops *ops, void *ops_arg,
@@ -702,8 +696,11 @@ int dlm_new_lockspace(const char *name, const char *cluster,
 		ls_count++;
 	if (error > 0)
 		error = 0;
-	if (!ls_count)
-		threads_stop();
+	if (!ls_count) {
+		dlm_scand_stop();
+		dlm_lowcomms_shutdown();
+		dlm_lowcomms_stop();
+	}
  out:
 	mutex_unlock(&ls_lock);
 	return error;
@@ -788,6 +785,11 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_recoverd_stop(ls);
 
+	if (ls_count == 1) {
+		dlm_scand_stop();
+		dlm_lowcomms_shutdown();
+	}
+
 	dlm_callback_stop(ls);
 
 	remove_lockspace(ls);
@@ -880,7 +882,7 @@ int dlm_release_lockspace(void *lockspace, int force)
 	if (!error)
 		ls_count--;
 	if (!ls_count)
-		threads_stop();
+		dlm_lowcomms_stop();
 	mutex_unlock(&ls_lock);
 
 	return error;
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 5fe571e44b1a..45c2fdaf34c4 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1608,6 +1608,29 @@ static int work_start(void)
 	return 0;
 }
 
+static void shutdown_conn(struct connection *con)
+{
+	if (con->shutdown_action)
+		con->shutdown_action(con);
+}
+
+void dlm_lowcomms_shutdown(void)
+{
+	/* Set all the flags to prevent any
+	 * socket activity.
+	 */
+	dlm_allow_conn = 0;
+
+	if (recv_workqueue)
+		flush_workqueue(recv_workqueue);
+	if (send_workqueue)
+		flush_workqueue(send_workqueue);
+
+	dlm_close_sock(&listen_con.sock);
+
+	foreach_conn(shutdown_conn);
+}
+
 static void _stop_conn(struct connection *con, bool and_other)
 {
 	mutex_lock(&con->sock_mutex);
@@ -1629,12 +1652,6 @@ static void stop_conn(struct connection *con)
 	_stop_conn(con, true);
 }
 
-static void shutdown_conn(struct connection *con)
-{
-	if (con->shutdown_action)
-		con->shutdown_action(con);
-}
-
 static void connection_release(struct rcu_head *rcu)
 {
 	struct connection *con = container_of(rcu, struct connection, rcu);
@@ -1691,19 +1708,6 @@ static void work_flush(void)
 
 void dlm_lowcomms_stop(void)
 {
-	/* Set all the flags to prevent any
-	   socket activity.
-	*/
-	dlm_allow_conn = 0;
-
-	if (recv_workqueue)
-		flush_workqueue(recv_workqueue);
-	if (send_workqueue)
-		flush_workqueue(send_workqueue);
-
-	dlm_close_sock(&listen_con.sock);
-
-	foreach_conn(shutdown_conn);
 	work_flush();
 	foreach_conn(free_conn);
 	work_stop();
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index bcd4dbd1dc98..48bbc4e18761 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -18,6 +18,7 @@
 extern int dlm_allow_conn;
 
 int dlm_lowcomms_start(void);
+void dlm_lowcomms_shutdown(void);
 void dlm_lowcomms_stop(void);
 void dlm_lowcomms_exit(void);
 int dlm_lowcomms_close(int nodeid);
-- 
2.30.2



