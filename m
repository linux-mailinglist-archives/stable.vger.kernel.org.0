Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A16F1D50
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 19:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfKFSQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 13:16:47 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36405 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfKFSQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 13:16:47 -0500
Received: by mail-pl1-f193.google.com with SMTP id g9so11831363plp.3
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 10:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PKTcz4kU1ASWWZOAuAYjf25ri3mcglo7OPKlrYojqjw=;
        b=oOBxJ0voZEO1PrvJ1+Fdp8BXW3ypRpBnQMvFM4AAY3Jafm+hZV2RTrW1jbK5tspRM7
         mPCsZw+zcVY1G6tu6MQIEK39ryaZdZgSa97RsTPXU5dx3AwbHYaXGWKofz5CIKzLRtDb
         WTpCzhlXUPOCbpKABwXg7iFKtapWIdGTAeiSJh6wcUqGPrrDw/PaJzlLOmOj8ZVsBygb
         pV7rMNsdcnlh5uixtgKSdUYTyDX9BpFmlHD/96buztQUGZitsoEaEj3tNYV5qrTGaM4K
         YzUIWR5bcPDL6Yf8jj7FkMO87Od9ZSVfpaKe870rAviZ1AhyGpa/HPNeoZJ/krOlkshR
         K/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PKTcz4kU1ASWWZOAuAYjf25ri3mcglo7OPKlrYojqjw=;
        b=GdbNY/y9Zv3GbZ3P+hAj+v2s478qGEMKKXk6zQDn/YhCipMfevffVT0z4XrY6r9WDI
         yR9oYpMDpcZksx+EMA7BXXeEdUqzqQNSRz/0IpYkag32/1KUBCQbLWHgS1CPcXNR50tK
         t8UtZN1supkxXCOn5paqfKvFiMimrIKLOqeG8SWI554NO1ZqSVJwrw73ZElK8P2Ui80u
         TfcTr9MLhPUqH6NOHeR20IOBYVRyt7foSHuJbIa6MObxtVmPuNFEIeV/EMfGZKPu6anV
         R5lvBfA0wfA3KA23l59C81rrIcHFfBhtgdZorXzO7vqeajdRFyN9IdBSCN+pgdlPYGey
         hjOw==
X-Gm-Message-State: APjAAAW6ruW2Hicru2Cj8JfJmGVWEObMDx843uwbYzzyXCtbeh1zzGQb
        t+jFc8DE0CL676uuniVJPWiIZVk=
X-Google-Smtp-Source: APXvYqzGJde1Ab0YFzOcqCU+Sjk5K2o4TpTmU8SOJWgN+AKkIEOce/vjv6bsZR1Ohlod3+KKCBAYAA==
X-Received: by 2002:a17:902:521:: with SMTP id 30mr4030531plf.37.1573064205510;
        Wed, 06 Nov 2019 10:16:45 -0800 (PST)
Received: from ubuntu-vm.mshome.net ([131.107.159.106])
        by smtp.gmail.com with ESMTPSA id 31sm23202139pgy.63.2019.11.06.10.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 10:16:44 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH] CIFS: Fix retry mid list corruption on reconnects
Date:   Wed,  6 Nov 2019 10:16:35 -0800
Message-Id: <20191106181635.25327-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit abe57073d08c1 ("CIFS: Fix retry mid list corruption on reconnects") upstream.

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

Cc: Stable <stable@vger.kernel.org> # 5.3.x
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-and-tested-by: David Wysochanski <dwysocha@redhat.com>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/connect.c   | 10 +++++++++-
 fs/cifs/transport.c | 42 +++++++++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8ee57d1f507f..8995c03056e3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -556,9 +556,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
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
@@ -568,6 +570,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 		list_del_init(&mid_entry->qhead);
 		mid_entry->callback(mid_entry);
+		cifs_mid_q_entry_release(mid_entry);
 	}
 
 	if (cifs_rdma_enabled(server)) {
@@ -887,8 +890,10 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
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
 
@@ -958,8 +963,10 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
+			kref_get(&mid_entry->refcount);
 			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
+			mid_entry->mid_flags |= MID_DELETED;
 		}
 		spin_unlock(&GlobalMid_Lock);
 
@@ -969,6 +976,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 			cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
 			mid_entry->callback(mid_entry);
+			cifs_mid_q_entry_release(mid_entry);
 		}
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5d6d44bfe10a..bb52751ba783 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -86,22 +86,8 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 
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
@@ -166,6 +152,19 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
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
@@ -868,7 +869,10 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
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
-- 
2.17.1

