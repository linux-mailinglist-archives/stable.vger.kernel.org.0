Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0499E6BB332
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbjCOMmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbjCOMl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:41:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB67DA0B29
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E577EB81E17
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA25C433D2;
        Wed, 15 Mar 2023 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884044;
        bh=wzG/d1uqZsRC5ni15sAttM6C+zyO0wtwPZoI2vQ6e4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIDEA5YoXl13iL0lCRN6jrPdfVMq+Uv3+TI3N7W5IlP7RWsTImn3Ao4QjsvoCLX4S
         Gf6A+sg7rNyqCzaZ+7UBAsD45pUBBjXP+DGHV5fOkMXf3T9VSFbTZ5Cu4PSbNHrbXu
         jGUnOSsJwnZqJXBnsmG/jhUj2h1uPzhyr2B64HOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 085/141] btrfs: fix extent map logging bit not cleared for split maps after dropping range
Date:   Wed, 15 Mar 2023 13:13:08 +0100
Message-Id: <20230315115742.566634206@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit e4cc1483f35940c9288c332dd275f6fad485f8d2 ]

At btrfs_drop_extent_map_range() we are clearing the EXTENT_FLAG_LOGGING
bit on a 'flags' variable that was not initialized. This makes static
checkers complain about it, so initialize the 'flags' variable before
clearing the bit.

In practice this has no consequences, because EXTENT_FLAG_LOGGING should
not be set when btrfs_drop_extent_map_range() is called, as an fsync locks
the inode in exclusive mode, locks the inode's mmap semaphore in exclusive
mode too and it always flushes all delalloc.

Also add a comment about why we clear EXTENT_FLAG_LOGGING on a copy of the
flags of the split extent map.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/Y%2FyipSVozUDEZKow@kili/
Fixes: db21370bffbc ("btrfs: drop extent map range more efficiently")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index be94030e1dfbf..138afa955370b 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -763,7 +763,13 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 			goto next;
 		}
 
+		flags = em->flags;
 		clear_bit(EXTENT_FLAG_PINNED, &em->flags);
+		/*
+		 * In case we split the extent map, we want to preserve the
+		 * EXTENT_FLAG_LOGGING flag on our extent map, but we don't want
+		 * it on the new extent maps.
+		 */
 		clear_bit(EXTENT_FLAG_LOGGING, &flags);
 		modified = !list_empty(&em->list);
 
@@ -774,7 +780,6 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 		if (em->start >= start && em_end <= end)
 			goto remove_em;
 
-		flags = em->flags;
 		gen = em->generation;
 		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 
-- 
2.39.2



