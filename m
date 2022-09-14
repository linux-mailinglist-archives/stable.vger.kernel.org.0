Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3E95B7F5A
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 05:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiIND0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 23:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiIND0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 23:26:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B29F252BB;
        Tue, 13 Sep 2022 20:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=wxlR+RcKUNcVxnL6r+YGXf5ONGBXh0hxXEDFCnNmUUc=; b=rIh8a1Xwm5Dv9JV8XThLe0X4B0
        nU+u9ewqPZXVLchhBJ3m+IsBQcaAxjsM6tiaxSCsQNXcjxBiS2sAVVcDp6AvHDUAc3MJ9LEn9QmVH
        wDR9MsS1iHW8pOloUq9IhnqfYXqAVoPrgLaJ2gJjRNKrBb+7DLclmSvFWRM1p5Q0rbDWBY1gGgWRf
        2EJsgpiCbcPTQkYGPuaJxEMD05QHXizX/Ai7DWVFMQ2BCoXoR25nmGzw1OjUMx+pnMxfGvsC0CyxF
        Q17rt8Yuhnf9ydA8+A7BPuKWOl7n3fy5GaNXYe9DBr2o1F4+177yQl+jNdtc3uVycwlo1Zu1ibKFs
        5c2usexzFxXmIcjgYJcmjTmQjHUT1v89raeUa+XJKWCsqOqMZQ2of00DMjWH/qMoomhFmA5GJyonN
        o6k/LBT/m/ak65+UwPeLBLthsKrg1BhCYE+ZzXR8Zbk8FOYU5Xp+bjbOyNsPwcfLNeEn3jidmE9RT
        +Wmer80JFKMyuQtbaRkZZoAG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oYJ2y-000I00-7G; Wed, 14 Sep 2022 03:26:44 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org,
        Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/2] cifs: always initialize struct msghdr smb_msg completely
Date:   Wed, 14 Sep 2022 05:25:47 +0200
Message-Id: <275d7b418b433823eb327a6f7ec8c95358da3277.1663125352.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663125352.git.metze@samba.org>
References: <cover.1663125352.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

So far we were just lucky because the uninitialized members
of struct msghdr are not used by default on a SOCK_STREAM tcp
socket.

But as new things like msg_ubuf and sg_from_iter where added
recently, we should play on the safe side and avoid potention
problems in future.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c   | 11 +++--------
 fs/cifs/transport.c |  6 +-----
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a0a06b6f252b..0225f4c8adf0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -702,9 +702,6 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 	int length = 0;
 	int total_read;
 
-	smb_msg->msg_control = NULL;
-	smb_msg->msg_controllen = 0;
-
 	for (total_read = 0; msg_data_left(smb_msg); total_read += length) {
 		try_to_freeze();
 
@@ -760,7 +757,7 @@ int
 cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 		      unsigned int to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
 	iov_iter_kvec(&smb_msg.msg_iter, READ, &iov, 1, to_read);
 
@@ -770,15 +767,13 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 ssize_t
 cifs_discard_from_socket(struct TCP_Server_Info *server, size_t to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 
 	/*
 	 *  iov_iter_discard already sets smb_msg.type and count and iov_offset
 	 *  and cifs_readv_from_socket sets msg_control and msg_controllen
 	 *  so little to initialize in struct msghdr
 	 */
-	smb_msg.msg_name = NULL;
-	smb_msg.msg_namelen = 0;
 	iov_iter_discard(&smb_msg.msg_iter, READ, to_read);
 
 	return cifs_readv_from_socket(server, &smb_msg);
@@ -788,7 +783,7 @@ int
 cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 	unsigned int page_offset, unsigned int to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	struct bio_vec bv = {
 		.bv_page = page, .bv_len = to_read, .bv_offset = page_offset};
 	iov_iter_bvec(&smb_msg.msg_iter, READ, &bv, 1, to_read);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index a43c87c1d343..9a2753e21170 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -194,10 +194,6 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 
 	*sent = 0;
 
-	smb_msg->msg_name = NULL;
-	smb_msg->msg_namelen = 0;
-	smb_msg->msg_control = NULL;
-	smb_msg->msg_controllen = 0;
 	if (server->noblocksnd)
 		smb_msg->msg_flags = MSG_DONTWAIT + MSG_NOSIGNAL;
 	else
@@ -309,7 +305,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	sigset_t mask, oldmask;
 	size_t total_len = 0, sent, size;
 	struct socket *ssocket = server->ssocket;
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	__be32 rfc1002_marker;
 
 	if (cifs_rdma_enabled(server)) {
-- 
2.34.1

