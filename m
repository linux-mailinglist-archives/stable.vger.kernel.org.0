Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738CA33B996
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbhCOOGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231949AbhCOOBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72E5B64D9E;
        Mon, 15 Mar 2021 14:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816903;
        bh=MjBuoI8VOm3CU0h0mIm3IIaPbh9+I2rHn3xThAtezcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uv2vohqXkwtCti/RiZH2DVM04Ir+QxSatNuettnVS8tWVX0vzbEL0y2y2B+KPwGwV
         W6sTDN4vn36nUSvbdEUHVpZEfkzc+PvzGo0BwX//DiN2Y+YSFIbub8A2o5t1SjdMuB
         BwYmp56Sjz4bvSYdhzFFT3qBlrigrwOczlTcMM6E=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 192/306] cifs: do not send close in compound create+close requests
Date:   Mon, 15 Mar 2021 14:54:15 +0100
Message-Id: <20210315135514.102814591@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Paulo Alcantara <pc@cjr.nz>

commit 04ad69c342fc4de5bd23be9ef15ea7574fb1a87e upstream.

In case of interrupted syscalls, prevent sending CLOSE commands for
compound CREATE+CLOSE requests by introducing an
CIFS_CP_CREATE_CLOSE_OP flag to indicate lower layers that it should
not send a CLOSE command to the MIDs corresponding the compound
CREATE+CLOSE request.

A simple reproducer:

    #!/bin/bash

    mount //server/share /mnt -o username=foo,password=***
    tc qdisc add dev eth0 root netem delay 450ms
    stat -f /mnt &>/dev/null & pid=$!
    sleep 0.01
    kill $pid
    tc qdisc del dev eth0 root
    umount /mnt

Before patch:

    ...
    6 0.256893470 192.168.122.2 → 192.168.122.15 SMB2 402 Create Request File: ;GetInfo Request FS_INFO/FileFsFullSizeInformation;Close Request
    7 0.257144491 192.168.122.15 → 192.168.122.2 SMB2 498 Create Response File: ;GetInfo Response;Close Response
    9 0.260798209 192.168.122.2 → 192.168.122.15 SMB2 146 Close Request File:
   10 0.260841089 192.168.122.15 → 192.168.122.2 SMB2 130 Close Response, Error: STATUS_FILE_CLOSED

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsglob.h  |   11 ++++++-----
 fs/cifs/smb2inode.c |    1 +
 fs/cifs/smb2misc.c  |    8 ++++----
 fs/cifs/smb2ops.c   |   10 +++++-----
 fs/cifs/smb2proto.h |    3 +--
 fs/cifs/transport.c |    2 +-
 6 files changed, 18 insertions(+), 17 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -256,7 +256,7 @@ struct smb_version_operations {
 	/* verify the message */
 	int (*check_message)(char *, unsigned int, struct TCP_Server_Info *);
 	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
-	int (*handle_cancelled_mid)(char *, struct TCP_Server_Info *);
+	int (*handle_cancelled_mid)(struct mid_q_entry *, struct TCP_Server_Info *);
 	void (*downgrade_oplock)(struct TCP_Server_Info *server,
 				 struct cifsInodeInfo *cinode, __u32 oplock,
 				 unsigned int epoch, bool *purge_cache);
@@ -1701,10 +1701,11 @@ static inline bool is_retryable_error(in
 #define   CIFS_NO_RSP_BUF   0x040    /* no response buffer required */
 
 /* Type of request operation */
-#define   CIFS_ECHO_OP      0x080    /* echo request */
-#define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
-#define   CIFS_NEG_OP      0x0200    /* negotiate request */
-#define   CIFS_OP_MASK     0x0380    /* mask request type */
+#define   CIFS_ECHO_OP            0x080  /* echo request */
+#define   CIFS_OBREAK_OP          0x0100 /* oplock break request */
+#define   CIFS_NEG_OP             0x0200 /* negotiate request */
+#define   CIFS_CP_CREATE_CLOSE_OP 0x0400 /* compound create+close request */
+#define   CIFS_OP_MASK            0x0780 /* mask request type */
 
 #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
 #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sending */
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -358,6 +358,7 @@ smb2_compound_op(const unsigned int xid,
 	if (cfile)
 		goto after_close;
 	/* Close */
+	flags |= CIFS_CP_CREATE_CLOSE_OP;
 	rqst[num_rqst].rq_iov = &vars->close_iov[0];
 	rqst[num_rqst].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, server,
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -844,14 +844,14 @@ smb2_handle_cancelled_close(struct cifs_
 }
 
 int
-smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
+smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
-	struct smb2_sync_hdr *sync_hdr = (struct smb2_sync_hdr *)buffer;
-	struct smb2_create_rsp *rsp = (struct smb2_create_rsp *)buffer;
+	struct smb2_sync_hdr *sync_hdr = mid->resp_buf;
+	struct smb2_create_rsp *rsp = mid->resp_buf;
 	struct cifs_tcon *tcon;
 	int rc;
 
-	if (sync_hdr->Command != SMB2_CREATE ||
+	if ((mid->optype & CIFS_CP_CREATE_CLOSE_OP) || sync_hdr->Command != SMB2_CREATE ||
 	    sync_hdr->Status != STATUS_SUCCESS)
 		return 0;
 
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1164,7 +1164,7 @@ smb2_set_ea(const unsigned int xid, stru
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
 	__le16 *utf16_path = NULL;
 	int ea_name_len = strlen(ea_name);
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	int len;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
@@ -1542,7 +1542,7 @@ smb2_ioctl_query_info(const unsigned int
 	struct smb_query_info qi;
 	struct smb_query_info __user *pqi;
 	int rc = 0;
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	struct smb2_query_info_rsp *qi_rsp = NULL;
 	struct smb2_ioctl_rsp *io_rsp = NULL;
 	void *buffer = NULL;
@@ -2516,7 +2516,7 @@ smb2_query_info_compound(const unsigned
 {
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
 	struct kvec rsp_iov[3];
@@ -2914,7 +2914,7 @@ smb2_query_symlink(const unsigned int xi
 	unsigned int sub_offset;
 	unsigned int print_len;
 	unsigned int print_offset;
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
 	struct kvec rsp_iov[3];
@@ -3096,7 +3096,7 @@ smb2_query_reparse_tag(const unsigned in
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
 	struct kvec rsp_iov[3];
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -246,8 +246,7 @@ extern int SMB2_oplock_break(const unsig
 extern int smb2_handle_cancelled_close(struct cifs_tcon *tcon,
 				       __u64 persistent_fid,
 				       __u64 volatile_fid);
-extern int smb2_handle_cancelled_mid(char *buffer,
-					struct TCP_Server_Info *server);
+extern int smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server);
 void smb2_cancelled_close_fid(struct work_struct *work);
 extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 			 u64 persistent_file_id, u64 volatile_file_id,
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -101,7 +101,7 @@ static void _cifs_mid_q_entry_release(st
 	if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
 	    midEntry->mid_state == MID_RESPONSE_RECEIVED &&
 	    server->ops->handle_cancelled_mid)
-		server->ops->handle_cancelled_mid(midEntry->resp_buf, server);
+		server->ops->handle_cancelled_mid(midEntry, server);
 
 	midEntry->mid_state = MID_FREE;
 	atomic_dec(&midCount);


