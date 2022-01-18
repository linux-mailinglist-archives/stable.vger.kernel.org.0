Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4216D491DE1
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348270AbiARDnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241988AbiARCzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:55:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BBDC02B860;
        Mon, 17 Jan 2022 18:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14509B81261;
        Tue, 18 Jan 2022 02:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9E0C36AF6;
        Tue, 18 Jan 2022 02:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473842;
        bh=TduZyZ0ghcIaAcEEXlYQaCTkJBtGHHywni40Kmh8Jh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prnBF0clEaSNT3eqYKWRzQ7ix8wtX1erwGcc6JLVQoaIP0wEPMLFWl+TsILrcuao5
         Zw1KWb1nLHRZvYJ+L2nNSuAjunG5ym/uz0kryF+yvlrbnZpJ/e7nNa8Lm7n4YNH4ir
         Q3Bqy03YkHplJjoLE9w1wjcUpM6XLXmHcLT5ZplZ2JB8e5WHQIdWOKd9qfev/taqZp
         OSTLSsl/HKL7cSuWcUN0EFAyBsbD/t3cF2pstYI65p9q34pWcZoIBjaD+FiiYGE6yU
         85BiHVW2pCb6Jgt0xJrFf8TJb6ovPgnR2iWsWXICrVa1jSO1fVy9JXTymWNm3pK7Dc
         iJf/Cw2+5jbpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 099/116] btrfs: remove BUG_ON() in find_parent_nodes()
Date:   Mon, 17 Jan 2022 21:39:50 -0500
Message-Id: <20220118024007.1950576-99-sashal@kernel.org>
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
index 6e447bdaf9ec8..8b471579e26e1 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1213,7 +1213,12 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
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

