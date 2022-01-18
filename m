Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E19491DDF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345574AbiARDnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245597AbiARCzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:55:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123D5C02B861;
        Mon, 17 Jan 2022 18:44:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 908CF612D2;
        Tue, 18 Jan 2022 02:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECC1C36AEB;
        Tue, 18 Jan 2022 02:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473844;
        bh=gcaFBvYiRKrylm0bdFUEbI/qmTw6tKAMBFvgaz3zcnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LV2qw+3pQIKhmruOaSNaBuTEcORsr3fdmTHTfh52dFArpWP1534hfs2T/oIqBkK7z
         hA6c0tOM4U/7sZ5bXdiYpuUXUAnGu3Bf2iEiHALwRJrguteu2fXGgyWRYhN6oCBOMI
         7MPYfnwuvjGBmPTuaaOMubLmHf6uvwZXMPry70A+o4qf7uHq7Wg4NS7Dmhz6Pvw0cy
         S1c/0ldEbnGFgDKUwzJn9GVDJRryNUdR8brbhISRrPuu1UX8d5xdDJWSX7FlqAqaOF
         pJGMldQxuF+nlo3YczVmLZYaPhS+rMoCcYvctx22D8z2IjqaTSe9SLYT3NzM3RYNGX
         7lUqxZXnb757g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 100/116] btrfs: remove BUG_ON(!eie) in find_parent_nodes
Date:   Mon, 17 Jan 2022 21:39:51 -0500
Message-Id: <20220118024007.1950576-100-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 8b471579e26e1..baff31a147e7d 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1366,10 +1366,18 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
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

