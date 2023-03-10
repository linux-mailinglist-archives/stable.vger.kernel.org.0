Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B514D6B4624
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbjCJOkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjCJOkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:40:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65041219EB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:40:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18051616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D83C4339C;
        Fri, 10 Mar 2023 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459229;
        bh=0WA3IHubj7aabl6dGo8czV/q1qGiMevt/BKsQnFKFwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmMZsEp5Q/3aQRsbgWexYrkVnBvGj2YOj7XmeET3rKSB2JbKeGouiITOccSGRDg9P
         5MrZKmGdvdUT1vOl+gJ1NvYTMTzrh0IQVgVTvYqhBqIzu4jRxCqhZDjGH4wd0nb+0M
         ouX2EydQ9J5MRquozSmOfN3xOnyvR1F2hEfMTP6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+2dacb8f015bf1420155f@syzkaller.appspotmail.com,
        stable@kernel.org, Jun Nie <jun.nie@linaro.org>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 250/357] ext4: optimize ea_inode block expansion
Date:   Fri, 10 Mar 2023 14:38:59 +0100
Message-Id: <20230310133745.792885515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Jun Nie <jun.nie@linaro.org>

commit 1e9d62d252812575ded7c620d8fc67c32ff06c16 upstream.

Copy ea data from inode entry when expanding ea block if possible.
Then remove the ea entry if expansion success. Thus memcpy to a
temporary buffer may be avoided.

If the expansion fails, we do not need to recovery the removed ea
entry neither in this way.

Reported-by: syzbot+2dacb8f015bf1420155f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=3613786cb88c93aa1c6a279b1df6a7b201347d08
Link: https://lore.kernel.org/r/20230103014517.495275-2-jun.nie@linaro.org
Cc: stable@kernel.org
Signed-off-by: Jun Nie <jun.nie@linaro.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2579,9 +2579,8 @@ static int ext4_xattr_move_to_block(hand
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
-	buffer = kvmalloc(value_size, GFP_NOFS);
 	b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
-	if (!is || !bs || !buffer || !b_entry_name) {
+	if (!is || !bs || !b_entry_name) {
 		error = -ENOMEM;
 		goto out;
 	}
@@ -2593,12 +2592,18 @@ static int ext4_xattr_move_to_block(hand
 
 	/* Save the entry name and the entry value */
 	if (entry->e_value_inum) {
+		buffer = kvmalloc(value_size, GFP_NOFS);
+		if (!buffer) {
+			error = -ENOMEM;
+			goto out;
+		}
+
 		error = ext4_xattr_inode_get(inode, entry, buffer, value_size);
 		if (error)
 			goto out;
 	} else {
 		size_t value_offs = le16_to_cpu(entry->e_value_offs);
-		memcpy(buffer, (void *)IFIRST(header) + value_offs, value_size);
+		buffer = (void *)IFIRST(header) + value_offs;
 	}
 
 	memcpy(b_entry_name, entry->e_name, entry->e_name_len);
@@ -2613,25 +2618,26 @@ static int ext4_xattr_move_to_block(hand
 	if (error)
 		goto out;
 
-	/* Remove the chosen entry from the inode */
-	error = ext4_xattr_ibody_set(handle, inode, &i, is);
-	if (error)
-		goto out;
-
 	i.value = buffer;
 	i.value_len = value_size;
 	error = ext4_xattr_block_find(inode, &i, bs);
 	if (error)
 		goto out;
 
-	/* Add entry which was removed from the inode into the block */
+	/* Move ea entry from the inode into the block */
 	error = ext4_xattr_block_set(handle, inode, &i, bs);
 	if (error)
 		goto out;
-	error = 0;
+
+	/* Remove the chosen entry from the inode */
+	i.value = NULL;
+	i.value_len = 0;
+	error = ext4_xattr_ibody_set(handle, inode, &i, is);
+
 out:
 	kfree(b_entry_name);
-	kvfree(buffer);
+	if (entry->e_value_inum && buffer)
+		kvfree(buffer);
 	if (is)
 		brelse(is->iloc.bh);
 	if (bs)


