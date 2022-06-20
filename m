Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C290551996
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244657AbiFTNFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244915AbiFTNEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61976186E1;
        Mon, 20 Jun 2022 05:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1931BB811A5;
        Mon, 20 Jun 2022 12:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7654AC3411B;
        Mon, 20 Jun 2022 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729956;
        bh=uff/LSoDCFORTp4ktTMN5owM8qbjZKsdjHY4n5fumQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyCyhiZbQEty+8KMZGDrawEnievsCHV6zNxGeUCZ7/oLAhsVbnyMBOqH0hfNLMoJ2
         ve7HhbEh+ZL61gphdAiUuAwkcPkypCyrTdYb581kP7+C9/5GivRHUwmcgsJlQS53Vp
         a+0lg+GZHq7PIwBmyu9ndzi8USklW/VwE+Iyu28w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.18 130/141] ext4: add reserved GDT blocks check
Date:   Mon, 20 Jun 2022 14:51:08 +0200
Message-Id: <20220620124733.399180590@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit b55c3cd102a6f48b90e61c44f7f3dda8c290c694 upstream.

We capture a NULL pointer issue when resizing a corrupt ext4 image which
is freshly clear resize_inode feature (not run e2fsck). It could be
simply reproduced by following steps. The problem is because of the
resize_inode feature was cleared, and it will convert the filesystem to
meta_bg mode in ext4_resize_fs(), but the es->s_reserved_gdt_blocks was
not reduced to zero, so could we mistakenly call reserve_backup_gdb()
and passing an uninitialized resize_inode to it when adding new group
descriptors.

 mkfs.ext4 /dev/sda 3G
 tune2fs -O ^resize_inode /dev/sda #forget to run requested e2fsck
 mount /dev/sda /mnt
 resize2fs /dev/sda 8G

 ========
 BUG: kernel NULL pointer dereference, address: 0000000000000028
 CPU: 19 PID: 3243 Comm: resize2fs Not tainted 5.18.0-rc7-00001-gfde086c5ebfd #748
 ...
 RIP: 0010:ext4_flex_group_add+0xe08/0x2570
 ...
 Call Trace:
  <TASK>
  ext4_resize_fs+0xbec/0x1660
  __ext4_ioctl+0x1749/0x24e0
  ext4_ioctl+0x12/0x20
  __x64_sys_ioctl+0xa6/0x110
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f2dd739617b
 ========

The fix is simple, add a check in ext4_resize_begin() to make sure that
the es->s_reserved_gdt_blocks is zero when the resize_inode feature is
disabled.

Cc: stable@kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220601092717.763694-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -54,6 +54,16 @@ int ext4_resize_begin(struct super_block
 		return -EPERM;
 
 	/*
+	 * If the reserved GDT blocks is non-zero, the resize_inode feature
+	 * should always be set.
+	 */
+	if (EXT4_SB(sb)->s_es->s_reserved_gdt_blocks &&
+	    !ext4_has_feature_resize_inode(sb)) {
+		ext4_error(sb, "resize_inode disabled but reserved GDT blocks non-zero");
+		return -EFSCORRUPTED;
+	}
+
+	/*
 	 * If we are not using the primary superblock/GDT copy don't resize,
          * because the user tools have no way of handling this.  Probably a
          * bad time to do it anyways.


