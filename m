Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CB01AC974
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898479AbgDPNpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898476AbgDPNpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:45:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19F902076D;
        Thu, 16 Apr 2020 13:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044703;
        bh=P+DhAni+7LywfXEEAFqkoXCLsAjx8/apO7sX3BOt4qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPiluiX4tMaCIbKs/OeYK9mNbXo/AUfIVTIqAAZbNFCqbDrHWF16w12Rjo4L9eAmG
         WqCVWRhv+5i/gXZca6s0wnxfi54lOCwZC3MTzx4VtD0ULSwGawA9muNQqJvjNHOyHg
         Rp+Rv8NYuYn6s5Fveh35tHQZA/bR6csSJQ6TGEgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/232] btrfs: restart relocate_tree_blocks properly
Date:   Thu, 16 Apr 2020 15:22:41 +0200
Message-Id: <20200416131323.700357960@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7ce48f1364f76..c4ed7015cc7d9 100644
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
@@ -4154,12 +4153,6 @@ restart:
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



