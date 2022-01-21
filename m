Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCCA49685D
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 00:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiAUXyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 18:54:09 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:33282 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiAUXyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 18:54:07 -0500
Received: by mail-pf1-f178.google.com with SMTP id y27so6105227pfa.0;
        Fri, 21 Jan 2022 15:54:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=khIC+u+MTPJ26mN7B+E2bNWIhiuFBq3/IbsqxM4+2ys=;
        b=SOGzurSdsjQbbW+IpUW011P3sJME4av5fhZIDpPpMPpr/XCdRGWOj6ZK2kzJjbX48z
         z3eh/4xuh303jbT783bD8GxlHUDDcvk39jj8sCAznGR59JNm8hJGLysgTFnaAxDx5O7g
         CP1jcCBB0orTdiH0kpgVFKXQkT1px9iMwNr27QAe6n5x1t7UluxgmppZQKjlgXroLbEJ
         3U2CNUYdQjM4pAl6DJsG53hINPQmqfnxE/FgZ/seP6kXvJbpfOOt6COuK+Q3fOseHcUB
         rzwwXXJK0QAExB2PECAJcgM/STdbZxksb1O3Wse3lwmk6rwPMHub9hs7HoDIeO0TT51O
         ltuw==
X-Gm-Message-State: AOAM532L5Dpu09QASr71N8JiV6FVxhjkq2aPz4ROaa0ZWOGlTQ1a+p7r
        Vs4P2cgfLxnirynIzlsdK9ETK7pN4FQ=
X-Google-Smtp-Source: ABdhPJyjXbsyyNsUsZqUsHfgFQpHFScvk3yRbY187roDQQaqaGPnUw1RJPkfddY5TFLr2Tp/t/1C2Q==
X-Received: by 2002:a63:b44a:: with SMTP id n10mr4431716pgu.77.1642809247178;
        Fri, 21 Jan 2022 15:54:07 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id nn14sm6076356pjb.26.2022.01.21.15.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 15:54:06 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15.y 4/4] ksmbd: add reserved room in ipc request/response
Date:   Sat, 22 Jan 2022 08:53:40 +0900
Message-Id: <20220121235340.10269-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220121235340.10269-1-linkinjeon@kernel.org>
References: <20220121235340.10269-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 41dbda16a0902798e732abc6599de256b9dc3b27 upstream.

Whenever new parameter is added to smb configuration, It is possible
to break the execution of the IPC daemon by mismatch size of
request/response. This patch tries to reserve space in ipc request/response
in advance to prevent that.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/ksmbd/ksmbd_netlink.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index a5c2861792ae..71bfb7de4472 100644
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
-- 
2.25.1

