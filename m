Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883E1594D2C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243809AbiHPA7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244068AbiHPAyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:54:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1246B7286;
        Mon, 15 Aug 2022 13:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7358B811A6;
        Mon, 15 Aug 2022 20:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFACC433C1;
        Mon, 15 Aug 2022 20:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596465;
        bh=0J+RU9t2EJdVMNMlvOZVwlYfDsPQl/hnucuwC90pG7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWGFB2u7jhnYKIK/SGS2apLUeHzYqWNGdEOmHH8BMc4PSnG6Zg6amUxPB2tGvMCTG
         jBWO3m2OYCJXq+BwZu0lDn0Lwe7VaUTTbUvsAm9YJYsnVYU1LMqzVh1lwDbeOlVeHd
         PBuQZBYAxOjbuzvI9di+KaiGJR6VoYkqqRF7KMFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1081/1157] btrfs: fix error handling of fallback uncompress write
Date:   Mon, 15 Aug 2022 20:07:17 +0200
Message-Id: <20220815180523.395924256@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 71aa147b4d9d81fa65afa6016f50d7818b64a54f ]

When cow_file_range() fails in the middle of the allocation loop, it
unlocks the pages but leaves the ordered extents intact. Thus, we need
to call btrfs_cleanup_ordered_extents() to finish the created ordered
extents.

Also, we need to call end_extent_writepage() if locked_page is available
because btrfs_cleanup_ordered_extents() never processes the region on
the locked_page.

Furthermore, we need to set the mapping as error if locked_page is
unavailable before unlocking the pages, so that the errno is properly
propagated to the user space.

CC: stable@vger.kernel.org # 5.18+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 52b2d1b48d2e..25872ee8594e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -927,8 +927,18 @@ static int submit_uncompressed_range(struct btrfs_inode *inode,
 		goto out;
 	}
 	if (ret < 0) {
-		if (locked_page)
+		btrfs_cleanup_ordered_extents(inode, locked_page, start, end - start + 1);
+		if (locked_page) {
+			const u64 page_start = page_offset(locked_page);
+			const u64 page_end = page_start + PAGE_SIZE - 1;
+
+			btrfs_page_set_error(inode->root->fs_info, locked_page,
+					     page_start, PAGE_SIZE);
+			set_page_writeback(locked_page);
+			end_page_writeback(locked_page);
+			end_extent_writepage(locked_page, ret, page_start, page_end);
 			unlock_page(locked_page);
+		}
 		goto out;
 	}
 
@@ -1377,9 +1387,12 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	 * However, in case of unlock == 0, we still need to unlock the pages
 	 * (except @locked_page) to ensure all the pages are unlocked.
 	 */
-	if (!unlock && orig_start < start)
+	if (!unlock && orig_start < start) {
+		if (!locked_page)
+			mapping_set_error(inode->vfs_inode.i_mapping, ret);
 		extent_clear_unlock_delalloc(inode, orig_start, start - 1,
 					     locked_page, 0, page_ops);
+	}
 
 	/*
 	 * For the range (2). If we reserved an extent for our delalloc range
-- 
2.35.1



