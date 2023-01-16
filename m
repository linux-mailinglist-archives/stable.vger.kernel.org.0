Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3587966C8EE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjAPQof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbjAPQoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:44:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532A73F289
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:31:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEF01B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF26C433F0;
        Mon, 16 Jan 2023 16:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886701;
        bh=5nMqm5iBN27AqVCsz8/sg+VHXebfJxb3aMo016ha5wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1eqAQGzo33UaWthc92cz9skkp8UDw/GO+a+ZOogEgIf48sVvIUzTkqj1Oar7dl7L
         W+gz00eQ4jNq9OqqoRm63v10HhW4ZuZ22VZhZimZB/+9GlDnIVfEOcJ+s4pn2v/lov
         xaoCVLZXdVMD60T6psoA5xL8eaB7O6ttZREJtmrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Jan Kara <jack@suse.cz>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 530/658] ext4: fix corruption when online resizing a 1K bigalloc fs
Date:   Mon, 16 Jan 2023 16:50:18 +0100
Message-Id: <20230116154933.807137511@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit 0aeaa2559d6d53358fca3e3fce73807367adca74 upstream.

When a backup superblock is updated in update_backups(), the primary
superblock's offset in the group (that is, sbi->s_sbh->b_blocknr) is used
as the backup superblock's offset in its group. However, when the block
size is 1K and bigalloc is enabled, the two offsets are not equal. This
causes the backup group descriptors to be overwritten by the superblock
in update_backups(). Moreover, if meta_bg is enabled, the file system will
be corrupted because this feature uses backup group descriptors.

To solve this issue, we use a more accurate ext4_group_first_block_no() as
the offset of the backup superblock in its group.

Fixes: d77147ff443b ("ext4: add support for online resizing with bigalloc")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221117040341.1380702-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1567,8 +1567,8 @@ exit_journal:
 		int meta_bg = ext4_has_feature_meta_bg(sb);
 		sector_t old_gdb = 0;
 
-		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
-			       sizeof(struct ext4_super_block), 0);
+		update_backups(sb, ext4_group_first_block_no(sb, 0),
+			       (char *)es, sizeof(struct ext4_super_block), 0);
 		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
 
@@ -1775,7 +1775,7 @@ errout:
 		if (test_opt(sb, DEBUG))
 			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
 			       "blocks\n", ext4_blocks_count(es));
-		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr,
+		update_backups(sb, ext4_group_first_block_no(sb, 0),
 			       (char *)es, sizeof(struct ext4_super_block), 0);
 	}
 	return err;


