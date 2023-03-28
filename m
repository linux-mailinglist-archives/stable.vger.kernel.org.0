Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6054B6CC41D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbjC1PAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjC1PAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:00:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9D4EB5B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 181A361820
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE2DC433D2;
        Tue, 28 Mar 2023 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015598;
        bh=SgqoHIgtuQPGkNziJ8BUUarq90YDbv98aczo1k/SxiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCiX6KYSCPURFRKL2t8rATtXi1QXC/GN253tFu2pNPKlo/X9AysSXyj/XHGDhTNnS
         AQuSBFB9lnSu8dRh4izLyKPhctGtf4bhiMviu/NipnuCo7yRzfDItHGYc4ZKpfA3XD
         W2EJL2VFQpMI30GkB9JXHrbgsrEECRRTs0Dwc+kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 106/224] smb3: fix unusable share after force unmount failure
Date:   Tue, 28 Mar 2023 16:41:42 +0200
Message-Id: <20230328142621.756704729@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 491eafce1a51c457701351a4bf40733799745314 upstream.

If user does forced unmount ("umount -f") while files are still open
on the share (as was seen in a Kubernetes example running on SMB3.1.1
mount) then we were marking the share as "TID_EXITING" in umount_begin()
which caused all subsequent operations (except write) to fail ... but
unfortunately when umount_begin() is called we do not know yet that
there are open files or active references on the share that would prevent
unmount from succeeding.  Kubernetes had example when they were doing
umount -f when files were open which caused the share to become
unusable until the files were closed (and the umount retried).

Fix this so that TID_EXITING is not set until we are about to send
the tree disconnect (not at the beginning of forced umounts in
umount_begin) so that if "umount -f" fails (due to open files or
references) the mount is still usable.

Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c  |    9 ++++++---
 fs/cifs/cifssmb.c |    6 ++----
 fs/cifs/connect.c |    1 +
 fs/cifs/smb2pdu.c |    8 ++------
 4 files changed, 11 insertions(+), 13 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -730,13 +730,16 @@ static void cifs_umount_begin(struct sup
 	spin_lock(&tcon->tc_lock);
 	if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
 		/* we have other mounts to same share or we have
-		   already tried to force umount this and woken up
+		   already tried to umount this and woken up
 		   all waiting network requests, nothing to do */
 		spin_unlock(&tcon->tc_lock);
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
-	} else if (tcon->tc_count == 1)
-		tcon->status = TID_EXITING;
+	}
+	/*
+	 * can not set tcon->status to TID_EXITING yet since we don't know if umount -f will
+	 * fail later (e.g. due to open files).  TID_EXITING will be set just before tdis req sent
+	 */
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -85,13 +85,11 @@ cifs_reconnect_tcon(struct cifs_tcon *tc
 
 	/*
 	 * only tree disconnect, open, and write, (and ulogoff which does not
-	 * have tcon) are allowed as we start force umount
+	 * have tcon) are allowed as we start umount
 	 */
 	spin_lock(&tcon->tc_lock);
 	if (tcon->status == TID_EXITING) {
-		if (smb_command != SMB_COM_WRITE_ANDX &&
-		    smb_command != SMB_COM_OPEN_ANDX &&
-		    smb_command != SMB_COM_TREE_DISCONNECT) {
+		if (smb_command != SMB_COM_TREE_DISCONNECT) {
 			spin_unlock(&tcon->tc_lock);
 			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
 				 smb_command);
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2365,6 +2365,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	WARN_ON(tcon->tc_count < 0);
 
 	list_del_init(&tcon->tcon_list);
+	tcon->status = TID_EXITING;
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -225,13 +225,9 @@ smb2_reconnect(__le16 smb2_command, stru
 	spin_lock(&tcon->tc_lock);
 	if (tcon->status == TID_EXITING) {
 		/*
-		 * only tree disconnect, open, and write,
-		 * (and ulogoff which does not have tcon)
-		 * are allowed as we start force umount.
+		 * only tree disconnect allowed when disconnecting ...
 		 */
-		if ((smb2_command != SMB2_WRITE) &&
-		   (smb2_command != SMB2_CREATE) &&
-		   (smb2_command != SMB2_TREE_DISCONNECT)) {
+		if (smb2_command != SMB2_TREE_DISCONNECT) {
 			spin_unlock(&tcon->tc_lock);
 			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
 				 smb2_command);


