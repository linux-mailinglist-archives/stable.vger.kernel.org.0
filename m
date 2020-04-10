Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B881A4065
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgDJDuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728769AbgDJDuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:50:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C11820CC7;
        Fri, 10 Apr 2020 03:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490602;
        bh=S+7+beaz5/RJ0NAlCU5OJ+8QC+v+mGFfrqkrr2LeSro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mu/BJqr+AYCl5Kivh6cHWHATWSbNhSRO3WjoRKM3HNWN1BY6XDD73axvFhcr54U5z
         39v9SfV5HmUnOcsjhdNIyHke5N8CjDxlSmm+Bv9CsRgmahX1lMAkJwAxL4lJEcE/MO
         xFpCjwQvjdyRh4YGa0Xclqx3uQC1PhW9SwqZOQuY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 45/46] btrfs: restart relocate_tree_blocks properly
Date:   Thu,  9 Apr 2020 23:49:08 -0400
Message-Id: <20200410034909.8922-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034909.8922-1-sashal@kernel.org>
References: <20200410034909.8922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 50dbbb71c79df89532ec41d118d59386e5a877e3 ]

There are two bugs here, but fixing them independently would just result
in pain if you happened to bisect between the two patches.

First is how we handle the -EAGAIN from relocate_tree_block().  We don't
set error, unless we happen to be the first node, which makes no sense,
I have no idea what the code was trying to accomplish here.

We in fact _do_ want err set here so that we know we need to restart in
relocate_block_group().  Also we need finish_pending_nodes() to not
actually call link_to_upper(), because we didn't actually relocate the
block.

And then if we do get -EAGAIN we do not want to set our backref cache
last_trans to the one before ours.  This would force us to update our
backref cache if we didn't cross transaction ids, which would mean we'd
have some nodes updated to their new_bytenr, but still able to find
their old bytenr because we're searching the same commit root as the
last time we went through relocate_tree_blocks.

Fixing these two things keeps us from panicing when we start breaking
out of relocate_tree_blocks() either for delayed ref flushing or enospc.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index e1337598d15ea..e3ba1c12008a9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3176,9 +3176,8 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		ret = relocate_tree_block(trans, rc, node, &block->key,
 					  path);
 		if (ret < 0) {
-			if (ret != -EAGAIN || &block->rb_node == rb_first(blocks))
-				err = ret;
-			goto out;
+			err = ret;
+			break;
 		}
 	}
 out:
@@ -4154,12 +4153,6 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		if (!RB_EMPTY_ROOT(&blocks)) {
 			ret = relocate_tree_blocks(trans, rc, &blocks);
 			if (ret < 0) {
-				/*
-				 * if we fail to relocate tree blocks, force to update
-				 * backref cache when committing transaction.
-				 */
-				rc->backref_cache.last_trans = trans->transid - 1;
-
 				if (ret != -EAGAIN) {
 					err = ret;
 					break;
-- 
2.20.1

