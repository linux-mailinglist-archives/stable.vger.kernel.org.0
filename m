Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB6E2FA99D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390534AbhARTBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390616AbhARLkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27BEF2245C;
        Mon, 18 Jan 2021 11:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969981;
        bh=3MmX1f5vRLSsLDhBIgQ6MPbl747hdkHM0N7BFjVHu3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNMAkQpCGWkWSZA9ZNme+qYc/uqIreoN86cScQMCacY1Nfi/2FL2mPvlrz78B0JVC
         8OjztqRyZsA16TCUCLnRUQwlhYy4+5Feu/Fzdc4iRHvb+yOEAK5GOIyH1Xk2oZKOpg
         ma2wvDo16157QT+fy0n72TjUc9niudvK7gskouqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/76] smb3: remove unused flag passed into close functions
Date:   Mon, 18 Jan 2021 12:34:22 +0100
Message-Id: <20210118113342.049743851@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 9e8fae2597405ab1deac8909928eb8e99876f639 ]

close was relayered to allow passing in an async flag which
is no longer needed in this path.  Remove the unneeded parameter
"flags" passed in on close.

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c   | 19 +++++--------------
 fs/cifs/smb2proto.h |  2 --
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7ff05c06f2a4c..c095f2e6b0825 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2945,8 +2945,8 @@ SMB2_close_free(struct smb_rqst *rqst)
 }
 
 int
-SMB2_close_flags(const unsigned int xid, struct cifs_tcon *tcon,
-		 u64 persistent_fid, u64 volatile_fid, int flags)
+SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
+		 u64 persistent_fid, u64 volatile_fid)
 {
 	struct smb_rqst rqst;
 	struct smb2_close_rsp *rsp = NULL;
@@ -2955,6 +2955,7 @@ SMB2_close_flags(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec rsp_iov;
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
+	int flags = 0;
 
 	cifs_dbg(FYI, "Close\n");
 
@@ -2993,27 +2994,17 @@ SMB2_close_flags(const unsigned int xid, struct cifs_tcon *tcon,
 close_exit:
 	SMB2_close_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
-	return rc;
-}
-
-int
-SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
-	   u64 persistent_fid, u64 volatile_fid)
-{
-	int rc;
-	int tmp_rc;
-
-	rc = SMB2_close_flags(xid, tcon, persistent_fid, volatile_fid, 0);
 
 	/* retry close in a worker thread if this one is interrupted */
 	if (rc == -EINTR) {
+		int tmp_rc;
+
 		tmp_rc = smb2_handle_cancelled_close(tcon, persistent_fid,
 						     volatile_fid);
 		if (tmp_rc)
 			cifs_dbg(VFS, "handle cancelled close fid 0x%llx returned error %d\n",
 				 persistent_fid, tmp_rc);
 	}
-
 	return rc;
 }
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 2a12a2fa38a22..57f7075a35871 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -156,8 +156,6 @@ extern int SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 
 extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
-extern int SMB2_close_flags(const unsigned int xid, struct cifs_tcon *tcon,
-			    u64 persistent_fid, u64 volatile_fid, int flags);
 extern int SMB2_close_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
 		      u64 persistent_file_id, u64 volatile_file_id);
 extern void SMB2_close_free(struct smb_rqst *rqst);
-- 
2.27.0



