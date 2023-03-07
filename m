Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002C96AF1A0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbjCGSpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbjCGSpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:45:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0B9B78A9;
        Tue,  7 Mar 2023 10:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C1261522;
        Tue,  7 Mar 2023 18:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDD3C433EF;
        Tue,  7 Mar 2023 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214049;
        bh=lirQZBshXmGux0ededLQKzzH7/4t3ErOiEKb6hIS7rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5Xlktf/zdVammX2aIEnvd4DWamhb8YzPchhWA1iG/FPYJUI4hf9B93dNK5wpEI5W
         0TyncLTBoG2/MbzK8bDYCWU6x2yPZvuxzLkt0ZFIgRr2psl+ZkUPF3ts34YUePW9nL
         XB3BRWrE3TEhxGIB+ONvo36AKpkVG5SlEmQvkfCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 674/885] cifs: split out smb3_use_rdma_offload() helper
Date:   Tue,  7 Mar 2023 18:00:08 +0100
Message-Id: <20230307170031.428460971@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

commit a6559cc1d35d3eeafb0296aca347b2f745a28a74 upstream.

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4063,6 +4063,32 @@ SMB2_flush(const unsigned int xid, struc
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
@@ -4106,9 +4132,7 @@ smb2_new_read_req(void **buf, unsigned i
 	 * If we want to do a RDMA write, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of read request
 	 */
-	if (server->rdma && rdata && !server->sign &&
-		rdata->bytes >= server->smbd_conn->rdma_readwrite_threshold) {
-
+	if (smb3_use_rdma_offload(io_parms)) {
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
@@ -4558,9 +4582,7 @@ smb2_async_writev(struct cifs_writedata
 	 * If we want to do a server RDMA read, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of write request
 	 */
-	if (server->rdma && !server->sign && io_parms->length >=
-		server->smbd_conn->rdma_readwrite_threshold) {
-
+	if (smb3_use_rdma_offload(io_parms)) {
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 


