Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675E2499244
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348336AbiAXUSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356214AbiAXUOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:14:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E892C09B052;
        Mon, 24 Jan 2022 11:37:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26BF8B81238;
        Mon, 24 Jan 2022 19:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7D2C340E5;
        Mon, 24 Jan 2022 19:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053070;
        bh=kEkyCNZBvcElxWMg8I/Xi3Hk6q+Di49XLMC0Q1kRaME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuGGVG6wLLETne1DU8lgcs5UzwxuDc9Dndio352zTUQl6nFfAoy+WIRIUnBKiaxTX
         IvzFQSBBWsZIbNgVHl1xDl2vL1Gde0jAqTQS9zFVAbRpuqj653FV22taKLxScA7Yh2
         rJnFr/8LufcM5NQZvpyuv2dmJwKsCy6inCCe8KzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 266/320] btrfs: check the root node for uptodate before returning it
Date:   Mon, 24 Jan 2022 19:44:10 +0100
Message-Id: <20220124184003.027352454@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 120de408e4b97504a2d9b5ca534b383de2c73d49 upstream.

Now that we clear the extent buffer uptodate if we fail to write it out
we need to check to see if our root node is uptodate before we search
down it.  Otherwise we could return stale data (or potentially corrupt
data that was caught by the write verification step) and think that the
path is OK to search down.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2658,12 +2658,9 @@ static struct extent_buffer *btrfs_searc
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *b;
-	int root_lock;
+	int root_lock = 0;
 	int level = 0;
 
-	/* We try very hard to do read locks on the root */
-	root_lock = BTRFS_READ_LOCK;
-
 	if (p->search_commit_root) {
 		/*
 		 * The commit roots are read only so we always do read locks,
@@ -2701,6 +2698,9 @@ static struct extent_buffer *btrfs_searc
 		goto out;
 	}
 
+	/* We try very hard to do read locks on the root */
+	root_lock = BTRFS_READ_LOCK;
+
 	/*
 	 * If the level is set to maximum, we can skip trying to get the read
 	 * lock.
@@ -2727,6 +2727,17 @@ static struct extent_buffer *btrfs_searc
 	level = btrfs_header_level(b);
 
 out:
+	/*
+	 * The root may have failed to write out at some point, and thus is no
+	 * longer valid, return an error in this case.
+	 */
+	if (!extent_buffer_uptodate(b)) {
+		if (root_lock)
+			btrfs_tree_unlock_rw(b, root_lock);
+		free_extent_buffer(b);
+		return ERR_PTR(-EIO);
+	}
+
 	p->nodes[level] = b;
 	if (!p->skip_locking)
 		p->locks[level] = root_lock;


