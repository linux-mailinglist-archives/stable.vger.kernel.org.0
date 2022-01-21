Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75B7496868
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 00:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiAUXyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 18:54:53 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:43794 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiAUXyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 18:54:52 -0500
Received: by mail-pj1-f49.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so10378650pja.2;
        Fri, 21 Jan 2022 15:54:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=khIC+u+MTPJ26mN7B+E2bNWIhiuFBq3/IbsqxM4+2ys=;
        b=P2yYYXnynGFA+FwdqRmi6DLNFiXOZpugK7VDM0JXx3ik6c5wUg7WkO9CrrvU6n0xA5
         98EL/egFjFQh4VOy5yfNxcDHkq4dpLUyVZdo8h3+uqzmAMTa8P/nHVKcA5x31gs44zUx
         bhjYLLebL1gXvaq+y4WZBHO2bfjRBJss6nmalt6ezGMUghbzhZVfzuR/GI0hQ2lCHbiK
         ZoCoD+rjzA5n0lIUs3jJS1L2wLtiq8MbcGWOV3g5M8lr1CagumLyfNGUAOCDZeFhwPJT
         Hq+G45xe5CErbET9wVFH/iicvJ52mAd2iJIyfjO9z3Juvj5NDRICdZbMrRLAvlbXh3zr
         mtDg==
X-Gm-Message-State: AOAM531IDzVkASq73UyPbgTnOUHNJJ7kC9eQhXNFviBF9gDckIgtybsa
        KcMHuwGEgBOxzzc79/BjGdE=
X-Google-Smtp-Source: ABdhPJzmiUrNX+fQdXmn4xsTI6+DtURENPdFZ/lX5y/UX9DVx2RgIVgBeO6uwaQK18s0EtohBh4cYw==
X-Received: by 2002:a17:902:aa4b:b0:14a:cff4:19ec with SMTP id c11-20020a170902aa4b00b0014acff419ecmr6146675plr.60.1642809291670;
        Fri, 21 Jan 2022 15:54:51 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id 5sm14530082pjf.34.2022.01.21.15.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 15:54:51 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16.y 4/4] ksmbd: add reserved room in ipc request/response
Date:   Sat, 22 Jan 2022 08:54:27 +0900
Message-Id: <20220121235427.10349-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220121235427.10349-1-linkinjeon@kernel.org>
References: <20220121235427.10349-1-linkinjeon@kernel.org>
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

