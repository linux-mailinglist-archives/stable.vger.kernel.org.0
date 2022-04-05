Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D704F2604
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiDEHx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiDEHxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:53:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3558F17E07;
        Tue,  5 Apr 2022 00:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA14AB81B9C;
        Tue,  5 Apr 2022 07:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B570C3410F;
        Tue,  5 Apr 2022 07:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144929;
        bh=G/l9aUJULJwmI7YT0KaZ81Zov+Y/RRth+XG3A6aSc6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoUrM8No3cBZ62fFt2zZptQwP3H00hEZ+tlMEeYrbnPC4rlPsj5AT6RL9UlREtg9k
         sl67GEOST3mSoABRnoakc8cJhENNoe/FZfcre9hUyuYZG9q9bXzGAZUg81++B8t5aO
         9jPK+1X2rpYEgf3JFd/X3NnfiEWUav+P5zuXnJYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Anton Mitterer <calestyo@scientia.org>,
        David Sterba <dsterba@suse.com>, ree.com@vger.kernel.org
Subject: [PATCH 5.17 0178/1126] btrfs: verify the tranisd of the to-be-written dirty extent buffer
Date:   Tue,  5 Apr 2022 09:15:25 +0200
Message-Id: <20220405070412.828601574@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 3777369ff1518b579560611a0d0c33f930154f64 upstream.

[BUG]
There is a bug report that a bitflip in the transid part of an extent
buffer makes btrfs to reject certain tree blocks:

  BTRFS error (device dm-0): parent transid verify failed on 1382301696 wanted 262166 found 22

[CAUSE]
Note the failed transid check, hex(262166) = 0x40016, while
hex(22) = 0x16.

It's an obvious bitflip.

Furthermore, the reporter also confirmed the bitflip is from the
hardware, so it's a real hardware caused bitflip, and such problem can
not be detected by the existing tree-checker framework.

As tree-checker can only verify the content inside one tree block, while
generation of a tree block can only be verified against its parent.

So such problem remain undetected.

[FIX]
Although tree-checker can not verify it at write-time, we still have a
quick (but not the most accurate) way to catch such obvious corruption.

Function csum_one_extent_buffer() is called before we submit metadata
write.

Thus it means, all the extent buffer passed in should be dirty tree
blocks, and should be newer than last committed transaction.

Using that we can catch the above bitflip.

Although it's not a perfect solution, as if the corrupted generation is
higher than the correct value, we have no way to catch it at all.

Reported-by: Christoph Anton Mitterer <calestyo@scientia.org>
Link: https://lore.kernel.org/linux-btrfs/2dfcbc130c55cc6fd067b93752e90bd2b079baca.camel@scientia.org/
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Qu Wenruo <wqu@sus,ree.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -441,17 +441,31 @@ static int csum_one_extent_buffer(struct
 	else
 		ret = btrfs_check_leaf_full(eb);
 
-	if (ret < 0) {
-		btrfs_print_tree(eb, 0);
+	if (ret < 0)
+		goto error;
+
+	/*
+	 * Also check the generation, the eb reached here must be newer than
+	 * last committed. Or something seriously wrong happened.
+	 */
+	if (unlikely(btrfs_header_generation(eb) <= fs_info->last_trans_committed)) {
+		ret = -EUCLEAN;
 		btrfs_err(fs_info,
-			"block=%llu write time tree block corruption detected",
-			eb->start);
-		WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
-		return ret;
+			"block=%llu bad generation, have %llu expect > %llu",
+			  eb->start, btrfs_header_generation(eb),
+			  fs_info->last_trans_committed);
+		goto error;
 	}
 	write_extent_buffer(eb, result, 0, fs_info->csum_size);
 
 	return 0;
+
+error:
+	btrfs_print_tree(eb, 0);
+	btrfs_err(fs_info, "block=%llu write time tree block corruption detected",
+		  eb->start);
+	WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
+	return ret;
 }
 
 /* Checksum all dirty extent buffers in one bio_vec */


