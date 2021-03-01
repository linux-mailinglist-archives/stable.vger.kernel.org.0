Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CF032766F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 04:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhCADf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 22:35:59 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:47365 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231605AbhCADf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 22:35:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tao.peng@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UPsyQO4_1614569714;
Received: from localhost(mailfrom:tao.peng@linux.alibaba.com fp:SMTPD_---0UPsyQO4_1614569714)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Mar 2021 11:35:15 +0800
From:   Peng Tao <tao.peng@linux.alibaba.com>
To:     alikernel-developer@linux.alibaba.com
Cc:     Liu Bo <bo.liu@linux.alibaba.com>,
        Ma Jie Yue <majieyue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eryu Guan <eguan@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>, <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <tao.peng@linux.alibaba.com>
Subject: [PATCH CK 4.19 1/4] fuse: fix page dereference after free
Date:   Mon,  1 Mar 2021 11:36:16 +0800
Message-Id: <1614569779-12114-2-git-send-email-tao.peng@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614569779-12114-1-git-send-email-tao.peng@linux.alibaba.com>
References: <1614569779-12114-1-git-send-email-tao.peng@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit d78092e4937de9ce55edcb4ee4c5e3c707be0190 upstream.

fix #32833505

After unlock_request() pages from the ap->pages[] array may be put (e.g. by
aborting the connection) and the pages can be freed.

Prevent use after free by grabbing a reference to the page before calling
unlock_request().

The original patch was created by Pradeep P V K.

Reported-by: Pradeep P V K <ppvk@codeaurora.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
 fs/fuse/dev.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3202ead..8ad877a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -877,15 +877,16 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 	struct page *newpage;
 	struct pipe_buffer *buf = cs->pipebufs;
 
+	get_page(oldpage);
 	err = unlock_request(cs->req);
 	if (err)
-		return err;
+		goto out_put_old;
 
 	fuse_copy_finish(cs);
 
 	err = pipe_buf_confirm(cs->pipe, buf);
 	if (err)
-		return err;
+		goto out_put_old;
 
 	BUG_ON(!cs->nr_segs);
 	cs->currbuf = buf;
@@ -925,7 +926,7 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 	err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
 	if (err) {
 		unlock_page(newpage);
-		return err;
+		goto out_put_old;
 	}
 
 	get_page(newpage);
@@ -944,14 +945,19 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 	if (err) {
 		unlock_page(newpage);
 		put_page(newpage);
-		return err;
+		goto out_put_old;
 	}
 
 	unlock_page(oldpage);
+	/* Drop ref for ap->pages[] array */
 	put_page(oldpage);
 	cs->len = 0;
 
-	return 0;
+	err = 0;
+out_put_old:
+	/* Drop ref obtained in this function */
+	put_page(oldpage);
+	return err;
 
 out_fallback_unlock:
 	unlock_page(newpage);
@@ -960,10 +966,10 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 	cs->offset = buf->offset;
 
 	err = lock_request(cs->req);
-	if (err)
-		return err;
+	if (!err)
+		err = 1;
 
-	return 1;
+	goto out_put_old;
 }
 
 static int fuse_ref_page(struct fuse_copy_state *cs, struct page *page,
@@ -975,14 +981,16 @@ static int fuse_ref_page(struct fuse_copy_state *cs, struct page *page,
 	if (cs->nr_segs == cs->pipe->buffers)
 		return -EIO;
 
+	get_page(page);
 	err = unlock_request(cs->req);
-	if (err)
+	if (err) {
+		put_page(page);
 		return err;
+	}
 
 	fuse_copy_finish(cs);
 
 	buf = cs->pipebufs;
-	get_page(page);
 	buf->page = page;
 	buf->offset = offset;
 	buf->len = count;
-- 
1.8.3.1

