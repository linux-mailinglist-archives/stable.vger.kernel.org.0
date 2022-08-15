Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DA059460D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347988AbiHOW2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348382AbiHOWZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:25:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D9D126952;
        Mon, 15 Aug 2022 12:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9DA9B80EAD;
        Mon, 15 Aug 2022 19:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12615C433C1;
        Mon, 15 Aug 2022 19:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592664;
        bh=CIV5OVk+czLEgtOy8HbR0wRahzxtme8/N3oniTZI5ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPRt1Yqu/cNa4XF1pqiAfEHrF79B+H1kTPuA+5sOPev95UMe/bRKrXaoaDaWG73JH
         1ZiU2oTYUdV7UJgL+C4f7u8tGctx3kQURWg7F6ibi1zSvfH5KNHMynonlN8jKC/vuS
         coescsu8AQ/jYVByHfGUEfLxWpSKB0eolrO1Da2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Lingfeng <lilingfeng3@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0823/1095] ext4: recover csum seed of tmp_inode after migrating to extents
Date:   Mon, 15 Aug 2022 20:03:42 +0200
Message-Id: <20220815180503.350168933@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit 07ea7a617d6b278fb7acedb5cbe1a81ce2de7d0c ]

When migrating to extents, the checksum seed of temporary inode
need to be replaced by inode's, otherwise the inode checksums
will be incorrect when swapping the inodes data.

However, the temporary inode can not match it's checksum to
itself since it has lost it's own checksum seed.

mkfs.ext4 -F /dev/sdc
mount /dev/sdc /mnt/sdc
xfs_io -fc "pwrite 4k 4k" -c "fsync" /mnt/sdc/testfile
chattr -e /mnt/sdc/testfile
chattr +e /mnt/sdc/testfile
umount /dev/sdc
fsck -fn /dev/sdc

========
...
Pass 1: Checking inodes, blocks, and sizes
Inode 13 passes checks, but checksum does not match inode.  Fix? no
...
========

The fix is simple, save the checksum seed of temporary inode, and
recover it after migrating to extents.

Fixes: e81c9302a6c3 ("ext4: set csum seed in tmp inode while migrating to extents")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220617062515.2113438-1-lilingfeng3@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/migrate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 7a5353a8cfd7..f2c4d9eee475 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -417,7 +417,7 @@ int ext4_ext_migrate(struct inode *inode)
 	struct inode *tmp_inode = NULL;
 	struct migrate_struct lb;
 	unsigned long max_entries;
-	__u32 goal;
+	__u32 goal, tmp_csum_seed;
 	uid_t owner[2];
 
 	/*
@@ -465,6 +465,7 @@ int ext4_ext_migrate(struct inode *inode)
 	 * the migration.
 	 */
 	ei = EXT4_I(inode);
+	tmp_csum_seed = EXT4_I(tmp_inode)->i_csum_seed;
 	EXT4_I(tmp_inode)->i_csum_seed = ei->i_csum_seed;
 	i_size_write(tmp_inode, i_size_read(inode));
 	/*
@@ -575,6 +576,7 @@ int ext4_ext_migrate(struct inode *inode)
 	 * the inode is not visible to user space.
 	 */
 	tmp_inode->i_blocks = 0;
+	EXT4_I(tmp_inode)->i_csum_seed = tmp_csum_seed;
 
 	/* Reset the extent details */
 	ext4_ext_tree_init(handle, tmp_inode);
-- 
2.35.1



