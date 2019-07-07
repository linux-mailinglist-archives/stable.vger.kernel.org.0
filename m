Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50885616BA
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfGGTlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57708 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727625AbfGGTiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:13 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0006kU-UU; Sun, 07 Jul 2019 20:38:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005eD-Dv; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Steve French" <stfrench@microsoft.com>,
        "Pavel Shilovsky" <pshilov@microsoft.com>,
        "Pavel Shilovsky" <piastryyy@gmail.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.9438667@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 098/129] CIFS: Do not reset lease state to NONE on
 lease break
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastryyy@gmail.com>

commit 7b9b9edb49ad377b1e06abf14354c227e9ac4b06 upstream.

Currently on lease break the client sets a caching level twice:
when oplock is detected and when oplock is processed. While the
1st attempt sets the level to the value provided by the server,
the 2nd one resets the level to None unconditionally.
This happens because the oplock/lease processing code was changed
to avoid races between page cache flushes and oplock breaks.
The commit c11f1df5003d534 ("cifs: Wait for writebacks to complete
before attempting write.") fixed the races for oplocks but didn't
apply the same changes for leases resulting in overwriting the
server granted value to None. Fix this by properly processing
lease breaks.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[bwh: Backported to 3.16: drop change in smb311_operations]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -420,7 +420,6 @@ smb2_tcon_has_lease(struct cifs_tcon *tc
 	__u8 lease_state;
 	struct list_head *tmp;
 	struct cifsFileInfo *cfile;
-	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_pending_open *open;
 	struct cifsInodeInfo *cinode;
 	int ack_req = le32_to_cpu(rsp->Flags &
@@ -440,13 +439,25 @@ smb2_tcon_has_lease(struct cifs_tcon *tc
 		cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
 			 le32_to_cpu(rsp->NewLeaseState));
 
-		server->ops->set_oplock_level(cinode, lease_state, 0, NULL);
-
 		if (ack_req)
 			cfile->oplock_break_cancelled = false;
 		else
 			cfile->oplock_break_cancelled = true;
 
+		set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
+
+		/*
+		 * Set or clear flags depending on the lease state being READ.
+		 * HANDLE caching flag should be added when the client starts
+		 * to defer closing remote file handles with HANDLE leases.
+		 */
+		if (lease_state & SMB2_LEASE_READ_CACHING_HE)
+			set_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
+				&cinode->flags);
+		else
+			clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
+				  &cinode->flags);
+
 		queue_work(cifsoplockd_wq, &cfile->oplock_break);
 		kfree(lw);
 		return true;
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -962,6 +962,15 @@ smb2_downgrade_oplock(struct TCP_Server_
 }
 
 static void
+smb21_downgrade_oplock(struct TCP_Server_Info *server,
+		       struct cifsInodeInfo *cinode, bool set_level2)
+{
+	server->ops->set_oplock_level(cinode,
+				      set_level2 ? SMB2_LEASE_READ_CACHING_HE :
+				      0, 0, NULL);
+}
+
+static void
 smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 		      unsigned int epoch, bool *purge_cache)
 {
@@ -1253,7 +1262,7 @@ struct smb_version_operations smb21_oper
 	.print_stats = smb2_print_stats,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb2_downgrade_oplock,
+	.downgrade_oplock = smb21_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb2_negotiate_wsize,
@@ -1331,7 +1340,7 @@ struct smb_version_operations smb30_oper
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb2_downgrade_oplock,
+	.downgrade_oplock = smb21_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb2_negotiate_wsize,

