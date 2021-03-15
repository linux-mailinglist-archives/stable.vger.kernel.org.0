Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28F833B9CC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbhCOOGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233225AbhCOOBu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E5364EF0;
        Mon, 15 Mar 2021 14:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816909;
        bh=/Ddd2zPl42t0KPISs+Dxeg/qgBi4KA8gGxKbfY4SnUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkn6CVYFE1m+sbAn7KwUzEBttVjxq9t0ShoC9fQgOu6Xcepovm24u5kTnY70tw8hn
         gKxyCG9byMrXv6G1wzN3uleSqknPGdrJrctmKeOzWXfNgJajGgzU2d4YhGHjH9pDJg
         3F07PYwi1n71e8VFQQTzNbZj/ZkAhZgI1daLrm0w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.10 183/290] Revert 95ebabde382c ("capabilities: Dont allow writing ambiguous v3 file capabilities")
Date:   Mon, 15 Mar 2021 14:54:36 +0100
Message-Id: <20210315135548.097352490@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Eric W. Biederman <ebiederm@xmission.com>

commit 3b0c2d3eaa83da259d7726192cf55a137769012f upstream.

It turns out that there are in fact userspace implementations that
care and this recent change caused a regression.

https://github.com/containers/buildah/issues/3071

As the motivation for the original change was future development,
and the impact is existing real world code just revert this change
and allow the ambiguity in v3 file caps.

Cc: stable@vger.kernel.org
Fixes: 95ebabde382c ("capabilities: Don't allow writing ambiguous v3 file capabilities")
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/commoncap.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -500,8 +500,7 @@ int cap_convert_nscap(struct dentry *den
 	__u32 magic, nsmagic;
 	struct inode *inode = d_backing_inode(dentry);
 	struct user_namespace *task_ns = current_user_ns(),
-		*fs_ns = inode->i_sb->s_user_ns,
-		*ancestor;
+		*fs_ns = inode->i_sb->s_user_ns;
 	kuid_t rootid;
 	size_t newsize;
 
@@ -524,15 +523,6 @@ int cap_convert_nscap(struct dentry *den
 	if (nsrootid == -1)
 		return -EINVAL;
 
-	/*
-	 * Do not allow allow adding a v3 filesystem capability xattr
-	 * if the rootid field is ambiguous.
-	 */
-	for (ancestor = task_ns->parent; ancestor; ancestor = ancestor->parent) {
-		if (from_kuid(ancestor, rootid) == 0)
-			return -EINVAL;
-	}
-
 	newsize = sizeof(struct vfs_ns_cap_data);
 	nscap = kmalloc(newsize, GFP_ATOMIC);
 	if (!nscap)


