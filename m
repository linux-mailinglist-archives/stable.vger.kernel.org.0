Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A05E339A1D
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 00:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhCLXoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 18:44:06 -0500
Received: from mx.cjr.nz ([51.158.111.142]:43630 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235865AbhCLXoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 18:44:00 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Mar 2021 18:44:00 EST
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 009D57FF6A;
        Fri, 12 Mar 2021 23:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1615592158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jnLgcySkCRSyxT0PomI84XiXznoy+UbogkcoWN2gZ7c=;
        b=dRRMQGt8UOuRnJNbFORsblT9DTsvJlijjKnB45/1PSHB2b0RZPhflTjySpl9uigltL7qrT
        QNEexZ/g2J7Egtuojs8p+qZ3eZVZc6CSaykwI3VemF6f/6tMEZe5HHJbZI6kQwjiIMmwgx
        N7IrGUJLlox8YWva6O6NAbNGqvlWB66AWvYHQZMyNPqJRjqQy0guOiGmCOaYUzedtHw6xb
        IQWmZm9a/a6azZVcacQ1SYSGJ3KJJjR1G+bC8+EQmgqUi/dHYIDDWFiJvcKVuRs/XkUuVC
        Y6ywhproTALF71ca+60uDWbD5QzCIetb4RmPXgzloiE3PUOLzQlnaQOV38kmzg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     gregkh@linuxfoundation.org, aaptel@suse.com, lsahlber@redhat.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cifs: do not send close in compound
 create+close requests" failed to apply to 5.10-stable tree
In-Reply-To: <1615543505112255@kroah.com>
References: <1615543505112255@kroah.com>
Date:   Fri, 12 Mar 2021 20:35:52 -0300
Message-ID: <87tupglzc7.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Greg,

<gregkh@linuxfoundation.org> writes:

> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I've attached the backport of

        04ad69c342fc ("cifs: do not send close in compound create+close requests")

for 5.10+ stable trees.

--=-=-=
Content-Type: text/x-patch; charset=utf-8
Content-Disposition: inline;
 filename=0001-cifs-do-not-send-close-in-compound-create-close-requ.patch
Content-Transfer-Encoding: quoted-printable

From 04ad69c342fc4de5bd23be9ef15ea7574fb1a87e Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@cjr.nz>
Date: Mon, 8 Mar 2021 12:00:50 -0300
Subject: [PATCH] cifs: do not send close in compound create+close requests

In case of interrupted syscalls, prevent sending CLOSE commands for
compound CREATE+CLOSE requests by introducing an
CIFS_CP_CREATE_CLOSE_OP flag to indicate lower layers that it should
not send a CLOSE command to the MIDs corresponding the compound
CREATE+CLOSE request.

A simple reproducer:

    #!/bin/bash

    mount //server/share /mnt -o username=3Dfoo,password=3D***
    tc qdisc add dev eth0 root netem delay 450ms
    stat -f /mnt &>/dev/null & pid=3D$!
    sleep 0.01
    kill $pid
    tc qdisc del dev eth0 root
    umount /mnt

Before patch:

    ...
    6 0.256893470 192.168.122.2 =E2=86=92 192.168.122.15 SMB2 402 Create Re=
quest File: ;GetInfo Request FS_INFO/FileFsFullSizeInformation;Close Request
    7 0.257144491 192.168.122.15 =E2=86=92 192.168.122.2 SMB2 498 Create Re=
sponse File: ;GetInfo Response;Close Response
    9 0.260798209 192.168.122.2 =E2=86=92 192.168.122.15 SMB2 146 Close Req=
uest File:
   10 0.260841089 192.168.122.15 =E2=86=92 192.168.122.2 SMB2 130 Close Res=
ponse, Error: STATUS_FILE_CLOSED

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
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
+	int (*handle_cancelled_mid)(struct mid_q_entry *, struct TCP_Server_Info =
*);
 	void (*downgrade_oplock)(struct TCP_Server_Info *server,
 				 struct cifsInodeInfo *cinode, __u32 oplock,
 				 unsigned int epoch, bool *purge_cache);
@@ -1701,10 +1701,11 @@ static inline bool is_retryable_error(in
 #define   CIFS_NO_RSP_BUF   0x040    /* no response buffer required */
=20
 /* Type of request operation */
-#define   CIFS_ECHO_OP      0x080    /* echo request */
-#define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
-#define   CIFS_NEG_OP      0x0200    /* negotiate request */
-#define   CIFS_OP_MASK     0x0380    /* mask request type */
+#define   CIFS_ECHO_OP            0x080  /* echo request */
+#define   CIFS_OBREAK_OP          0x0100 /* oplock break request */
+#define   CIFS_NEG_OP             0x0200 /* negotiate request */
+#define   CIFS_CP_CREATE_CLOSE_OP 0x0400 /* compound create+close request =
*/
+#define   CIFS_OP_MASK            0x0780 /* mask request type */
=20
 #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
 #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sending=
 */
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -358,6 +358,7 @@ smb2_compound_op(const unsigned int xid,
 	if (cfile)
 		goto after_close;
 	/* Close */
+	flags |=3D CIFS_CP_CREATE_CLOSE_OP;
 	rqst[num_rqst].rq_iov =3D &vars->close_iov[0];
 	rqst[num_rqst].rq_nvec =3D 1;
 	rc =3D SMB2_close_init(tcon, server,
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -844,14 +844,14 @@ smb2_handle_cancelled_close(struct cifs_
 }
=20
 int
-smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
+smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info =
*server)
 {
-	struct smb2_sync_hdr *sync_hdr =3D (struct smb2_sync_hdr *)buffer;
-	struct smb2_create_rsp *rsp =3D (struct smb2_create_rsp *)buffer;
+	struct smb2_sync_hdr *sync_hdr =3D mid->resp_buf;
+	struct smb2_create_rsp *rsp =3D mid->resp_buf;
 	struct cifs_tcon *tcon;
 	int rc;
=20
-	if (sync_hdr->Command !=3D SMB2_CREATE ||
+	if ((mid->optype & CIFS_CP_CREATE_CLOSE_OP) || sync_hdr->Command !=3D SMB=
2_CREATE ||
 	    sync_hdr->Status !=3D STATUS_SUCCESS)
 		return 0;
=20
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1164,7 +1164,7 @@ smb2_set_ea(const unsigned int xid, stru
 	struct TCP_Server_Info *server =3D cifs_pick_channel(ses);
 	__le16 *utf16_path =3D NULL;
 	int ea_name_len =3D strlen(ea_name);
-	int flags =3D 0;
+	int flags =3D CIFS_CP_CREATE_CLOSE_OP;
 	int len;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
@@ -1542,7 +1542,7 @@ smb2_ioctl_query_info(const unsigned int
 	struct smb_query_info qi;
 	struct smb_query_info __user *pqi;
 	int rc =3D 0;
-	int flags =3D 0;
+	int flags =3D CIFS_CP_CREATE_CLOSE_OP;
 	struct smb2_query_info_rsp *qi_rsp =3D NULL;
 	struct smb2_ioctl_rsp *io_rsp =3D NULL;
 	void *buffer =3D NULL;
@@ -2516,7 +2516,7 @@ smb2_query_info_compound(const unsigned
 {
 	struct cifs_ses *ses =3D tcon->ses;
 	struct TCP_Server_Info *server =3D cifs_pick_channel(ses);
-	int flags =3D 0;
+	int flags =3D CIFS_CP_CREATE_CLOSE_OP;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
 	struct kvec rsp_iov[3];
@@ -2914,7 +2914,7 @@ smb2_query_symlink(const unsigned int xi
 	unsigned int sub_offset;
 	unsigned int print_len;
 	unsigned int print_offset;
-	int flags =3D 0;
+	int flags =3D CIFS_CP_CREATE_CLOSE_OP;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
 	struct kvec rsp_iov[3];
@@ -3096,7 +3096,7 @@ smb2_query_reparse_tag(const unsigned in
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 	struct TCP_Server_Info *server =3D cifs_pick_channel(tcon->ses);
-	int flags =3D 0;
+	int flags =3D CIFS_CP_CREATE_CLOSE_OP;
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
+extern int smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_S=
erver_Info *server);
 void smb2_cancelled_close_fid(struct work_struct *work);
 extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 			 u64 persistent_file_id, u64 volatile_file_id,
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -101,7 +101,7 @@ static void _cifs_mid_q_entry_release(st
 	if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
 	    midEntry->mid_state =3D=3D MID_RESPONSE_RECEIVED &&
 	    server->ops->handle_cancelled_mid)
-		server->ops->handle_cancelled_mid(midEntry->resp_buf, server);
+		server->ops->handle_cancelled_mid(midEntry, server);
=20
 	midEntry->mid_state =3D MID_FREE;
 	atomic_dec(&midCount);

--=-=-=--
