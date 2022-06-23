Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADA25584CD
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbiFWRtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiFWRrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:47:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C52A14A5;
        Thu, 23 Jun 2022 10:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 181FEB824B7;
        Thu, 23 Jun 2022 17:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74067C3411B;
        Thu, 23 Jun 2022 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004254;
        bh=lmx12xyyH4sS1e3SCxv2MacjkNSxnGdVrtzoBmi1DsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjlHpKM/7Fwv6X2W2E6hLQFgyE/sGtkgnuIj5JLbAmfPOwaUCh7+TbgIYUXYTh4mH
         ytPPZsRfgNp7ks1Po3i0tJXQ+Refo6AjOXuAy6HA/CB4eUMTgGuwftVVtQLTygMcud
         a8YEQD1WBKK1ySIof8Rw7YfjBoOPmUI6/hrXhgY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 225/237] ext4: add reserved GDT blocks check
Date:   Thu, 23 Jun 2022 18:44:19 +0200
Message-Id: <20220623164349.625363991@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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
@@ -53,6 +53,16 @@ int ext4_resize_begin(struct super_block
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


