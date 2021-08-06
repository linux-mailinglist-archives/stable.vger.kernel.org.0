Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD5C3E25D4
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244223AbhHFIWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244220AbhHFIVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 319F561052;
        Fri,  6 Aug 2021 08:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238066;
        bh=fLUtY4f+huXtYcYoyIYEvo1j3B1AhkHJ/JR08t4lg6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alsa1ESwhJkFKPEIfwVx9K19mDEUu0tZFaaGeHNaYI+DXdUjTPkU4cVj7PGAXHj2B
         a2woK93Glr0/htD+sWzEilx16+LI9gOZ49hVk/N8K8e9bPd++uLLEzeUPUZ2HgsP4l
         +K/+GyLqLNCIfXbGfxq5s879wrrrGyzWIXaD8LsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 07/35] cifs: use helpers when parsing uid/gid mount options and validate them
Date:   Fri,  6 Aug 2021 10:16:50 +0200
Message-Id: <20210806081113.951060612@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit e0a3cbcd5cef00cace01546cc6eaaa3b31940da9 ]

Use the nice helpers to initialize and the uid/gid/cred_uid when passed as mount arguments.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/fs_context.c | 24 +++++++++++++++++++-----
 fs/cifs/fs_context.h |  1 +
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 92d4ab029c91..553adfbcc22a 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -322,7 +322,6 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	new_ctx->UNC = NULL;
 	new_ctx->source = NULL;
 	new_ctx->iocharset = NULL;
-
 	/*
 	 * Make sure to stay in sync with smb3_cleanup_fs_context_contents()
 	 */
@@ -792,6 +791,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
+	kuid_t uid;
+	kgid_t gid;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -904,18 +905,31 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		break;
 	case Opt_uid:
-		ctx->linux_uid.val = result.uint_32;
+		uid = make_kuid(current_user_ns(), result.uint_32);
+		if (!uid_valid(uid))
+			goto cifs_parse_mount_err;
+		ctx->linux_uid = uid;
 		ctx->uid_specified = true;
 		break;
 	case Opt_cruid:
-		ctx->cred_uid.val = result.uint_32;
+		uid = make_kuid(current_user_ns(), result.uint_32);
+		if (!uid_valid(uid))
+			goto cifs_parse_mount_err;
+		ctx->cred_uid = uid;
+		ctx->cruid_specified = true;
 		break;
 	case Opt_backupgid:
-		ctx->backupgid.val = result.uint_32;
+		gid = make_kgid(current_user_ns(), result.uint_32);
+		if (!gid_valid(gid))
+			goto cifs_parse_mount_err;
+		ctx->backupgid = gid;
 		ctx->backupgid_specified = true;
 		break;
 	case Opt_gid:
-		ctx->linux_gid.val = result.uint_32;
+		gid = make_kgid(current_user_ns(), result.uint_32);
+		if (!gid_valid(gid))
+			goto cifs_parse_mount_err;
+		ctx->linux_gid = gid;
 		ctx->gid_specified = true;
 		break;
 	case Opt_port:
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 2a71c8e411ac..b6243972edf3 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -155,6 +155,7 @@ enum cifs_param {
 
 struct smb3_fs_context {
 	bool uid_specified;
+	bool cruid_specified;
 	bool gid_specified;
 	bool sloppy;
 	bool got_ip;
-- 
2.30.2



