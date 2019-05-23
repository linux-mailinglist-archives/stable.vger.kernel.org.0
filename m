Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40252780A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 10:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfEWIfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 04:35:16 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57333 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbfEWIfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 04:35:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9F9402E950;
        Thu, 23 May 2019 04:35:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 04:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=F5kFW3
        1HQxpljqKvwAddqhVeSZX0pNBX5K/fVpffzaw=; b=qlfob3xdhOmIsEewPwzfhN
        f8AWB0tFr//CWfvsDYckUB3ypPRAR2wwL49mh4Yazu2xvMfs0Up1/wLHfBf5NLz8
        YYcZ8epEhCNVv6x/S44NofzHWweTtEg3BFBfeNPhdfkvK7lKPCUj0xODpmYb07hm
        wR1piKgvAr4PsSyPsSKcSZE5/4b+glPtS3RvwhqXZP3w0leSvO1rk9lAJ7P8xJud
        KEyayo8GFc/7h9oYjJUiutME3w8eLbr5onX0dog7/VEvBqdHnp/fwIKQ2FpHD+Ky
        K2cEqZaITDak4NAM5GC9tbccQxAzKlGODqoUjCZgDIT6z3xzcc/KSoNB1NPtWF3Q
        ==
X-ME-Sender: <xms:QlvmXPd4PLZjdajiYfNocK1rb2GyBYpLXbdZQBziY3sFlSY4s1Re2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:QlvmXJdgRkMHO3sdsdEe0T6FavPja1ROxvLukTQS-tU3tNciyjZe3A>
    <xmx:QlvmXDi3nZ4J18cbBY9BEgza-agqt5x_K4HjyIPud-EF15R4l_UJhQ>
    <xmx:QlvmXFRcYsLbRIPL2QU_GyapMNuxPNqzwoq3JUJOj2vLt5pjOpYx2g>
    <xmx:QlvmXCR9R5ppNW3erLh229ZuQ3k7LAKWTfAqGYzyeg7259jjM_2GOw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D978780063;
        Thu, 23 May 2019 04:35:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs: smbd: take an array of reqeusts when sending upper" failed to apply to 5.1-stable tree
To:     longli@microsoft.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 10:35:12 +0200
Message-ID: <1558600512175209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4739f2328661d070f93f9bcc8afb2a82706c826d Mon Sep 17 00:00:00 2001
From: Long Li <longli@microsoft.com>
Date: Mon, 15 Apr 2019 14:49:17 -0700
Subject: [PATCH] cifs: smbd: take an array of reqeusts when sending upper
 layer data

To support compounding, __smb_send_rqst() now sends an array of requests to
the transport layer.
Change smbd_send() to take an array of requests, and send them in as few
packets as possible.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 05b05e78f31b..251ef1223206 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2072,7 +2072,8 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
  * rqst: the data to write
  * return value: 0 if successfully write, otherwise error code
  */
-int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
+int smbd_send(struct TCP_Server_Info *server,
+	int num_rqst, struct smb_rqst *rqst_array)
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct kvec vec;
@@ -2084,53 +2085,49 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		info->max_send_size - sizeof(struct smbd_data_transfer);
 	struct kvec *iov;
 	int rc;
+	struct smb_rqst *rqst;
+	int rqst_idx;
 
 	if (info->transport_status != SMBD_CONNECTED) {
 		rc = -EAGAIN;
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
@@ -2178,14 +2175,14 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
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
@@ -2229,6 +2226,10 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
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
index a3c7b3d0561e..f6241b8bce5f 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -284,7 +284,8 @@ void smbd_destroy(struct TCP_Server_Info *server);
 
 /* Interface for carrying upper layer I/O through send/recv */
 int smbd_recv(struct smbd_connection *info, struct msghdr *msg);
-int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst);
+int smbd_send(struct TCP_Server_Info *server,
+	int num_rqst, struct smb_rqst *rqst);
 
 enum mr_state {
 	MR_READY,
@@ -324,7 +325,7 @@ static inline void *smbd_get_connection(
 static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
 static inline void smbd_destroy(struct TCP_Server_Info *server) {}
 static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
-static inline int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst) {return -1; }
+static inline int smbd_send(struct TCP_Server_Info *server, int num_rqst, struct smb_rqst *rqst) {return -1; }
 #endif
 
 #endif
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 65d9f3e2eb88..5c59c498f56a 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -319,7 +319,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	__be32 rfc1002_marker;
 
 	if (cifs_rdma_enabled(server) && server->smbd_conn) {
-		rc = smbd_send(server, rqst);
+		rc = smbd_send(server, num_rqst, rqst);
 		goto smbd_done;
 	}
 

