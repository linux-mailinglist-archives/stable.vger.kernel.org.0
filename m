Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1684547B069
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhLTPhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:37:18 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37479 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236419AbhLTPhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:37:18 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1BKFb569004484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 10:37:06 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4448215C33AD; Mon, 20 Dec 2021 10:37:05 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 1/3] ext4: prevent partial update of the extent blocks
Date:   Mon, 20 Dec 2021 10:36:57 -0500
Message-Id: <20211220153659.2120506-2-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20211220153659.2120506-1-tytso@mit.edu>
References: <20211220153659.2120506-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

Commit 0f2f87d51aebcf71a709b52f661d681594c7dffa upstream.

In the most error path of current extents updating operations are not
roll back partial updates properly when some bad things happens(.e.g in
ext4_ext_insert_extent()). So we may get an inconsistent extents tree
if journal has been aborted due to IO error, which may probability lead
to BUGON later when we accessing these extent entries in errors=continue
mode. This patch drop extent buffer's verify flag before updatng the
contents in ext4_ext_get_access(), and reset it after updating in
__ext4_ext_dirty(). After this patch we could force to check the extent
buffer if extents tree updating was break off, make sure the extents are
consistent.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210908120850.4012324-4-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index aa4d74f9d162..f2e569e9701d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -136,14 +136,24 @@ int ext4_datasem_ensure_credits(handle_t *handle, struct inode *inode,
 static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path)
 {
+	int err = 0;
+
 	if (path->p_bh) {
 		/* path points to block */
 		BUFFER_TRACE(path->p_bh, "get_write_access");
-		return ext4_journal_get_write_access(handle, path->p_bh);
+		err = ext4_journal_get_write_access(handle, path->p_bh);
+		/*
+		 * The extent buffer's verified bit will be set again in
+		 * __ext4_ext_dirty(). We could leave an inconsistent
+		 * buffer if the extents updating procudure break off du
+		 * to some error happens, force to check it again.
+		 */
+		if (!err)
+			clear_buffer_verified(path->p_bh);
 	}
 	/* path points to leaf/index in inode body */
 	/* we use in-core data, no need to protect them */
-	return 0;
+	return err;
 }
 
 /*
@@ -164,6 +174,9 @@ static int __ext4_ext_dirty(const char *where, unsigned int line,
 		/* path points to block */
 		err = __ext4_handle_dirty_metadata(where, line, handle,
 						   inode, path->p_bh);
+		/* Extents updating done, re-set verified flag */
+		if (!err)
+			set_buffer_verified(path->p_bh);
 	} else {
 		/* path points to leaf/index in inode body */
 		err = ext4_mark_inode_dirty(handle, inode);
-- 
2.31.0

