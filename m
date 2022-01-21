Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1152496862
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 00:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiAUXyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 18:54:43 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:41732 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiAUXym (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 18:54:42 -0500
Received: by mail-pl1-f174.google.com with SMTP id e8so10084635plh.8;
        Fri, 21 Jan 2022 15:54:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qiUDYeE4bFCB9/8M/hX30JmAmvOyaQeLUDs6VhvkilY=;
        b=SKViBcBJtlTMmXshoB9W7MLyIf6NLUwl8B96q/p4p6QOB2e69p9YRU+Tl2tfVGHj3O
         5Co9OD5tAFIodiUVS5JZD7vlmw7R4mhUmZ9QfZ6s2k9TJB567fp/LNtvyg+cWJl/dIVq
         Z/hZav+eOfOJN+rCdIXK1b08NaFQtK3LoM1myKRc5QnQ2qN374fY5pZ5CpMnTkveXxfW
         Dj057Bg/8uEzilLz/yhXATZDLe1fR8TAW2lxnPdOszeiK2h9IlZf0BfUudIP/drrJQhz
         oqYYRnz4mQaTvpRzvgYSNSftnNhoi2mDRu/xFIq7inVtlJAC/sxnfzv8Yw/XL0USsOL+
         Uhzw==
X-Gm-Message-State: AOAM532Ep1GK/tMQrsGs1nVzOs/KGWPb1qNQumtaEOFd4dVnuoPaSW6M
        /exvUTTs19XqANRAlVw/W5DaMBhDmXY=
X-Google-Smtp-Source: ABdhPJz4pFMOOCIOtrYZhZCLl7JjrkpFkhloC0QIFUQFA7m8EWzGc5n3Y5PVhj+Dw8txA/2tTTdSIA==
X-Received: by 2002:a17:902:b60b:b0:14a:fa6d:7e4c with SMTP id b11-20020a170902b60b00b0014afa6d7e4cmr6046286pls.109.1642809282217;
        Fri, 21 Jan 2022 15:54:42 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id 5sm14530082pjf.34.2022.01.21.15.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 15:54:41 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16.y 1/4] ksmbd: add support for smb2 max credit parameter
Date:   Sat, 22 Jan 2022 08:54:24 +0900
Message-Id: <20220121235427.10349-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220121235427.10349-1-linkinjeon@kernel.org>
References: <20220121235427.10349-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 004443b3f6d722b455cf963ed7c3edd7f4772405 upstream.

Add smb2 max credits parameter to adjust maximum credits value to limit
number of outstanding requests.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/ksmbd/connection.h    |  1 -
 fs/ksmbd/ksmbd_netlink.h |  1 +
 fs/ksmbd/smb2misc.c      |  2 +-
 fs/ksmbd/smb2ops.c       | 16 ++++++++++++----
 fs/ksmbd/smb2pdu.c       |  8 ++++----
 fs/ksmbd/smb2pdu.h       |  1 +
 fs/ksmbd/smb_common.h    |  1 +
 fs/ksmbd/transport_ipc.c |  2 ++
 8 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index e5403c587a58..08e85568ccd6 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -62,7 +62,6 @@ struct ksmbd_conn {
 	/* References which are made for this Server object*/
 	atomic_t			r_count;
 	unsigned short			total_credits;
-	unsigned short			max_credits;
 	spinlock_t			credits_lock;
 	wait_queue_head_t		req_running_q;
 	/* Lock to protect requests list*/
diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index c6718a05d347..a5c2861792ae 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -103,6 +103,7 @@ struct ksmbd_startup_request {
 					 * we set the SPARSE_FILES bit (0x40).
 					 */
 	__u32	sub_auth[3];		/* Subauth value for Security ID */
+	__u32	smb2_max_credits;	/* MAX credits */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 };
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 50d0b1022289..6892d1822269 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -326,7 +326,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 		ksmbd_debug(SMB, "Insufficient credit charge, given: %d, needed: %d\n",
 			    credit_charge, calc_credit_num);
 		return 1;
-	} else if (credit_charge > conn->max_credits) {
+	} else if (credit_charge > conn->vals->max_credits) {
 		ksmbd_debug(SMB, "Too large credit charge: %d\n", credit_charge);
 		return 1;
 	}
diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index 02a44d28bdaf..ab23da2120b9 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -19,6 +19,7 @@ static struct smb_version_values smb21_server_values = {
 	.max_read_size = SMB21_DEFAULT_IOSIZE,
 	.max_write_size = SMB21_DEFAULT_IOSIZE,
 	.max_trans_size = SMB21_DEFAULT_IOSIZE,
+	.max_credits = SMB2_MAX_CREDITS,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED,
@@ -44,6 +45,7 @@ static struct smb_version_values smb30_server_values = {
 	.max_read_size = SMB3_DEFAULT_IOSIZE,
 	.max_write_size = SMB3_DEFAULT_IOSIZE,
 	.max_trans_size = SMB3_DEFAULT_TRANS_SIZE,
+	.max_credits = SMB2_MAX_CREDITS,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED,
@@ -70,6 +72,7 @@ static struct smb_version_values smb302_server_values = {
 	.max_read_size = SMB3_DEFAULT_IOSIZE,
 	.max_write_size = SMB3_DEFAULT_IOSIZE,
 	.max_trans_size = SMB3_DEFAULT_TRANS_SIZE,
+	.max_credits = SMB2_MAX_CREDITS,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED,
@@ -96,6 +99,7 @@ static struct smb_version_values smb311_server_values = {
 	.max_read_size = SMB3_DEFAULT_IOSIZE,
 	.max_write_size = SMB3_DEFAULT_IOSIZE,
 	.max_trans_size = SMB3_DEFAULT_TRANS_SIZE,
+	.max_credits = SMB2_MAX_CREDITS,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED,
@@ -197,7 +201,6 @@ void init_smb2_1_server(struct ksmbd_conn *conn)
 	conn->ops = &smb2_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_HMAC_SHA256_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
@@ -215,7 +218,6 @@ void init_smb3_0_server(struct ksmbd_conn *conn)
 	conn->ops = &smb3_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
@@ -240,7 +242,6 @@ void init_smb3_02_server(struct ksmbd_conn *conn)
 	conn->ops = &smb3_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
@@ -265,7 +266,6 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 	conn->ops = &smb3_11_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
@@ -304,3 +304,11 @@ void init_smb2_max_trans_size(unsigned int sz)
 	smb302_server_values.max_trans_size = sz;
 	smb311_server_values.max_trans_size = sz;
 }
+
+void init_smb2_max_credits(unsigned int sz)
+{
+	smb21_server_values.max_credits = sz;
+	smb30_server_values.max_credits = sz;
+	smb302_server_values.max_credits = sz;
+	smb311_server_values.max_credits = sz;
+}
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b8b3a4c28b74..d8f89b753c54 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -308,7 +308,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 
 	hdr->CreditCharge = req_hdr->CreditCharge;
 
-	if (conn->total_credits > conn->max_credits) {
+	if (conn->total_credits > conn->vals->max_credits) {
 		hdr->CreditRequest = 0;
 		pr_err("Total credits overflow: %d\n", conn->total_credits);
 		return -EINVAL;
@@ -329,12 +329,12 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	if (hdr->Command == SMB2_NEGOTIATE)
 		aux_max = 0;
 	else
-		aux_max = conn->max_credits - credit_charge;
+		aux_max = conn->vals->max_credits - credit_charge;
 	aux_credits = min_t(unsigned short, aux_credits, aux_max);
 	credits_granted = credit_charge + aux_credits;
 
-	if (conn->max_credits - conn->total_credits < credits_granted)
-		credits_granted = conn->max_credits -
+	if (conn->vals->max_credits - conn->total_credits < credits_granted)
+		credits_granted = conn->vals->max_credits -
 			conn->total_credits;
 
 	conn->total_credits += credits_granted;
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index 4a3e4339d4c4..725b800c29c8 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -980,6 +980,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn);
 void init_smb2_max_read_size(unsigned int sz);
 void init_smb2_max_write_size(unsigned int sz);
 void init_smb2_max_trans_size(unsigned int sz);
+void init_smb2_max_credits(unsigned int sz);
 
 bool is_smb2_neg_cmd(struct ksmbd_work *work);
 bool is_smb2_rsp(struct ksmbd_work *work);
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index 50590842b651..e1369b4345a9 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -365,6 +365,7 @@ struct smb_version_values {
 	__u32		max_read_size;
 	__u32		max_write_size;
 	__u32		max_trans_size;
+	__u32		max_credits;
 	__u32		large_lock_type;
 	__u32		exclusive_lock_type;
 	__u32		shared_lock_type;
diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index 1acf1892a466..3ad6881e0f7e 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -301,6 +301,8 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 		init_smb2_max_write_size(req->smb2_max_write);
 	if (req->smb2_max_trans)
 		init_smb2_max_trans_size(req->smb2_max_trans);
+	if (req->smb2_max_credits)
+		init_smb2_max_credits(req->smb2_max_credits);
 
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
-- 
2.25.1

