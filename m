Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43F94E9FFF
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343617AbiC1ToJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343568AbiC1ToE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:44:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A85D5C367;
        Mon, 28 Mar 2022 12:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C853B612BB;
        Mon, 28 Mar 2022 19:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517B8C36AE3;
        Mon, 28 Mar 2022 19:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496539;
        bh=BF/guW/+isYw2DnCZre/fA94hxTACgaGf++mu0iwiAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gglaOfkJsyQOShHXzItcmM2gxLXCJ54hx/ljPI6W2DOJHUhIyyeN4OcWAYmbe/X6x
         Z62ZpVsWwM1wu/QoC6AF/KNjKWH3pt08vEdPHz9xwGeMMqgbpYLLl1ul9g3qbM+7bA
         BwjUMcSpBAWBZdXSMEghEjrHW8eFmSGXINZ1dUuG70+F4gwlSxHsZu5N5E61zuQ/UG
         sp9AeBZ75jTFZH574UrjEPQ8Q6Msqn56b9QrZ8QUDtWR5T1Oj0cxA9ZJzL402/HNMj
         x+IApDDwvyD2o2Oprnnj8uupYwGWTwOAEBLNoIeEmNQPQfzrrbstJ6YKW6zj0tScFn
         96TvR8psWkbVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, Boris Burkov <boris@bur.io>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 16/21] btrfs: do not clean up repair bio if submit fails
Date:   Mon, 28 Mar 2022 15:41:51 -0400
Message-Id: <20220328194157.1585642-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194157.1585642-1-sashal@kernel.org>
References: <20220328194157.1585642-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 8cbc3001a3264d998d6b6db3e23f935c158abd4d ]

The submit helper will always run bio_endio() on the bio if it fails to
submit, so cleaning up the bio just leads to a variety of use-after-free
and NULL pointer dereference bugs because we race with the endio
function that is cleaning up the bio.  Instead just return BLK_STS_OK as
the repair function has to continue to process the rest of the pages,
and the endio for the repair bio will do the appropriate cleanup for the
page that it was given.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4c91060d103a..2c4f75348282 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2639,7 +2639,6 @@ int btrfs_repair_one_sector(struct inode *inode,
 	const int icsum = bio_offset >> fs_info->sectorsize_bits;
 	struct bio *repair_bio;
 	struct btrfs_bio *repair_bbio;
-	blk_status_t status;
 
 	btrfs_debug(fs_info,
 		   "repair read error: read error at %llu", start);
@@ -2678,13 +2677,13 @@ int btrfs_repair_one_sector(struct inode *inode,
 		    "repair read error: submitting new read to mirror %d",
 		    failrec->this_mirror);
 
-	status = submit_bio_hook(inode, repair_bio, failrec->this_mirror,
-				 failrec->bio_flags);
-	if (status) {
-		free_io_failure(failure_tree, tree, failrec);
-		bio_put(repair_bio);
-	}
-	return blk_status_to_errno(status);
+	/*
+	 * At this point we have a bio, so any errors from submit_bio_hook()
+	 * will be handled by the endio on the repair_bio, so we can't return an
+	 * error here.
+	 */
+	submit_bio_hook(inode, repair_bio, failrec->this_mirror, failrec->bio_flags);
+	return BLK_STS_OK;
 }
 
 static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
-- 
2.34.1

