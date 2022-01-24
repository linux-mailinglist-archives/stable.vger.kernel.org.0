Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC495499B23
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574646AbiAXVuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377338AbiAXVh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2D18B81142;
        Mon, 24 Jan 2022 21:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2393CC340E7;
        Mon, 24 Jan 2022 21:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060237;
        bh=NoAJVYw6CP/5wj4wKs43vSyyWuXkyI9r0CT4hhQoO8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6ZV7o86rpTbcfpnGZu53diW3t1PDaPhohU46LfkhkXWEiTNcTAkI/DYrB7DpYPlP
         pRHjk2i0qC2tqVfV2lvBMYde8zeBIbkJD9I6+xivmOM7O3wsY/skzMlmUGdjzmkb91
         00gaZZlrgNOnA7N4gBwX6YoCKIqwZATyUKcVMYZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 0884/1039] btrfs: check the root node for uptodate before returning it
Date:   Mon, 24 Jan 2022 19:44:33 +0100
Message-Id: <20220124184155.007622603@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -1570,12 +1570,9 @@ static struct extent_buffer *btrfs_searc
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
@@ -1613,6 +1610,9 @@ static struct extent_buffer *btrfs_searc
 		goto out;
 	}
 
+	/* We try very hard to do read locks on the root */
+	root_lock = BTRFS_READ_LOCK;
+
 	/*
 	 * If the level is set to maximum, we can skip trying to get the read
 	 * lock.
@@ -1639,6 +1639,17 @@ static struct extent_buffer *btrfs_searc
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


