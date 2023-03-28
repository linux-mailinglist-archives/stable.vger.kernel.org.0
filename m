Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4C16CC48C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbjC1PFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbjC1PFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:05:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87527D53B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6325CB81D7A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6AEC433EF;
        Tue, 28 Mar 2023 15:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015834;
        bh=IcPqGMhvHTalH1PfA6xanNWPq+lGcIvvWJDn6QEKnqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9dH6vVBsqTgTXd7cKIMpRr4op7vuTRJJdPaXDitzhTnhZdNpdgB/edA28l3wup0a
         Ow+hKmptFELyClvOOF2iP9HOlkOH8i8XAqlLJk683LR1a7gvBN3jr3Z03SVN0M21z7
         RJm+LJdnP9rPSCk95Kx743WwwolyY25IOz98Ot4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve French <stfrench@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 193/224] ksmbd: dont terminate inactive sessions after a few seconds
Date:   Tue, 28 Mar 2023 16:43:09 +0200
Message-Id: <20230328142625.424832804@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit be6f42fad5f5fd1fea9d562df82c38ad6ed3bfe9 upstream.

Steve reported that inactive sessions are terminated after a few
seconds. ksmbd terminate when receiving -EAGAIN error from
kernel_recvmsg(). -EAGAIN means there is no data available in timeout.
So ksmbd should keep connection with unlimited retries instead of
terminating inactive sessions.

Cc: stable@vger.kernel.org
Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c     |    4 ++--
 fs/ksmbd/connection.h     |    3 ++-
 fs/ksmbd/transport_rdma.c |    2 +-
 fs/ksmbd/transport_tcp.c  |   35 +++++++++++++++++++++++------------
 4 files changed, 28 insertions(+), 16 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -298,7 +298,7 @@ int ksmbd_conn_handler_loop(void *p)
 		kvfree(conn->request_buf);
 		conn->request_buf = NULL;
 
-		size = t->ops->read(t, hdr_buf, sizeof(hdr_buf));
+		size = t->ops->read(t, hdr_buf, sizeof(hdr_buf), -1);
 		if (size != sizeof(hdr_buf))
 			break;
 
@@ -344,7 +344,7 @@ int ksmbd_conn_handler_loop(void *p)
 		 * We already read 4 bytes to find out PDU size, now
 		 * read in PDU
 		 */
-		size = t->ops->read(t, conn->request_buf + 4, pdu_size);
+		size = t->ops->read(t, conn->request_buf + 4, pdu_size, 2);
 		if (size < 0) {
 			pr_err("sock_read failed: %d\n", size);
 			break;
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -114,7 +114,8 @@ struct ksmbd_transport_ops {
 	int (*prepare)(struct ksmbd_transport *t);
 	void (*disconnect)(struct ksmbd_transport *t);
 	void (*shutdown)(struct ksmbd_transport *t);
-	int (*read)(struct ksmbd_transport *t, char *buf, unsigned int size);
+	int (*read)(struct ksmbd_transport *t, char *buf,
+		    unsigned int size, int max_retries);
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
 		      int size, bool need_invalidate_rkey,
 		      unsigned int remote_key);
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -670,7 +670,7 @@ static int smb_direct_post_recv(struct s
 }
 
 static int smb_direct_read(struct ksmbd_transport *t, char *buf,
-			   unsigned int size)
+			   unsigned int size, int unused)
 {
 	struct smb_direct_recvmsg *recvmsg;
 	struct smb_direct_data_transfer *data_transfer;
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -291,16 +291,18 @@ static int ksmbd_tcp_run_kthread(struct
 
 /**
  * ksmbd_tcp_readv() - read data from socket in given iovec
- * @t:		TCP transport instance
- * @iov_orig:	base IO vector
- * @nr_segs:	number of segments in base iov
- * @to_read:	number of bytes to read from socket
+ * @t:			TCP transport instance
+ * @iov_orig:		base IO vector
+ * @nr_segs:		number of segments in base iov
+ * @to_read:		number of bytes to read from socket
+ * @max_retries:	maximum retry count
  *
  * Return:	on success return number of bytes read from socket,
  *		otherwise return error number
  */
 static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
-			   unsigned int nr_segs, unsigned int to_read)
+			   unsigned int nr_segs, unsigned int to_read,
+			   int max_retries)
 {
 	int length = 0;
 	int total_read;
@@ -308,7 +310,6 @@ static int ksmbd_tcp_readv(struct tcp_tr
 	struct msghdr ksmbd_msg;
 	struct kvec *iov;
 	struct ksmbd_conn *conn = KSMBD_TRANS(t)->conn;
-	int max_retry = 2;
 
 	iov = get_conn_iovec(t, nr_segs);
 	if (!iov)
@@ -335,14 +336,23 @@ static int ksmbd_tcp_readv(struct tcp_tr
 		} else if (conn->status == KSMBD_SESS_NEED_RECONNECT) {
 			total_read = -EAGAIN;
 			break;
-		} else if ((length == -ERESTARTSYS || length == -EAGAIN) &&
-			   max_retry) {
+		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
+			/*
+			 * If max_retries is negative, Allow unlimited
+			 * retries to keep connection with inactive sessions.
+			 */
+			if (max_retries == 0) {
+				total_read = length;
+				break;
+			} else if (max_retries > 0) {
+				max_retries--;
+			}
+
 			usleep_range(1000, 2000);
 			length = 0;
-			max_retry--;
 			continue;
 		} else if (length <= 0) {
-			total_read = -EAGAIN;
+			total_read = length;
 			break;
 		}
 	}
@@ -358,14 +368,15 @@ static int ksmbd_tcp_readv(struct tcp_tr
  * Return:	on success return number of bytes read from socket,
  *		otherwise return error number
  */
-static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf, unsigned int to_read)
+static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf,
+			  unsigned int to_read, int max_retries)
 {
 	struct kvec iov;
 
 	iov.iov_base = buf;
 	iov.iov_len = to_read;
 
-	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read);
+	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read, max_retries);
 }
 
 static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *iov,


