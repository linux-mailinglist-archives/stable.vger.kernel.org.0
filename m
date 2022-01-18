Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7C5491C59
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355911AbiARDOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352437AbiARDIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:08:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB80C061747;
        Mon, 17 Jan 2022 18:51:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D92B56133E;
        Tue, 18 Jan 2022 02:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986DAC36AEB;
        Tue, 18 Jan 2022 02:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474261;
        bh=gAdR1OM5DyzXldaoTGerOPYk5Q5HS47XdNIAaB8QhhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aN7hgv5eD3xtN9pR0wddgdteEuI1gMBl6y20f9sVP8mgvciYM06BhmXThh2vpleb+
         9wiJd3xzibGUqucGB0we2/oWICgysWqRjlqD13x00QQFIEt5ISqF6FZqWmC9dxvO5z
         WhsuZmBU0U/84bPVxBhQEIQCkWe0MVet21/N74bvab5zFWEYoKa9IX/yFUfWzXQxnD
         W8k0isA9Tg4rUCXsPRUf84UT9Ew0Uum+dwIPgWoH/j/hQ3XXy9yqQOl4eK+f+G3xWp
         3KQfwPktGMJ0fHvCK1CuZ8fStDhRp3oKDMAKzd51vsWHGR8+fblYOZfsszrrDn//VY
         B0e/Iv4BRh+Kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 47/56] btrfs: remove BUG_ON() in find_parent_nodes()
Date:   Mon, 17 Jan 2022 21:48:59 -0500
Message-Id: <20220118024908.1953673-47-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit fcba0120edf88328524a4878d1d6f4ad39f2ec81 ]

We search for an extent entry with .offset = -1, which shouldn't be a
thing, but corruption happens.  Add an ASSERT() for the developers,
return -EUCLEAN for mortals.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 1cf75d1032e17..f2c2ac3343bac 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1163,7 +1163,12 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
-	BUG_ON(ret == 0);
+	if (ret == 0) {
+		/* This shouldn't happen, indicates a bug or fs corruption. */
+		ASSERT(ret != 0);
+		ret = -EUCLEAN;
+		goto out;
+	}
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	if (trans && likely(trans->type != __TRANS_DUMMY) &&
-- 
2.34.1

