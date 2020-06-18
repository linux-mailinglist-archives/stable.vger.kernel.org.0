Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B001FE6AD
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387711AbgFRCfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729301AbgFRBOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E0E21D90;
        Thu, 18 Jun 2020 01:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442855;
        bh=wNFOCtt8LTUNr49VedmNRx6nMehudw/n7D78NzTv1Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7yXqxZBIY56gx9y0hlHdf1NNHEzHiOhZlRbVpBRFpyPxf5WPLl+W3aomLZzSdliQ
         OiXKmNKmp7fNnxhdTkvi3rCKPv0y54tswo7a+L2gvl+F9UKZVkiyFeWrDcdII89+gU
         TtwWKLKqRF5RNPwqbtJTsFhX9YY0UPPNAuu537s0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 285/388] scsi: iscsi: Fix deadlock on recovery path during GFP_IO reclaim
Date:   Wed, 17 Jun 2020 21:06:22 -0400
Message-Id: <20200618010805.600873-285-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 7e7cd796f2776d055351d80328f45633bbb0aae5 ]

iSCSI suffers from a deadlock in case a management command submitted via
the netlink socket sleeps on an allocation while holding the rx_queue_mutex
if that allocation causes a memory reclaim that writebacks to a failed
iSCSI device.  The recovery procedure can never make progress to recover
the failed disk or abort outstanding IO operations to complete the reclaim
(since rx_queue_mutex is locked), thus locking the system.

Nevertheless, just marking all allocations under rx_queue_mutex as GFP_NOIO
(or locking the userspace process with something like PF_MEMALLOC_NOIO) is
not enough, since the iSCSI command code relies on other subsystems that
try to grab locked mutexes, whose threads are GFP_IO, leading to the same
deadlock. One instance where this situation can be observed is in the
backtraces below, stitched from multiple bugs reports, involving the kobj
uevent sent when a session is created.

The root of the problem is not the fact that iSCSI does GFP_IO allocations,
that is acceptable. The actual problem is that rx_queue_mutex has a very
large granularity, covering every unrelated netlink command execution at
the same time as the error recovery path.

The proposed fix leverages the recently added mechanism to stop failed
connections from the kernel, by enabling it to execute even though a
management command from the netlink socket is being run (rx_queue_mutex is
held), provided that the command is known to be safe.  It splits the
rx_queue_mutex in two mutexes, one protecting from concurrent command
execution from the netlink socket, and one protecting stop_conn from racing
with other connection management operations that might conflict with it.

It is not very pretty, but it is the simplest way to resolve the deadlock.
I considered making it a lock per connection, but some external mutex would
still be needed to deal with iscsi_if_destroy_conn.

The patch was tested by forcing a memory shrinker (unrelated, but used
bufio/dm-verity) to reclaim iSCSI pages every time
ISCSI_UEVENT_CREATE_SESSION happens, which is reasonable to simulate
reclaims that might happen with GFP_KERNEL on that path.  Then, a faulty
hung target causes a connection to fail during intensive IO, at the same
time a new session is added by iscsid.

The following stacktraces are stiches from several bug reports, showing a
case where the deadlock can happen.

 iSCSI-write
         holding: rx_queue_mutex
         waiting: uevent_sock_mutex

         kobject_uevent_env+0x1bd/0x419
         kobject_uevent+0xb/0xd
         device_add+0x48a/0x678
         scsi_add_host_with_dma+0xc5/0x22d
         iscsi_host_add+0x53/0x55
         iscsi_sw_tcp_session_create+0xa6/0x129
         iscsi_if_rx+0x100/0x1247
         netlink_unicast+0x213/0x4f0
         netlink_sendmsg+0x230/0x3c0

 iscsi_fail iscsi_conn_failure
         waiting: rx_queue_mutex

         schedule_preempt_disabled+0x325/0x734
         __mutex_lock_slowpath+0x18b/0x230
         mutex_lock+0x22/0x40
         iscsi_conn_failure+0x42/0x149
         worker_thread+0x24a/0xbc0

 EventManager_
         holding: uevent_sock_mutex
         waiting: dm_bufio_client->lock

         dm_bufio_lock+0xe/0x10
         shrink+0x34/0xf7
         shrink_slab+0x177/0x5d0
         do_try_to_free_pages+0x129/0x470
         try_to_free_mem_cgroup_pages+0x14f/0x210
         memcg_kmem_newpage_charge+0xa6d/0x13b0
         __alloc_pages_nodemask+0x4a3/0x1a70
         fallback_alloc+0x1b2/0x36c
         __kmalloc_node_track_caller+0xb9/0x10d0
         __alloc_skb+0x83/0x2f0
         kobject_uevent_env+0x26b/0x419
         dm_kobject_uevent+0x70/0x79
         dev_suspend+0x1a9/0x1e7
         ctl_ioctl+0x3e9/0x411
         dm_ctl_ioctl+0x13/0x17
         do_vfs_ioctl+0xb3/0x460
         SyS_ioctl+0x5e/0x90

 MemcgReclaimerD"
         holding: dm_bufio_client->lock
         waiting: stuck io to finish (needs iscsi_fail thread to progress)

         schedule at ffffffffbd603618
         io_schedule at ffffffffbd603ba4
         do_io_schedule at ffffffffbdaf0d94
         __wait_on_bit at ffffffffbd6008a6
         out_of_line_wait_on_bit at ffffffffbd600960
         wait_on_bit.constprop.10 at ffffffffbdaf0f17
         __make_buffer_clean at ffffffffbdaf18ba
         __cleanup_old_buffer at ffffffffbdaf192f
         shrink at ffffffffbdaf19fd
         do_shrink_slab at ffffffffbd6ec000
         shrink_slab at ffffffffbd6ec24a
         do_try_to_free_pages at ffffffffbd6eda09
         try_to_free_mem_cgroup_pages at ffffffffbd6ede7e
         mem_cgroup_resize_limit at ffffffffbd7024c0
         mem_cgroup_write at ffffffffbd703149
         cgroup_file_write at ffffffffbd6d9c6e
         sys_write at ffffffffbd6662ea
         system_call_fastpath at ffffffffbdbc34a2

Link: https://lore.kernel.org/r/20200520022959.1912856-1-krisman@collabora.com
Reported-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 64 +++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b2a803c51288..ea6d498fa923 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1616,6 +1616,12 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
 static struct sock *nls;
 static DEFINE_MUTEX(rx_queue_mutex);
 
+/*
+ * conn_mutex protects the {start,bind,stop,destroy}_conn from racing
+ * against the kernel stop_connection recovery mechanism
+ */
+static DEFINE_MUTEX(conn_mutex);
+
 static LIST_HEAD(sesslist);
 static LIST_HEAD(sessdestroylist);
 static DEFINE_SPINLOCK(sesslock);
@@ -2445,6 +2451,32 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
 
+/*
+ * This can be called without the rx_queue_mutex, if invoked by the kernel
+ * stop work. But, in that case, it is guaranteed not to race with
+ * iscsi_destroy by conn_mutex.
+ */
+static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
+{
+	/*
+	 * It is important that this path doesn't rely on
+	 * rx_queue_mutex, otherwise, a thread doing allocation on a
+	 * start_session/start_connection could sleep waiting on a
+	 * writeback to a failed iscsi device, that cannot be recovered
+	 * because the lock is held.  If we don't hold it here, the
+	 * kernel stop_conn_work_fn has a chance to stop the broken
+	 * session and resolve the allocation.
+	 *
+	 * Still, the user invoked .stop_conn() needs to be serialized
+	 * with stop_conn_work_fn by a private mutex.  Not pretty, but
+	 * it works.
+	 */
+	mutex_lock(&conn_mutex);
+	conn->transport->stop_conn(conn, flag);
+	mutex_unlock(&conn_mutex);
+
+}
+
 static void stop_conn_work_fn(struct work_struct *work)
 {
 	struct iscsi_cls_conn *conn, *tmp;
@@ -2463,30 +2495,17 @@ static void stop_conn_work_fn(struct work_struct *work)
 		uint32_t sid = iscsi_conn_get_sid(conn);
 		struct iscsi_cls_session *session;
 
-		mutex_lock(&rx_queue_mutex);
-
 		session = iscsi_session_lookup(sid);
 		if (session) {
 			if (system_state != SYSTEM_RUNNING) {
 				session->recovery_tmo = 0;
-				conn->transport->stop_conn(conn,
-							   STOP_CONN_TERM);
+				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
 			} else {
-				conn->transport->stop_conn(conn,
-							   STOP_CONN_RECOVER);
+				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
 			}
 		}
 
 		list_del_init(&conn->conn_list_err);
-
-		mutex_unlock(&rx_queue_mutex);
-
-		/* we don't want to hold rx_queue_mutex for too long,
-		 * for instance if many conns failed at the same time,
-		 * since this stall other iscsi maintenance operations.
-		 * Give other users a chance to proceed.
-		 */
-		cond_resched();
 	}
 }
 
@@ -2846,8 +2865,11 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
 	spin_unlock_irqrestore(&connlock, flags);
 
 	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
+
+	mutex_lock(&conn_mutex);
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn);
+	mutex_unlock(&conn_mutex);
 
 	return 0;
 }
@@ -3689,9 +3711,12 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			break;
 		}
 
+		mutex_lock(&conn_mutex);
 		ev->r.retcode =	transport->bind_conn(session, conn,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
+		mutex_unlock(&conn_mutex);
+
 		if (ev->r.retcode || !transport->ep_connect)
 			break;
 
@@ -3713,9 +3738,11 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	case ISCSI_UEVENT_START_CONN:
 		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
 		if (conn) {
+			mutex_lock(&conn_mutex);
 			ev->r.retcode = transport->start_conn(conn);
 			if (!ev->r.retcode)
 				conn->state = ISCSI_CONN_UP;
+			mutex_unlock(&conn_mutex);
 		}
 		else
 			err = -EINVAL;
@@ -3723,17 +3750,20 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	case ISCSI_UEVENT_STOP_CONN:
 		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
 		if (conn)
-			transport->stop_conn(conn, ev->u.stop_conn.flag);
+			iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
 		else
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SEND_PDU:
 		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
-		if (conn)
+		if (conn) {
+			mutex_lock(&conn_mutex);
 			ev->r.retcode =	transport->send_pdu(conn,
 				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
 				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
 				ev->u.send_pdu.data_size);
+			mutex_unlock(&conn_mutex);
+		}
 		else
 			err = -EINVAL;
 		break;
-- 
2.25.1

