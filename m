Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E9D65D990
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239853AbjADQ0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbjADQZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:25:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FCC1C136
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:25:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D294B81731
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A393FC433EF;
        Wed,  4 Jan 2023 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849537;
        bh=r9gpkwUQ4GAZnNuMWhHpqcOJjhZ41GYTe9WsgUmaTT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMXiFGRGucQhWQxf/qqc7EUju7D6BOLeN8IJvA0fGeIuAUXw1fMi5bYu8EzDqVD4/
         fSj6LJTha1YsNcZlV6nH1iabHJBiW5EzbRGA91H09MlNlKdqYeMM8r/s5bT3u+KL8u
         LsfZSbLVf/AkE4pv07a3bR7aKDnXmqTsGu44JCHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 6.0 138/177] ext4: add EXT4_IGET_BAD flag to prevent unexpected bad inode
Date:   Wed,  4 Jan 2023 17:07:09 +0100
Message-Id: <20230104160511.829741228@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -2964,7 +2964,8 @@ int do_journal_get_write_access(handle_t
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
@@ -5053,8 +5053,14 @@ struct inode *__ext4_iget(struct super_b
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
@@ -374,7 +374,8 @@ static long swap_inode_boot_loader(struc
 	blkcnt_t blocks;
 	unsigned short bytes;
 
-	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
+	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO,
+			EXT4_IGET_SPECIAL | EXT4_IGET_BAD);
 	if (IS_ERR(inode_bl))
 		return PTR_ERR(inode_bl);
 	ei_bl = EXT4_I(inode_bl);


