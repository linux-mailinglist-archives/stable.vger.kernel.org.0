Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 145201095E2
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 23:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfKYW6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 17:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfKYW6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 17:58:05 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4CCA20733;
        Mon, 25 Nov 2019 22:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574722684;
        bh=gj+SEk9uqb9UfgP2kZhcFdtV83bIb2xnwZU/g2r4KwI=;
        h=Date:From:To:Subject:From;
        b=HwLZDJ61trtnF0WWHH6j1z9jAogK8imzYjC1P9Zv8/HUjndrg14ZRuNb9PRM4B2OW
         Rc48onJVk4HBJ96n1RzgP/0orMsEvYFANJcFCAKCZacSUcqdR0I7rb2BFlCM/RuEO6
         wKpNdHn3RQEjfZO4VIfqODlgtZAcDWFUo/bXKr/Y=
Date:   Mon, 25 Nov 2019 14:58:03 -0800
From:   akpm@linux-foundation.org
To:     baijiaju1990@gmail.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, stable@vger.kernel.org, tv@lio96.de
Subject:  [merged]
 =?US-ASCII?Q?revert-fs-ocfs2-fix-possible-null-pointer-dereferences-in-?=
 =?US-ASCII?Q?ocfs2=5Fxa=5Fprepare=5Fentry.patch?= removed from -mm tree
Message-ID: <20191125225803.2TqkYwcvv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()"
has been removed from the -mm tree.  Its filename was
     revert-fs-ocfs2-fix-possible-null-pointer-dereferences-in-ocfs2_xa_prepare_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Revert "fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()"

This reverts commit 56e94ea132bb5c2c1d0b60a6aeb34dcb7d71a53d.

commit 56e94ea132bb ("fs: ocfs2: fix possible null-pointer dereferences
in ocfs2_xa_prepare_entry()") introduces a regression that fail to create
directory with mount option user_xattr and acl.
Actually the reported NULL pointer dereference case can be correctly
handled by loc->xl_ops->xlo_add_entry(), so revert it.

Link: http://lkml.kernel.org/r/1573624916-83825-1-git-send-email-joseph.qi@linux.alibaba.com
Fixes: 56e94ea132bb ("fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Thomas Voegtle <tv@lio96.de>
Acked-by: Changwei Ge <gechangwei@live.cn>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   56 ++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

--- a/fs/ocfs2/xattr.c~revert-fs-ocfs2-fix-possible-null-pointer-dereferences-in-ocfs2_xa_prepare_entry
+++ a/fs/ocfs2/xattr.c
@@ -1490,6 +1490,18 @@ static int ocfs2_xa_check_space(struct o
 	return loc->xl_ops->xlo_check_space(loc, xi);
 }
 
+static void ocfs2_xa_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
+{
+	loc->xl_ops->xlo_add_entry(loc, name_hash);
+	loc->xl_entry->xe_name_hash = cpu_to_le32(name_hash);
+	/*
+	 * We can't leave the new entry's xe_name_offset at zero or
+	 * add_namevalue() will go nuts.  We set it to the size of our
+	 * storage so that it can never be less than any other entry.
+	 */
+	loc->xl_entry->xe_name_offset = cpu_to_le16(loc->xl_size);
+}
+
 static void ocfs2_xa_add_namevalue(struct ocfs2_xa_loc *loc,
 				   struct ocfs2_xattr_info *xi)
 {
@@ -2121,31 +2133,29 @@ static int ocfs2_xa_prepare_entry(struct
 	if (rc)
 		goto out;
 
-	if (!loc->xl_entry) {
-		rc = -EINVAL;
-		goto out;
-	}
-
-	if (ocfs2_xa_can_reuse_entry(loc, xi)) {
-		orig_value_size = loc->xl_entry->xe_value_size;
-		rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
-		if (rc)
-			goto out;
-		goto alloc_value;
-	}
+	if (loc->xl_entry) {
+		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
+			orig_value_size = loc->xl_entry->xe_value_size;
+			rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
+			if (rc)
+				goto out;
+			goto alloc_value;
+		}
 
-	if (!ocfs2_xattr_is_local(loc->xl_entry)) {
-		orig_clusters = ocfs2_xa_value_clusters(loc);
-		rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
-		if (rc) {
-			mlog_errno(rc);
-			ocfs2_xa_cleanup_value_truncate(loc,
-							"overwriting",
-							orig_clusters);
-			goto out;
+		if (!ocfs2_xattr_is_local(loc->xl_entry)) {
+			orig_clusters = ocfs2_xa_value_clusters(loc);
+			rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
+			if (rc) {
+				mlog_errno(rc);
+				ocfs2_xa_cleanup_value_truncate(loc,
+								"overwriting",
+								orig_clusters);
+				goto out;
+			}
 		}
-	}
-	ocfs2_xa_wipe_namevalue(loc);
+		ocfs2_xa_wipe_namevalue(loc);
+	} else
+		ocfs2_xa_add_entry(loc, name_hash);
 
 	/*
 	 * If we get here, we have a blank entry.  Fill it.  We grow our
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


