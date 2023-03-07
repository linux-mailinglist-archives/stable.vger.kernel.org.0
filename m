Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4236AEC0F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjCGRv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjCGRvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:51:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF1FACE04;
        Tue,  7 Mar 2023 09:46:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 888EDB819C8;
        Tue,  7 Mar 2023 17:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2444C4339B;
        Tue,  7 Mar 2023 17:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211166;
        bh=lirQZBshXmGux0ededLQKzzH7/4t3ErOiEKb6hIS7rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YujdUKdnOhe+OEtwXVxuIANj0Kf9UvX5NoMccSfMw+jbwm5TXLE0+0XmTTumG8r4f
         09MpINTflQ5ecLi0AOFTl9wlxQIE/Do5t0gXTp5i6KC2j4FW4riZZpZ5SfHVb4xMEE
         MQ5opHRWrzQHWpN5sYErtU2xtjWCuarRd0xPfOrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 0775/1001] cifs: split out smb3_use_rdma_offload() helper
Date:   Tue,  7 Mar 2023 17:59:07 +0100
Message-Id: <20230307170055.385110619@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
 


