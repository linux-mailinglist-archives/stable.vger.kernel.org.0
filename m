Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE4E5FD01D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJMAYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiJMAXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9A5104D33;
        Wed, 12 Oct 2022 17:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 066B8B81CDB;
        Thu, 13 Oct 2022 00:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41C7C43142;
        Thu, 13 Oct 2022 00:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620448;
        bh=qhBcIWK4YyASSVFSasnTNu6sZGAsWOlT2wFZw+T9GGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6M1xFoPN7sS7WnrS/FQMBRtwrfd7u8vXieFDTDeZh8Ed78bduF7n124TUuGTrtqd
         RStk/OTBy3yAEaUGoaNy4mcaq758SJ1jc6fcbNbms7BdFcLGxHUFaWoJN//durdvAb
         gmzBhR1TYgp+rZnpnf2jQDVbi94ebhnQECfmGNJV2H3SmwzD2yJEZYfKG+Ag+aij6f
         Q/5oK3tzaJOmrHh00ywkLeepBY7WiP4miiE+mWTJSM9PMnz8oDY/ewQpH8jkFJ8kEU
         1+DoIRx8EOU3Eu30qJmCQzCRUveOdcPNkGiUmtp84K/sr2swZCWqVWjT1vrvILkxVD
         HfHXclsuy0Lyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+0f2f7e65a3007d39539f@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, jack@suse.com,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 49/63] ext2: Use kvmalloc() for group descriptor array
Date:   Wed, 12 Oct 2022 20:18:23 -0400
Message-Id: <20221013001842.1893243-49-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
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
index cdffa2a041af..f8c0abc5fcdd 100644
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
@@ -1081,7 +1081,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	db_count = (sbi->s_groups_count + EXT2_DESC_PER_BLOCK(sb) - 1) /
 		   EXT2_DESC_PER_BLOCK(sb);
-	sbi->s_group_desc = kmalloc_array(db_count,
+	sbi->s_group_desc = kvmalloc_array(db_count,
 					   sizeof(struct buffer_head *),
 					   GFP_KERNEL);
 	if (sbi->s_group_desc == NULL) {
@@ -1207,7 +1207,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
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

