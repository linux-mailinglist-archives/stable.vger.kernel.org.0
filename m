Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E2B49180F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345402AbiARCoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48436 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345075AbiARCjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:39:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2864EB81239;
        Tue, 18 Jan 2022 02:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539EEC36AEF;
        Tue, 18 Jan 2022 02:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473553;
        bh=zI6GycII7ZqdcccMhnvZf7pbAzNxjeMsL9gidccGsHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8wT/PCBhUOqHSrf+gYsxSwzdCW3lGe34BBDBwUfgZVllpu4c6SmcQ49WNLIYTv1s
         8/OTLfxmNmVMarxYOnaCciU9Ha2juOPKE7Sp0GcdUD9wmnG7c1mkRYaoznraDOPpsp
         UXnfqsWHssMiXOFanXYWQR0+kYu7upRKTTETsI3q1sG6jw8dpXo+XmbOoLA2NS95yF
         Gao3xZeYZsOifBWxxuGXAdLDWTKTkh9HHU+j5ZcQGSMfOGuXwHKNxnfrVp3TA0P01/
         d4FfdNwr/SQqfNPdPPcUJLgOiGri5oVAuWd34+nrXX9Vzfr9omqNgFsox4fLFR2pXu
         GkLwEqA46RxGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 164/188] btrfs: remove BUG_ON() in find_parent_nodes()
Date:   Mon, 17 Jan 2022 21:31:28 -0500
Message-Id: <20220118023152.1948105-164-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index f735b8798ba12..6b4b0f105a572 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1214,7 +1214,12 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
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

