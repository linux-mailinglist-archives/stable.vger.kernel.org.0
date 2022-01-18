Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582624915FF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245563AbiARCcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42462 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344375AbiARC3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98BCFB8124E;
        Tue, 18 Jan 2022 02:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98E6C36AF2;
        Tue, 18 Jan 2022 02:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472988;
        bh=zI6GycII7ZqdcccMhnvZf7pbAzNxjeMsL9gidccGsHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVYb2OjGxexQQI+93dqsjY2XIKdb2fVyHXuqYxRCL/Cpt2BMGbtXLNgO8mee3H0rX
         J4CeqAVxxZbc4ik2ZPSrtBQIAHc5jbnetpEA1P9demhAXHGw/MZ7rSMDWUZCYTTKvx
         VMWAUZrOhFlzSbDNGdAtiuckG8RVUA9PVZudiGHj7A2JJHiG18/Q/KUVs1YT4PeYqW
         6ImHDY6rhk4gl8ntNVrMrPS5oAVdj8IAqHc6m5bhsjKzB3mAgD7Uf3NHx3BaqLy5yo
         4PuTNoFhztAkkzL2T1imgo9bnDxW3VOKa1laEfuyWlV2ffpM2acRHdjw5LE2C9vKr/
         9Iq05+2ysMcwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 192/217] btrfs: remove BUG_ON() in find_parent_nodes()
Date:   Mon, 17 Jan 2022 21:19:15 -0500
Message-Id: <20220118021940.1942199-192-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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

