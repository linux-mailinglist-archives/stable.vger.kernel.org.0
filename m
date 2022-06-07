Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E015410D7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355354AbiFGT3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356853AbiFGT2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858C61A1964;
        Tue,  7 Jun 2022 11:11:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23BE2B82182;
        Tue,  7 Jun 2022 18:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8941EC385A2;
        Tue,  7 Jun 2022 18:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625468;
        bh=6h9ichIbYjeX0IRGIBt3RoX6ZPJ0263pT4xyI6uN8Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3mDo6B5py7tmEUUSeADkZoNwOpneLLtyLARb7z7jz+SGQJ8id42z3Chd3QJ+pFM6
         UaL6Lch2Uzn52SyzbIX4kdcsj8Gec/oWfxoIk9swvD3OPk2Jdphlm5c6j7B0Mpo1hr
         4aKKMpIjDoWDkF//4bxjiIQnG07r5s7bOAaX2PRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Byron Stanoszek <gandalf@winds.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 029/772] cifs: fix ntlmssp on old servers
Date:   Tue,  7 Jun 2022 18:53:41 +0200
Message-Id: <20220607164949.877763839@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit de3a9e943ddecba8d2ac1dde4cfff538e5c6a7b9 upstream.

Some older servers seem to require the workstation name during ntlmssp
to be at most 15 chars (RFC1001 name length), so truncate it before
sending when using insecure dialects.

Link: https://lore.kernel.org/r/e6837098-15d9-acb6-7e34-1923cf8c6fe1@winds.org
Reported-by: Byron Stanoszek <gandalf@winds.org>
Tested-by: Byron Stanoszek <gandalf@winds.org>
Fixes: 49bd49f983b5 ("cifs: send workstation name during ntlmssp session setup")
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsglob.h   |   15 ++++++++++++++-
 fs/cifs/connect.c    |   22 ++++------------------
 fs/cifs/fs_context.c |   29 ++++-------------------------
 fs/cifs/fs_context.h |    2 +-
 fs/cifs/misc.c       |    1 -
 fs/cifs/sess.c       |    6 +++---
 6 files changed, 26 insertions(+), 49 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -949,7 +949,7 @@ struct cifs_ses {
 				   and after mount option parsing we fill it */
 	char *domainName;
 	char *password;
-	char *workstation_name;
+	char workstation_name[CIFS_MAX_WORKSTATION_LEN];
 	struct session_key auth_key;
 	struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challenge */
 	enum securityEnum sectype; /* what security flavor was specified? */
@@ -1983,4 +1983,17 @@ static inline bool cifs_is_referral_serv
 	return is_tcon_dfs(tcon) || (ref && (ref->flags & DFSREF_REFERRAL_SERVER));
 }
 
+static inline size_t ntlmssp_workstation_name_size(const struct cifs_ses *ses)
+{
+	if (WARN_ON_ONCE(!ses || !ses->server))
+		return 0;
+	/*
+	 * Make workstation name no more than 15 chars when using insecure dialects as some legacy
+	 * servers do require it during NTLMSSP.
+	 */
+	if (ses->server->dialect <= SMB20_PROT_ID)
+		return min_t(size_t, sizeof(ses->workstation_name), RFC1001_NAME_LEN_WITH_NULL);
+	return sizeof(ses->workstation_name);
+}
+
 #endif	/* _CIFS_GLOB_H */
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2037,18 +2037,7 @@ cifs_set_cifscreds(struct smb3_fs_contex
 		}
 	}
 
-	ctx->workstation_name = kstrdup(ses->workstation_name, GFP_KERNEL);
-	if (!ctx->workstation_name) {
-		cifs_dbg(FYI, "Unable to allocate memory for workstation_name\n");
-		rc = -ENOMEM;
-		kfree(ctx->username);
-		ctx->username = NULL;
-		kfree_sensitive(ctx->password);
-		ctx->password = NULL;
-		kfree(ctx->domainname);
-		ctx->domainname = NULL;
-		goto out_key_put;
-	}
+	strscpy(ctx->workstation_name, ses->workstation_name, sizeof(ctx->workstation_name));
 
 out_key_put:
 	up_read(&key->sem);
@@ -2157,12 +2146,9 @@ cifs_get_smb_ses(struct TCP_Server_Info
 		if (!ses->domainName)
 			goto get_ses_fail;
 	}
-	if (ctx->workstation_name) {
-		ses->workstation_name = kstrdup(ctx->workstation_name,
-						GFP_KERNEL);
-		if (!ses->workstation_name)
-			goto get_ses_fail;
-	}
+
+	strscpy(ses->workstation_name, ctx->workstation_name, sizeof(ses->workstation_name));
+
 	if (ctx->domainauto)
 		ses->domainAuto = ctx->domainauto;
 	ses->cred_uid = ctx->cred_uid;
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -312,7 +312,6 @@ smb3_fs_context_dup(struct smb3_fs_conte
 	new_ctx->password = NULL;
 	new_ctx->server_hostname = NULL;
 	new_ctx->domainname = NULL;
-	new_ctx->workstation_name = NULL;
 	new_ctx->UNC = NULL;
 	new_ctx->source = NULL;
 	new_ctx->iocharset = NULL;
@@ -327,7 +326,6 @@ smb3_fs_context_dup(struct smb3_fs_conte
 	DUP_CTX_STR(UNC);
 	DUP_CTX_STR(source);
 	DUP_CTX_STR(domainname);
-	DUP_CTX_STR(workstation_name);
 	DUP_CTX_STR(nodename);
 	DUP_CTX_STR(iocharset);
 
@@ -766,8 +764,7 @@ static int smb3_verify_reconfigure_ctx(s
 		cifs_errorf(fc, "can not change domainname during remount\n");
 		return -EINVAL;
 	}
-	if (new_ctx->workstation_name &&
-	    (!old_ctx->workstation_name || strcmp(new_ctx->workstation_name, old_ctx->workstation_name))) {
+	if (strcmp(new_ctx->workstation_name, old_ctx->workstation_name)) {
 		cifs_errorf(fc, "can not change workstation_name during remount\n");
 		return -EINVAL;
 	}
@@ -814,7 +811,6 @@ static int smb3_reconfigure(struct fs_co
 	STEAL_STRING(cifs_sb, ctx, username);
 	STEAL_STRING(cifs_sb, ctx, password);
 	STEAL_STRING(cifs_sb, ctx, domainname);
-	STEAL_STRING(cifs_sb, ctx, workstation_name);
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
 
@@ -1467,22 +1463,15 @@ static int smb3_fs_context_parse_param(s
 
 int smb3_init_fs_context(struct fs_context *fc)
 {
-	int rc;
 	struct smb3_fs_context *ctx;
 	char *nodename = utsname()->nodename;
 	int i;
 
 	ctx = kzalloc(sizeof(struct smb3_fs_context), GFP_KERNEL);
-	if (unlikely(!ctx)) {
-		rc = -ENOMEM;
-		goto err_exit;
-	}
+	if (unlikely(!ctx))
+		return -ENOMEM;
 
-	ctx->workstation_name = kstrdup(nodename, GFP_KERNEL);
-	if (unlikely(!ctx->workstation_name)) {
-		rc = -ENOMEM;
-		goto err_exit;
-	}
+	strscpy(ctx->workstation_name, nodename, sizeof(ctx->workstation_name));
 
 	/*
 	 * does not have to be perfect mapping since field is
@@ -1555,14 +1544,6 @@ int smb3_init_fs_context(struct fs_conte
 	fc->fs_private = ctx;
 	fc->ops = &smb3_fs_context_ops;
 	return 0;
-
-err_exit:
-	if (ctx) {
-		kfree(ctx->workstation_name);
-		kfree(ctx);
-	}
-
-	return rc;
 }
 
 void
@@ -1588,8 +1569,6 @@ smb3_cleanup_fs_context_contents(struct
 	ctx->source = NULL;
 	kfree(ctx->domainname);
 	ctx->domainname = NULL;
-	kfree(ctx->workstation_name);
-	ctx->workstation_name = NULL;
 	kfree(ctx->nodename);
 	ctx->nodename = NULL;
 	kfree(ctx->iocharset);
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -170,7 +170,7 @@ struct smb3_fs_context {
 	char *server_hostname;
 	char *UNC;
 	char *nodename;
-	char *workstation_name;
+	char workstation_name[CIFS_MAX_WORKSTATION_LEN];
 	char *iocharset;  /* local code page for mapping to and from Unicode */
 	char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* clnt nb name */
 	char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* srvr nb name */
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -95,7 +95,6 @@ sesInfoFree(struct cifs_ses *buf_to_free
 	kfree_sensitive(buf_to_free->password);
 	kfree(buf_to_free->user_name);
 	kfree(buf_to_free->domainName);
-	kfree(buf_to_free->workstation_name);
 	kfree_sensitive(buf_to_free->auth_key.response);
 	kfree(buf_to_free->iface_list);
 	kfree_sensitive(buf_to_free);
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -714,9 +714,9 @@ static int size_of_ntlmssp_blob(struct c
 	else
 		sz += sizeof(__le16);
 
-	if (ses->workstation_name)
+	if (ses->workstation_name[0])
 		sz += sizeof(__le16) * strnlen(ses->workstation_name,
-			CIFS_MAX_WORKSTATION_LEN);
+					       ntlmssp_workstation_name_size(ses));
 	else
 		sz += sizeof(__le16);
 
@@ -960,7 +960,7 @@ int build_ntlmssp_auth_blob(unsigned cha
 
 	cifs_security_buffer_from_str(&sec_blob->WorkstationName,
 				      ses->workstation_name,
-				      CIFS_MAX_WORKSTATION_LEN,
+				      ntlmssp_workstation_name_size(ses),
 				      *pbuffer, &tmp,
 				      nls_cp);
 


