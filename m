Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E40B60AD0D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiJXORb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbiJXOP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:15:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87FD78214;
        Mon, 24 Oct 2022 05:55:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66EFA61278;
        Mon, 24 Oct 2022 12:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799A6C433C1;
        Mon, 24 Oct 2022 12:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616106;
        bh=dNCuxLTTNKFz5VDNGJB5PQxnQFbJ48RYQ3+HDlVGbtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPlRSBjyhXIot7ea5Q0oYoBQymIIOFmd/9TYKRcj2RbRzS4z4ttHXldnwHQ5X14k6
         BmiY4/3XQ+1y9BCnGBvC7bu56/a7hZ9ySRSCBNuSv0a4WvR0FBpE44NaoDC1jL5qrC
         BuP6oZ5JcUVwWqdH1ylcb4AcnHRX+pLB69TkDpqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0f2f7e65a3007d39539f@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 504/530] ext2: Use kvmalloc() for group descriptor array
Date:   Mon, 24 Oct 2022 13:34:08 +0200
Message-Id: <20221024113107.844012970@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index fd855574ef09..02d82f8fe85d 100644
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



