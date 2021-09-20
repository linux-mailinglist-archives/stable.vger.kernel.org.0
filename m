Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9112412104
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356723AbhITSBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347903AbhITR7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BF7163218;
        Mon, 20 Sep 2021 17:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158121;
        bh=N01rFWMIESTbGlmm3z6+y+F94ZscUPhe8NXzPUvifdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOmAueTxi50CFCqqX7WOK3JzRsuC5VmwzpB9nzrG61V6+41TP3d4laCQo6e99epIi
         M/e8O0wYa3yo/sjeqH6T9D7Mlf5WzKLQyAtjcjf/aPE27cTk96iWDU9kQtjj7c/3fQ
         WlHB2TPQYq6r8Zt2ONq/Q/DH0wNI9YNeMKyQ2LCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 002/260] btrfs: wake up async_delalloc_pages waiters after submit
Date:   Mon, 20 Sep 2021 18:40:20 +0200
Message-Id: <20210920163931.207132508@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit ac98141d140444fe93e26471d3074c603b70e2ca upstream.

We use the async_delalloc_pages mechanism to make sure that we've
completed our async work before trying to continue our delalloc
flushing.  The reason for this is we need to see any ordered extents
that were created by our delalloc flushing.  However we're waking up
before we do the submit work, which is before we create the ordered
extents.  This is a pretty wide race window where we could potentially
think there are no ordered extents and thus exit shrink_delalloc
prematurely.  Fix this by waking us up after we've done the work to
create ordered extents.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1200,11 +1200,6 @@ static noinline void async_cow_submit(st
 	nr_pages = (async_chunk->end - async_chunk->start + PAGE_SIZE) >>
 		PAGE_SHIFT;
 
-	/* atomic_sub_return implies a barrier */
-	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
-	    5 * SZ_1M)
-		cond_wake_up_nomb(&fs_info->async_submit_wait);
-
 	/*
 	 * ->inode could be NULL if async_chunk_start has failed to compress,
 	 * in which case we don't have anything to submit, yet we need to
@@ -1213,6 +1208,11 @@ static noinline void async_cow_submit(st
 	 */
 	if (async_chunk->inode)
 		submit_compressed_extents(async_chunk);
+
+	/* atomic_sub_return implies a barrier */
+	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
+	    5 * SZ_1M)
+		cond_wake_up_nomb(&fs_info->async_submit_wait);
 }
 
 static noinline void async_cow_free(struct btrfs_work *work)


