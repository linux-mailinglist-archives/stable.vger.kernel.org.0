Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2636373AF9
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391159AbfGXTzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404536AbfGXTzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:55:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA52205C9;
        Wed, 24 Jul 2019 19:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998137;
        bh=A5atY+AUMvceYVV9R9lZUU3bqgHP7eCnruQ6LYDFjTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xsb0P1aITBliIP5IkaFqg2LL0A0dciu9x1f6QTtWV+z0EWmg6XR3PlUV4tjpDhzRR
         YNxxYaoJvHEgcL7NzypjoJ0Y7W0zB/b7B4Keu/HIckze2c3ud1EBhw7Ze1LuGDRHFz
         B1BeX1h2qgYiwbGgTHxnDUSZQtMaDPa4JvyhOuQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.1 252/371] cifs: fix crash in smb2_compound_op()/smb2_set_next_command()
Date:   Wed, 24 Jul 2019 21:20:04 +0200
Message-Id: <20190724191743.617931993@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 88a92c913cef09e70b1744a8877d177aa6cb2189 upstream.

RHBZ: 1722704

In low memory situations the various SMB2_*_init() functions can fail
to allocate a request PDU and thus leave the request iovector as NULL.

If we don't check the return code for failure we end up calling
smb2_set_next_command() with a NULL iovector causing a crash when it tries
to dereference it.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2inode.c |   12 ++++++++++++
 fs/cifs/smb2ops.c   |   11 ++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -120,6 +120,8 @@ smb2_compound_op(const unsigned int xid,
 				SMB2_O_INFO_FILE, 0,
 				sizeof(struct smb2_file_all_info) +
 					  PATH_MAX * 2, 0, NULL);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_query_info_compound_enter(xid, ses->Suid, tcon->tid,
@@ -147,6 +149,8 @@ smb2_compound_op(const unsigned int xid,
 					COMPOUND_FID, current->tgid,
 					FILE_DISPOSITION_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_rmdir_enter(xid, ses->Suid, tcon->tid, full_path);
@@ -163,6 +167,8 @@ smb2_compound_op(const unsigned int xid,
 					COMPOUND_FID, current->tgid,
 					FILE_END_OF_FILE_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
@@ -180,6 +186,8 @@ smb2_compound_op(const unsigned int xid,
 					COMPOUND_FID, current->tgid,
 					FILE_BASIC_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_set_info_compound_enter(xid, ses->Suid, tcon->tid,
@@ -206,6 +214,8 @@ smb2_compound_op(const unsigned int xid,
 					COMPOUND_FID, current->tgid,
 					FILE_RENAME_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_rename_enter(xid, ses->Suid, tcon->tid, full_path);
@@ -231,6 +241,8 @@ smb2_compound_op(const unsigned int xid,
 					COMPOUND_FID, current->tgid,
 					FILE_LINK_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+		if (rc)
+			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_hardlink_enter(xid, ses->Suid, tcon->tid, full_path);
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2004,6 +2004,10 @@ smb2_set_related(struct smb_rqst *rqst)
 	struct smb2_sync_hdr *shdr;
 
 	shdr = (struct smb2_sync_hdr *)(rqst->rq_iov[0].iov_base);
+	if (shdr == NULL) {
+		cifs_dbg(FYI, "shdr NULL in smb2_set_related\n");
+		return;
+	}
 	shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
 }
 
@@ -2018,6 +2022,12 @@ smb2_set_next_command(struct cifs_tcon *
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
@@ -2057,7 +2067,6 @@ smb2_set_next_command(struct cifs_tcon *
 	}
 
  finished:
-	shdr = (struct smb2_sync_hdr *)(rqst->rq_iov[0].iov_base);
 	shdr->NextCommand = cpu_to_le32(len);
 }
 


