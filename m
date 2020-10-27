Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A8C29B38C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900403AbgJ0OxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772899AbgJ0Ou1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:50:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 888FA20709;
        Tue, 27 Oct 2020 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810227;
        bh=U9XkeznRaBRhcxUYAB0DI2V9noC0os5Uhj8gTDfDIXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJ2A5wFRdn/A+eyOVKvBMxNkOV9HNDCRN9ZfWgwWTCQDKij925z9FOLyIwDCrf+b7
         wMBoh6yl7zsUuPO5M0uj7jB1rQD3dZijXLpY3jcbdx64BokmRScC1Z0DU9wQE0rrHQ
         XdCp37DITEU4Z4zTjjHSL3NyUQx1qw46YrC7iiOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.8 065/633] SMB3.1.1: Fix ids returned in POSIX query dir
Date:   Tue, 27 Oct 2020 14:46:48 +0100
Message-Id: <20201027135525.748467921@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
@@ -208,6 +208,8 @@ extern int cifs_set_file_info(struct ino
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


