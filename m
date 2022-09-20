Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE315BEB30
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiITQhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 12:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiITQhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 12:37:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BD46D549
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 09:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E32D5B82B4F
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 16:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5226CC433D6;
        Tue, 20 Sep 2022 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663691827;
        bh=DRuRNO7/0u8mzKtUckGwoRktlYSmcPNxUp6zMqxncSQ=;
        h=Subject:To:Cc:From:Date:From;
        b=XP9QQBoziRl3HEzPRqdKKUeS0ZTmWNy5fl9zM9sW/ukND+UpdTtBttY9ovQjykism
         gOdgQM2qZbv4Ap/dCrR03fsxWifTPCZ00ldsFleva5+J8aRSxBawrnVaQQUR2C58MM
         edvA0TRUWvoH/O6zcJLu+SqUBBypHqL/w3B758U4=
Subject: FAILED: patch "[PATCH] cifs: always initialize struct msghdr smb_msg completely" failed to apply to 4.9-stable tree
To:     metze@samba.org, lsahlber@redhat.com, pc@cjr.nz,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 20 Sep 2022 18:36:50 +0200
Message-ID: <1663691810184184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

bedc8f76b353 ("cifs: always initialize struct msghdr smb_msg completely")
17d3df38dc5f ("cifs: don't send down the destination address to sendmsg for a SOCK_STREAM")
cf0604a686b1 ("cifs: use discard iterator to discard unneeded network data more efficiently")
db10538a4b99 ("tcp: add tcp_sock_set_cork")
13091aa30535 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bedc8f76b3539ac4f952114b316bcc2251e808ce Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Wed, 14 Sep 2022 05:25:47 +0200
Subject: [PATCH] cifs: always initialize struct msghdr smb_msg completely

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

