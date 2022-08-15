Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9FE592DFB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiHOLQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiHOLQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:16:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C6C1054A
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E33406113D
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80FEC433D6;
        Mon, 15 Aug 2022 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660562193;
        bh=JchuRs4PafLMap8w3i/osewUF15AjU99w690N6c955Y=;
        h=Subject:To:Cc:From:Date:From;
        b=vTLMGmx8SUjkbUF11tRi1rV/FD5gh912uKD7rMLmjWGlod9yVdrWXPdoe2XOIKDI5
         O24OaooDxoZ5MeCHy0xehFLNBDVmowLUFpI2n6Fl6rxnkjelcnringF+Y+gCLtLgFD
         /kzz5Gd7UgAK5la6KeBPmJhBGKANFXHk84xRyboY=
Subject: FAILED: patch "[PATCH] ext4: check if directory block is within i_size" failed to apply to 5.4-stable tree
To:     lczerner@redhat.com, adilger@dilger.ca, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:16:30 +0200
Message-ID: <166056219080145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 65f8ea4cd57dbd46ea13b41dc8bac03176b04233 Mon Sep 17 00:00:00 2001
From: Lukas Czerner <lczerner@redhat.com>
Date: Mon, 4 Jul 2022 16:27:20 +0200
Subject: [PATCH] ext4: check if directory block is within i_size

Currently ext4 directory handling code implicitly assumes that the
directory blocks are always within the i_size. In fact ext4_append()
will attempt to allocate next directory block based solely on i_size and
the i_size is then appropriately increased after a successful
allocation.

However, for this to work it requires i_size to be correct. If, for any
reason, the directory inode i_size is corrupted in a way that the
directory tree refers to a valid directory block past i_size, we could
end up corrupting parts of the directory tree structure by overwriting
already used directory blocks when modifying the directory.

Fix it by catching the corruption early in __ext4_read_dirblock().

Addresses Red-Hat-Bugzilla: #2070205
CVE: CVE-2022-1184
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20220704142721.157985-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1c6725ecca1a..7fced54e2891 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -110,6 +110,13 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	struct ext4_dir_entry *dirent;
 	int is_dx_block = 0;
 
+	if (block >= inode->i_size) {
+		ext4_error_inode(inode, func, line, block,
+		       "Attempting to read directory block (%u) that is past i_size (%llu)",
+		       block, inode->i_size);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	if (ext4_simulate_fail(inode->i_sb, EXT4_SIM_DIRBLOCK_EIO))
 		bh = ERR_PTR(-EIO);
 	else

