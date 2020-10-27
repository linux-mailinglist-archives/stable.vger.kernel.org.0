Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A881929B623
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796344AbgJ0PUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796927AbgJ0PUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:20:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54C4520728;
        Tue, 27 Oct 2020 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812038;
        bh=mSVbc8urRtrPQ1aAI0yJgu1QY2COMvNP2PyLBX9ttlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNIUDDc8PacX6GfD/1aQcMjbVZM6l3xXEW13DlmteWAXkkDFtW8A0lTfW0aMfIgOC
         uJV25nT8D0yg+ivr4+X4uh7GTNb6v3Sm41k7FHDsvzdAKR+IsDz9ABaGAodY5IfnLP
         yNGodUMoiqdEQXZ0kvK05ii3wZuzHmXrW0Kh5lnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.9 069/757] SMB3.1.1: Fix ids returned in POSIX query dir
Date:   Tue, 27 Oct 2020 14:45:19 +0100
Message-Id: <20201027135453.781484145@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 9934430e2178d5164eb1ac91a9b092f9e7e64745 upstream.

We were setting the uid/gid to the default in each dir entry
in the parsing of the POSIX query dir response, rather
than attempting to map the user and group SIDs returned by
the server to well known SIDs (or upcall if not found).

CC: Stable <stable@vger.kernel.org>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsacl.c   |    5 +++--
 fs/cifs/cifsproto.h |    2 ++
 fs/cifs/readdir.c   |    5 ++---
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -338,7 +338,7 @@ invalidate_key:
 	goto out_key_put;
 }
 
-static int
+int
 sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		struct cifs_fattr *fattr, uint sidtype)
 {
@@ -359,7 +359,8 @@ sid_to_id(struct cifs_sb_info *cifs_sb,
 		return -EIO;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL) {
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL) ||
+	    (cifs_sb_master_tcon(cifs_sb)->posix_extensions)) {
 		uint32_t unix_id;
 		bool is_group;
 
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -209,6 +209,8 @@ extern int cifs_set_file_info(struct ino
 extern int cifs_rename_pending_delete(const char *full_path,
 				      struct dentry *dentry,
 				      const unsigned int xid);
+extern int sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
+				struct cifs_fattr *fattr, uint sidtype);
 extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
 			      struct cifs_fattr *fattr, struct inode *inode,
 			      bool get_mode_from_special_sid,
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -267,9 +267,8 @@ cifs_posix_to_fattr(struct cifs_fattr *f
 	if (reparse_file_needs_reval(fattr))
 		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
 
-	/* TODO map SIDs */
-	fattr->cf_uid = cifs_sb->mnt_uid;
-	fattr->cf_gid = cifs_sb->mnt_gid;
+	sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
+	sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
 }
 
 static void __dir_info_to_fattr(struct cifs_fattr *fattr, const void *info)


