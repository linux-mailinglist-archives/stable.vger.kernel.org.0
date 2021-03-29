Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0301C34CB17
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhC2InR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234220AbhC2Ik2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:40:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C19E619C4;
        Mon, 29 Mar 2021 08:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007215;
        bh=ycmzTaxWcufupS6nc0iPeWob00g3HBiXWDX9uuh78Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWHpIbC4jGXbxG7HRmeqXBUUbcMga1gjPbf6kNDp77v4eFPgTXZ1zq6oQfiAhmRvX
         OkNqg6nQd1ybK7XbE4KN3c/IQgEEXQZnrgac1TS/3PkRhx9ov2qOoTudh9q1Ko+ts0
         V9+qXI1X0Et4dkpmOlT+MO2/tGPACPWYTDMO3+HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 240/254] cifs: Adjust key sizes and key generation routines for AES256 encryption
Date:   Mon, 29 Mar 2021 09:59:16 +0200
Message-Id: <20210329075640.960290120@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 45a4546c6167a2da348a31ca439d8a8ff773b6ea upstream.

For AES256 encryption (GCM and CCM), we need to adjust the size of a few
fields to 32 bytes instead of 16 to accommodate the larger keys.

Also, the L value supplied to the key generator needs to be changed from
to 256 when these algorithms are used.

Keeping the ioctl struct for dumping keys of the same size for now.
Will send out a different patch for that one.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
CC: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsglob.h      |    4 ++--
 fs/cifs/cifspdu.h       |    5 +++++
 fs/cifs/smb2glob.h      |    1 +
 fs/cifs/smb2ops.c       |    9 +++++----
 fs/cifs/smb2transport.c |   37 ++++++++++++++++++++++++++++---------
 5 files changed, 41 insertions(+), 15 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -915,8 +915,8 @@ struct cifs_ses {
 	bool binding:1; /* are we binding the session? */
 	__u16 session_flags;
 	__u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
-	__u8 smb3encryptionkey[SMB3_SIGN_KEY_SIZE];
-	__u8 smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
+	__u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
+	__u8 smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
 	__u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
 
 	__u8 binding_preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -147,6 +147,11 @@
  */
 #define SMB3_SIGN_KEY_SIZE (16)
 
+/*
+ * Size of the smb3 encryption/decryption keys
+ */
+#define SMB3_ENC_DEC_KEY_SIZE (32)
+
 #define CIFS_CLIENT_CHALLENGE_SIZE (8)
 #define CIFS_SERVER_CHALLENGE_SIZE (8)
 #define CIFS_HMAC_MD5_HASH_SIZE (16)
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -58,6 +58,7 @@
 #define SMB2_HMACSHA256_SIZE (32)
 #define SMB2_CMACAES_SIZE (16)
 #define SMB3_SIGNKEY_SIZE (16)
+#define SMB3_GCM128_CRYPTKEY_SIZE (16)
 #define SMB3_GCM256_CRYPTKEY_SIZE (32)
 
 /* Maximum buffer size value we can send with 1 credit */
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4109,7 +4109,7 @@ smb2_get_enc_key(struct TCP_Server_Info
 			if (ses->Suid == ses_id) {
 				ses_enc_key = enc ? ses->smb3encryptionkey :
 					ses->smb3decryptionkey;
-				memcpy(key, ses_enc_key, SMB3_SIGN_KEY_SIZE);
+				memcpy(key, ses_enc_key, SMB3_ENC_DEC_KEY_SIZE);
 				spin_unlock(&cifs_tcp_ses_lock);
 				return 0;
 			}
@@ -4136,7 +4136,7 @@ crypt_message(struct TCP_Server_Info *se
 	int rc = 0;
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
-	u8 key[SMB3_SIGN_KEY_SIZE];
+	u8 key[SMB3_ENC_DEC_KEY_SIZE];
 	struct aead_request *req;
 	char *iv;
 	unsigned int iv_len;
@@ -4160,10 +4160,11 @@ crypt_message(struct TCP_Server_Info *se
 	tfm = enc ? server->secmech.ccmaesencrypt :
 						server->secmech.ccmaesdecrypt;
 
-	if (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
+		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
 	else
-		rc = crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE);
+		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
 
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -298,7 +298,8 @@ static int generate_key(struct cifs_ses
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
-	__u8 L[4] = {0, 0, 0, 128};
+	__u8 L128[4] = {0, 0, 0, 128};
+	__u8 L256[4] = {0, 0, 1, 0};
 	int rc = 0;
 	unsigned char prfhash[SMB2_HMACSHA256_SIZE];
 	unsigned char *hashptr = prfhash;
@@ -354,8 +355,14 @@ static int generate_key(struct cifs_ses
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
-				L, 4);
+	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
+		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM)) {
+		rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
+				L256, 4);
+	} else {
+		rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
+				L128, 4);
+	}
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with L\n", __func__);
 		goto smb3signkey_ret;
@@ -390,6 +397,9 @@ generate_smb3signingkey(struct cifs_ses
 			const struct derivation_triplet *ptriplet)
 {
 	int rc;
+#ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
+	struct TCP_Server_Info *server = ses->server;
+#endif
 
 	/*
 	 * All channels use the same encryption/decryption keys but
@@ -422,11 +432,11 @@ generate_smb3signingkey(struct cifs_ses
 		rc = generate_key(ses, ptriplet->encryption.label,
 				  ptriplet->encryption.context,
 				  ses->smb3encryptionkey,
-				  SMB3_SIGN_KEY_SIZE);
+				  SMB3_ENC_DEC_KEY_SIZE);
 		rc = generate_key(ses, ptriplet->decryption.label,
 				  ptriplet->decryption.context,
 				  ses->smb3decryptionkey,
-				  SMB3_SIGN_KEY_SIZE);
+				  SMB3_ENC_DEC_KEY_SIZE);
 		if (rc)
 			return rc;
 	}
@@ -442,14 +452,23 @@ generate_smb3signingkey(struct cifs_ses
 	 */
 	cifs_dbg(VFS, "Session Id    %*ph\n", (int)sizeof(ses->Suid),
 			&ses->Suid);
+	cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
 	cifs_dbg(VFS, "Session Key   %*ph\n",
 		 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
 	cifs_dbg(VFS, "Signing Key   %*ph\n",
 		 SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
-	cifs_dbg(VFS, "ServerIn Key  %*ph\n",
-		 SMB3_SIGN_KEY_SIZE, ses->smb3encryptionkey);
-	cifs_dbg(VFS, "ServerOut Key %*ph\n",
-		 SMB3_SIGN_KEY_SIZE, ses->smb3decryptionkey);
+	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
+		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM)) {
+		cifs_dbg(VFS, "ServerIn Key  %*ph\n",
+				SMB3_GCM256_CRYPTKEY_SIZE, ses->smb3encryptionkey);
+		cifs_dbg(VFS, "ServerOut Key %*ph\n",
+				SMB3_GCM256_CRYPTKEY_SIZE, ses->smb3decryptionkey);
+	} else {
+		cifs_dbg(VFS, "ServerIn Key  %*ph\n",
+				SMB3_GCM128_CRYPTKEY_SIZE, ses->smb3encryptionkey);
+		cifs_dbg(VFS, "ServerOut Key %*ph\n",
+				SMB3_GCM128_CRYPTKEY_SIZE, ses->smb3decryptionkey);
+	}
 #endif
 	return rc;
 }


