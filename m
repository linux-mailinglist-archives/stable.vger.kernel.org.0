Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76CA491A40
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346249AbiARC66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39242 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348902AbiARCqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:46:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D38506130F;
        Tue, 18 Jan 2022 02:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FED5C36AE3;
        Tue, 18 Jan 2022 02:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474001;
        bh=AA9YYFjl/q1mqv9RbvGD8amx10J1e3sqEDSaIOLxGfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obVOE5n8yTrsF5d79qnFYenRH9A0z2plQAo6FTnROhZdIej1n6jsfveOho/up4jyF
         h+7KXrhkOXpOKP56/FpI8v41VfsDPjQtSa9h+vXGhF8Jx9KJE0aDD5lviIUdXXGt/z
         raw3TVRcdEnjZKia5ANr9IImIo14bP1CoOTMBNfooFGulZyZ6X9kWGJ8P3cNwBWeBJ
         nF2g4OXYlSK/UJDQH1ShSai8jzc8GSpZ32dMUxluEmUWPN77hMfFMvcM+Ic8oQZU3l
         OS0wq+edPpKmlYeJILbYys04f0Ci+TBRs5EJZCuH4v5GlnvWWeS2wLdSYgVHTr2HR+
         e6t9lNWfpOkWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 61/73] btrfs: remove BUG_ON() in find_parent_nodes()
Date:   Mon, 17 Jan 2022 21:44:20 -0500
Message-Id: <20220118024432.1952028-61-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index 7f644a58db511..9044e7282d0b2 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1208,7 +1208,12 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
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

