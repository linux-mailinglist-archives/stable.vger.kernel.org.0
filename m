Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68E022EFDB
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbgG0OTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731455AbgG0OTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E34902070A;
        Mon, 27 Jul 2020 14:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859592;
        bh=W1KFMAIHFlohENhNRehYvsOhP45gjEfT1u4uc4hD2kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6cCWkTV0AFsCbjAIRrCq0t0AV0eu3gMZGKWCNiMoXgM5VL/wjIMDFsDi9MEPRZeC
         L9/isjDEeW0LmyXiOUpOTxNGgo3lRzaiJsKl5HseAXcwGZl679gMCQE4J2GHim7inA
         xyK94OxLfJJHkKJhz3irL5QctuIQUdMYng7002lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 031/179] btrfs: reloc: clear DEAD_RELOC_TREE bit for orphan roots to prevent runaway balance
Date:   Mon, 27 Jul 2020 16:03:26 +0200
Message-Id: <20200727134934.182761381@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 1dae7e0e58b484eaa43d530f211098fdeeb0f404 upstream.

[BUG]
There are several reported runaway balance, that balance is flooding the
log with "found X extents" where the X never changes.

[CAUSE]
Commit d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after
merge_reloc_roots") introduced BTRFS_ROOT_DEAD_RELOC_TREE bit to
indicate that one subvolume has finished its tree blocks swap with its
reloc tree.

However if balance is canceled or hits ENOSPC halfway, we didn't clear
the BTRFS_ROOT_DEAD_RELOC_TREE bit, leaving that bit hanging forever
until unmount.

Any subvolume root with that bit, would cause backref cache to skip this
tree block, as it has finished its tree block swap.  This would cause
all tree blocks of that root be ignored by balance, leading to runaway
balance.

[FIX]
Fix the problem by also clearing the BTRFS_ROOT_DEAD_RELOC_TREE bit for
the original subvolume of orphan reloc root.

Add an umount check for the stale bit still set.

Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/btrfs/disk-io.c    |    1 +
 fs/btrfs/relocation.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1998,6 +1998,7 @@ void btrfs_put_root(struct btrfs_root *r
 
 	if (refcount_dec_and_test(&root->refs)) {
 		WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
+		WARN_ON(test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state));
 		if (root->anon_dev)
 			free_anon_bdev(root->anon_dev);
 		btrfs_drew_lock_destroy(&root->snapshot_lock);
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2642,6 +2642,8 @@ again:
 					root->reloc_root = NULL;
 					btrfs_put_root(reloc_root);
 				}
+				clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
+					  &root->state);
 				btrfs_put_root(root);
 			}
 


