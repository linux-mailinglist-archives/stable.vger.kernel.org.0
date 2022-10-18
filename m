Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32877601EAC
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiJRAMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiJRAKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:10:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CDD895E4;
        Mon, 17 Oct 2022 17:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E60C06131C;
        Tue, 18 Oct 2022 00:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394B0C433D6;
        Tue, 18 Oct 2022 00:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051718;
        bh=vP+Q99lZsWKTGFWxgY3JE7loaN0NWlj+K8znaZaSXFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8748vbPh3cYnyfDbWB7ax5X7AydGhK4Q5YCvSWiVmLrOPBJ9679wZ+u0em+Bx3bS
         jTQvZHYGoucF3pmBsLu3aC6Nyo+K/pmI62oc1Bij9Ayb8UJRjWtO5cTIJYeDAfcrAg
         6Pwa5Y4pFf8NZRLo8YxLs/Htp1yGmL/4M0OMpIyE1jEW5P/cw3EL9ZZC2w56sSMiJv
         SrD6weOFOYXl/ZTt6L7UxKwtqd0SHiJ40ni46aSamlxkFX5Wox83APyPpFzNYb9XJ9
         w/pf36M0c91YJJ4dgSCyBTVYfo5qqO1UP4sLzkPa5TwW4CxyJ3nsD5W/FiSNdo/mtL
         i9C5H4OrKnkrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        kernel test robot <oliver.sang@intel.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.0 32/32] cifs: replace kfree() with kfree_sensitive() for sensitive data
Date:   Mon, 17 Oct 2022 20:07:29 -0400
Message-Id: <20221018000729.2730519-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit a4e430c8c8ba96be8c6ec4f2eb108bb8bcbee069 ]

Replace kfree with kfree_sensitive, or prepend memzero_explicit() in
other cases, when freeing sensitive material that could still be left
in memory.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/r/202209201529.ec633796-oliver.sang@intel.com
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsencrypt.c | 12 ++++++------
 fs/cifs/connect.c     |  6 +++---
 fs/cifs/fs_context.c  | 12 ++++++++++--
 fs/cifs/misc.c        |  2 +-
 fs/cifs/sess.c        | 24 +++++++++++++++---------
 fs/cifs/smb2ops.c     |  6 +++---
 fs/cifs/smb2pdu.c     | 19 ++++++++++++++-----
 7 files changed, 52 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 46f5718754f9..d848bc0aac27 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -679,7 +679,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 unlock:
 	cifs_server_unlock(ses->server);
 setup_ntlmv2_rsp_ret:
-	kfree(tiblob);
+	kfree_sensitive(tiblob);
 
 	return rc;
 }
@@ -753,14 +753,14 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 		server->secmech.ccmaesdecrypt = NULL;
 	}
 
-	kfree(server->secmech.sdesccmacaes);
+	kfree_sensitive(server->secmech.sdesccmacaes);
 	server->secmech.sdesccmacaes = NULL;
-	kfree(server->secmech.sdeschmacsha256);
+	kfree_sensitive(server->secmech.sdeschmacsha256);
 	server->secmech.sdeschmacsha256 = NULL;
-	kfree(server->secmech.sdeschmacmd5);
+	kfree_sensitive(server->secmech.sdeschmacmd5);
 	server->secmech.sdeschmacmd5 = NULL;
-	kfree(server->secmech.sdescmd5);
+	kfree_sensitive(server->secmech.sdescmd5);
 	server->secmech.sdescmd5 = NULL;
-	kfree(server->secmech.sdescsha512);
+	kfree_sensitive(server->secmech.sdescsha512);
 	server->secmech.sdescsha512 = NULL;
 }
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7ae6f2c08153..a43d5686c302 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -311,7 +311,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	}
 	server->sequence_number = 0;
 	server->session_estab = false;
-	kfree(server->session_key.response);
+	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
 	server->lstrp = jiffies;
@@ -1580,7 +1580,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	cifs_crypto_secmech_release(server);
 
-	kfree(server->session_key.response);
+	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
 	kfree(server->hostname);
@@ -4134,7 +4134,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		if (ses->auth_key.response) {
 			cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
 				 ses->auth_key.response);
-			kfree(ses->auth_key.response);
+			kfree_sensitive(ses->auth_key.response);
 			ses->auth_key.response = NULL;
 			ses->auth_key.len = 0;
 		}
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 0e13dec86b25..45119597c765 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -791,6 +791,13 @@ do {									\
 	cifs_sb->ctx->field = NULL;					\
 } while (0)
 
+#define STEAL_STRING_SENSITIVE(cifs_sb, ctx, field)			\
+do {									\
+	kfree_sensitive(ctx->field);					\
+	ctx->field = cifs_sb->ctx->field;				\
+	cifs_sb->ctx->field = NULL;					\
+} while (0)
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -811,7 +818,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, UNC);
 	STEAL_STRING(cifs_sb, ctx, source);
 	STEAL_STRING(cifs_sb, ctx, username);
-	STEAL_STRING(cifs_sb, ctx, password);
+	STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
@@ -1162,7 +1169,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		break;
 	case Opt_pass:
-		kfree(ctx->password);
+		kfree_sensitive(ctx->password);
 		ctx->password = NULL;
 		if (strlen(param->string) == 0)
 			break;
@@ -1470,6 +1477,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	return 0;
 
  cifs_parse_mount_err:
+	kfree_sensitive(ctx->password);
 	return -EINVAL;
 }
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 87f60f736731..85109a9a2146 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1119,7 +1119,7 @@ cifs_alloc_hash(const char *name,
 void
 cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc)
 {
-	kfree(*sdesc);
+	kfree_sensitive(*sdesc);
 	*sdesc = NULL;
 	if (*shash)
 		crypto_free_shash(*shash);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3af3b05b6c74..f1c3c6d9146c 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1213,6 +1213,12 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 static void
 sess_free_buffer(struct sess_data *sess_data)
 {
+	int i;
+
+	/* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
+	for (i = 0; i < 3; i++)
+		if (sess_data->iov[i].iov_base)
+			memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
 
 	free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
 	sess_data->buf0_type = CIFS_NO_BUFFER;
@@ -1374,7 +1380,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
 	sess_data->result = rc;
 	sess_data->func = NULL;
 	sess_free_buffer(sess_data);
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
 }
 
@@ -1513,7 +1519,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 	sess_data->result = rc;
 	sess_data->func = NULL;
 	sess_free_buffer(sess_data);
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
 }
 
@@ -1648,7 +1654,7 @@ sess_auth_rawntlmssp_negotiate(struct sess_data *sess_data)
 	rc = decode_ntlmssp_challenge(bcc_ptr, blob_len, ses);
 
 out_free_ntlmsspblob:
-	kfree(ntlmsspblob);
+	kfree_sensitive(ntlmsspblob);
 out:
 	sess_free_buffer(sess_data);
 
@@ -1658,9 +1664,9 @@ sess_auth_rawntlmssp_negotiate(struct sess_data *sess_data)
 	}
 
 	/* Else error. Cleanup */
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 
 	sess_data->func = NULL;
@@ -1759,7 +1765,7 @@ sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)
 	}
 
 out_free_ntlmsspblob:
-	kfree(ntlmsspblob);
+	kfree_sensitive(ntlmsspblob);
 out:
 	sess_free_buffer(sess_data);
 
@@ -1767,9 +1773,9 @@ sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)
 		rc = sess_establish_session(sess_data);
 
 	/* Cleanup */
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 
 	sess_data->func = NULL;
@@ -1845,7 +1851,7 @@ int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 	rc = sess_data->result;
 
 out:
-	kfree(sess_data);
+	kfree_sensitive(sess_data);
 	return rc;
 }
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 421be43af425..5094336cade6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4410,11 +4410,11 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	if (!rc && enc)
 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
 
-	kfree(iv);
+	kfree_sensitive(iv);
 free_sg:
-	kfree(sg);
+	kfree_sensitive(sg);
 free_req:
-	kfree(req);
+	kfree_sensitive(req);
 	return rc;
 }
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6352ab32c7e7..722ebff05759 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1345,6 +1345,13 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 static void
 SMB2_sess_free_buffer(struct SMB2_sess_data *sess_data)
 {
+	int i;
+
+	/* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
+	for (i = 0; i < 2; i++)
+		if (sess_data->iov[i].iov_base)
+			memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
+
 	free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
 	sess_data->buf0_type = CIFS_NO_BUFFER;
 }
@@ -1477,6 +1484,8 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 out_put_spnego_key:
 	key_invalidate(spnego_key);
 	key_put(spnego_key);
+	if (rc)
+		kfree_sensitive(ses->auth_key.response);
 out:
 	sess_data->result = rc;
 	sess_data->func = NULL;
@@ -1573,7 +1582,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 	}
 
 out:
-	kfree(ntlmssp_blob);
+	memzero_explicit(ntlmssp_blob, blob_length);
 	SMB2_sess_free_buffer(sess_data);
 	if (!rc) {
 		sess_data->result = 0;
@@ -1581,7 +1590,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 		return;
 	}
 out_err:
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 	sess_data->result = rc;
 	sess_data->func = NULL;
@@ -1657,9 +1666,9 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 	}
 #endif
 out:
-	kfree(ntlmssp_blob);
+	memzero_explicit(ntlmssp_blob, blob_length);
 	SMB2_sess_free_buffer(sess_data);
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 	sess_data->result = rc;
 	sess_data->func = NULL;
@@ -1737,7 +1746,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 		cifs_server_dbg(VFS, "signing requested but authenticated as guest\n");
 	rc = sess_data->result;
 out:
-	kfree(sess_data);
+	kfree_sensitive(sess_data);
 	return rc;
 }
 
-- 
2.35.1

