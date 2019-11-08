Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71AC8F56B8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391902AbfKHTKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730571AbfKHTKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1829521D7B;
        Fri,  8 Nov 2019 19:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240235;
        bh=xgSpBqSLkquN9a8a8MVfL6qy56+9Z/eZyt2So1rSis4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIOOdq2P/3nAeI8vnXaJi2Z640nhrLrHxBoxqzWQS41NI2mM5gWa2CIzf/DzI3Hax
         zyx0Ou81SmEEiQzwI4A2jrFcw5uPzugVQwG0nxVmACWSxFYNaVpV4wC0m4EdkcjXKr
         2MM2FYRzX26f8TEtlpTLT775Y33/4FQ4OFm2f4wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        David Wysochanski <dwysocha@redhat.com>
Subject: [PATCH 5.3 135/140] CIFS: Fix retry mid list corruption on reconnects
Date:   Fri,  8 Nov 2019 19:51:03 +0100
Message-Id: <20191108174913.103146663@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

commit abe57073d08c13b95a46ccf48cc9dc957d5c6fdb upstream.

When the client hits reconnect it iterates over the mid
pending queue marking entries for retry and moving them
to a temporary list to issue callbacks later without holding
GlobalMid_Lock. In the same time there is no guarantee that
mids can't be removed from the temporary list or even
freed completely by another thread. It may cause a temporary
list corruption:

[  430.454897] list_del corruption. prev->next should be ffff98d3a8f316c0, but was 2e885cb266355469
[  430.464668] ------------[ cut here ]------------
[  430.466569] kernel BUG at lib/list_debug.c:51!
[  430.468476] invalid opcode: 0000 [#1] SMP PTI
[  430.470286] CPU: 0 PID: 13267 Comm: cifsd Kdump: loaded Not tainted 5.4.0-rc3+ #19
[  430.473472] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  430.475872] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
...
[  430.510426] Call Trace:
[  430.511500]  cifs_reconnect+0x25e/0x610 [cifs]
[  430.513350]  cifs_readv_from_socket+0x220/0x250 [cifs]
[  430.515464]  cifs_read_from_socket+0x4a/0x70 [cifs]
[  430.517452]  ? try_to_wake_up+0x212/0x650
[  430.519122]  ? cifs_small_buf_get+0x16/0x30 [cifs]
[  430.521086]  ? allocate_buffers+0x66/0x120 [cifs]
[  430.523019]  cifs_demultiplex_thread+0xdc/0xc30 [cifs]
[  430.525116]  kthread+0xfb/0x130
[  430.526421]  ? cifs_handle_standard+0x190/0x190 [cifs]
[  430.528514]  ? kthread_park+0x90/0x90
[  430.530019]  ret_from_fork+0x35/0x40

Fix this by obtaining extra references for mids being retried
and marking them as MID_DELETED which indicates that such a mid
has been dequeued from the pending list.

Also move mid cleanup logic from DeleteMidQEntry to
_cifs_mid_q_entry_release which is called when the last reference
to a particular mid is put. This allows to avoid any use-after-free
of response buffers.

The patch needs to be backported to stable kernels. A stable tag
is not mentioned below because the patch doesn't apply cleanly
to any actively maintained stable kernel.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-and-tested-by: David Wysochanski <dwysocha@redhat.com>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c   |   10 +++++++++-
 fs/cifs/transport.c |   42 +++++++++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 20 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -556,9 +556,11 @@ cifs_reconnect(struct TCP_Server_Info *s
 	spin_lock(&GlobalMid_Lock);
 	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+		kref_get(&mid_entry->refcount);
 		if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
 			mid_entry->mid_state = MID_RETRY_NEEDED;
 		list_move(&mid_entry->qhead, &retry_list);
+		mid_entry->mid_flags |= MID_DELETED;
 	}
 	spin_unlock(&GlobalMid_Lock);
 	mutex_unlock(&server->srv_mutex);
@@ -568,6 +570,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 		list_del_init(&mid_entry->qhead);
 		mid_entry->callback(mid_entry);
+		cifs_mid_q_entry_release(mid_entry);
 	}
 
 	if (cifs_rdma_enabled(server)) {
@@ -887,8 +890,10 @@ dequeue_mid(struct mid_q_entry *mid, boo
 	if (mid->mid_flags & MID_DELETED)
 		printk_once(KERN_WARNING
 			    "trying to dequeue a deleted mid\n");
-	else
+	else {
 		list_del_init(&mid->qhead);
+		mid->mid_flags |= MID_DELETED;
+	}
 	spin_unlock(&GlobalMid_Lock);
 }
 
@@ -958,8 +963,10 @@ static void clean_demultiplex_info(struc
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
+			kref_get(&mid_entry->refcount);
 			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
+			mid_entry->mid_flags |= MID_DELETED;
 		}
 		spin_unlock(&GlobalMid_Lock);
 
@@ -969,6 +976,7 @@ static void clean_demultiplex_info(struc
 			cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
 			mid_entry->callback(mid_entry);
+			cifs_mid_q_entry_release(mid_entry);
 		}
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -86,22 +86,8 @@ AllocMidQEntry(const struct smb_hdr *smb
 
 static void _cifs_mid_q_entry_release(struct kref *refcount)
 {
-	struct mid_q_entry *mid = container_of(refcount, struct mid_q_entry,
-					       refcount);
-
-	mempool_free(mid, cifs_mid_poolp);
-}
-
-void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
-{
-	spin_lock(&GlobalMid_Lock);
-	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
-	spin_unlock(&GlobalMid_Lock);
-}
-
-void
-DeleteMidQEntry(struct mid_q_entry *midEntry)
-{
+	struct mid_q_entry *midEntry =
+			container_of(refcount, struct mid_q_entry, refcount);
 #ifdef CONFIG_CIFS_STATS2
 	__le16 command = midEntry->server->vals->lock_cmd;
 	__u16 smb_cmd = le16_to_cpu(midEntry->command);
@@ -166,6 +152,19 @@ DeleteMidQEntry(struct mid_q_entry *midE
 		}
 	}
 #endif
+
+	mempool_free(midEntry, cifs_mid_poolp);
+}
+
+void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
+{
+	spin_lock(&GlobalMid_Lock);
+	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
+	spin_unlock(&GlobalMid_Lock);
+}
+
+void DeleteMidQEntry(struct mid_q_entry *midEntry)
+{
 	cifs_mid_q_entry_release(midEntry);
 }
 
@@ -173,8 +172,10 @@ void
 cifs_delete_mid(struct mid_q_entry *mid)
 {
 	spin_lock(&GlobalMid_Lock);
-	list_del_init(&mid->qhead);
-	mid->mid_flags |= MID_DELETED;
+	if (!(mid->mid_flags & MID_DELETED)) {
+		list_del_init(&mid->qhead);
+		mid->mid_flags |= MID_DELETED;
+	}
 	spin_unlock(&GlobalMid_Lock);
 
 	DeleteMidQEntry(mid);
@@ -868,7 +869,10 @@ cifs_sync_mid_result(struct mid_q_entry
 		rc = -EHOSTDOWN;
 		break;
 	default:
-		list_del_init(&mid->qhead);
+		if (!(mid->mid_flags & MID_DELETED)) {
+			list_del_init(&mid->qhead);
+			mid->mid_flags |= MID_DELETED;
+		}
 		cifs_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
 			 __func__, mid->mid, mid->mid_state);
 		rc = -EIO;


