Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F271498CA0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347090AbiAXTXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349837AbiAXTVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:21:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDCFC02B857;
        Mon, 24 Jan 2022 11:08:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B45CB811FC;
        Mon, 24 Jan 2022 19:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BFEC340E5;
        Mon, 24 Jan 2022 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051311;
        bh=SvjvMtJ7tOmDYbJxKQfh7QYBfYnBz6AH1YssZDecAbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEMLf2/dr4Gv3X83S2QACF1mUMiKEEyPM6iMTGOedEigFHrn2RLdLc65ehiIvRrCe
         VQRPj1YEhmjIkIuFsBNOr6yalOqZ8aNh1oHuOyewiU8ETxarw0A0tIuZ9pXuQrKqcg
         BKvDMuqKJRIDKKDtVWeU+8HkjrMziHq1aNMx7GNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 122/186] btrfs: remove BUG_ON() in find_parent_nodes()
Date:   Mon, 24 Jan 2022 19:43:17 +0100
Message-Id: <20220124183941.038652634@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -1163,7 +1163,12 @@ again:
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



