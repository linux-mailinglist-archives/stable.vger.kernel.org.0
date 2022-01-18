Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017FE491C74
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356190AbiARDPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:15:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32950 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344590AbiARDJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:09:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D30960B57;
        Tue, 18 Jan 2022 03:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F610C36AF2;
        Tue, 18 Jan 2022 03:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475365;
        bh=ELfRStfHNKsOOsq2oe4qyi0/nGf+qt+zN6WciT1U+OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIhowbfDmycSQq1yeGJ1YubHNCQH8mTgRCQW+ufAeB92cXQ8InO5YoxLA1A3SO3rl
         a4ngXmq42Xgf2HqmyS3qm5ang0A+7s6Bs99GqqGB3aHnYjWbGhoaGgnp7vJkqBWf1Z
         x2mL9Fj2sDhKu8vEWSflcpg4O4lu3CibbbAWSgpTYRCXuVhQKUxjnFVqVWLkAAolXn
         xvhy0SZVJ+P5+UNWIV/A3Hu92Gs5l3/dmaW8vQNi3W+U0lCVhUqJtiAZ84LH4Zh8Za
         Kp6kOI7am1brYxk5nyPVzKIqRwncNitfCFqi+icRzVXipkw7doPvIzdTfr4DtYOIz8
         YoL2a9bZjoxvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 22/29] btrfs: remove BUG_ON() in find_parent_nodes()
Date:   Mon, 17 Jan 2022 22:08:15 -0500
Message-Id: <20220118030822.1955469-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
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
index 228bfa19b745d..c59a13a53b1cc 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -975,7 +975,12 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
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

