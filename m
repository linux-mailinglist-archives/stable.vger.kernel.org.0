Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1EE2A59BE
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbgKCUiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbgKCUiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0C5122226;
        Tue,  3 Nov 2020 20:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435888;
        bh=aFdSBfAYL1JIBQZPl9OLo9j9t2k6oXvMLTRkzYYckwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1AtBwAb2pluepiQkOfIzfQ42yJSqDHBhXZTbdNPJgYJU2PFkS1Pu+bTYTsa16a8Q
         HWqk6+ChO3X5jXRS+QC6JYS8J9nlVoT3xUuLv/b2Fomp5gdTI1CrAKTV2jBY3Y/Cwq
         ni6devjVb5UeJKRhJKrrgIbX6XUMIsCCJHdhhIeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 027/391] afs: Fix afs_launder_page to not clear PG_writeback
Date:   Tue,  3 Nov 2020 21:31:18 +0100
Message-Id: <20201103203349.646715753@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit d383e346f97d6bb0d654bb3d63c44ab106d92d29 ]

Fix afs_launder_page() to not clear PG_writeback on the page it is
laundering as the flag isn't set in this case.

Fixes: 4343d00872e1 ("afs: Get rid of the afs_writeback record")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h |  1 +
 fs/afs/write.c    | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 06e617ee4cd1e..c8acb58ac5d8f 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -811,6 +811,7 @@ struct afs_operation {
 			pgoff_t		last;		/* last page in mapping to deal with */
 			unsigned	first_offset;	/* offset into mapping[first] */
 			unsigned	last_to;	/* amount of mapping[last] */
+			bool		laundering;	/* Laundering page, PG_writeback not set */
 		} store;
 		struct {
 			struct iattr	*attr;
diff --git a/fs/afs/write.c b/fs/afs/write.c
index da12abd6db213..b937ec047ec98 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -396,7 +396,8 @@ static void afs_store_data_success(struct afs_operation *op)
 	op->ctime = op->file[0].scb.status.mtime_client;
 	afs_vnode_commit_status(op, &op->file[0]);
 	if (op->error == 0) {
-		afs_pages_written_back(vnode, op->store.first, op->store.last);
+		if (!op->store.laundering)
+			afs_pages_written_back(vnode, op->store.first, op->store.last);
 		afs_stat_v(vnode, n_stores);
 		atomic_long_add((op->store.last * PAGE_SIZE + op->store.last_to) -
 				(op->store.first * PAGE_SIZE + op->store.first_offset),
@@ -415,7 +416,7 @@ static const struct afs_operation_ops afs_store_data_operation = {
  */
 static int afs_store_data(struct address_space *mapping,
 			  pgoff_t first, pgoff_t last,
-			  unsigned offset, unsigned to)
+			  unsigned offset, unsigned to, bool laundering)
 {
 	struct afs_vnode *vnode = AFS_FS_I(mapping->host);
 	struct afs_operation *op;
@@ -448,6 +449,7 @@ static int afs_store_data(struct address_space *mapping,
 	op->store.last = last;
 	op->store.first_offset = offset;
 	op->store.last_to = to;
+	op->store.laundering = laundering;
 	op->mtime = vnode->vfs_inode.i_mtime;
 	op->flags |= AFS_OPERATION_UNINTR;
 	op->ops = &afs_store_data_operation;
@@ -601,7 +603,7 @@ no_more:
 	if (end > i_size)
 		to = i_size & ~PAGE_MASK;
 
-	ret = afs_store_data(mapping, first, last, offset, to);
+	ret = afs_store_data(mapping, first, last, offset, to, false);
 	switch (ret) {
 	case 0:
 		ret = count;
@@ -921,7 +923,7 @@ int afs_launder_page(struct page *page)
 
 		trace_afs_page_dirty(vnode, tracepoint_string("launder"),
 				     page->index, priv);
-		ret = afs_store_data(mapping, page->index, page->index, t, f);
+		ret = afs_store_data(mapping, page->index, page->index, t, f, true);
 	}
 
 	trace_afs_page_dirty(vnode, tracepoint_string("laundered"),
-- 
2.27.0



