Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0315E5948E5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347878AbiHOXjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiHOXha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:37:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209A683BF1;
        Mon, 15 Aug 2022 13:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6683560B6E;
        Mon, 15 Aug 2022 20:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77478C43144;
        Mon, 15 Aug 2022 20:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594191;
        bh=QXTGSx7ODr0ZLVLHfecCAQdyOcrmgkVGa7p1m1KvxRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yiz1cTXLOYouXRJUfCSPTutkGEAh9bDQ5gcczP2tOiqhhVNWvkGXjR5HoXWCEg9Tx
         tR3R/sUyu19FcjyQCgJfkxu/5xZ4nyNhV+FQJJwYHqfIaTBM0IyDFcMq6oV8JBRBZc
         Ji7sANSAjv5itcUWUZmxoZf34JJHBTs0+o9hDK8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1052/1095] ksmbd: fix wrong smbd max read/write size check
Date:   Mon, 15 Aug 2022 20:07:31 +0200
Message-Id: <20220815180512.596642150@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 7a84399e1ce3f5f2fbec3e7dd93459ba25badc2f ]

smb-direct max read/write size can be different with smb2 max read/write
size. So smb2_read() can return error by wrong max read/write size check.
This patch use smb_direct_max_read_write_size for this check in
smb-direct read/write().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c        | 39 +++++++++++++++++++++++++--------------
 fs/ksmbd/transport_rdma.c |  5 +++++
 fs/ksmbd/transport_rdma.h |  2 ++
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 8f86b8d6765f..6c8dd718b5db 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6194,6 +6194,8 @@ int smb2_read(struct ksmbd_work *work)
 	size_t length, mincount;
 	ssize_t nbytes = 0, remain_bytes = 0;
 	int err = 0;
+	bool is_rdma_channel = false;
+	unsigned int max_read_size = conn->vals->max_read_size;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -6205,6 +6207,11 @@ int smb2_read(struct ksmbd_work *work)
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+		is_rdma_channel = true;
+		max_read_size = get_smbd_max_read_write_size();
+	}
+
+	if (is_rdma_channel == true) {
 		unsigned int ch_offset = le16_to_cpu(req->ReadChannelInfoOffset);
 
 		if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
@@ -6236,9 +6243,9 @@ int smb2_read(struct ksmbd_work *work)
 	length = le32_to_cpu(req->Length);
 	mincount = le32_to_cpu(req->MinimumCount);
 
-	if (length > conn->vals->max_read_size) {
+	if (length > max_read_size) {
 		ksmbd_debug(SMB, "limiting read size to max size(%u)\n",
-			    conn->vals->max_read_size);
+			    max_read_size);
 		err = -EINVAL;
 		goto out;
 	}
@@ -6270,8 +6277,7 @@ int smb2_read(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
 		    nbytes, offset, mincount);
 
-	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
-	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+	if (is_rdma_channel == true) {
 		/* write data to the client using rdma channel */
 		remain_bytes = smb2_read_rdma_channel(work, req,
 						      work->aux_payload_buf,
@@ -6432,8 +6438,9 @@ int smb2_write(struct ksmbd_work *work)
 	size_t length;
 	ssize_t nbytes;
 	char *data_buf;
-	bool writethrough = false;
+	bool writethrough = false, is_rdma_channel = false;
 	int err = 0;
+	unsigned int max_write_size = work->conn->vals->max_write_size;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -6442,8 +6449,17 @@ int smb2_write(struct ksmbd_work *work)
 		return smb2_write_pipe(work);
 	}
 
+	offset = le64_to_cpu(req->Offset);
+	length = le32_to_cpu(req->Length);
+
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+		is_rdma_channel = true;
+		max_write_size = get_smbd_max_read_write_size();
+		length = le32_to_cpu(req->RemainingBytes);
+	}
+
+	if (is_rdma_channel == true) {
 		unsigned int ch_offset = le16_to_cpu(req->WriteChannelInfoOffset);
 
 		if (req->Length != 0 || req->DataOffset != 0 ||
@@ -6478,12 +6494,9 @@ int smb2_write(struct ksmbd_work *work)
 		goto out;
 	}
 
-	offset = le64_to_cpu(req->Offset);
-	length = le32_to_cpu(req->Length);
-
-	if (length > work->conn->vals->max_write_size) {
+	if (length > max_write_size) {
 		ksmbd_debug(SMB, "limiting write size to max size(%u)\n",
-			    work->conn->vals->max_write_size);
+			    max_write_size);
 		err = -EINVAL;
 		goto out;
 	}
@@ -6491,8 +6504,7 @@ int smb2_write(struct ksmbd_work *work)
 	if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
 		writethrough = true;
 
-	if (req->Channel != SMB2_CHANNEL_RDMA_V1 &&
-	    req->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+	if (is_rdma_channel == false) {
 		if ((u64)le16_to_cpu(req->DataOffset) + length >
 		    get_rfc1002_len(work->request_buf)) {
 			pr_err("invalid write data offset %u, smb_len %u\n",
@@ -6518,8 +6530,7 @@ int smb2_write(struct ksmbd_work *work)
 		/* read data from the client using rdma channel, and
 		 * write the data.
 		 */
-		nbytes = smb2_write_rdma_channel(work, req, fp, offset,
-						 le32_to_cpu(req->RemainingBytes),
+		nbytes = smb2_write_rdma_channel(work, req, fp, offset, length,
 						 writethrough);
 		if (nbytes < 0) {
 			err = (int)nbytes;
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index afc66b9765e7..c6af8d89b7f7 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -220,6 +220,11 @@ void init_smbd_max_io_size(unsigned int sz)
 	smb_direct_max_read_write_size = sz;
 }
 
+unsigned int get_smbd_max_read_write_size(void)
+{
+	return smb_direct_max_read_write_size;
+}
+
 static inline int get_buf_page_count(void *buf, int size)
 {
 	return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
diff --git a/fs/ksmbd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
index e7b4e6790fab..77aee4e5c9dc 100644
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -57,11 +57,13 @@ int ksmbd_rdma_init(void);
 void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 void init_smbd_max_io_size(unsigned int sz);
+unsigned int get_smbd_max_read_write_size(void);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline int ksmbd_rdma_destroy(void) { return 0; }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
 static inline void init_smbd_max_io_size(unsigned int sz) { }
+static inline unsigned int get_smbd_max_read_write_size(void) { return 0; }
 #endif
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
-- 
2.35.1



