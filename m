Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA695949B7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242651AbiHOXcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353489AbiHOX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:28:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839D414EC8D;
        Mon, 15 Aug 2022 13:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38092B80EA8;
        Mon, 15 Aug 2022 20:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77507C433D6;
        Mon, 15 Aug 2022 20:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594061;
        bh=uxd7EsReGra/kxKK0MUI8FhFK70UAPwYm5or0x5vyGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRFHwtetQADb+N/0Dx/lD4xyA5lldub/nCjISAhZBRGagzy0ktGg+orYgqqRw7dzd
         PLPlq5HiGQUA5E3v7kusZlA0aoArEB3lJPaBwFP+OgEqqwTs+kYKTlaZaSY1jywPot
         YDd5Qm+5BH7r/IUVY9oSpeE746EstcYDnShkD1kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1049/1095] ksmbd: smbd: change prototypes of RDMA read/write related functions
Date:   Mon, 15 Aug 2022 20:07:28 +0200
Message-Id: <20220815180512.469753235@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 1807abcf8778bcbbf584fe54da9ccbe9029c49bb ]

Change the prototypes of RDMA read/write
operations to accept a pointer and length
of buffer descriptors.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/connection.c     | 20 ++++++++++----------
 fs/ksmbd/connection.h     | 27 ++++++++++++++++-----------
 fs/ksmbd/smb2pdu.c        | 23 ++++++++---------------
 fs/ksmbd/transport_rdma.c | 30 +++++++++++++++++-------------
 4 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index bc6050b67256..e8f476c5f189 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -205,31 +205,31 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 	return 0;
 }
 
-int ksmbd_conn_rdma_read(struct ksmbd_conn *conn, void *buf,
-			 unsigned int buflen, u32 remote_key, u64 remote_offset,
-			 u32 remote_len)
+int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
+			 void *buf, unsigned int buflen,
+			 struct smb2_buffer_desc_v1 *desc,
+			 unsigned int desc_len)
 {
 	int ret = -EINVAL;
 
 	if (conn->transport->ops->rdma_read)
 		ret = conn->transport->ops->rdma_read(conn->transport,
 						      buf, buflen,
-						      remote_key, remote_offset,
-						      remote_len);
+						      desc, desc_len);
 	return ret;
 }
 
-int ksmbd_conn_rdma_write(struct ksmbd_conn *conn, void *buf,
-			  unsigned int buflen, u32 remote_key,
-			  u64 remote_offset, u32 remote_len)
+int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
+			  void *buf, unsigned int buflen,
+			  struct smb2_buffer_desc_v1 *desc,
+			  unsigned int desc_len)
 {
 	int ret = -EINVAL;
 
 	if (conn->transport->ops->rdma_write)
 		ret = conn->transport->ops->rdma_write(conn->transport,
 						       buf, buflen,
-						       remote_key, remote_offset,
-						       remote_len);
+						       desc, desc_len);
 	return ret;
 }
 
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 7a59aacb5daa..98c1cbe45ec9 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -122,11 +122,14 @@ struct ksmbd_transport_ops {
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
 		      int size, bool need_invalidate_rkey,
 		      unsigned int remote_key);
-	int (*rdma_read)(struct ksmbd_transport *t, void *buf, unsigned int len,
-			 u32 remote_key, u64 remote_offset, u32 remote_len);
-	int (*rdma_write)(struct ksmbd_transport *t, void *buf,
-			  unsigned int len, u32 remote_key, u64 remote_offset,
-			  u32 remote_len);
+	int (*rdma_read)(struct ksmbd_transport *t,
+			 void *buf, unsigned int len,
+			 struct smb2_buffer_desc_v1 *desc,
+			 unsigned int desc_len);
+	int (*rdma_write)(struct ksmbd_transport *t,
+			  void *buf, unsigned int len,
+			  struct smb2_buffer_desc_v1 *desc,
+			  unsigned int desc_len);
 };
 
 struct ksmbd_transport {
@@ -148,12 +151,14 @@ struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
-int ksmbd_conn_rdma_read(struct ksmbd_conn *conn, void *buf,
-			 unsigned int buflen, u32 remote_key, u64 remote_offset,
-			 u32 remote_len);
-int ksmbd_conn_rdma_write(struct ksmbd_conn *conn, void *buf,
-			  unsigned int buflen, u32 remote_key, u64 remote_offset,
-			  u32 remote_len);
+int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
+			 void *buf, unsigned int buflen,
+			 struct smb2_buffer_desc_v1 *desc,
+			 unsigned int desc_len);
+int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
+			  void *buf, unsigned int buflen,
+			  struct smb2_buffer_desc_v1 *desc,
+			  unsigned int desc_len);
 void ksmbd_conn_enqueue_request(struct ksmbd_work *work);
 int ksmbd_conn_try_dequeue_request(struct ksmbd_work *work);
 void ksmbd_conn_init_server_callbacks(struct ksmbd_conn_ops *ops);
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 5df87fe18905..8f86b8d6765f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6132,7 +6132,6 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
 					struct smb2_buffer_desc_v1 *desc,
 					__le32 Channel,
-					__le16 ChannelInfoOffset,
 					__le16 ChannelInfoLength)
 {
 	unsigned int i, ch_count;
@@ -6158,7 +6157,8 @@ static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
 
 	work->need_invalidate_rkey =
 		(Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
-	work->remote_key = le32_to_cpu(desc->token);
+	if (Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE)
+		work->remote_key = le32_to_cpu(desc->token);
 	return 0;
 }
 
@@ -6166,14 +6166,12 @@ static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
 				      struct smb2_read_req *req, void *data_buf,
 				      size_t length)
 {
-	struct smb2_buffer_desc_v1 *desc =
-		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
 	int err;
 
 	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
-				    le32_to_cpu(desc->token),
-				    le64_to_cpu(desc->offset),
-				    le32_to_cpu(desc->length));
+				    (struct smb2_buffer_desc_v1 *)
+				    ((char *)req + le16_to_cpu(req->ReadChannelInfoOffset)),
+				    le16_to_cpu(req->ReadChannelInfoLength));
 	if (err)
 		return err;
 
@@ -6217,7 +6215,6 @@ int smb2_read(struct ksmbd_work *work)
 						   (struct smb2_buffer_desc_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
-						   req->ReadChannelInfoOffset,
 						   req->ReadChannelInfoLength);
 		if (err)
 			goto out;
@@ -6395,21 +6392,18 @@ static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
 				       struct ksmbd_file *fp,
 				       loff_t offset, size_t length, bool sync)
 {
-	struct smb2_buffer_desc_v1 *desc;
 	char *data_buf;
 	int ret;
 	ssize_t nbytes;
 
-	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
-
 	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
 	if (!data_buf)
 		return -ENOMEM;
 
 	ret = ksmbd_conn_rdma_read(work->conn, data_buf, length,
-				   le32_to_cpu(desc->token),
-				   le64_to_cpu(desc->offset),
-				   le32_to_cpu(desc->length));
+				   (struct smb2_buffer_desc_v1 *)
+				   ((char *)req + le16_to_cpu(req->WriteChannelInfoOffset)),
+				   le16_to_cpu(req->WriteChannelInfoLength));
 	if (ret < 0) {
 		kvfree(data_buf);
 		return ret;
@@ -6461,7 +6455,6 @@ int smb2_write(struct ksmbd_work *work)
 						   (struct smb2_buffer_desc_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
-						   req->WriteChannelInfoOffset,
 						   req->WriteChannelInfoLength);
 		if (err)
 			goto out;
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 3f5d13571694..479d279ee146 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1352,14 +1352,18 @@ static void write_done(struct ib_cq *cq, struct ib_wc *wc)
 	read_write_done(cq, wc, DMA_TO_DEVICE);
 }
 
-static int smb_direct_rdma_xmit(struct smb_direct_transport *t, void *buf,
-				int buf_len, u32 remote_key, u64 remote_offset,
-				u32 remote_len, bool is_read)
+static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
+				void *buf, int buf_len,
+				struct smb2_buffer_desc_v1 *desc,
+				unsigned int desc_len,
+				bool is_read)
 {
 	struct smb_direct_rdma_rw_msg *msg;
 	int ret;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct ib_send_wr *first_wr = NULL;
+	u32 remote_key = le32_to_cpu(desc[0].token);
+	u64 remote_offset = le64_to_cpu(desc[0].offset);
 
 	ret = wait_for_credits(t, &t->wait_rw_avail_ops, &t->rw_avail_ops);
 	if (ret < 0)
@@ -1424,22 +1428,22 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t, void *buf,
 	return ret;
 }
 
-static int smb_direct_rdma_write(struct ksmbd_transport *t, void *buf,
-				 unsigned int buflen, u32 remote_key,
-				 u64 remote_offset, u32 remote_len)
+static int smb_direct_rdma_write(struct ksmbd_transport *t,
+				 void *buf, unsigned int buflen,
+				 struct smb2_buffer_desc_v1 *desc,
+				 unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
-				    remote_key, remote_offset,
-				    remote_len, false);
+				    desc, desc_len, false);
 }
 
-static int smb_direct_rdma_read(struct ksmbd_transport *t, void *buf,
-				unsigned int buflen, u32 remote_key,
-				u64 remote_offset, u32 remote_len)
+static int smb_direct_rdma_read(struct ksmbd_transport *t,
+				void *buf, unsigned int buflen,
+				struct smb2_buffer_desc_v1 *desc,
+				unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
-				    remote_key, remote_offset,
-				    remote_len, true);
+				    desc, desc_len, true);
 }
 
 static void smb_direct_disconnect(struct ksmbd_transport *t)
-- 
2.35.1



