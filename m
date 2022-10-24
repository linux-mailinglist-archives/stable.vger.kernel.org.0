Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED9960AB15
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiJXNpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbiJXNoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:44:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B006402E1;
        Mon, 24 Oct 2022 05:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29CE46133A;
        Mon, 24 Oct 2022 12:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C698C433C1;
        Mon, 24 Oct 2022 12:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615122;
        bh=AFa8a5sesGuSJSKsd2zWmTwOICUaEhIgr5X8brAl8u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BH+DDR5lAh8vNIlJJJPzuZgQ2lDUh3L55aDZbSBBy6JcydwKhM9cpjN74tZS9bjI1
         FDIu1C0R3jFVz4V5K4/nMNXWnJeiQQiIJSLFQnC9Km3EgapL/JQv4aE4OTph5bZPk5
         7p/OAKkXPuz1rYMMeGMgNy7/MkgsrMCjY5mL1s5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 100/530] ext4: fix miss release buffer head in ext4_fc_write_inode
Date:   Mon, 24 Oct 2022 13:27:24 +0200
Message-Id: <20221024113049.536381634@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit ccbf8eeb39f2ff00b54726a2b20b35d788c4ecb5 upstream.

In 'ext4_fc_write_inode' function first call 'ext4_get_inode_loc' get 'iloc',
after use it miss release 'iloc.bh'.
So just release 'iloc.bh' before 'ext4_fc_write_inode' return.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220914100859.1415196-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -794,22 +794,25 @@ static int ext4_fc_write_inode(struct in
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_INODE);
 	tl.fc_len = cpu_to_le16(inode_len + sizeof(fc_inode.fc_ino));
 
+	ret = -ECANCELED;
 	dst = ext4_fc_reserve_space(inode->i_sb,
 			sizeof(tl) + inode_len + sizeof(fc_inode.fc_ino), crc);
 	if (!dst)
-		return -ECANCELED;
+		goto err;
 
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, sizeof(tl), crc))
-		return -ECANCELED;
+		goto err;
 	dst += sizeof(tl);
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &fc_inode, sizeof(fc_inode), crc))
-		return -ECANCELED;
+		goto err;
 	dst += sizeof(fc_inode);
 	if (!ext4_fc_memcpy(inode->i_sb, dst, (u8 *)ext4_raw_inode(&iloc),
 					inode_len, crc))
-		return -ECANCELED;
-
-	return 0;
+		goto err;
+	ret = 0;
+err:
+	brelse(iloc.bh);
+	return ret;
 }
 
 /*


