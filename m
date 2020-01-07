Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A0F1333ED
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgAGVBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgAGVBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5445E20678;
        Tue,  7 Jan 2020 21:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430908;
        bh=DqfXjYHAgHZqv84WzodfCpB6d+/ao7YuK6XlquCQias=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Txs4YoKgnb2FziPW0cl88Ubzea1Cs3XqpaZ1GWtZatUCmn8Isk3KzD6o1MSiEUn0G
         yVVPrnZMIQ9x68em3znVhT/di12OL5jaqEsDH9wBL+iwnWen9gaySMKEVssIF/IAtN
         pRhFhMPy+g8l5Am4V1zO+b0jxhiUSHfkh1E7lzl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 146/191] cifs: Fix potential softlockups while refreshing DFS cache
Date:   Tue,  7 Jan 2020 21:54:26 +0100
Message-Id: <20200107205340.787098324@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara (SUSE) <pc@cjr.nz>

commit 84a1f5b1cc6fd7f6cd99fc5630c36f631b19fa60 upstream.

We used to skip reconnects on all SMB2_IOCTL commands due to SMB3+
FSCTL_VALIDATE_NEGOTIATE_INFO - which made sense since we're still
establishing a SMB session.

However, when refresh_cache_worker() calls smb2_get_dfs_refer() and
we're under reconnect, SMB2_ioctl() will not be able to get a proper
status error (e.g. -EHOSTDOWN in case we failed to reconnect) but an
-EAGAIN from cifs_send_recv() thus looping forever in
refresh_cache_worker().

Fixes: e99c63e4d86d ("SMB3: Fix deadlock in validate negotiate hits reconnect")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Suggested-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -252,7 +252,7 @@ smb2_reconnect(__le16 smb2_command, stru
 	if (tcon == NULL)
 		return 0;
 
-	if (smb2_command == SMB2_TREE_CONNECT || smb2_command == SMB2_IOCTL)
+	if (smb2_command == SMB2_TREE_CONNECT)
 		return 0;
 
 	if (tcon->tidStatus == CifsExiting) {
@@ -426,16 +426,9 @@ fill_small_buf(__le16 smb2_command, stru
  * SMB information in the SMB header. If the return code is zero, this
  * function must have filled in request_buf pointer.
  */
-static int
-smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
-		    void **request_buf, unsigned int *total_len)
+static int __smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
+				  void **request_buf, unsigned int *total_len)
 {
-	int rc;
-
-	rc = smb2_reconnect(smb2_command, tcon);
-	if (rc)
-		return rc;
-
 	/* BB eventually switch this to SMB2 specific small buf size */
 	if (smb2_command == SMB2_SET_INFO)
 		*request_buf = cifs_buf_get();
@@ -456,7 +449,31 @@ smb2_plain_req_init(__le16 smb2_command,
 		cifs_stats_inc(&tcon->num_smbs_sent);
 	}
 
-	return rc;
+	return 0;
+}
+
+static int smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
+			       void **request_buf, unsigned int *total_len)
+{
+	int rc;
+
+	rc = smb2_reconnect(smb2_command, tcon);
+	if (rc)
+		return rc;
+
+	return __smb2_plain_req_init(smb2_command, tcon, request_buf,
+				     total_len);
+}
+
+static int smb2_ioctl_req_init(u32 opcode, struct cifs_tcon *tcon,
+			       void **request_buf, unsigned int *total_len)
+{
+	/* Skip reconnect only for FSCTL_VALIDATE_NEGOTIATE_INFO IOCTLs */
+	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO) {
+		return __smb2_plain_req_init(SMB2_IOCTL, tcon, request_buf,
+					     total_len);
+	}
+	return smb2_plain_req_init(SMB2_IOCTL, tcon, request_buf, total_len);
 }
 
 /* For explanation of negotiate contexts see MS-SMB2 section 2.2.3.1 */
@@ -2661,7 +2678,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 	int rc;
 	char *in_data_buf;
 
-	rc = smb2_plain_req_init(SMB2_IOCTL, tcon, (void **) &req, &total_len);
+	rc = smb2_ioctl_req_init(opcode, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 


