Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D859491D9C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353417AbiARDkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354496AbiARDG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:06:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16ACC014F2C;
        Mon, 17 Jan 2022 18:48:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55B2460AB6;
        Tue, 18 Jan 2022 02:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06B1C36AEB;
        Tue, 18 Jan 2022 02:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474130;
        bh=2IwHZEdFHmVCrgmRtCoS7h96nCXu6mfBcB8QWe4ZJMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfBtGvMGHxxyEyDT3J4cTzpAHkDgnY4ezcI1+ny5LjiT6I3g8ciCpeFlEP47dcjR/
         e0oqnQ3lXeyv/tDX1oCbml7QQ3QvHOGIhTXl6hhfv5RpGtPztTOGyec3wM8bVtOaeI
         YO+3IoieyiYgsocLUtAax2nhWZdShgrvSFyGJ9L4G1O71FM01z8RHCeZA+/D+P088M
         EpG6sKbKcrOqVj6ueaFGDsp+fauws41Ei9DY6HWkOyqw2PmC/JKdzEuGK/oH4xl6WP
         QwOQcpSB0dNszWEq+4g3Ctvo8KScQks6iTo9Q9Yhem9vVFrwSwEo+2nDkbaQ/IyTmG
         USSBB1U7EGrwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 49/59] btrfs: remove BUG_ON(!eie) in find_parent_nodes
Date:   Mon, 17 Jan 2022 21:46:50 -0500
Message-Id: <20220118024701.1952911-49-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 9f05c09d6baef789726346397438cca4ec43c3ee ]

If we're looking for leafs that point to a data extent we want to record
the extent items that point at our bytenr.  At this point we have the
reference and we know for a fact that this leaf should have a reference
to our bytenr.  However if there's some sort of corruption we may not
find any references to our leaf, and thus could end up with eie == NULL.
Replace this BUG_ON() with an ASSERT() and then return -EUCLEAN for the
mortals.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 0073182d4e689..3fe15d6f40873 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1313,10 +1313,18 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 				goto out;
 			if (!ret && extent_item_pos) {
 				/*
-				 * we've recorded that parent, so we must extend
-				 * its inode list here
+				 * We've recorded that parent, so we must extend
+				 * its inode list here.
+				 *
+				 * However if there was corruption we may not
+				 * have found an eie, return an error in this
+				 * case.
 				 */
-				BUG_ON(!eie);
+				ASSERT(eie);
+				if (!eie) {
+					ret = -EUCLEAN;
+					goto out;
+				}
 				while (eie->next)
 					eie = eie->next;
 				eie->next = ref->inode_list;
-- 
2.34.1

