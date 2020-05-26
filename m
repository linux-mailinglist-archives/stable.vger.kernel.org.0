Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484A51DB63E
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgETOXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:23:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33432 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727772AbgETOW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-00037r-NV; Wed, 20 May 2020 15:22:22 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbw-007DUp-Oz; Wed, 20 May 2020 15:22:20 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        "Steve French" <stfrench@microsoft.com>,
        "Vincent Whitchurch" <vincent.whitchurch@axis.com>,
        "Pavel Shilovsky" <pshilov@microsoft.com>
Date:   Wed, 20 May 2020 15:14:42 +0100
Message-ID: <lsq.1589984009.342766154@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 74/99] CIFS: Fix task struct use-after-free on reconnect
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

commit f1f27ad74557e39f67a8331a808b860f89254f2d upstream.

The task which created the MID may be gone by the time cifsd attempts to
call the callbacks on MIDs from cifs_reconnect().

This leads to a use-after-free of the task struct in cifs_wake_up_task:

 ==================================================================
 BUG: KASAN: use-after-free in __lock_acquire+0x31a0/0x3270
 Read of size 8 at addr ffff8880103e3a68 by task cifsd/630

 CPU: 0 PID: 630 Comm: cifsd Not tainted 5.5.0-rc6+ #119
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
 Call Trace:
  dump_stack+0x8e/0xcb
  print_address_description.constprop.5+0x1d3/0x3c0
  ? __lock_acquire+0x31a0/0x3270
  __kasan_report+0x152/0x1aa
  ? __lock_acquire+0x31a0/0x3270
  ? __lock_acquire+0x31a0/0x3270
  kasan_report+0xe/0x20
  __lock_acquire+0x31a0/0x3270
  ? __wake_up_common+0x1dc/0x630
  ? _raw_spin_unlock_irqrestore+0x4c/0x60
  ? mark_held_locks+0xf0/0xf0
  ? _raw_spin_unlock_irqrestore+0x39/0x60
  ? __wake_up_common_lock+0xd5/0x130
  ? __wake_up_common+0x630/0x630
  lock_acquire+0x13f/0x330
  ? try_to_wake_up+0xa3/0x19e0
  _raw_spin_lock_irqsave+0x38/0x50
  ? try_to_wake_up+0xa3/0x19e0
  try_to_wake_up+0xa3/0x19e0
  ? cifs_compound_callback+0x178/0x210
  ? set_cpus_allowed_ptr+0x10/0x10
  cifs_reconnect+0xa1c/0x15d0
  ? generic_ip_connect+0x1860/0x1860
  ? rwlock_bug.part.0+0x90/0x90
  cifs_readv_from_socket+0x479/0x690
  cifs_read_from_socket+0x9d/0xe0
  ? cifs_readv_from_socket+0x690/0x690
  ? mempool_resize+0x690/0x690
  ? rwlock_bug.part.0+0x90/0x90
  ? memset+0x1f/0x40
  ? allocate_buffers+0xff/0x340
  cifs_demultiplex_thread+0x388/0x2a50
  ? cifs_handle_standard+0x610/0x610
  ? rcu_read_lock_held_common+0x120/0x120
  ? mark_lock+0x11b/0xc00
  ? __lock_acquire+0x14ed/0x3270
  ? __kthread_parkme+0x78/0x100
  ? lockdep_hardirqs_on+0x3e8/0x560
  ? lock_downgrade+0x6a0/0x6a0
  ? lockdep_hardirqs_on+0x3e8/0x560
  ? _raw_spin_unlock_irqrestore+0x39/0x60
  ? cifs_handle_standard+0x610/0x610
  kthread+0x2bb/0x3a0
  ? kthread_create_worker_on_cpu+0xc0/0xc0
  ret_from_fork+0x3a/0x50

 Allocated by task 649:
  save_stack+0x19/0x70
  __kasan_kmalloc.constprop.5+0xa6/0xf0
  kmem_cache_alloc+0x107/0x320
  copy_process+0x17bc/0x5370
  _do_fork+0x103/0xbf0
  __x64_sys_clone+0x168/0x1e0
  do_syscall_64+0x9b/0xec0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 Freed by task 0:
  save_stack+0x19/0x70
  __kasan_slab_free+0x11d/0x160
  kmem_cache_free+0xb5/0x3d0
  rcu_core+0x52f/0x1230
  __do_softirq+0x24d/0x962

 The buggy address belongs to the object at ffff8880103e32c0
  which belongs to the cache task_struct of size 6016
 The buggy address is located 1960 bytes inside of
  6016-byte region [ffff8880103e32c0, ffff8880103e4a40)
 The buggy address belongs to the page:
 page:ffffea000040f800 refcount:1 mapcount:0 mapping:ffff8880108da5c0
 index:0xffff8880103e4c00 compound_mapcount: 0
 raw: 4000000000010200 ffffea00001f2208 ffffea00001e3408 ffff8880108da5c0
 raw: ffff8880103e4c00 0000000000050003 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff8880103e3900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880103e3980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 >ffff8880103e3a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                           ^
  ffff8880103e3a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880103e3b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

This can be reliably reproduced by adding the below delay to
cifs_reconnect(), running find(1) on the mount, restarting the samba
server while find is running, and killing find during the delay:

  	spin_unlock(&GlobalMid_Lock);
  	mutex_unlock(&server->srv_mutex);

 +	msleep(10000);
 +
  	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
  	list_for_each_safe(tmp, tmp2, &retry_list) {
  		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);

Fix this by holding a reference to the task struct until the MID is
freed.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
[bwh: Backported to 3.16:
 - In _cifs_mid_q_entry_release(), use mid instead of midEntry
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1252,6 +1252,7 @@ struct mid_q_entry {
 	mid_receive_t *receive; /* call receive callback */
 	mid_callback_t *callback; /* call completion callback */
 	void *callback_data;	  /* general purpose pointer for callback */
+	struct task_struct *creator;
 	void *resp_buf;		/* pointer to received SMB header */
 	int mid_state;	/* wish this were enum but can not pass to wait_event */
 	unsigned int mid_flags;
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -542,6 +542,8 @@ smb2_mid_entry_alloc(const struct smb2_h
 		 * The default is for the mid to be synchronous, so the
 		 * default callback just wakes up the current task.
 		 */
+		get_task_struct(current);
+		temp->creator = current;
 		temp->callback = cifs_wake_up_task;
 		temp->callback_data = current;
 	}
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -72,6 +72,8 @@ AllocMidQEntry(const struct smb_hdr *smb
 		 * The default is for the mid to be synchronous, so the
 		 * default callback just wakes up the current task.
 		 */
+		get_task_struct(current);
+		temp->creator = current;
 		temp->callback = cifs_wake_up_task;
 		temp->callback_data = current;
 	}
@@ -86,6 +88,8 @@ static void _cifs_mid_q_entry_release(st
 	struct mid_q_entry *mid = container_of(refcount, struct mid_q_entry,
 					       refcount);
 
+	put_task_struct(mid->creator);
+
 	mempool_free(mid, cifs_mid_poolp);
 }
 

