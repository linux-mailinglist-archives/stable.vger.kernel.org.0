Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461AA5FCFCC
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiJMAWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiJMAVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:21:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E020012347E;
        Wed, 12 Oct 2022 17:18:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACE98B81C48;
        Thu, 13 Oct 2022 00:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D03C433C1;
        Thu, 13 Oct 2022 00:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620281;
        bh=ktBfXEsDFFOjWhVbQ1V3G/ayXo1lLohKY9Q2vTWa4Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OErLJN7uDV4slBNLef7IxLGa78pbBVWy33Ruvp4B4SzKvTinE0u7DGVtEqA2AGRmK
         wpkI2hehzXnDJ8h9oLmb9n4n2Xb6+HcjB2G2G7/vHVZgnZKOx9ezmDeUqc4LYlOHMF
         sr/+Blr9usXQMzUo1raYTHGKTR+QvwAt/8P8MRvYA5A6RzWbVZ4hLX9r+6cDYcZy2Y
         iD6Nlz9OCyWxdtH7+3cnnmKTfXs+TDFWy7tAJjooEGqBQ3bU8YhP6bCFUpmqeEryAl
         QVlJY8Pde2qoTzAmhFO3yXFPnsJlaaBbomxeEyqea6/KnjZK/Gy4G69LcmjL1/F/hP
         WgKhziPW0hXSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+0f2f7e65a3007d39539f@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, jack@suse.com,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 51/67] ext2: Use kvmalloc() for group descriptor array
Date:   Wed, 12 Oct 2022 20:15:32 -0400
Message-Id: <20221013001554.1892206-51-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit e7c7fbb9a8574ebd89cc05db49d806c7476863ad ]

Array of group descriptor block buffers can get rather large. In theory
in can reach 1MB for perfectly valid filesystem and even more for
maliciously crafted ones. Use kvmalloc() to allocate the array to avoid
straining memory allocator with large order allocations unnecessarily.

Reported-by: syzbot+0f2f7e65a3007d39539f@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 252c742379cf..98348357a356 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -163,7 +163,7 @@ static void ext2_put_super (struct super_block * sb)
 	db_count = sbi->s_gdb_count;
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
-	kfree(sbi->s_group_desc);
+	kvfree(sbi->s_group_desc);
 	kfree(sbi->s_debts);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
@@ -1080,7 +1080,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	db_count = (sbi->s_groups_count + EXT2_DESC_PER_BLOCK(sb) - 1) /
 		   EXT2_DESC_PER_BLOCK(sb);
-	sbi->s_group_desc = kmalloc_array(db_count,
+	sbi->s_group_desc = kvmalloc_array(db_count,
 					   sizeof(struct buffer_head *),
 					   GFP_KERNEL);
 	if (sbi->s_group_desc == NULL) {
@@ -1206,7 +1206,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
 failed_mount_group_desc:
-	kfree(sbi->s_group_desc);
+	kvfree(sbi->s_group_desc);
 	kfree(sbi->s_debts);
 failed_mount:
 	brelse(bh);
-- 
2.35.1

