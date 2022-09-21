Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9785C0256
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiIUPvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiIUPvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:51:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35429E6BD;
        Wed, 21 Sep 2022 08:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34CCDB830A2;
        Wed, 21 Sep 2022 15:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB76C433D6;
        Wed, 21 Sep 2022 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775294;
        bh=WqbU4bRX8dq5JfsA1AgVgblRWyx1f/Vw5GJBaC3Mdaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVPqRIh5Mvo7bjF3FAgoOVdKrAPZxxRglT8RsT0R8QtGzEfVq6kzUk9R7iyf49FEY
         VXhTzMbNxj7UEddi+Klbcu2LEP2sTgawvzq/qntS3YlelHwcK29ia8e8C0n0WS1GlO
         tSpe71/yZP+GybuYEFPwAXsFcxEnBjj9/L0ZK01c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.19 24/38] cifs: always initialize struct msghdr smb_msg completely
Date:   Wed, 21 Sep 2022 17:46:08 +0200
Message-Id: <20220921153647.023752565@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

commit bedc8f76b3539ac4f952114b316bcc2251e808ce upstream.

So far we were just lucky because the uninitialized members
of struct msghdr are not used by default on a SOCK_STREAM tcp
socket.

But as new things like msg_ubuf and sg_from_iter where added
recently, we should play on the safe side and avoid potention
problems in future.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c   |   11 +++--------
 fs/cifs/transport.c |    6 +-----
 2 files changed, 4 insertions(+), 13 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -707,9 +707,6 @@ cifs_readv_from_socket(struct TCP_Server
 	int length = 0;
 	int total_read;
 
-	smb_msg->msg_control = NULL;
-	smb_msg->msg_controllen = 0;
-
 	for (total_read = 0; msg_data_left(smb_msg); total_read += length) {
 		try_to_freeze();
 
@@ -765,7 +762,7 @@ int
 cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 		      unsigned int to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
 	iov_iter_kvec(&smb_msg.msg_iter, READ, &iov, 1, to_read);
 
@@ -775,15 +772,13 @@ cifs_read_from_socket(struct TCP_Server_
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
@@ -793,7 +788,7 @@ int
 cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 	unsigned int page_offset, unsigned int to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	struct bio_vec bv = {
 		.bv_page = page, .bv_len = to_read, .bv_offset = page_offset};
 	iov_iter_bvec(&smb_msg.msg_iter, READ, &bv, 1, to_read);
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -196,10 +196,6 @@ smb_send_kvec(struct TCP_Server_Info *se
 
 	*sent = 0;
 
-	smb_msg->msg_name = NULL;
-	smb_msg->msg_namelen = 0;
-	smb_msg->msg_control = NULL;
-	smb_msg->msg_controllen = 0;
 	if (server->noblocksnd)
 		smb_msg->msg_flags = MSG_DONTWAIT + MSG_NOSIGNAL;
 	else
@@ -311,7 +307,7 @@ __smb_send_rqst(struct TCP_Server_Info *
 	sigset_t mask, oldmask;
 	size_t total_len = 0, sent, size;
 	struct socket *ssocket = server->ssocket;
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	__be32 rfc1002_marker;
 
 	if (cifs_rdma_enabled(server)) {


