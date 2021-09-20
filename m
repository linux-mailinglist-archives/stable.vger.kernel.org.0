Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE4A411B43
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbhITQ4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343676AbhITQyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:54:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A394B61390;
        Mon, 20 Sep 2021 16:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156652;
        bh=qIPmLpE9GT58z5aPlmNfpCXUCDHmcqeVvg8YpMvXZTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKXOTTx67v3iiagQZATgr1OjvPxNxl7SfhgEq2aY3C3jcEckK1GSExauPk/QhBea7
         iydQ5QCcgzxStymDJnn9CuZyU9aubbUlcRuacqKACswhhPmZ9d2jfTohoZ/k2wqggF
         aVrHkS5Z/KF5l3H3qjcrazSDhkBVS3JFB8109hOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 4.9 023/175] gfs2: Dont clear SGID when inheriting ACLs
Date:   Mon, 20 Sep 2021 18:41:12 +0200
Message-Id: <20210920163918.829520705@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 914cea93dd89f00b41c1d8ff93f17be47356a36a upstream.

When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
set, DIR1 is expected to have SGID bit set (and owning group equal to
the owning group of 'DIR0'). However when 'DIR0' also has some default
ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
'DIR1' to get cleared if user is not member of the owning group.

Fix the problem by moving posix_acl_update_mode() out of
__gfs2_set_acl() into gfs2_set_acl(). That way the function will not be
called when inheriting ACLs which is what we want as it prevents SGID
bit clearing and the mode has been properly set by posix_acl_create()
anyway.

Fixes: 073931017b49d9458aa351605b43a7e34598caef
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/acl.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -86,19 +86,6 @@ int __gfs2_set_acl(struct inode *inode,
 	char *data;
 	const char *name = gfs2_acl_name(type);
 
-	if (acl && acl->a_count > GFS2_ACL_MAX_ENTRIES(GFS2_SB(inode)))
-		return -E2BIG;
-
-	if (type == ACL_TYPE_ACCESS) {
-		umode_t mode = inode->i_mode;
-
-		error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
-		if (error)
-			return error;
-		if (mode != inode->i_mode)
-			mark_inode_dirty(inode);
-	}
-
 	if (acl) {
 		len = posix_acl_to_xattr(&init_user_ns, acl, NULL, 0);
 		if (len == 0)
@@ -130,6 +117,9 @@ int gfs2_set_acl(struct inode *inode, st
 	bool need_unlock = false;
 	int ret;
 
+	if (acl && acl->a_count > GFS2_ACL_MAX_ENTRIES(GFS2_SB(inode)))
+		return -E2BIG;
+
 	ret = gfs2_rsqa_alloc(ip);
 	if (ret)
 		return ret;
@@ -140,7 +130,18 @@ int gfs2_set_acl(struct inode *inode, st
 			return ret;
 		need_unlock = true;
 	}
+	if (type == ACL_TYPE_ACCESS && acl) {
+		umode_t mode = inode->i_mode;
+
+		ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+		if (ret)
+			goto unlock;
+		if (mode != inode->i_mode)
+			mark_inode_dirty(inode);
+	}
+
 	ret = __gfs2_set_acl(inode, acl, type);
+unlock:
 	if (need_unlock)
 		gfs2_glock_dq_uninit(&gh);
 	return ret;


