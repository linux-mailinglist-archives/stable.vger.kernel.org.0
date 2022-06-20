Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE11F551E52
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbiFTODf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347722AbiFTN5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:57:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686A6377E1;
        Mon, 20 Jun 2022 06:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAD9C60EC7;
        Mon, 20 Jun 2022 13:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB97C3411B;
        Mon, 20 Jun 2022 13:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731352;
        bh=lmx12xyyH4sS1e3SCxv2MacjkNSxnGdVrtzoBmi1DsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiwyiDXXsygz2f5I8RVcySM6z4Of6lIyWmYe+79qgwN48ItdwgGtHFr1z0OsmZ7SG
         anlCIf7XkX9VvoDtC9c7FYoRYTs3tz/rU34UbWBrQKZ1w/nNouCqu24kvR5vlWPE26
         bkYSSiSIU6eWQQxrt2HgG1EvY68BZdNs4MSuabGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 230/240] ext4: add reserved GDT blocks check
Date:   Mon, 20 Jun 2022 14:52:11 +0200
Message-Id: <20220620124745.622329368@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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


