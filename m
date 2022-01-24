Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC024995F0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbiAXU5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:57:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46710 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442133AbiAXUxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:53:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A956D611DA;
        Mon, 24 Jan 2022 20:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA6EC340E5;
        Mon, 24 Jan 2022 20:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057601;
        bh=wKeoF4KVuNIMj/NAwyFfmj59Rac6LZagk23kK+eb/6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZKdZV1WlkNIvqX+5ZAs4luAcCAaLsjgWTdC1vDy48F7jnP/XyoiN/95nZ3sstP0a
         nMi2XbDqjzPUv3s7BSApnlJjwvvZJYf4BPsDqRhtTTXmmdfte7y/CMezOvTCi0IMSz
         Htby/RpYg3pAe7NmMELuDMCvotoeJcsneatoXbUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16 0009/1039] cifs: free ntlmsspblob allocated in negotiate
Date:   Mon, 24 Jan 2022 19:29:58 +0100
Message-Id: <20220124184125.451931499@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit e3548aaf41a200c2af359462be23bcdd76efd795 upstream.

One of my previous fixes:
cifs: send workstation name during ntlmssp session setup
...changed the prototype of build_ntlmssp_negotiate_blob
from being allocated by the caller to being allocated within
the function. The caller needs to free this object too.
While SMB2 version of the caller did it, I forgot to free
for the SMB1 version. Fixing that here.

Fixes: 49bd49f983b5 ("cifs: send workstation name during ntlmssp session setup")
Cc: stable@vger.kernel.org # 5.16
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/sess.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1354,7 +1354,7 @@ sess_auth_rawntlmssp_negotiate(struct se
 				     &blob_len, ses,
 				     sess_data->nls_cp);
 	if (rc)
-		goto out;
+		goto out_free_ntlmsspblob;
 
 	sess_data->iov[1].iov_len = blob_len;
 	sess_data->iov[1].iov_base = ntlmsspblob;
@@ -1362,7 +1362,7 @@ sess_auth_rawntlmssp_negotiate(struct se
 
 	rc = _sess_auth_rawntlmssp_assemble_req(sess_data);
 	if (rc)
-		goto out;
+		goto out_free_ntlmsspblob;
 
 	rc = sess_sendreceive(sess_data);
 
@@ -1376,14 +1376,14 @@ sess_auth_rawntlmssp_negotiate(struct se
 		rc = 0;
 
 	if (rc)
-		goto out;
+		goto out_free_ntlmsspblob;
 
 	cifs_dbg(FYI, "rawntlmssp session setup challenge phase\n");
 
 	if (smb_buf->WordCount != 4) {
 		rc = -EIO;
 		cifs_dbg(VFS, "bad word count %d\n", smb_buf->WordCount);
-		goto out;
+		goto out_free_ntlmsspblob;
 	}
 
 	ses->Suid = smb_buf->Uid;   /* UID left in wire format (le) */
@@ -1397,10 +1397,13 @@ sess_auth_rawntlmssp_negotiate(struct se
 		cifs_dbg(VFS, "bad security blob length %d\n",
 				blob_len);
 		rc = -EINVAL;
-		goto out;
+		goto out_free_ntlmsspblob;
 	}
 
 	rc = decode_ntlmssp_challenge(bcc_ptr, blob_len, ses);
+
+out_free_ntlmsspblob:
+	kfree(ntlmsspblob);
 out:
 	sess_free_buffer(sess_data);
 


