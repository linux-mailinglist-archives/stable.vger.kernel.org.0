Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9319FEF005
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387941AbfKDWZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730661AbfKDVwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:03 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0410C2184C;
        Mon,  4 Nov 2019 21:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904322;
        bh=ChdGGD+txzjN2zotCun5b3jNdy1Ga0tyEkZHwi0rZMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/rSIT/Ui8+KDqaXRZHy/ZlHD9x+nqnhD4TNtEtn1Bkg52sOB+8Ln9yFCKZE0zBEh
         bEprtWsqUzIp5v0hw1b3sOthjiK/rqWEba/9KJTLS56a5bU93ODO+7nsWLsSE3rsdB
         BKEmTtLH08dWPHDUj1Onc+RBbnHtgK8J6JNs1EHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 24/62] fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()
Date:   Mon,  4 Nov 2019 22:44:46 +0100
Message-Id: <20191104211923.803443309@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 56e94ea132bb5c2c1d0b60a6aeb34dcb7d71a53d ]

In ocfs2_xa_prepare_entry(), there is an if statement on line 2136 to
check whether loc->xl_entry is NULL:

    if (loc->xl_entry)

When loc->xl_entry is NULL, it is used on line 2158:

    ocfs2_xa_add_entry(loc, name_hash);
        loc->xl_entry->xe_name_hash = cpu_to_le32(name_hash);
        loc->xl_entry->xe_name_offset = cpu_to_le16(loc->xl_size);

and line 2164:

    ocfs2_xa_add_namevalue(loc, xi);
        loc->xl_entry->xe_value_size = cpu_to_le64(xi->xi_value_len);
        loc->xl_entry->xe_name_len = xi->xi_name_len;

Thus, possible null-pointer dereferences may occur.

To fix these bugs, if loc-xl_entry is NULL, ocfs2_xa_prepare_entry()
abnormally returns with -EINVAL.

These bugs are found by a static analysis tool STCheck written by us.

[akpm@linux-foundation.org: remove now-unused ocfs2_xa_add_entry()]
Link: http://lkml.kernel.org/r/20190726101447.9153-1-baijiaju1990@gmail.com
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 56 ++++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e108c945ac1f8..c387467d574cb 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1497,18 +1497,6 @@ static int ocfs2_xa_check_space(struct ocfs2_xa_loc *loc,
 	return loc->xl_ops->xlo_check_space(loc, xi);
 }
 
-static void ocfs2_xa_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
-{
-	loc->xl_ops->xlo_add_entry(loc, name_hash);
-	loc->xl_entry->xe_name_hash = cpu_to_le32(name_hash);
-	/*
-	 * We can't leave the new entry's xe_name_offset at zero or
-	 * add_namevalue() will go nuts.  We set it to the size of our
-	 * storage so that it can never be less than any other entry.
-	 */
-	loc->xl_entry->xe_name_offset = cpu_to_le16(loc->xl_size);
-}
-
 static void ocfs2_xa_add_namevalue(struct ocfs2_xa_loc *loc,
 				   struct ocfs2_xattr_info *xi)
 {
@@ -2140,29 +2128,31 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 	if (rc)
 		goto out;
 
-	if (loc->xl_entry) {
-		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
-			orig_value_size = loc->xl_entry->xe_value_size;
-			rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
-			if (rc)
-				goto out;
-			goto alloc_value;
-		}
+	if (!loc->xl_entry) {
+		rc = -EINVAL;
+		goto out;
+	}
 
-		if (!ocfs2_xattr_is_local(loc->xl_entry)) {
-			orig_clusters = ocfs2_xa_value_clusters(loc);
-			rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
-			if (rc) {
-				mlog_errno(rc);
-				ocfs2_xa_cleanup_value_truncate(loc,
-								"overwriting",
-								orig_clusters);
-				goto out;
-			}
+	if (ocfs2_xa_can_reuse_entry(loc, xi)) {
+		orig_value_size = loc->xl_entry->xe_value_size;
+		rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
+		if (rc)
+			goto out;
+		goto alloc_value;
+	}
+
+	if (!ocfs2_xattr_is_local(loc->xl_entry)) {
+		orig_clusters = ocfs2_xa_value_clusters(loc);
+		rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
+		if (rc) {
+			mlog_errno(rc);
+			ocfs2_xa_cleanup_value_truncate(loc,
+							"overwriting",
+							orig_clusters);
+			goto out;
 		}
-		ocfs2_xa_wipe_namevalue(loc);
-	} else
-		ocfs2_xa_add_entry(loc, name_hash);
+	}
+	ocfs2_xa_wipe_namevalue(loc);
 
 	/*
 	 * If we get here, we have a blank entry.  Fill it.  We grow our
-- 
2.20.1



