Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5751B4210
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgDVKFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgDVKFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:05:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 752FF2075A;
        Wed, 22 Apr 2020 10:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549901;
        bh=jOSt8wcuCExgb4rCQPiKRHJ0jDf2eTaFk0dQRm42qlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2zqIPvixohInPjqdOwrCHvSXVTvFn7WB20chzAh8CbhbjKFdE6leyuLS0TTmKMQn
         sgyVCFN5FAQjjjP9dlPyWBIwqG8KI+KAivSsmAKav5IngxEUyoLYO3WU1bSZUXH3rF
         UjVP7djtgzAGugZq9bhGINqAnRUw2dLi9BLz5bsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 012/125] btrfs: remove a BUG_ON() from merge_reloc_roots()
Date:   Wed, 22 Apr 2020 11:55:29 +0200
Message-Id: <20200422095035.026582083@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7b7b74315b24dc064bc1c683659061c3d48f8668 ]

This was pretty subtle, we default to reloc roots having 0 root refs, so
if we crash in the middle of the relocation they can just be deleted.
If we successfully complete the relocation operations we'll set our root
refs to 1 in prepare_to_merge() and then go on to merge_reloc_roots().

At prepare_to_merge() time if any of the reloc roots have a 0 reference
still, we will remove that reloc root from our reloc root rb tree, and
then clean it up later.

However this only happens if we successfully start a transaction.  If
we've aborted previously we will skip this step completely, and only
have reloc roots with a reference count of 0, but were never properly
removed from the reloc control's rb tree.

This isn't a problem per-se, our references are held by the list the
reloc roots are on, and by the original root the reloc root belongs to.
If we end up in this situation all the reloc roots will be added to the
dirty_reloc_list, and then properly dropped at that point.  The reloc
control will be free'd and the rb tree is no longer used.

There were two options when fixing this, one was to remove the BUG_ON(),
the other was to make prepare_to_merge() handle the case where we
couldn't start a trans handle.

IMO this is the cleaner solution.  I started with handling the error in
prepare_to_merge(), but it turned out super ugly.  And in the end this
BUG_ON() simply doesn't matter, the cleanup was happening properly, we
were just panicing because this BUG_ON() only matters in the success
case.  So I've opted to just remove it and add a comment where it was.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b106d365257d3..97bc85ca508c2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2457,7 +2457,21 @@ out:
 			free_reloc_roots(&reloc_roots);
 	}
 
-	BUG_ON(!RB_EMPTY_ROOT(&rc->reloc_root_tree.rb_root));
+	/*
+	 * We used to have
+	 *
+	 * BUG_ON(!RB_EMPTY_ROOT(&rc->reloc_root_tree.rb_root));
+	 *
+	 * here, but it's wrong.  If we fail to start the transaction in
+	 * prepare_to_merge() we will have only 0 ref reloc roots, none of which
+	 * have actually been removed from the reloc_root_tree rb tree.  This is
+	 * fine because we're bailing here, and we hold a reference on the root
+	 * for the list that holds it, so these roots will be cleaned up when we
+	 * do the reloc_dirty_list afterwards.  Meanwhile the root->reloc_root
+	 * will be cleaned up on unmount.
+	 *
+	 * The remaining nodes will be cleaned up by free_reloc_control.
+	 */
 }
 
 static void free_block_list(struct rb_root *blocks)
-- 
2.20.1



