Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018685EA264
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237356AbiIZLGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbiIZLGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:06:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A551F2F7;
        Mon, 26 Sep 2022 03:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B89B60CBA;
        Mon, 26 Sep 2022 10:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890A8C433C1;
        Mon, 26 Sep 2022 10:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188418;
        bh=N+8bQDQp77I4BCxPZxRnBskbs6fao6jprpFCgIVyF8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3bqrQ4Hc9pwimOdecm4WnKFdU7c/Y7CWENBQlVecgqmDSnmjXtR95WTsDViwa0/g
         4c+d0VEkMBhfWVb6P4g/IftvIixYeGM4QhR+p4YUkXFZUFc/wjO6ESDIabZbQxgnA1
         Ji/WJHJYKELggUykIAcKmLaZljAF6WgOlWLP8dr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/141] cifs: use discard iterator to discard unneeded network data more efficiently
Date:   Mon, 26 Sep 2022 12:12:30 +0200
Message-Id: <20220926100758.942222886@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit cf0604a686b11175d8beae60281c4ccc95aaa5c2 ]

The iterator, ITER_DISCARD, that can only be used in READ mode and
just discards any data copied to it, was added to allow a network
filesystem to discard any unwanted data sent by a server.
Convert cifs_discard_from_socket() to use this.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: bedc8f76b353 ("cifs: always initialize struct msghdr smb_msg completely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsproto.h |  2 ++
 fs/cifs/cifssmb.c   |  6 +++---
 fs/cifs/connect.c   | 17 +++++++++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 24c6f36177ba..a6ca4eda9a5a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -230,6 +230,8 @@ extern unsigned int setup_special_user_owner_ACE(struct cifs_ace *pace);
 extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
 extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 			         unsigned int to_read);
+extern ssize_t cifs_discard_from_socket(struct TCP_Server_Info *server,
+					size_t to_read);
 extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
 					struct page *page,
 					unsigned int page_offset,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0496934feecb..c279527aae92 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1451,9 +1451,9 @@ cifs_discard_remaining_data(struct TCP_Server_Info *server)
 	while (remaining > 0) {
 		int length;
 
-		length = cifs_read_from_socket(server, server->bigbuf,
-				min_t(unsigned int, remaining,
-				    CIFSMaxBufSize + MAX_HEADER_SIZE(server)));
+		length = cifs_discard_from_socket(server,
+				min_t(size_t, remaining,
+				      CIFSMaxBufSize + MAX_HEADER_SIZE(server)));
 		if (length < 0)
 			return length;
 		server->total_read += length;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7f5d173760cf..6e7d5b9e84b8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -755,6 +755,23 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 	return cifs_readv_from_socket(server, &smb_msg);
 }
 
+ssize_t
+cifs_discard_from_socket(struct TCP_Server_Info *server, size_t to_read)
+{
+	struct msghdr smb_msg;
+
+	/*
+	 *  iov_iter_discard already sets smb_msg.type and count and iov_offset
+	 *  and cifs_readv_from_socket sets msg_control and msg_controllen
+	 *  so little to initialize in struct msghdr
+	 */
+	smb_msg.msg_name = NULL;
+	smb_msg.msg_namelen = 0;
+	iov_iter_discard(&smb_msg.msg_iter, READ, to_read);
+
+	return cifs_readv_from_socket(server, &smb_msg);
+}
+
 int
 cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 	unsigned int page_offset, unsigned int to_read)
-- 
2.35.1



