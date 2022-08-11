Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1AF590116
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbiHKPsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbiHKPqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:46:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76165979C8;
        Thu, 11 Aug 2022 08:41:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ABC0B82128;
        Thu, 11 Aug 2022 15:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BB7C433C1;
        Thu, 11 Aug 2022 15:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232477;
        bh=LUk1ubcV+Xs5kdplnQ3qwUHkWfVeb33sR4aXFbkGBSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FB0KzDFpMRGSPSPwJXAT8D/t655c3ues+KuGacPNJ2qjwXxwANZpSTvWLp8JKGObZ
         UKWqNSe0K0sP4rpndQQXBFp5w6ljRGfrex7wqnBgw4020jmzE8iUAk5w1+17jO0y0w
         mfex7A0A84VEz98y55ZoFeUChNcO3h5OpLz+RjRymKOtWSkPsiqGwM5Qa+hEq3Nvgo
         jG5lfITO8bio05eEV5EduKfzNh9x/Xk4/xwo46Mwc49qL5BEJv7YYy/EkIFgQ0eQfj
         4rwBkDmKmjX7/t8UjZOBW5WmxmUXSmgAKZD3ZyNFZ9i07EUbhhy32snJ1kxN8FVOTM
         JpbndP4Na4tQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 093/105] btrfs: output mirror number for bad metadata
Date:   Thu, 11 Aug 2022 11:28:17 -0400
Message-Id: <20220811152851.1520029-93-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 8f0ed7d4e7bd87c9207a59d6d887777f632a5ed5 ]

When handling a real world transid mismatch image, it's hard to know
which copy is corrupted, as the error messages just look like this:

  BTRFS warning (device dm-3): checksum verify failed on 30408704 wanted 0xcdcdcdcd found 0x3c0adc8e level 0
  BTRFS warning (device dm-3): checksum verify failed on 30408704 wanted 0xcdcdcdcd found 0x3c0adc8e level 0
  BTRFS warning (device dm-3): checksum verify failed on 30408704 wanted 0xcdcdcdcd found 0x3c0adc8e level 0
  BTRFS warning (device dm-3): checksum verify failed on 30408704 wanted 0xcdcdcdcd found 0x3c0adc8e level 0

We don't even know if the retry is caused by btrfs or the VFS retry.

To make things a little easier to read, add mirror number for all
related tree block read errors.

So the above messages would look like this:

  BTRFS warning (device dm-3): checksum verify failed on logical 30408704 mirror 1 wanted 0xcdcdcdcd found 0x3c0adc8e level 0
  BTRFS warning (device dm-3): checksum verify failed on logical 30408704 mirror 2 wanted 0xcdcdcdcd found 0x3c0adc8e level 0
  BTRFS warning (device dm-3): checksum verify failed on logical 30408704 mirror 1 wanted 0xcdcdcdcd found 0x3c0adc8e level 0
  BTRFS warning (device dm-3): checksum verify failed on logical 30408704 mirror 2 wanted 0xcdcdcdcd found 0x3c0adc8e level 0

Signed-off-by: Qu Wenruo <wqu@suse.com>
[ update messages, add "logical" ]
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index de440ebf5648..b9f335252113 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -256,8 +256,8 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		goto out;
 	}
 	btrfs_err_rl(eb->fs_info,
-		"parent transid verify failed on %llu wanted %llu found %llu",
-			eb->start,
+"parent transid verify failed on logical %llu mirror %u wanted %llu found %llu",
+			eb->start, eb->read_mirror,
 			parent_transid, btrfs_header_generation(eb));
 	ret = 1;
 	clear_extent_buffer_uptodate(eb);
@@ -587,21 +587,23 @@ static int validate_extent_buffer(struct extent_buffer *eb)
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != eb->start) {
-		btrfs_err_rl(fs_info, "bad tree block start, want %llu have %llu",
-			     eb->start, found_start);
+		btrfs_err_rl(fs_info,
+			"bad tree block start, mirror %u want %llu have %llu",
+			     eb->read_mirror, eb->start, found_start);
 		ret = -EIO;
 		goto out;
 	}
 	if (check_tree_block_fsid(eb)) {
-		btrfs_err_rl(fs_info, "bad fsid on block %llu",
-			     eb->start);
+		btrfs_err_rl(fs_info, "bad fsid on logical %llu mirror %u",
+			     eb->start, eb->read_mirror);
 		ret = -EIO;
 		goto out;
 	}
 	found_level = btrfs_header_level(eb);
 	if (found_level >= BTRFS_MAX_LEVEL) {
-		btrfs_err(fs_info, "bad tree block level %d on %llu",
-			  (int)btrfs_header_level(eb), eb->start);
+		btrfs_err(fs_info,
+			"bad tree block level, mirror %u level %d on logical %llu",
+			eb->read_mirror, btrfs_header_level(eb), eb->start);
 		ret = -EIO;
 		goto out;
 	}
@@ -612,8 +614,8 @@ static int validate_extent_buffer(struct extent_buffer *eb)
 
 	if (memcmp(result, header_csum, csum_size) != 0) {
 		btrfs_warn_rl(fs_info,
-	"checksum verify failed on %llu wanted " CSUM_FMT " found " CSUM_FMT " level %d",
-			      eb->start,
+"checksum verify failed on logical %llu mirror %u wanted " CSUM_FMT " found " CSUM_FMT " level %d",
+			      eb->start, eb->read_mirror,
 			      CSUM_FMT_VALUE(csum_size, header_csum),
 			      CSUM_FMT_VALUE(csum_size, result),
 			      btrfs_header_level(eb));
@@ -638,8 +640,8 @@ static int validate_extent_buffer(struct extent_buffer *eb)
 		set_extent_buffer_uptodate(eb);
 	else
 		btrfs_err(fs_info,
-			  "block=%llu read time tree block corruption detected",
-			  eb->start);
+		"read time tree block corruption detected on logical %llu mirror %u",
+			  eb->start, eb->read_mirror);
 out:
 	return ret;
 }
-- 
2.35.1

