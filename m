Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E878B2AB95F
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbgKINIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731060AbgKINIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A44320663;
        Mon,  9 Nov 2020 13:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927317;
        bh=2u4uFiuVxotEO64+laPzB8xN6NojkVe8Zht9x6elIRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0/0JXGhPNvMiYitc0aieH/Q+kDSWnrxenfonQjU55XtM60HuDw3K5TvblBiQAILT
         V8HtMcp9JrpcPdQCW9SOuiQQSwsWmgRBL3l+9XT36rCSSEbUnGxlkmoaHK90u2L0cK
         Fog65LviGvJpz3zAzCQT78Znv+9OzjdnhK2WeCAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 19/71] btrfs: extent_io: add proper error handling to lock_extent_buffer_for_io()
Date:   Mon,  9 Nov 2020 13:55:13 +0100
Message-Id: <20201109125020.811120362@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 2e3c25136adfb293d517e17f761d3b8a43a8fc22 upstream.

This function needs some extra checks on locked pages and eb.  For error
handling we need to unlock locked pages and the eb.

There is a rare >0 return value branch, where all pages get locked
while write bio is not flushed.

Thankfully it's handled by the only caller, btree_write_cache_pages(),
as later write_one_eb() call will trigger submit_one_bio().  So there
shouldn't be any problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3554,19 +3554,27 @@ void wait_on_extent_buffer_writeback(str
 		       TASK_UNINTERRUPTIBLE);
 }
 
+/*
+ * Lock eb pages and flush the bio if we can't the locks
+ *
+ * Return  0 if nothing went wrong
+ * Return >0 is same as 0, except bio is not submitted
+ * Return <0 if something went wrong, no page is locked
+ */
 static noinline_for_stack int
 lock_extent_buffer_for_io(struct extent_buffer *eb,
 			  struct btrfs_fs_info *fs_info,
 			  struct extent_page_data *epd)
 {
-	int i, num_pages;
+	int i, num_pages, failed_page_nr;
 	int flush = 0;
 	int ret = 0;
 
 	if (!btrfs_try_tree_write_lock(eb)) {
-		flush = 1;
 		ret = flush_write_bio(epd);
-		BUG_ON(ret < 0);
+		if (ret < 0)
+			return ret;
+		flush = 1;
 		btrfs_tree_lock(eb);
 	}
 
@@ -3576,7 +3584,8 @@ lock_extent_buffer_for_io(struct extent_
 			return 0;
 		if (!flush) {
 			ret = flush_write_bio(epd);
-			BUG_ON(ret < 0);
+			if (ret < 0)
+				return ret;
 			flush = 1;
 		}
 		while (1) {
@@ -3618,7 +3627,10 @@ lock_extent_buffer_for_io(struct extent_
 		if (!trylock_page(p)) {
 			if (!flush) {
 				ret = flush_write_bio(epd);
-				BUG_ON(ret < 0);
+				if (ret < 0) {
+					failed_page_nr = i;
+					goto err_unlock;
+				}
 				flush = 1;
 			}
 			lock_page(p);
@@ -3626,6 +3638,11 @@ lock_extent_buffer_for_io(struct extent_
 	}
 
 	return ret;
+err_unlock:
+	/* Unlock already locked pages */
+	for (i = 0; i < failed_page_nr; i++)
+		unlock_page(eb->pages[i]);
+	return ret;
 }
 
 static void end_extent_buffer_writeback(struct extent_buffer *eb)


