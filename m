Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8504F2BBD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355440AbiDEKTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345198AbiDEJWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3838D2CE13;
        Tue,  5 Apr 2022 02:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD23661577;
        Tue,  5 Apr 2022 09:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF27FC385A0;
        Tue,  5 Apr 2022 09:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149774;
        bh=dfwslQshdOGJvbL0tDsFD7rVh7X7+dHJBiQvqfoAksw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebmFm1tILaLHhl2FprVv+5sMHi1WeeeXZ5xiCPBblmhxxpIEZmRWHsmZVGt8aAjyE
         KI7itjlB1udBHKRibY4lWf1Ok1QmjS/4ZAHNy1Zhn7C315uaOsf1TV5NW59bMchOMs
         Ey9hYthMTv8R8S+HKzIcCWNMeSvBF0vg7lWMj+M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Burkov <boris@bur.io>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0798/1017] btrfs: do not clean up repair bio if submit fails
Date:   Tue,  5 Apr 2022 09:28:31 +0200
Message-Id: <20220405070417.937994199@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c3f466362103..ced0195f3390 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2640,7 +2640,6 @@ int btrfs_repair_one_sector(struct inode *inode,
 	const int icsum = bio_offset >> fs_info->sectorsize_bits;
 	struct bio *repair_bio;
 	struct btrfs_bio *repair_bbio;
-	blk_status_t status;
 
 	btrfs_debug(fs_info,
 		   "repair read error: read error at %llu", start);
@@ -2679,13 +2678,13 @@ int btrfs_repair_one_sector(struct inode *inode,
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



