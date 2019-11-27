Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7C610B822
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbfK0UkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbfK0UkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:40:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A909621770;
        Wed, 27 Nov 2019 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887212;
        bh=g6tQzpPav/HyLLUIHmdIMx0pZsXaRsRBu3POfBuvuyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMd5xx6HVZaXS+IHfKPwoWdjdlOqi/cOnOYo/LNj9aW2t+938diN4B3//D2pVMPqV
         j6iEboEp3Y/GdS5lZ/ucvug1BsnooVf7BBOsNilJ2g/JniI7riTNT0tA6NhA51KXW5
         LA0tk2+Sl5wqM8tmtdQxdsjvqlhvPvVT4VGFrCXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Thomas Voegtle <tv@lio96.de>, Changwei Ge <gechangwei@live.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 008/151] Revert "fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()"
Date:   Wed, 27 Nov 2019 21:29:51 +0100
Message-Id: <20191127203006.310925298@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 94b07b6f9e2e996afff7395de6b35f34f4cb10bf upstream.

This reverts commit 56e94ea132bb5c2c1d0b60a6aeb34dcb7d71a53d.

Commit 56e94ea132bb ("fs: ocfs2: fix possible null-pointer dereferences
in ocfs2_xa_prepare_entry()") introduces a regression that fail to
create directory with mount option user_xattr and acl.  Actually the
reported NULL pointer dereference case can be correctly handled by
loc->xl_ops->xlo_add_entry(), so revert it.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/xattr.c |   56 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1497,6 +1497,18 @@ static int ocfs2_xa_check_space(struct o
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
@@ -2128,31 +2140,29 @@ static int ocfs2_xa_prepare_entry(struct
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


