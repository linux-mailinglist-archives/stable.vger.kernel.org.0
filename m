Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6B260A3CE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbiJXMA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbiJXL7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B86E7C333;
        Mon, 24 Oct 2022 04:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ADBD61252;
        Mon, 24 Oct 2022 11:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C542C433D6;
        Mon, 24 Oct 2022 11:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612094;
        bh=5bSnUp5dX34XQ99c1SQZmiSSKHcGvqw4nlmJQKpbDSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ChASDfRQ3cezodCy6I3Y1VplWqK6hy+HSvbBzRNC3YoXKMQQyjNhuXCNHTAAzUOF5
         lWbawIDtpu1GL79xj+UPa8zmzNX2O7sY6/7NXloK1nTg/tgG4tYkrddsOaVQlhWo9m
         C1s+l/qsCthU1MUzNXhWVGPDJH7bg63o/qmsb+QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+2b32eb36c1a825b7a74c@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 036/210] nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
Date:   Mon, 24 Oct 2022 13:29:13 +0200
Message-Id: <20221024112958.154110294@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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

commit 21a87d88c2253350e115029f14fe2a10a7e6c856 upstream.

If the i_mode field in inode of metadata files is corrupted on disk, it
can cause the initialization of bmap structure, which should have been
called from nilfs_read_inode_common(), not to be called.  This causes a
lockdep warning followed by a NULL pointer dereference at
nilfs_bmap_lookup_at_level().

This patch fixes these issues by adding a missing sanitiy check for the
i_mode field of metadata file's inode.

Link: https://lkml.kernel.org/r/20221002030804.29978-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+2b32eb36c1a825b7a74c@syzkaller.appspotmail.com
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -455,6 +455,8 @@ int nilfs_read_inode_common(struct inode
 	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
+		return -EIO; /* this inode is for metadata and corrupted */
 	if (inode->i_nlink == 0)
 		return -ESTALE; /* this inode is deleted */
 


