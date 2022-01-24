Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FE3499E63
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348768AbiAXWdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586851AbiAXW1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:27:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD07BC019B16;
        Mon, 24 Jan 2022 12:54:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D93D61287;
        Mon, 24 Jan 2022 20:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FEFC36B01;
        Mon, 24 Jan 2022 20:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057671;
        bh=olKOp1fP6GqohxFV6u2yGgn8fWqUo03Gd4u6tv86pMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/1y1uJq8aiwJCwCHHeFVdn0xlCEcLGGEoQl3OZCzluHP5zpN3sSl9ijaZXDbt73D
         j1/CMdy0rMPKk4Qu6VwSDJtlqHeNWJEA1x/V6PhiUPlBYrXv6OMDxoEoThSASt6ZYW
         erXCJnlu9hFhHADN3h3xIGEywRlNQ2I5jCWIwkSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16 0041/1039] ksmbd: add reserved room in ipc request/response
Date:   Mon, 24 Jan 2022 19:30:30 +0100
Message-Id: <20220124184126.518506728@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 41dbda16a0902798e732abc6599de256b9dc3b27 upstream.

Whenever new parameter is added to smb configuration, It is possible
to break the execution of the IPC daemon by mismatch size of
request/response. This patch tries to reserve space in ipc request/response
in advance to prevent that.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ksmbd_netlink.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -104,6 +104,7 @@ struct ksmbd_startup_request {
 					 */
 	__u32	sub_auth[3];		/* Subauth value for Security ID */
 	__u32	smb2_max_credits;	/* MAX credits */
+	__u32	reserved[128];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 };
@@ -114,7 +115,7 @@ struct ksmbd_startup_request {
  * IPC request to shutdown ksmbd server.
  */
 struct ksmbd_shutdown_request {
-	__s32	reserved;
+	__s32	reserved[16];
 };
 
 /*
@@ -123,6 +124,7 @@ struct ksmbd_shutdown_request {
 struct ksmbd_login_request {
 	__u32	handle;
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ]; /* user account name */
+	__u32	reserved[16];				/* Reserved room */
 };
 
 /*
@@ -136,6 +138,7 @@ struct ksmbd_login_response {
 	__u16	status;
 	__u16	hash_sz;			/* hash size */
 	__s8	hash[KSMBD_REQ_MAX_HASH_SZ];	/* password hash */
+	__u32	reserved[16];			/* Reserved room */
 };
 
 /*
@@ -144,6 +147,7 @@ struct ksmbd_login_response {
 struct ksmbd_share_config_request {
 	__u32	handle;
 	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME]; /* share name */
+	__u32	reserved[16];		/* Reserved room */
 };
 
 /*
@@ -158,6 +162,7 @@ struct ksmbd_share_config_response {
 	__u16	force_directory_mode;
 	__u16	force_uid;
 	__u16	force_gid;
+	__u32	reserved[128];		/* Reserved room */
 	__u32	veto_list_sz;
 	__s8	____payload[];
 };
@@ -188,6 +193,7 @@ struct ksmbd_tree_connect_request {
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ];
 	__s8	share[KSMBD_REQ_MAX_SHARE_NAME];
 	__s8	peer_addr[64];
+	__u32	reserved[16];		/* Reserved room */
 };
 
 /*
@@ -197,6 +203,7 @@ struct ksmbd_tree_connect_response {
 	__u32	handle;
 	__u16	status;
 	__u16	connection_flags;
+	__u32	reserved[16];		/* Reserved room */
 };
 
 /*
@@ -205,6 +212,7 @@ struct ksmbd_tree_connect_response {
 struct ksmbd_tree_disconnect_request {
 	__u64	session_id;	/* session id */
 	__u64	connect_id;	/* tree connection id */
+	__u32	reserved[16];	/* Reserved room */
 };
 
 /*
@@ -213,6 +221,7 @@ struct ksmbd_tree_disconnect_request {
 struct ksmbd_logout_request {
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ]; /* user account name */
 	__u32	account_flags;
+	__u32	reserved[16];				/* Reserved room */
 };
 
 /*


