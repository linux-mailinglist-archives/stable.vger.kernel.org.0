Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A5E66C8E8
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbjAPQoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbjAPQnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:43:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB0539BA8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:31:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 786546106E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFB9C433EF;
        Mon, 16 Jan 2023 16:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886685;
        bh=xOvi7aIxPjKXJsKEx5kQQgW2dp3oENq6smwAh6Mly+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DTvesiQVzY/bJdyYAyPpSOAov5icjWjtZ2d1a+CDrdK9bUqto3Z+gnkOoBuCgx90
         3Fw2PmwUyYcaDRLMHmOcYt38LOKlLHlGVCI8Uo7WIObIKGHQ8rh700EGZdUI5aZ1Je
         hA80eVW6LGZIJ+bjlkGAoCiBa/E0zbwHgP/Fxf5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.4 524/658] ext4: add EXT4_IGET_BAD flag to prevent unexpected bad inode
Date:   Mon, 16 Jan 2023 16:50:12 +0100
Message-Id: <20230116154933.511427664@linuxfoundation.org>
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

commit 63b1e9bccb71fe7d7e3ddc9877dbdc85e5d2d023 upstream.

There are many places that will get unhappy (and crash) when ext4_iget()
returns a bad inode. However, if iget the boot loader inode, allows a bad
inode to be returned, because the inode may not be initialized. This
mechanism can be used to bypass some checks and cause panic. To solve this
problem, we add a special iget flag EXT4_IGET_BAD. Only with this flag
we'd be returning bad inode from ext4_iget(), otherwise we always return
the error code if the inode is bad inode.(suggested by Jan Kara)

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221026042310.3839669-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    3 ++-
 fs/ext4/inode.c |    8 +++++++-
 fs/ext4/ioctl.c |    3 ++-
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2608,7 +2608,8 @@ int do_journal_get_write_access(handle_t
 typedef enum {
 	EXT4_IGET_NORMAL =	0,
 	EXT4_IGET_SPECIAL =	0x0001, /* OK to iget a system inode */
-	EXT4_IGET_HANDLE = 	0x0002	/* Inode # is from a handle */
+	EXT4_IGET_HANDLE = 	0x0002,	/* Inode # is from a handle */
+	EXT4_IGET_BAD =		0x0004  /* Allow to iget a bad inode */
 } ext4_iget_flags;
 
 extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5192,8 +5192,14 @@ struct inode *__ext4_iget(struct super_b
 	if (IS_CASEFOLDED(inode) && !ext4_has_feature_casefold(inode->i_sb))
 		ext4_error_inode(inode, function, line, 0,
 				 "casefold flag without casefold feature");
-	brelse(iloc.bh);
+	if (is_bad_inode(inode) && !(flags & EXT4_IGET_BAD)) {
+		ext4_error_inode(inode, function, line, 0,
+				 "bad inode without EXT4_IGET_BAD flag");
+		ret = -EUCLEAN;
+		goto bad_inode;
+	}
 
+	brelse(iloc.bh);
 	unlock_new_inode(inode);
 	return inode;
 
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -121,7 +121,8 @@ static long swap_inode_boot_loader(struc
 	blkcnt_t blocks;
 	unsigned short bytes;
 
-	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
+	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO,
+			EXT4_IGET_SPECIAL | EXT4_IGET_BAD);
 	if (IS_ERR(inode_bl))
 		return PTR_ERR(inode_bl);
 	ei_bl = EXT4_I(inode_bl);


