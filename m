Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9349B6CBEF4
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjC1MX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjC1MX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:23:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3831BE1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:23:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31562B81CA6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD56C433D2;
        Tue, 28 Mar 2023 12:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680006202;
        bh=2TkXhUPXqVyt8slRXjhKgRUlDdKfI1vad1O9jTB+7Qo=;
        h=Subject:To:Cc:From:Date:From;
        b=iXVUzK6eFv0C0ijFNcQr6MeY6znbZWdnmxQQG4SgOZtIM/9xORv/5QCDT2cOoo9SO
         sU0NeFBJC1WHFNlz+7W9qVgyk8hB3E7zZooQKTbYxeee96s4TGh0wkwiLemo6lThFn
         1D0V6I+WFfJMsJ0YsjoNu9WZgxVk81xz5BXi63bU=
Subject: FAILED: patch "[PATCH] ksmbd: don't terminate inactive sessions after a few seconds" failed to apply to 5.15-stable tree
To:     linkinjeon@kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:23:20 +0200
Message-ID: <168000620030178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x be6f42fad5f5fd1fea9d562df82c38ad6ed3bfe9
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '168000620030178@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

be6f42fad5f5 ("ksmbd: don't terminate inactive sessions after a few seconds")
83dcedd5540d ("ksmbd: fix infinite loop in ksmbd_conn_handler_loop()")
136dff3a6b71 ("ksmbd: add smb-direct shutdown")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From be6f42fad5f5fd1fea9d562df82c38ad6ed3bfe9 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 21 Mar 2023 15:25:34 +0900
Subject: [PATCH] ksmbd: don't terminate inactive sessions after a few seconds

Steve reported that inactive sessions are terminated after a few
seconds. ksmbd terminate when receiving -EAGAIN error from
kernel_recvmsg(). -EAGAIN means there is no data available in timeout.
So ksmbd should keep connection with unlimited retries instead of
terminating inactive sessions.

Cc: stable@vger.kernel.org
Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 5b10b03800c1..5d914715605f 100644
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
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 3643354a3fa7..0e3a848defaf 100644
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
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 096eda9ef873..c06efc020bd9 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -670,7 +670,7 @@ static int smb_direct_post_recv(struct smb_direct_transport *t,
 }
 
 static int smb_direct_read(struct ksmbd_transport *t, char *buf,
-			   unsigned int size)
+			   unsigned int size, int unused)
 {
 	struct smb_direct_recvmsg *recvmsg;
 	struct smb_direct_data_transfer *data_transfer;
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 603893fd87f5..20e85e2701f2 100644
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

