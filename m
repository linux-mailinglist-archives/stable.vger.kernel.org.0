Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB0B499E38
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355917AbiAXWaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586055AbiAXWZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:25:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3AFC034000;
        Mon, 24 Jan 2022 12:54:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26E11611ED;
        Mon, 24 Jan 2022 20:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D735C340E5;
        Mon, 24 Jan 2022 20:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057662;
        bh=J+KXYCuBSxn16KMxMHIqNdfyCFf5L/O1RLEaiAnQBSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOwi0pqCvZobkeWDypFPCMOaPhCJcHDg5ffO92C/iQk3wGU5eHfAjRt8AVBR3AmH4
         iK38/rQyJkfuU1L9nJl71QtsBO7Bw2qjuO0NfJPnHPXNtd+CJQQNfTbx9Wa3+JFpdl
         0Jf1SuctgE0xhhBqc8rd0wSYFXeb9NOXgy4tZnUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16 0038/1039] ksmbd: add support for smb2 max credit parameter
Date:   Mon, 24 Jan 2022 19:30:27 +0100
Message-Id: <20220124184126.414273851@linuxfoundation.org>
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

commit 004443b3f6d722b455cf963ed7c3edd7f4772405 upstream.

Add smb2 max credits parameter to adjust maximum credits value to limit
number of outstanding requests.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.h    |    1 -
 fs/ksmbd/ksmbd_netlink.h |    1 +
 fs/ksmbd/smb2misc.c      |    2 +-
 fs/ksmbd/smb2ops.c       |   16 ++++++++++++----
 fs/ksmbd/smb2pdu.c       |    8 ++++----
 fs/ksmbd/smb2pdu.h       |    1 +
 fs/ksmbd/smb_common.h    |    1 +
 fs/ksmbd/transport_ipc.c |    2 ++
 8 files changed, 22 insertions(+), 10 deletions(-)

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
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -326,7 +326,7 @@ static int smb2_validate_credit_charge(s
 		ksmbd_debug(SMB, "Insufficient credit charge, given: %d, needed: %d\n",
 			    credit_charge, calc_credit_num);
 		return 1;
-	} else if (credit_charge > conn->max_credits) {
+	} else if (credit_charge > conn->vals->max_credits) {
 		ksmbd_debug(SMB, "Too large credit charge: %d\n", credit_charge);
 		return 1;
 	}
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -19,6 +19,7 @@ static struct smb_version_values smb21_s
 	.max_read_size = SMB21_DEFAULT_IOSIZE,
 	.max_write_size = SMB21_DEFAULT_IOSIZE,
 	.max_trans_size = SMB21_DEFAULT_IOSIZE,
+	.max_credits = SMB2_MAX_CREDITS,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED,
@@ -44,6 +45,7 @@ static struct smb_version_values smb30_s
 	.max_read_size = SMB3_DEFAULT_IOSIZE,
 	.max_write_size = SMB3_DEFAULT_IOSIZE,
 	.max_trans_size = SMB3_DEFAULT_TRANS_SIZE,
+	.max_credits = SMB2_MAX_CREDITS,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED,
@@ -70,6 +72,7 @@ static struct smb_version_values smb302_
 	.max_read_size = SMB3_DEFAULT_IOSIZE,
 	.max_write_size = SMB3_DEFAULT_IOSIZE,
 	.max_trans_size = SMB3_DEFAULT_TRANS_SIZE,
+	.max_credits = SMB2_MAX_CREDITS,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED,
@@ -96,6 +99,7 @@ static struct smb_version_values smb311_
 	.max_read_size = SMB3_DEFAULT_IOSIZE,
 	.max_write_size = SMB3_DEFAULT_IOSIZE,
 	.max_trans_size = SMB3_DEFAULT_TRANS_SIZE,
+	.max_credits = SMB2_MAX_CREDITS,
 	.large_lock_type = 0,
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED,
@@ -197,7 +201,6 @@ void init_smb2_1_server(struct ksmbd_con
 	conn->ops = &smb2_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_HMAC_SHA256_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
@@ -215,7 +218,6 @@ void init_smb3_0_server(struct ksmbd_con
 	conn->ops = &smb3_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
@@ -240,7 +242,6 @@ void init_smb3_02_server(struct ksmbd_co
 	conn->ops = &smb3_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
@@ -265,7 +266,6 @@ int init_smb3_11_server(struct ksmbd_con
 	conn->ops = &smb3_11_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
@@ -304,3 +304,11 @@ void init_smb2_max_trans_size(unsigned i
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
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -308,7 +308,7 @@ int smb2_set_rsp_credits(struct ksmbd_wo
 
 	hdr->CreditCharge = req_hdr->CreditCharge;
 
-	if (conn->total_credits > conn->max_credits) {
+	if (conn->total_credits > conn->vals->max_credits) {
 		hdr->CreditRequest = 0;
 		pr_err("Total credits overflow: %d\n", conn->total_credits);
 		return -EINVAL;
@@ -329,12 +329,12 @@ int smb2_set_rsp_credits(struct ksmbd_wo
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
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -980,6 +980,7 @@ int init_smb3_11_server(struct ksmbd_con
 void init_smb2_max_read_size(unsigned int sz);
 void init_smb2_max_write_size(unsigned int sz);
 void init_smb2_max_trans_size(unsigned int sz);
+void init_smb2_max_credits(unsigned int sz);
 
 bool is_smb2_neg_cmd(struct ksmbd_work *work);
 bool is_smb2_rsp(struct ksmbd_work *work);
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
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -301,6 +301,8 @@ static int ipc_server_config_on_startup(
 		init_smb2_max_write_size(req->smb2_max_write);
 	if (req->smb2_max_trans)
 		init_smb2_max_trans_size(req->smb2_max_trans);
+	if (req->smb2_max_credits)
+		init_smb2_max_credits(req->smb2_max_credits);
 
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);


