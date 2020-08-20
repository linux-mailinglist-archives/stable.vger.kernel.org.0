Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7764724BC3B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgHTMml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbgHTJp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B369A20724;
        Thu, 20 Aug 2020 09:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916758;
        bh=Bmg10UqZE2OfqzUwO5/985U5PYWvxAjDL4ixoSb1H2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eywTQZ5lrG+nzYI5S/A2o0Pox6SKneSCwYuamD+CEW4AeF2fn8xESHOnujuIrBFUI
         oVb+IUZ3SDtHscI825w+sW7jSle7TmujqBCx08avwx4WwuBRALI6DfmJJ4p2I5LSRu
         Z5vpWbSwbR+oCq9gcUmmR5I89EwPMYLF0TInKkBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Aurich <paul@darkrain42.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 035/152] cifs: Fix leak when handling lease break for cached root fid
Date:   Thu, 20 Aug 2020 11:20:02 +0200
Message-Id: <20200820091555.458338289@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Aurich <paul@darkrain42.org>

commit baf57b56d3604880ccb3956ec6c62ea894f5de99 upstream.

Handling a lease break for the cached root didn't free the
smb2_lease_break_work allocation, resulting in a leak:

    unreferenced object 0xffff98383a5af480 (size 128):
      comm "cifsd", pid 684, jiffies 4294936606 (age 534.868s)
      hex dump (first 32 bytes):
        c0 ff ff ff 1f 00 00 00 88 f4 5a 3a 38 98 ff ff  ..........Z:8...
        88 f4 5a 3a 38 98 ff ff 80 88 d6 8a ff ff ff ff  ..Z:8...........
      backtrace:
        [<0000000068957336>] smb2_is_valid_oplock_break+0x1fa/0x8c0
        [<0000000073b70b9e>] cifs_demultiplex_thread+0x73d/0xcc0
        [<00000000905fa372>] kthread+0x11c/0x150
        [<0000000079378e4e>] ret_from_fork+0x22/0x30

Avoid this leak by only allocating when necessary.

Fixes: a93864d93977 ("cifs: add lease tracking to the cached root fid")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: Stable <stable@vger.kernel.org> # v4.18+
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2misc.c |   73 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 21 deletions(-)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -509,15 +509,31 @@ cifs_ses_oplock_break(struct work_struct
 	kfree(lw);
 }
 
+static void
+smb2_queue_pending_open_break(struct tcon_link *tlink, __u8 *lease_key,
+			      __le32 new_lease_state)
+{
+	struct smb2_lease_break_work *lw;
+
+	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
+	if (!lw) {
+		cifs_put_tlink(tlink);
+		return;
+	}
+
+	INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
+	lw->tlink = tlink;
+	lw->lease_state = new_lease_state;
+	memcpy(lw->lease_key, lease_key, SMB2_LEASE_KEY_SIZE);
+	queue_work(cifsiod_wq, &lw->lease_break);
+}
+
 static bool
-smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
-		    struct smb2_lease_break_work *lw)
+smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
 {
-	bool found;
 	__u8 lease_state;
 	struct list_head *tmp;
 	struct cifsFileInfo *cfile;
-	struct cifs_pending_open *open;
 	struct cifsInodeInfo *cinode;
 	int ack_req = le32_to_cpu(rsp->Flags &
 				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
@@ -556,22 +572,29 @@ smb2_tcon_has_lease(struct cifs_tcon *tc
 				  &cinode->flags);
 
 		cifs_queue_oplock_break(cfile);
-		kfree(lw);
 		return true;
 	}
 
-	found = false;
+	return false;
+}
+
+static struct cifs_pending_open *
+smb2_tcon_find_pending_open_lease(struct cifs_tcon *tcon,
+				  struct smb2_lease_break *rsp)
+{
+	__u8 lease_state = le32_to_cpu(rsp->NewLeaseState);
+	int ack_req = le32_to_cpu(rsp->Flags &
+				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
+	struct cifs_pending_open *open;
+	struct cifs_pending_open *found = NULL;
+
 	list_for_each_entry(open, &tcon->pending_opens, olist) {
 		if (memcmp(open->lease_key, rsp->LeaseKey,
 			   SMB2_LEASE_KEY_SIZE))
 			continue;
 
 		if (!found && ack_req) {
-			found = true;
-			memcpy(lw->lease_key, open->lease_key,
-			       SMB2_LEASE_KEY_SIZE);
-			lw->tlink = cifs_get_tlink(open->tlink);
-			queue_work(cifsiod_wq, &lw->lease_break);
+			found = open;
 		}
 
 		cifs_dbg(FYI, "found in the pending open list\n");
@@ -592,14 +615,7 @@ smb2_is_valid_lease_break(char *buffer)
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
-	struct smb2_lease_break_work *lw;
-
-	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
-	if (!lw)
-		return false;
-
-	INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
-	lw->lease_state = rsp->NewLeaseState;
+	struct cifs_pending_open *open;
 
 	cifs_dbg(FYI, "Checking for lease break\n");
 
@@ -617,11 +633,27 @@ smb2_is_valid_lease_break(char *buffer)
 				spin_lock(&tcon->open_file_lock);
 				cifs_stats_inc(
 				    &tcon->stats.cifs_stats.num_oplock_brks);
-				if (smb2_tcon_has_lease(tcon, rsp, lw)) {
+				if (smb2_tcon_has_lease(tcon, rsp)) {
 					spin_unlock(&tcon->open_file_lock);
 					spin_unlock(&cifs_tcp_ses_lock);
 					return true;
 				}
+				open = smb2_tcon_find_pending_open_lease(tcon,
+									 rsp);
+				if (open) {
+					__u8 lease_key[SMB2_LEASE_KEY_SIZE];
+					struct tcon_link *tlink;
+
+					tlink = cifs_get_tlink(open->tlink);
+					memcpy(lease_key, open->lease_key,
+					       SMB2_LEASE_KEY_SIZE);
+					spin_unlock(&tcon->open_file_lock);
+					spin_unlock(&cifs_tcp_ses_lock);
+					smb2_queue_pending_open_break(tlink,
+								      lease_key,
+								      rsp->NewLeaseState);
+					return true;
+				}
 				spin_unlock(&tcon->open_file_lock);
 
 				if (tcon->crfid.is_valid &&
@@ -639,7 +671,6 @@ smb2_is_valid_lease_break(char *buffer)
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-	kfree(lw);
 	cifs_dbg(FYI, "Can not process lease break - no lease matched\n");
 	return false;
 }


