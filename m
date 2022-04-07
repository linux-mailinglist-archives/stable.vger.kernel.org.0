Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380564F6FD5
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbiDGBOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiDGBNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:13:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD52181D94;
        Wed,  6 Apr 2022 18:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F12CF61DBA;
        Thu,  7 Apr 2022 01:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDE1C385A1;
        Thu,  7 Apr 2022 01:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293873;
        bh=76DJXd6Fli9lN8T8svIoL6KictAqBIBfTueJkfIe6Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amSfLqtDy07q9+Bqet2T1R3Y4dUvcZoEYqAieSSgVjcb+8IU0v+mprkGxSEtFcqQl
         FKBskb/VtacuAcYZFZQmM/ZvHU/7PNzELAeS0w8M1XG5FI4YWVGNjwhk0iGmEsEVxR
         gPJb+xEqreO+GsrINoI4dG3y5FYRRqHKMz2eBDM55D7wdh9iPNBMI02CuRbV2RX6TS
         iRPmWOPh2F2TGj2hwk2X+77ZgGjyX1fBf50xhpkE6bYIlK9xoE76ZjrQKY/w9fB4gh
         fVDu8zb00Ki5QXF7QttRm6jGDtjIAaBYAQaA7Sj9BKhDaHYm08mUjVeFp+vkHPZhWN
         uOqTgnvk9JMHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.17 21/31] smb3: cleanup and clarify status of tree connections
Date:   Wed,  6 Apr 2022 21:10:19 -0400
Message-Id: <20220407011029.113321-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011029.113321-1-sashal@kernel.org>
References: <20220407011029.113321-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit fdf59eb548e51bce81382c39f1a5fd4cb9403b78 ]

Currently the way the tid (tree connection) status is tracked
is confusing.  The same enum is used for structs cifs_tcon
and cifs_ses and TCP_Server_info, but each of these three has
different states that they transition among.  The current
code also unnecessarily uses camelCase.

Convert from use of statusEnum to a new tid_status_enum for
tree connections.  The valid states for a tid are:

        TID_NEW = 0,
        TID_GOOD,
        TID_EXITING,
        TID_NEED_RECON,
        TID_NEED_TCON,
        TID_IN_TCON,
        TID_NEED_FILES_INVALIDATE, /* unused, considering removing in future */
        TID_IN_FILES_INVALIDATE

It also removes CifsNeedTcon, CifsInTcon, CifsNeedFilesInvalidate and
CifsInFilesInvalidate from the statusEnum used for session and
TCP_Server_Info since they are not relevant for those.

A follow on patch will fix the places where we use the
tcon->need_reconnect flag to be more consistent with the tid->status.

Also fixes a bug that was:
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_debug.c |  2 +-
 fs/cifs/cifsfs.c     |  4 ++--
 fs/cifs/cifsglob.h   | 18 +++++++++++++-----
 fs/cifs/cifssmb.c    | 11 +++++------
 fs/cifs/connect.c    | 32 ++++++++++++++++----------------
 fs/cifs/misc.c       |  2 +-
 fs/cifs/smb2pdu.c    |  4 ++--
 7 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index ea00e1a91250..9d334816eac0 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -94,7 +94,7 @@ static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
 		   le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
 		   le32_to_cpu(tcon->fsAttrInfo.Attributes),
 		   le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
-		   tcon->tidStatus);
+		   tcon->status);
 	if (dev_type == FILE_DEVICE_DISK)
 		seq_puts(m, " type: DISK ");
 	else if (dev_type == FILE_DEVICE_CD_ROM)
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 082c21478686..783b48d1d9ec 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -691,14 +691,14 @@ static void cifs_umount_begin(struct super_block *sb)
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
 	spin_lock(&cifs_tcp_ses_lock);
-	if ((tcon->tc_count > 1) || (tcon->tidStatus == CifsExiting)) {
+	if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
 		/* we have other mounts to same share or we have
 		   already tried to force umount this and woken up
 		   all waiting network requests, nothing to do */
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	} else if (tcon->tc_count == 1)
-		tcon->tidStatus = CifsExiting;
+		tcon->status = TID_EXITING;
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 48b343d03430..560ecc4ad87d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -115,10 +115,18 @@ enum statusEnum {
 	CifsInNegotiate,
 	CifsNeedSessSetup,
 	CifsInSessSetup,
-	CifsNeedTcon,
-	CifsInTcon,
-	CifsNeedFilesInvalidate,
-	CifsInFilesInvalidate
+};
+
+/* associated with each tree connection to the server */
+enum tid_status_enum {
+	TID_NEW = 0,
+	TID_GOOD,
+	TID_EXITING,
+	TID_NEED_RECON,
+	TID_NEED_TCON,
+	TID_IN_TCON,
+	TID_NEED_FILES_INVALIDATE, /* currently unused */
+	TID_IN_FILES_INVALIDATE
 };
 
 enum securityEnum {
@@ -1038,7 +1046,7 @@ struct cifs_tcon {
 	char *password;		/* for share-level security */
 	__u32 tid;		/* The 4 byte tree id */
 	__u16 Flags;		/* optional support bits */
-	enum statusEnum tidStatus;
+	enum tid_status_enum status;
 	atomic_t num_smbs_sent;
 	union {
 		struct {
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 071e2f21a7db..aca9338b0877 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -75,12 +75,11 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 
 	/* only send once per connect */
 	spin_lock(&cifs_tcp_ses_lock);
-	if (tcon->ses->status != CifsGood ||
-	    tcon->tidStatus != CifsNeedReconnect) {
+	if ((tcon->ses->status != CifsGood) || (tcon->status != TID_NEED_RECON)) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	}
-	tcon->tidStatus = CifsInFilesInvalidate;
+	tcon->status = TID_IN_FILES_INVALIDATE;
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* list all files open on tree connection and mark them invalid */
@@ -100,8 +99,8 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	mutex_unlock(&tcon->crfid.fid_mutex);
 
 	spin_lock(&cifs_tcp_ses_lock);
-	if (tcon->tidStatus == CifsInFilesInvalidate)
-		tcon->tidStatus = CifsNeedTcon;
+	if (tcon->status == TID_IN_FILES_INVALIDATE)
+		tcon->status = TID_NEED_TCON;
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/*
@@ -136,7 +135,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * have tcon) are allowed as we start force umount
 	 */
 	spin_lock(&cifs_tcp_ses_lock);
-	if (tcon->tidStatus == CifsExiting) {
+	if (tcon->status == TID_EXITING) {
 		if (smb_command != SMB_COM_WRITE_ANDX &&
 		    smb_command != SMB_COM_OPEN_ANDX &&
 		    smb_command != SMB_COM_TREE_DISCONNECT) {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d3020abfe404..570719deeb04 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -205,7 +205,7 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			tcon->need_reconnect = true;
-			tcon->tidStatus = CifsNeedReconnect;
+			tcon->status = TID_NEED_RECON;
 		}
 		if (ses->tcon_ipc)
 			ses->tcon_ipc->need_reconnect = true;
@@ -2167,7 +2167,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 static int match_tcon(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
-	if (tcon->tidStatus == CifsExiting)
+	if (tcon->status == TID_EXITING)
 		return 0;
 	if (strncmp(tcon->treeName, ctx->UNC, MAX_TREE_SIZE))
 		return 0;
@@ -4438,12 +4438,12 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	/* only send once per connect */
 	spin_lock(&cifs_tcp_ses_lock);
 	if (tcon->ses->status != CifsGood ||
-	    (tcon->tidStatus != CifsNew &&
-	    tcon->tidStatus != CifsNeedTcon)) {
+	    (tcon->status != TID_NEW &&
+	    tcon->status != TID_NEED_TCON)) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return 0;
 	}
-	tcon->tidStatus = CifsInTcon;
+	tcon->status = TID_IN_TCON;
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
@@ -4484,13 +4484,13 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	if (rc) {
 		spin_lock(&cifs_tcp_ses_lock);
-		if (tcon->tidStatus == CifsInTcon)
-			tcon->tidStatus = CifsNeedTcon;
+		if (tcon->status == TID_IN_TCON)
+			tcon->status = TID_NEED_TCON;
 		spin_unlock(&cifs_tcp_ses_lock);
 	} else {
 		spin_lock(&cifs_tcp_ses_lock);
-		if (tcon->tidStatus == CifsInTcon)
-			tcon->tidStatus = CifsGood;
+		if (tcon->status == TID_IN_TCON)
+			tcon->status = TID_GOOD;
 		spin_unlock(&cifs_tcp_ses_lock);
 		tcon->need_reconnect = false;
 	}
@@ -4506,24 +4506,24 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	/* only send once per connect */
 	spin_lock(&cifs_tcp_ses_lock);
 	if (tcon->ses->status != CifsGood ||
-	    (tcon->tidStatus != CifsNew &&
-	    tcon->tidStatus != CifsNeedTcon)) {
+	    (tcon->status != TID_NEW &&
+	    tcon->status != TID_NEED_TCON)) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return 0;
 	}
-	tcon->tidStatus = CifsInTcon;
+	tcon->status = TID_IN_TCON;
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
 	if (rc) {
 		spin_lock(&cifs_tcp_ses_lock);
-		if (tcon->tidStatus == CifsInTcon)
-			tcon->tidStatus = CifsNeedTcon;
+		if (tcon->status == TID_IN_TCON)
+			tcon->status = TID_NEED_TCON;
 		spin_unlock(&cifs_tcp_ses_lock);
 	} else {
 		spin_lock(&cifs_tcp_ses_lock);
-		if (tcon->tidStatus == CifsInTcon)
-			tcon->tidStatus = CifsGood;
+		if (tcon->status == TID_IN_TCON)
+			tcon->status = TID_GOOD;
 		spin_unlock(&cifs_tcp_ses_lock);
 		tcon->need_reconnect = false;
 	}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 56598f7dbe00..afaf59c22193 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -116,7 +116,7 @@ tconInfoAlloc(void)
 	}
 
 	atomic_inc(&tconInfoAllocCount);
-	ret_buf->tidStatus = CifsNew;
+	ret_buf->status = TID_NEW;
 	++ret_buf->tc_count;
 	INIT_LIST_HEAD(&ret_buf->openFileList);
 	INIT_LIST_HEAD(&ret_buf->tcon_list);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7e7909b1ae11..b13b17480b3b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -163,7 +163,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		return 0;
 
 	spin_lock(&cifs_tcp_ses_lock);
-	if (tcon->tidStatus == CifsExiting) {
+	if (tcon->status == TID_EXITING) {
 		/*
 		 * only tree disconnect, open, and write,
 		 * (and ulogoff which does not have tcon)
@@ -3863,7 +3863,7 @@ void smb2_reconnect_server(struct work_struct *work)
 		goto done;
 	}
 
-	tcon->tidStatus = CifsGood;
+	tcon->status = TID_GOOD;
 	tcon->retry = false;
 	tcon->need_reconnect = false;
 
-- 
2.35.1

