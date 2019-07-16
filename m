Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C67BF6A003
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 02:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbfGPAmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 20:42:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730383AbfGPAmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 20:42:02 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B23C3082E0E;
        Tue, 16 Jul 2019 00:42:02 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-77.bne.redhat.com [10.64.54.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D033C5D968;
        Tue, 16 Jul 2019 00:42:01 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] cifs: fix crash in smb2_compound_op()/smb2_set_next_command()
Date:   Tue, 16 Jul 2019 10:41:46 +1000
Message-Id: <20190716004146.13668-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 16 Jul 2019 00:42:02 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RHBZ: 1722704

In low memory situations the various SMB2_*_init() functions can fail
to allocate a request PDU and thus leave the request iovector as NULL.

If we don't check the return code for failure we end up calling
smb2_set_next_command() with a NULL iovector causing a crash when it tries
to dereference it.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2inode.c | 12 ++++++++++++
 fs/cifs/smb2ops.c   | 11 ++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 278405d26c47..d8d9cdfa30b6 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -120,6 +120,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				SMB2_O_INFO_FILE, 0,
 				sizeof(struct smb2_file_all_info) +
 					  PATH_MAX * 2, 0, NULL);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_query_info_compound_enter(xid, ses->Suid, tcon->tid,
@@ -147,6 +149,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					COMPOUND_FID, current->tgid,
 					FILE_DISPOSITION_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_rmdir_enter(xid, ses->Suid, tcon->tid, full_path);
@@ -163,6 +167,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					COMPOUND_FID, current->tgid,
 					FILE_END_OF_FILE_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
@@ -180,6 +186,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					COMPOUND_FID, current->tgid,
 					FILE_BASIC_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_set_info_compound_enter(xid, ses->Suid, tcon->tid,
@@ -206,6 +214,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					COMPOUND_FID, current->tgid,
 					FILE_RENAME_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_rename_enter(xid, ses->Suid, tcon->tid, full_path);
@@ -231,6 +241,8 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					COMPOUND_FID, current->tgid,
 					FILE_LINK_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_hardlink_enter(xid, ses->Suid, tcon->tid, full_path);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4b0b14946343..462890f4cb9c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2027,6 +2027,10 @@ smb2_set_related(struct smb_rqst *rqst)
 	struct smb2_sync_hdr *shdr;
 
 	shdr = (struct smb2_sync_hdr *)(rqst->rq_iov[0].iov_base);
+	if (shdr == NULL) {
+		cifs_dbg(FYI, "shdr NULL in smb2_set_related\n");
+		return;
+	}
 	shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
 }
 
@@ -2041,6 +2045,12 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 	unsigned long len = smb_rqst_len(server, rqst);
 	int i, num_padding;
 
+	shdr = (struct smb2_sync_hdr *)(rqst->rq_iov[0].iov_base);
+	if (shdr == NULL) {
+		cifs_dbg(FYI, "shdr NULL in smb2_set_next_command\n");
+		return;
+	}
+
 	/* SMB headers in a compound are 8 byte aligned. */
 
 	/* No padding needed */
@@ -2080,7 +2090,6 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 	}
 
  finished:
-	shdr = (struct smb2_sync_hdr *)(rqst->rq_iov[0].iov_base);
 	shdr->NextCommand = cpu_to_le32(len);
 }
 
-- 
2.13.6

