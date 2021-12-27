Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD95480068
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbhL0PqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45354 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240069AbhL0Pog (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84F74B810A3;
        Mon, 27 Dec 2021 15:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA8BC36AE7;
        Mon, 27 Dec 2021 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619873;
        bh=VIB4/gmxwIe7z+SckKN0JcsGrt9Nypt9uKJfKrj1j90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPL0eqY9jwhzVY8TTEWvgI3OmTdBAjE746/BTYVFIkkncViAb7YDZLFreEeG6crrk
         yoGLQKsDeBsaw/KsmBQGc2nFrpzpy0ScOmFS9gIOwhGPq8nyA0zLFcQGbHBas/tyTR
         whvkP27PFpVRLeZ0jM9gdTHa7K3FhtgYUySz5pd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Marcos Del Sol Vives <marcos@orca.pet>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 100/128] ksmbd: disable SMB2_GLOBAL_CAP_ENCRYPTION for SMB 3.1.1
Date:   Mon, 27 Dec 2021 16:31:15 +0100
Message-Id: <20211227151334.860662780@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Del Sol Vives <marcos@orca.pet>

commit 83912d6d55be10d65b5268d1871168b9ebe1ec4b upstream.

According to the official Microsoft MS-SMB2 document section 3.3.5.4, this
flag should be used only for 3.0 and 3.0.2 dialects. Setting it for 3.1.1
is a violation of the specification.

This causes my Windows 10 client to detect an anomaly in the negotiation,
and disable encryption entirely despite being explicitly enabled in ksmbd,
causing all data transfers to go in plain text.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org # v5.15
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Marcos Del Sol Vives <marcos@orca.pet>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2ops.c |    3 ---
 fs/ksmbd/smb2pdu.c |   25 +++++++++++++++++++++----
 2 files changed, 21 insertions(+), 7 deletions(-)

--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -272,9 +272,6 @@ int init_smb3_11_server(struct ksmbd_con
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING;
 
-	if (conn->cipher_type)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
-
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -917,6 +917,25 @@ static void decode_encrypt_ctxt(struct k
 	}
 }
 
+/**
+ * smb3_encryption_negotiated() - checks if server and client agreed on enabling encryption
+ * @conn:	smb connection
+ *
+ * Return:	true if connection should be encrypted, else false
+ */
+static bool smb3_encryption_negotiated(struct ksmbd_conn *conn)
+{
+	if (!conn->ops->generate_encryptionkey)
+		return false;
+
+	/*
+	 * SMB 3.0 and 3.0.2 dialects use the SMB2_GLOBAL_CAP_ENCRYPTION flag.
+	 * SMB 3.1.1 uses the cipher_type field.
+	 */
+	return (conn->vals->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION) ||
+	    conn->cipher_type;
+}
+
 static void decode_compress_ctxt(struct ksmbd_conn *conn,
 				 struct smb2_compression_ctx *pneg_ctxt)
 {
@@ -1471,8 +1490,7 @@ static int ntlm_authenticate(struct ksmb
 		    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
 			sess->sign = true;
 
-		if (conn->vals->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION &&
-		    conn->ops->generate_encryptionkey &&
+		if (smb3_encryption_negotiated(conn) &&
 		    !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 			rc = conn->ops->generate_encryptionkey(sess);
 			if (rc) {
@@ -1562,8 +1580,7 @@ static int krb5_authenticate(struct ksmb
 	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
 		sess->sign = true;
 
-	if ((conn->vals->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION) &&
-	    conn->ops->generate_encryptionkey) {
+	if (smb3_encryption_negotiated(conn)) {
 		retval = conn->ops->generate_encryptionkey(sess);
 		if (retval) {
 			ksmbd_debug(SMB,


