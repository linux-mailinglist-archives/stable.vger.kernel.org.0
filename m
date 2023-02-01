Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2A26865E3
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 13:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbjBAMZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 07:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjBAMZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 07:25:15 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Feb 2023 04:25:14 PST
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20760457E2
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 04:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=Bknl8YBzziRlkluRYCNcInPknbR6aYwMsTkimd3N8g0=; b=dMDqhxFJlAOQQ65TVF6J5+9SPj
        /JllHCL4JuO+xM0xRopPMkHvtQCgbabHb+a4pVwXo8nmWtjuAz0semi6SfOoO66EYwlB0ZrCBlfn+
        RTY4SBFu/PsTggsQZpmjVCPc9hvlJ6aZaG8Bo9LaIe/76FGNWsRoAU9Nb+3MqJBMakkpKUWdS10y0
        XebJ9j/m59LuyDkkFnUswJxtheSQW0ueJ19oJDdGbFvzvRAZ7bidDMutRKCKFJ3jCdONTy26Mm+3P
        6UbB0BFOAuuo/itydjM7aCXfkHXxsLQV0UZIhGzY2rIFvYkm39V4NB6MwEk5iCclhVCvajCzBndIk
        eZRvsZ3Axtbk4/Yko271C/KSDCECRatpOwoNvCb+QH+PUQQcihspFWbZf4QVcTyfYNc8x/+mKYRKs
        oCBA9/ilvgGsp85KZmdW6e4X/CMY1Ymhk01tIZUycaVDz3m8ofz/1ueqYEZLsdqKQXhFpGPP35Mox
        XjqFOpGUcGzEiq7jXSjTkLXZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pNBri-00BE5t-GI; Wed, 01 Feb 2023 12:05:26 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] cifs: introduce cifs_io_parms in smb2_async_writev()
Date:   Wed,  1 Feb 2023 13:04:41 +0100
Message-Id: <ff2e9e6cff4c2082e516405f4ebe0d1338f5b67d.1675252643.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1675252643.git.metze@samba.org>
References: <cover.1675252643.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This will simplify the following changes and makes it easy to get
in passed in from the caller in future.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
---
 fs/cifs/smb2pdu.c | 53 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2d5c3df2277d..64e2c8b438f4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4504,10 +4504,27 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	struct kvec iov[1];
 	struct smb_rqst rqst = { };
 	unsigned int total_len;
+	struct cifs_io_parms _io_parms;
+	struct cifs_io_parms *io_parms = NULL;
 
 	if (!wdata->server)
 		server = wdata->server = cifs_pick_channel(tcon->ses);
 
+	/*
+	 * in future we may get cifs_io_parms passed in from the caller,
+	 * but for now we construct it here...
+	 */
+	_io_parms = (struct cifs_io_parms) {
+		.tcon = tcon,
+		.server = server,
+		.offset = wdata->offset,
+		.length = wdata->bytes,
+		.persistent_fid = wdata->cfile->fid.persistent_fid,
+		.volatile_fid = wdata->cfile->fid.volatile_fid,
+		.pid = wdata->pid,
+	};
+	io_parms = &_io_parms;
+
 	rc = smb2_plain_req_init(SMB2_WRITE, tcon, server,
 				 (void **) &req, &total_len);
 	if (rc)
@@ -4517,26 +4534,31 @@ smb2_async_writev(struct cifs_writedata *wdata,
 		flags |= CIFS_TRANSFORM_REQ;
 
 	shdr = (struct smb2_hdr *)req;
-	shdr->Id.SyncId.ProcessId = cpu_to_le32(wdata->cfile->pid);
+	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
 
-	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
-	req->VolatileFileId = wdata->cfile->fid.volatile_fid;
+	req->PersistentFileId = io_parms->persistent_fid;
+	req->VolatileFileId = io_parms->volatile_fid;
 	req->WriteChannelInfoOffset = 0;
 	req->WriteChannelInfoLength = 0;
 	req->Channel = 0;
-	req->Offset = cpu_to_le64(wdata->offset);
+	req->Offset = cpu_to_le64(io_parms->offset);
 	req->DataOffset = cpu_to_le16(
 				offsetof(struct smb2_write_req, Buffer));
 	req->RemainingBytes = 0;
 
-	trace_smb3_write_enter(0 /* xid */, wdata->cfile->fid.persistent_fid,
-		tcon->tid, tcon->ses->Suid, wdata->offset, wdata->bytes);
+	trace_smb3_write_enter(0 /* xid */,
+			       io_parms->persistent_fid,
+			       io_parms->tcon->tid,
+			       io_parms->tcon->ses->Suid,
+			       io_parms->offset,
+			       io_parms->length);
+
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
 	 * If we want to do a server RDMA read, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of write request
 	 */
-	if (server->rdma && !server->sign && wdata->bytes >=
+	if (server->rdma && !server->sign && io_parms->length >=
 		server->smbd_conn->rdma_readwrite_threshold) {
 
 		struct smbd_buffer_descriptor_v1 *v1;
@@ -4590,14 +4612,14 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	}
 #endif
 	cifs_dbg(FYI, "async write at %llu %u bytes\n",
-		 wdata->offset, wdata->bytes);
+		 io_parms->offset, io_parms->length);
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/* For RDMA read, I/O size is in RemainingBytes not in Length */
 	if (!wdata->mr)
-		req->Length = cpu_to_le32(wdata->bytes);
+		req->Length = cpu_to_le32(io_parms->length);
 #else
-	req->Length = cpu_to_le32(wdata->bytes);
+	req->Length = cpu_to_le32(io_parms->length);
 #endif
 
 	if (wdata->credits.value > 0) {
@@ -4605,7 +4627,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 						    SMB2_MAX_BUFFER_SIZE));
 		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
 
-		rc = adjust_credits(server, &wdata->credits, wdata->bytes);
+		rc = adjust_credits(server, &wdata->credits, io_parms->length);
 		if (rc)
 			goto async_writev_out;
 
@@ -4618,9 +4640,12 @@ smb2_async_writev(struct cifs_writedata *wdata,
 
 	if (rc) {
 		trace_smb3_write_err(0 /* no xid */,
-				     req->PersistentFileId,
-				     tcon->tid, tcon->ses->Suid, wdata->offset,
-				     wdata->bytes, rc);
+				     io_parms->persistent_fid,
+				     io_parms->tcon->tid,
+				     io_parms->tcon->ses->Suid,
+				     io_parms->offset,
+				     io_parms->length,
+				     rc);
 		kref_put(&wdata->refcount, release);
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 	}
-- 
2.34.1

