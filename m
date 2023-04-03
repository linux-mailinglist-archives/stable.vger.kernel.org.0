Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0DF6D48B5
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjDCObR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbjDCObM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B1B3501C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92788B81C5B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0CCC433EF;
        Mon,  3 Apr 2023 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532268;
        bh=pm499dLIuPFQxS03VhUJO+tDXd8FwpaPsu/4/gtoJHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQU41uGHGC8c49c4ieoyzKdL4IcUQ+mA9s1FpD+DnfvYFV7sVxKJgPeQgZPmNRXp/
         UoIropdYGC5fGEurTApVYeG7xRA+psOXSmTEd45cqDrLeDBaMLSzRc4yUaz88xiwKn
         0ax7B0TNRPFXa1OKhlLAL90LepcjyTpnSEvyrI9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve French <stfrench@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/99] ksmbd: dont terminate inactive sessions after a few seconds
Date:   Mon,  3 Apr 2023 16:08:29 +0200
Message-Id: <20230403140356.296427018@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
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

[ Upstream commit be6f42fad5f5fd1fea9d562df82c38ad6ed3bfe9 ]

Steve reported that inactive sessions are terminated after a few
seconds. ksmbd terminate when receiving -EAGAIN error from
kernel_recvmsg(). -EAGAIN means there is no data available in timeout.
So ksmbd should keep connection with unlimited retries instead of
terminating inactive sessions.

Cc: stable@vger.kernel.org
Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/connection.c     |  4 ++--
 fs/ksmbd/connection.h     |  3 ++-
 fs/ksmbd/transport_rdma.c |  2 +-
 fs/ksmbd/transport_tcp.c  | 35 +++++++++++++++++++++++------------
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 6105649b4ebb0..610abaadbb677 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -292,7 +292,7 @@ int ksmbd_conn_handler_loop(void *p)
 		kvfree(conn->request_buf);
 		conn->request_buf = NULL;
 
-		size = t->ops->read(t, hdr_buf, sizeof(hdr_buf));
+		size = t->ops->read(t, hdr_buf, sizeof(hdr_buf), -1);
 		if (size != sizeof(hdr_buf))
 			break;
 
@@ -335,7 +335,7 @@ int ksmbd_conn_handler_loop(void *p)
 		 * We already read 4 bytes to find out PDU size, now
 		 * read in PDU
 		 */
-		size = t->ops->read(t, conn->request_buf + 4, pdu_size);
+		size = t->ops->read(t, conn->request_buf + 4, pdu_size, 2);
 		if (size < 0) {
 			pr_err("sock_read failed: %d\n", size);
 			break;
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 8694aef482c1a..4b15c5e673d92 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -122,7 +122,8 @@ struct ksmbd_conn_ops {
 struct ksmbd_transport_ops {
 	int (*prepare)(struct ksmbd_transport *t);
 	void (*disconnect)(struct ksmbd_transport *t);
-	int (*read)(struct ksmbd_transport *t, char *buf, unsigned int size);
+	int (*read)(struct ksmbd_transport *t, char *buf,
+		    unsigned int size, int max_retries);
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
 		      int size, bool need_invalidate_rkey,
 		      unsigned int remote_key);
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 9d67419929d6c..9ca29cdb7898f 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -663,7 +663,7 @@ static int smb_direct_post_recv(struct smb_direct_transport *t,
 }
 
 static int smb_direct_read(struct ksmbd_transport *t, char *buf,
-			   unsigned int size)
+			   unsigned int size, int unused)
 {
 	struct smb_direct_recvmsg *recvmsg;
 	struct smb_direct_data_transfer *data_transfer;
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index e0ca6cc04b91c..d1d7954368a56 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -291,16 +291,18 @@ static int ksmbd_tcp_run_kthread(struct interface *iface)
 
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
@@ -308,7 +310,6 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
 	struct msghdr ksmbd_msg;
 	struct kvec *iov;
 	struct ksmbd_conn *conn = KSMBD_TRANS(t)->conn;
-	int max_retry = 2;
 
 	iov = get_conn_iovec(t, nr_segs);
 	if (!iov)
@@ -335,14 +336,23 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
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
@@ -358,14 +368,15 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
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
-- 
2.39.2



