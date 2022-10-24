Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3623C60A2EC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiJXLtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiJXLsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:48:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA9A10FEA;
        Mon, 24 Oct 2022 04:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7034BCE1346;
        Mon, 24 Oct 2022 11:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C44C433B5;
        Mon, 24 Oct 2022 11:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611715;
        bh=62cxHPxacIeJObyCUvpGDXSutCGffzA9SR9xi6Ab0Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hn06oHh5ktdp0XJf8WF4EnQ6zX9elWei8SRkJJW+GiwHhVZun8sV9qvfXDFNlSjUZ
         fGtZVEWE89pKwTrFh6jj67Tra2adfId+1GdhMg3GZLrvlPzKgU+aI29/WpdUnjqOYV
         A4eWc2X67s9XDgMaIi4dg3HQe9ELLFSedESkv7kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+b8c672b0e22615c80fe0@syzkaller.appspotmail.com,
        Khalid Masum <khalid.masum.92@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 054/159] nilfs2: fix use-after-free bug of struct nilfs_root
Date:   Mon, 24 Oct 2022 13:30:08 +0200
Message-Id: <20221024112951.405149610@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit d325dc6eb763c10f591c239550b8c7e5466a5d09 upstream.

If the beginning of the inode bitmap area is corrupted on disk, an inode
with the same inode number as the root inode can be allocated and fail
soon after.  In this case, the subsequent call to nilfs_clear_inode() on
that bogus root inode will wrongly decrement the reference counter of
struct nilfs_root, and this will erroneously free struct nilfs_root,
causing kernel oopses.

This fixes the problem by changing nilfs_new_inode() to skip reserved
inode numbers while repairing the inode bitmap.

Link: https://lkml.kernel.org/r/20221003150519.39789-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+b8c672b0e22615c80fe0@syzkaller.appspotmail.com
Reported-by: Khalid Masum <khalid.masum.92@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/inode.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -344,6 +344,7 @@ struct inode *nilfs_new_inode(struct ino
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
+	struct buffer_head *bh;
 	int err = -ENOMEM;
 	ino_t ino;
 
@@ -359,11 +360,26 @@ struct inode *nilfs_new_inode(struct ino
 	ii->i_state = BIT(NILFS_I_NEW);
 	ii->i_root = root;
 
-	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
+	err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
+	if (unlikely(ino < NILFS_USER_INO)) {
+		nilfs_msg(sb, KERN_WARNING,
+			  "inode bitmap is inconsistent for reserved inodes");
+		do {
+			brelse(bh);
+			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
+			if (unlikely(err))
+				goto failed_ifile_create_inode;
+		} while (ino < NILFS_USER_INO);
+
+		nilfs_msg(sb, KERN_INFO,
+			  "repaired inode bitmap for reserved inodes");
+	}
+	ii->i_bh = bh;
+
 	atomic64_inc(&root->inodes_count);
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = ino;


