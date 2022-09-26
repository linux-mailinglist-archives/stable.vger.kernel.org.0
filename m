Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C795EA262
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbiIZLGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbiIZLF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:05:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05544F6B0;
        Mon, 26 Sep 2022 03:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C9BC60C05;
        Mon, 26 Sep 2022 10:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82142C433C1;
        Mon, 26 Sep 2022 10:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188422;
        bh=BPFEgtuDPRS6M4K2zKUGEDYswwOrwW1BnzLKphyFSNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFJrB5iUUwwFlMtnQB7cYXsoJmdkIQC6gzCTFabKoASDW2N+zUN2cVS0kDf4CLslI
         nNmU4fBWP7VNTOsG2DACdhVKhww+pE5XkOU4Wj/QmUj8IfNwvD78JyGXKpLemj6Zh4
         VJKAsArIqeBZeHaC+is0O3j9KqlwI2yU/z00R3lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/141] cifs: always initialize struct msghdr smb_msg completely
Date:   Mon, 26 Sep 2022 12:12:31 +0200
Message-Id: <20220926100758.986193625@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit bedc8f76b3539ac4f952114b316bcc2251e808ce ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c   | 11 +++--------
 fs/cifs/transport.c |  6 +-----
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6e7d5b9e84b8..d1c3086d7ddd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -695,9 +695,6 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 	int length = 0;
 	int total_read;
 
-	smb_msg->msg_control = NULL;
-	smb_msg->msg_controllen = 0;
-
 	for (total_read = 0; msg_data_left(smb_msg); total_read += length) {
 		try_to_freeze();
 
@@ -748,7 +745,7 @@ int
 cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 		      unsigned int to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
 	iov_iter_kvec(&smb_msg.msg_iter, READ, &iov, 1, to_read);
 
@@ -758,15 +755,13 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
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
@@ -776,7 +771,7 @@ int
 cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 	unsigned int page_offset, unsigned int to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	struct bio_vec bv = {
 		.bv_page = page, .bv_len = to_read, .bv_offset = page_offset};
 	iov_iter_bvec(&smb_msg.msg_iter, READ, &bv, 1, to_read);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 383ae8744c33..b137006f0fd2 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -209,10 +209,6 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 
 	*sent = 0;
 
-	smb_msg->msg_name = NULL;
-	smb_msg->msg_namelen = 0;
-	smb_msg->msg_control = NULL;
-	smb_msg->msg_controllen = 0;
 	if (server->noblocksnd)
 		smb_msg->msg_flags = MSG_DONTWAIT + MSG_NOSIGNAL;
 	else
@@ -324,7 +320,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	sigset_t mask, oldmask;
 	size_t total_len = 0, sent, size;
 	struct socket *ssocket = server->ssocket;
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	__be32 rfc1002_marker;
 
 	if (cifs_rdma_enabled(server)) {
-- 
2.35.1



