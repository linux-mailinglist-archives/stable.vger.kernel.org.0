Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF2D68961D
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbjBCKZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjBCKZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187DF5CD33
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:24:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B75CB82A69
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15AEC433D2;
        Fri,  3 Feb 2023 10:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419879;
        bh=D50oKx3n1eCGDmz5refqipGnKtd7W0OefKjfjzeW8EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fxpqlh0h5nHQ9LjB4B8Kwpw1IZWjkGzeF9liQzwJm10DUMKAhfk299bmYMrmWI3ex
         xYpbsS+5On2vnDvQtgkQw4pr6MxCygvT+pSulqMMDPRi5G8lsmMq3AYbWjV8EqBZ19
         R/mTNe/XYKjjCTkOsaX4x2XXScceWOJHjo4Lo02E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        stable@kernel.org, Theodore Tso <tytso@mit.edu>,
        Oleksandr Tymoshenko <ovt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/20] ext4: fix bad checksum after online resize
Date:   Fri,  3 Feb 2023 11:13:39 +0100
Message-Id: <20230203101008.530057770@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit a408f33e895e455f16cf964cb5cd4979b658db7b upstream.

When online resizing is performed twice consecutively, the error message
"Superblock checksum does not match superblock" is displayed for the
second time. Here's the reproducer:

	mkfs.ext4 -F /dev/sdb 100M
	mount /dev/sdb /tmp/test
	resize2fs /dev/sdb 5G
	resize2fs /dev/sdb 6G

To solve this issue, we moved the update of the checksum after the
es->s_overhead_clusters is updated.

Fixes: 026d0d27c488 ("ext4: reduce computation of overhead during resize")
Fixes: de394a86658f ("ext4: update s_overhead_clusters in the superblock during an on-line resize")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221117040341.1380702-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/resize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 405c68085055..589ed99856f3 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1445,8 +1445,6 @@ static void ext4_update_super(struct super_block *sb,
 	 * active. */
 	ext4_r_blocks_count_set(es, ext4_r_blocks_count(es) +
 				reserved_blocks);
-	ext4_superblock_csum_set(sb);
-	unlock_buffer(sbi->s_sbh);
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
@@ -1474,6 +1472,8 @@ static void ext4_update_super(struct super_block *sb,
 	ext4_calculate_overhead(sb);
 	es->s_overhead_clusters = cpu_to_le32(sbi->s_overhead);
 
+	ext4_superblock_csum_set(sb);
+	unlock_buffer(sbi->s_sbh);
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: added group %u:"
 		       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,
-- 
2.39.0



