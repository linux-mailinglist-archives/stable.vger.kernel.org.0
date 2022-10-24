Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80D760A960
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbiJXNUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiJXNRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:17:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D56625C;
        Mon, 24 Oct 2022 05:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71FBD612A1;
        Mon, 24 Oct 2022 12:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850ACC433D6;
        Mon, 24 Oct 2022 12:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614394;
        bh=ZEKZ0rHKHvvFCsKbf3+2Hp2IMvYXyT0zHyqCHjppJ5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5/VLANVLlPEYC7AZ71NDFXmEx07V5mX+Byk1RJEOjmHj/6GbQrgbUkoDYCH9+qj1
         7AnlcMqcAWTFYoulWJTVkL/wAZUbeXt/He27PrLLu9xQotXeCSdoWuEwWSJNCsnr4Q
         KGNhDKkqNx7KmsXgkfFgQRkOu/hJAxuBYqeuD2W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/390] scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername()
Date:   Mon, 24 Oct 2022 13:30:41 +0200
Message-Id: <20221024113033.228525124@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 57569c37f0add1b6489e1a1563c71519daf732cf ]

Fix a NULL pointer crash that occurs when we are freeing the socket at the
same time we access it via sysfs.

The problem is that:

 1. iscsi_sw_tcp_conn_get_param() and iscsi_sw_tcp_host_get_param() take
    the frwd_lock and do sock_hold() then drop the frwd_lock. sock_hold()
    does a get on the "struct sock".

 2. iscsi_sw_tcp_release_conn() does sockfd_put() which does the last put
    on the "struct socket" and that does __sock_release() which sets the
    sock->ops to NULL.

 3. iscsi_sw_tcp_conn_get_param() and iscsi_sw_tcp_host_get_param() then
    call kernel_getpeername() which accesses the NULL sock->ops.

Above we do a get on the "struct sock", but we needed a get on the "struct
socket". Originally, we just held the frwd_lock the entire time but in
commit bcf3a2953d36 ("scsi: iscsi: iscsi_tcp: Avoid holding spinlock while
calling getpeername()") we switched to refcount based because the network
layer changed and started taking a mutex in that path, so we could no
longer hold the frwd_lock.

Instead of trying to maintain multiple refcounts, this just has us use a
mutex for accessing the socket in the interface code paths.

Link: https://lore.kernel.org/r/20220907221700.10302-1-michael.christie@oracle.com
Fixes: bcf3a2953d36 ("scsi: iscsi: iscsi_tcp: Avoid holding spinlock while calling getpeername()")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_tcp.c | 73 ++++++++++++++++++++++++++++------------
 drivers/scsi/iscsi_tcp.h |  2 ++
 2 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index df47557a02a3..6485c1aa9e74 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -558,6 +558,8 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 	tcp_conn = conn->dd_data;
 	tcp_sw_conn = tcp_conn->dd_data;
 
+	mutex_init(&tcp_sw_conn->sock_lock);
+
 	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm))
 		goto free_conn;
@@ -592,11 +594,15 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 
 static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 {
-	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct socket *sock = tcp_sw_conn->sock;
 
+	/*
+	 * The iscsi transport class will make sure we are not called in
+	 * parallel with start, stop, bind and destroys. However, this can be
+	 * called twice if userspace does a stop then a destroy.
+	 */
 	if (!sock)
 		return;
 
@@ -604,9 +610,9 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
 
-	spin_lock_bh(&session->frwd_lock);
+	mutex_lock(&tcp_sw_conn->sock_lock);
 	tcp_sw_conn->sock = NULL;
-	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&tcp_sw_conn->sock_lock);
 	sockfd_put(sock);
 }
 
@@ -658,7 +664,6 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
 		       int is_leading)
 {
-	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
@@ -678,10 +683,10 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	if (err)
 		goto free_socket;
 
-	spin_lock_bh(&session->frwd_lock);
+	mutex_lock(&tcp_sw_conn->sock_lock);
 	/* bind iSCSI connection and socket */
 	tcp_sw_conn->sock = sock;
-	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&tcp_sw_conn->sock_lock);
 
 	/* setup Socket parameters */
 	sk = sock->sk;
@@ -717,8 +722,15 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
+
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		if (!tcp_sw_conn->sock) {
+			mutex_unlock(&tcp_sw_conn->sock_lock);
+			return -ENOTCONN;
+		}
 		tcp_sw_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
+		mutex_unlock(&tcp_sw_conn->sock_lock);
 		break;
 	case ISCSI_PARAM_MAX_R2T:
 		return iscsi_tcp_set_max_r2t(conn, buf);
@@ -733,8 +745,8 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				       enum iscsi_param param, char *buf)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn;
+	struct iscsi_tcp_conn *tcp_conn;
 	struct sockaddr_in6 addr;
 	struct socket *sock;
 	int rc;
@@ -744,21 +756,36 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_CONN_ADDRESS:
 	case ISCSI_PARAM_LOCAL_PORT:
 		spin_lock_bh(&conn->session->frwd_lock);
-		if (!tcp_sw_conn || !tcp_sw_conn->sock) {
+		if (!conn->session->leadconn) {
 			spin_unlock_bh(&conn->session->frwd_lock);
 			return -ENOTCONN;
 		}
-		sock = tcp_sw_conn->sock;
-		sock_hold(sock->sk);
+		/*
+		 * The conn has been setup and bound, so just grab a ref
+		 * incase a destroy runs while we are in the net layer.
+		 */
+		iscsi_get_conn(conn->cls_conn);
 		spin_unlock_bh(&conn->session->frwd_lock);
 
+		tcp_conn = conn->dd_data;
+		tcp_sw_conn = tcp_conn->dd_data;
+
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		sock = tcp_sw_conn->sock;
+		if (!sock) {
+			rc = -ENOTCONN;
+			goto sock_unlock;
+		}
+
 		if (param == ISCSI_PARAM_LOCAL_PORT)
 			rc = kernel_getsockname(sock,
 						(struct sockaddr *)&addr);
 		else
 			rc = kernel_getpeername(sock,
 						(struct sockaddr *)&addr);
-		sock_put(sock->sk);
+sock_unlock:
+		mutex_unlock(&tcp_sw_conn->sock_lock);
+		iscsi_put_conn(conn->cls_conn);
 		if (rc < 0)
 			return rc;
 
@@ -796,17 +823,21 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 		}
 		tcp_conn = conn->dd_data;
 		tcp_sw_conn = tcp_conn->dd_data;
-		sock = tcp_sw_conn->sock;
-		if (!sock) {
-			spin_unlock_bh(&session->frwd_lock);
-			return -ENOTCONN;
-		}
-		sock_hold(sock->sk);
+		/*
+		 * The conn has been setup and bound, so just grab a ref
+		 * incase a destroy runs while we are in the net layer.
+		 */
+		iscsi_get_conn(conn->cls_conn);
 		spin_unlock_bh(&session->frwd_lock);
 
-		rc = kernel_getsockname(sock,
-					(struct sockaddr *)&addr);
-		sock_put(sock->sk);
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		sock = tcp_sw_conn->sock;
+		if (!sock)
+			rc = -ENOTCONN;
+		else
+			rc = kernel_getsockname(sock, (struct sockaddr *)&addr);
+		mutex_unlock(&tcp_sw_conn->sock_lock);
+		iscsi_put_conn(conn->cls_conn);
 		if (rc < 0)
 			return rc;
 
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 791453195099..1731956326e2 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -28,6 +28,8 @@ struct iscsi_sw_tcp_send {
 
 struct iscsi_sw_tcp_conn {
 	struct socket		*sock;
+	/* Taken when accessing the sock from the netlink/sysfs interface */
+	struct mutex		sock_lock;
 
 	struct iscsi_sw_tcp_send out;
 	/* old values for socket callbacks */
-- 
2.35.1



