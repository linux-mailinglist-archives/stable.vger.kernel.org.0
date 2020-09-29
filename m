Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250EF27C9AA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgI2MMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730122AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B6D23B84;
        Tue, 29 Sep 2020 11:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379273;
        bh=4/SsSdKWdBZmsZm+AN3zfVgsWt8g9wZCe3pR2EeOjcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7oohMHOrdVdwJ6MF2v/Q7FCW4s+DhJQnpf/H4BCWWFYwAWzx3zy8OY0bgHXaDDMb
         oD3ZBcf3wmzi/hVKSoeqceVo0JTLh9108YIWk0gjpCGiJ83yiH+VAoAs3u3FoZlf5f
         UKGumSPmhb5ORR1lVB56KOEeJvlSoAGSt+1Vw+Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/388] CIFS: Properly process SMB3 lease breaks
Date:   Tue, 29 Sep 2020 12:56:31 +0200
Message-Id: <20200929110013.399948916@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

[ Upstream commit 9bd4540836684013aaad6070a65d6fcdd9006625 ]

Currenly we doesn't assume that a server may break a lease
from RWH to RW which causes us setting a wrong lease state
on a file and thus mistakenly flushing data and byte-range
locks and purging cached data on the client. This leads to
performance degradation because subsequent IOs go directly
to the server.

Fix this by propagating new lease state and epoch values
to the oplock break handler through cifsFileInfo structure
and removing the use of cifsInodeInfo flags for that. It
allows to avoid some races of several lease/oplock breaks
using those flags in parallel.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h |  9 ++++++---
 fs/cifs/file.c     | 10 +++++++---
 fs/cifs/misc.c     | 17 +++--------------
 fs/cifs/smb1ops.c  |  8 +++-----
 fs/cifs/smb2misc.c | 32 +++++++-------------------------
 fs/cifs/smb2ops.c  | 44 ++++++++++++++++++++++++++++++--------------
 fs/cifs/smb2pdu.h  |  2 +-
 7 files changed, 57 insertions(+), 65 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f9cbdfc1591b1..b16c994414ab0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -268,8 +268,9 @@ struct smb_version_operations {
 	int (*check_message)(char *, unsigned int, struct TCP_Server_Info *);
 	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
 	int (*handle_cancelled_mid)(char *, struct TCP_Server_Info *);
-	void (*downgrade_oplock)(struct TCP_Server_Info *,
-					struct cifsInodeInfo *, bool);
+	void (*downgrade_oplock)(struct TCP_Server_Info *server,
+				 struct cifsInodeInfo *cinode, __u32 oplock,
+				 unsigned int epoch, bool *purge_cache);
 	/* process transaction2 response */
 	bool (*check_trans2)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     char *, int);
@@ -1261,6 +1262,8 @@ struct cifsFileInfo {
 	unsigned int f_flags;
 	bool invalidHandle:1;	/* file closed via session abend */
 	bool oplock_break_cancelled:1;
+	unsigned int oplock_epoch; /* epoch from the lease break */
+	__u32 oplock_level; /* oplock/lease level from the lease break */
 	int count;
 	spinlock_t file_info_lock; /* protects four flag/count fields above */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
@@ -1408,7 +1411,7 @@ struct cifsInodeInfo {
 	unsigned int epoch;		/* used to track lease state changes */
 #define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progress */
 #define CIFS_INODE_PENDING_WRITERS	  (1) /* Writes in progress */
-#define CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2 (2) /* Downgrade oplock to L2 */
+#define CIFS_INODE_FLAG_UNUSED		  (2) /* Unused flag */
 #define CIFS_INO_DELETE_PENDING		  (3) /* delete pending on server */
 #define CIFS_INO_INVALID_MAPPING	  (4) /* pagecache is invalid */
 #define CIFS_INO_LOCK			  (5) /* lock bit for synchronization */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4959dbe740f71..14ae341755d47 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4675,12 +4675,13 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
+	bool purge_cache = false;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
-	server->ops->downgrade_oplock(server, cinode,
-		test_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2, &cinode->flags));
+	server->ops->downgrade_oplock(server, cinode, cfile->oplock_level,
+				      cfile->oplock_epoch, &purge_cache);
 
 	if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
 						cifs_has_mand_locks(cinode)) {
@@ -4695,18 +4696,21 @@ void cifs_oplock_break(struct work_struct *work)
 		else
 			break_lease(inode, O_WRONLY);
 		rc = filemap_fdatawrite(inode->i_mapping);
-		if (!CIFS_CACHE_READ(cinode)) {
+		if (!CIFS_CACHE_READ(cinode) || purge_cache) {
 			rc = filemap_fdatawait(inode->i_mapping);
 			mapping_set_error(inode->i_mapping, rc);
 			cifs_zap_mapping(inode);
 		}
 		cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc);
+		if (CIFS_CACHE_WRITE(cinode))
+			goto oplock_break_ack;
 	}
 
 	rc = cifs_push_locks(cfile);
 	if (rc)
 		cifs_dbg(VFS, "Push locks rc = %d\n", rc);
 
+oplock_break_ack:
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
 	 * a now incorrect file handle is not a data integrity issue but do
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 5ad83bdb9bea3..40ca394fd5de9 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -488,21 +488,10 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 				set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK,
 					&pCifsInode->flags);
 
-				/*
-				 * Set flag if the server downgrades the oplock
-				 * to L2 else clear.
-				 */
-				if (pSMB->OplockLevel)
-					set_bit(
-					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-					   &pCifsInode->flags);
-				else
-					clear_bit(
-					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-					   &pCifsInode->flags);
-
-				cifs_queue_oplock_break(netfile);
+				netfile->oplock_epoch = 0;
+				netfile->oplock_level = pSMB->OplockLevel;
 				netfile->oplock_break_cancelled = false;
+				cifs_queue_oplock_break(netfile);
 
 				spin_unlock(&tcon->open_file_lock);
 				spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 195766221a7a8..e523c05a44876 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -369,12 +369,10 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 
 static void
 cifs_downgrade_oplock(struct TCP_Server_Info *server,
-			struct cifsInodeInfo *cinode, bool set_level2)
+		      struct cifsInodeInfo *cinode, __u32 oplock,
+		      unsigned int epoch, bool *purge_cache)
 {
-	if (set_level2)
-		cifs_set_oplock_level(cinode, OPLOCK_READ);
-	else
-		cifs_set_oplock_level(cinode, 0);
+	cifs_set_oplock_level(cinode, oplock);
 }
 
 static bool
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 2fc96f7923ee5..7d875a47d0226 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -550,7 +550,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
 
 		cifs_dbg(FYI, "found in the open list\n");
 		cifs_dbg(FYI, "lease key match, lease break 0x%x\n",
-			 le32_to_cpu(rsp->NewLeaseState));
+			 lease_state);
 
 		if (ack_req)
 			cfile->oplock_break_cancelled = false;
@@ -559,17 +559,8 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
 
 		set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
 
-		/*
-		 * Set or clear flags depending on the lease state being READ.
-		 * HANDLE caching flag should be added when the client starts
-		 * to defer closing remote file handles with HANDLE leases.
-		 */
-		if (lease_state & SMB2_LEASE_READ_CACHING_HE)
-			set_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-				&cinode->flags);
-		else
-			clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-				  &cinode->flags);
+		cfile->oplock_epoch = le16_to_cpu(rsp->Epoch);
+		cfile->oplock_level = lease_state;
 
 		cifs_queue_oplock_break(cfile);
 		return true;
@@ -599,7 +590,7 @@ smb2_tcon_find_pending_open_lease(struct cifs_tcon *tcon,
 
 		cifs_dbg(FYI, "found in the pending open list\n");
 		cifs_dbg(FYI, "lease key match, lease break 0x%x\n",
-			 le32_to_cpu(rsp->NewLeaseState));
+			 lease_state);
 
 		open->oplock = lease_state;
 	}
@@ -732,18 +723,9 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 				set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK,
 					&cinode->flags);
 
-				/*
-				 * Set flag if the server downgrades the oplock
-				 * to L2 else clear.
-				 */
-				if (rsp->OplockLevel)
-					set_bit(
-					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-					   &cinode->flags);
-				else
-					clear_bit(
-					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
-					   &cinode->flags);
+				cfile->oplock_epoch = 0;
+				cfile->oplock_level = rsp->OplockLevel;
+
 				spin_unlock(&cfile->file_info_lock);
 
 				cifs_queue_oplock_break(cfile);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 318d805e74d40..64ad466695c55 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3332,22 +3332,38 @@ static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
 
 static void
 smb2_downgrade_oplock(struct TCP_Server_Info *server,
-			struct cifsInodeInfo *cinode, bool set_level2)
+		      struct cifsInodeInfo *cinode, __u32 oplock,
+		      unsigned int epoch, bool *purge_cache)
 {
-	if (set_level2)
-		server->ops->set_oplock_level(cinode, SMB2_OPLOCK_LEVEL_II,
-						0, NULL);
-	else
-		server->ops->set_oplock_level(cinode, 0, 0, NULL);
+	server->ops->set_oplock_level(cinode, oplock, 0, NULL);
 }
 
 static void
-smb21_downgrade_oplock(struct TCP_Server_Info *server,
-		       struct cifsInodeInfo *cinode, bool set_level2)
+smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
+		       unsigned int epoch, bool *purge_cache);
+
+static void
+smb3_downgrade_oplock(struct TCP_Server_Info *server,
+		       struct cifsInodeInfo *cinode, __u32 oplock,
+		       unsigned int epoch, bool *purge_cache)
 {
-	server->ops->set_oplock_level(cinode,
-				      set_level2 ? SMB2_LEASE_READ_CACHING_HE :
-				      0, 0, NULL);
+	unsigned int old_state = cinode->oplock;
+	unsigned int old_epoch = cinode->epoch;
+	unsigned int new_state;
+
+	if (epoch > old_epoch) {
+		smb21_set_oplock_level(cinode, oplock, 0, NULL);
+		cinode->epoch = epoch;
+	}
+
+	new_state = cinode->oplock;
+	*purge_cache = false;
+
+	if ((old_state & CIFS_CACHE_READ_FLG) != 0 &&
+	    (new_state & CIFS_CACHE_READ_FLG) == 0)
+		*purge_cache = true;
+	else if (old_state == new_state && (epoch - old_epoch > 1))
+		*purge_cache = true;
 }
 
 static void
@@ -4607,7 +4623,7 @@ struct smb_version_operations smb21_operations = {
 	.print_stats = smb2_print_stats,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb21_downgrade_oplock,
+	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb2_negotiate_wsize,
@@ -4707,7 +4723,7 @@ struct smb_version_operations smb30_operations = {
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb21_downgrade_oplock,
+	.downgrade_oplock = smb3_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb3_negotiate_wsize,
@@ -4815,7 +4831,7 @@ struct smb_version_operations smb311_operations = {
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb21_downgrade_oplock,
+	.downgrade_oplock = smb3_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb3_negotiate_wsize,
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 0abfde6d0b051..f264e1d36fe16 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1386,7 +1386,7 @@ struct smb2_oplock_break {
 struct smb2_lease_break {
 	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 44 */
-	__le16 Reserved;
+	__le16 Epoch;
 	__le32 Flags;
 	__u8   LeaseKey[16];
 	__le32 CurrentLeaseState;
-- 
2.25.1



