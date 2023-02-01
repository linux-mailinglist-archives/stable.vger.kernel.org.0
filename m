Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC46686A22
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 16:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjBAPWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 10:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbjBAPWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 10:22:37 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F66E721DA;
        Wed,  1 Feb 2023 07:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=SYyWbiw9XtcLHU02AyB+gSll+qDnb025TUIs9LtZWf8=; b=KgImW2mj88WUdK88np7rSqz6Bn
        vFR7oa6yWEojpJgwULqWnj9WkEB/ZvuqGmW9VLx9s/zFN6bIjA+HuvUp+lKyATkvbK6kJ3SOYaFtx
        fKj1D+lKf+120h4sPf0JtVtadJJpSjBrMk+JHDuw7RCHiztTCdAhTk/Zca1MuIRqv72ou6ljtKkJV
        Qn4DKF7NXTNOZZ6JmXihwx5m3zqc+KuARaddfmHwaw+Z6s3icvMQSUSFIncyX+TMb77G+r+kzfZke
        uKwrgR9ES+b4iQqbawtC3J7k1m3XqWz6SVIH25bzzwuzyZbSJFiQi8+kacxbHj+vbwr0JbnRXGfZU
        Xpwh13zYRE7w8o/raOzLGZdeEMm3FY0xAjVA5KUTFaYHKKdSre9UpVx0YTtQBcWHzUQeqOM+z+lj+
        7uQO8LrvpfzZykskcz5bapE/6V1FVjRkLyTtAk6/+0LBrPWiXqIU0Rmm4W5IgyCSsLYsOLV2diS/2
        Ukx5jUKwbrCkzgU8/VIkwBsA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pNEw3-00BFZu-J2; Wed, 01 Feb 2023 15:22:07 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/3] cifs: split out smb3_use_rdma_offload() helper
Date:   Wed,  1 Feb 2023 16:21:40 +0100
Message-Id: <ad79ce14cffcd82728a78edb90188f69d43b6c31.1675264648.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1675264648.git.metze@samba.org>
References: <cover.1675264648.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We should have the logic to decide if we want rdma offload
in a single spot in order to advance it in future.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
---
 fs/cifs/smb2pdu.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 64e2c8b438f4..6a4d621241dd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4063,6 +4063,32 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	return rc;
 }
 
+#ifdef CONFIG_CIFS_SMB_DIRECT
+static inline bool smb3_use_rdma_offload(struct cifs_io_parms *io_parms)
+{
+	struct TCP_Server_Info *server = io_parms->server;
+	struct cifs_tcon *tcon = io_parms->tcon;
+
+	/* we can only offload if we're connected */
+	if (!server || !tcon)
+		return false;
+
+	/* we can only offload on an rdma connection */
+	if (!server->rdma || !server->smbd_conn)
+		return false;
+
+	/* we don't support signed offload yet */
+	if (server->sign)
+		return false;
+
+	/* offload also has its overhead, so only do it if desired */
+	if (io_parms->length < server->smbd_conn->rdma_readwrite_threshold)
+		return false;
+
+	return true;
+}
+#endif /* CONFIG_CIFS_SMB_DIRECT */
+
 /*
  * To form a chain of read requests, any read requests after the first should
  * have the end_of_chain boolean set to true.
@@ -4106,9 +4132,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	 * If we want to do a RDMA write, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of read request
 	 */
-	if (server->rdma && rdata && !server->sign &&
-		rdata->bytes >= server->smbd_conn->rdma_readwrite_threshold) {
-
+	if (smb3_use_rdma_offload(io_parms)) {
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
@@ -4558,9 +4582,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	 * If we want to do a server RDMA read, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of write request
 	 */
-	if (server->rdma && !server->sign && io_parms->length >=
-		server->smbd_conn->rdma_readwrite_threshold) {
-
+	if (smb3_use_rdma_offload(io_parms)) {
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
-- 
2.34.1

