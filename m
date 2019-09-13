Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FC4B1F3F
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390047AbfIMNRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390033AbfIMNRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:17:18 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12891206BB;
        Fri, 13 Sep 2019 13:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380637;
        bh=qmOB3n/qyuqx5APPgMjwIF0rFMVyzdqDDGzVByua/Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUBnb1JEava3By1hM91X6G5Z4rCNQZkCP2voa/XAy1dP5ttCecn6JVZY35g73VIR4
         cigfb00bku0C17lwLV+vZf8AFQB2tnactEpSQPJuOha+AqJOl6eKn49Rb7DHfiY+J1
         vWOaYrv2y3pp5A/RbdkTEs+8C3mVoTtWabyKQU34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Long Li <longli@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/190] cifs: smbd: take an array of reqeusts when sending upper layer data
Date:   Fri, 13 Sep 2019 14:06:25 +0100
Message-Id: <20190913130610.324318195@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4739f2328661d070f93f9bcc8afb2a82706c826d ]

To support compounding, __smb_send_rqst() now sends an array of requests to
the transport layer.
Change smbd_send() to take an array of requests, and send them in as few
packets as possible.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smbdirect.c | 55 +++++++++++++++++++++++----------------------
 fs/cifs/smbdirect.h |  5 +++--
 fs/cifs/transport.c |  2 +-
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5fdb9a509a97f..1959931e14c1e 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2090,7 +2090,8 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
  * rqst: the data to write
  * return value: 0 if successfully write, otherwise error code
  */
-int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
+int smbd_send(struct TCP_Server_Info *server,
+	int num_rqst, struct smb_rqst *rqst_array)
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct kvec vec;
@@ -2102,6 +2103,8 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		info->max_send_size - sizeof(struct smbd_data_transfer);
 	struct kvec *iov;
 	int rc;
+	struct smb_rqst *rqst;
+	int rqst_idx;
 
 	info->smbd_send_pending++;
 	if (info->transport_status != SMBD_CONNECTED) {
@@ -2109,47 +2112,41 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		goto done;
 	}
 
-	/*
-	 * Skip the RFC1002 length defined in MS-SMB2 section 2.1
-	 * It is used only for TCP transport in the iov[0]
-	 * In future we may want to add a transport layer under protocol
-	 * layer so this will only be issued to TCP transport
-	 */
-
-	if (rqst->rq_iov[0].iov_len != 4) {
-		log_write(ERR, "expected the pdu length in 1st iov, but got %zu\n", rqst->rq_iov[0].iov_len);
-		return -EINVAL;
-	}
-
 	/*
 	 * Add in the page array if there is one. The caller needs to set
 	 * rq_tailsz to PAGE_SIZE when the buffer has multiple pages and
 	 * ends at page boundary
 	 */
-	buflen = smb_rqst_len(server, rqst);
+	remaining_data_length = 0;
+	for (i = 0; i < num_rqst; i++)
+		remaining_data_length += smb_rqst_len(server, &rqst_array[i]);
 
-	if (buflen + sizeof(struct smbd_data_transfer) >
+	if (remaining_data_length + sizeof(struct smbd_data_transfer) >
 		info->max_fragmented_send_size) {
 		log_write(ERR, "payload size %d > max size %d\n",
-			buflen, info->max_fragmented_send_size);
+			remaining_data_length, info->max_fragmented_send_size);
 		rc = -EINVAL;
 		goto done;
 	}
 
-	iov = &rqst->rq_iov[1];
+	rqst_idx = 0;
+
+next_rqst:
+	rqst = &rqst_array[rqst_idx];
+	iov = rqst->rq_iov;
 
-	cifs_dbg(FYI, "Sending smb (RDMA): smb_len=%u\n", buflen);
-	for (i = 0; i < rqst->rq_nvec-1; i++)
+	cifs_dbg(FYI, "Sending smb (RDMA): idx=%d smb_len=%lu\n",
+		rqst_idx, smb_rqst_len(server, rqst));
+	for (i = 0; i < rqst->rq_nvec; i++)
 		dump_smb(iov[i].iov_base, iov[i].iov_len);
 
-	remaining_data_length = buflen;
 
-	log_write(INFO, "rqst->rq_nvec=%d rqst->rq_npages=%d rq_pagesz=%d "
-		"rq_tailsz=%d buflen=%d\n",
-		rqst->rq_nvec, rqst->rq_npages, rqst->rq_pagesz,
-		rqst->rq_tailsz, buflen);
+	log_write(INFO, "rqst_idx=%d nvec=%d rqst->rq_npages=%d rq_pagesz=%d "
+		"rq_tailsz=%d buflen=%lu\n",
+		rqst_idx, rqst->rq_nvec, rqst->rq_npages, rqst->rq_pagesz,
+		rqst->rq_tailsz, smb_rqst_len(server, rqst));
 
-	start = i = iov[0].iov_len ? 0 : 1;
+	start = i = 0;
 	buflen = 0;
 	while (true) {
 		buflen += iov[i].iov_len;
@@ -2197,14 +2194,14 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 						goto done;
 				}
 				i++;
-				if (i == rqst->rq_nvec-1)
+				if (i == rqst->rq_nvec)
 					break;
 			}
 			start = i;
 			buflen = 0;
 		} else {
 			i++;
-			if (i == rqst->rq_nvec-1) {
+			if (i == rqst->rq_nvec) {
 				/* send out all remaining vecs */
 				remaining_data_length -= buflen;
 				log_write(INFO,
@@ -2248,6 +2245,10 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		}
 	}
 
+	rqst_idx++;
+	if (rqst_idx < num_rqst)
+		goto next_rqst;
+
 done:
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index a11096254f296..b5c240ff21919 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -292,7 +292,8 @@ void smbd_destroy(struct smbd_connection *info);
 
 /* Interface for carrying upper layer I/O through send/recv */
 int smbd_recv(struct smbd_connection *info, struct msghdr *msg);
-int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst);
+int smbd_send(struct TCP_Server_Info *server,
+	int num_rqst, struct smb_rqst *rqst);
 
 enum mr_state {
 	MR_READY,
@@ -332,7 +333,7 @@ static inline void *smbd_get_connection(
 static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
 static inline void smbd_destroy(struct smbd_connection *info) {}
 static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
-static inline int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst) {return -1; }
+static inline int smbd_send(struct TCP_Server_Info *server, int num_rqst, struct smb_rqst *rqst) {return -1; }
 #endif
 
 #endif
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f2938bd95c40e..fe77f41bff9f2 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -287,7 +287,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	__be32 rfc1002_marker;
 
 	if (cifs_rdma_enabled(server) && server->smbd_conn) {
-		rc = smbd_send(server, rqst);
+		rc = smbd_send(server, num_rqst, rqst);
 		goto smbd_done;
 	}
 	if (ssocket == NULL)
-- 
2.20.1



