Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B45204226
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 22:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgFVUt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 16:49:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbgFVUt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 16:49:27 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FFCF2075A;
        Mon, 22 Jun 2020 20:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592858966;
        bh=cJdwCLff7uoBvQqvEwe258p8eBytD64Va2IPg//oGio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KGkWeJoqNOdSoW7p+pofhsgGgQsGyw812R40OCYMyvFOigo9twTk8TMnsoy/Kj1xr
         fp/kUXycm2D2vado7MwnoGKoja/KMpQaZ5YcKdtC2WHc+e9VDLY/k9RusaWwKxyGXa
         xGJobsV1t94pwFXA4quXiZAo9lCqZQ3n+hMO8jcY=
Date:   Mon, 22 Jun 2020 16:49:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     tytso@mit.edu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ext4: avoid race conditions when
 remounting with options that" failed to apply to 5.7-stable tree
Message-ID: <20200622204925.GJ1931@sasha-vm>
References: <1592848256147238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592848256147238@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 07:50:56PM +0200, gregkh@linuxfoundation.org wrote:
>From 829b37b8cddb1db75c1b7905505b90e593b15db1 Mon Sep 17 00:00:00 2001
>From: Theodore Ts'o <tytso@mit.edu>
>Date: Wed, 10 Jun 2020 11:16:37 -0400
>Subject: [PATCH] ext4: avoid race conditions when remounting with options that
> change dax
>
>Trying to change dax mount options when remounting could allow mount
>options to be enabled for a small amount of time, and then the mount
>option change would be reverted.
>
>In the case of "mount -o remount,dax", this can cause a race where
>files would temporarily treated as DAX --- and then not.
>
>Cc: stable@kernel.org
>Reported-by: syzbot+bca9799bf129256190da@syzkaller.appspotmail.com
>Signed-off-by: Theodore Ts'o <tytso@mit.edu>

We didn't have the conversion of the DAX mount option to a tri-state back in
5.7 and older:

	9cb20f94afcd ("fs/ext4: Make DAX mount option a tri-state")
	a8ab6d3885ef ("fs/ext4: Update ext4_should_use_dax()")
	fc626fe322f1 ("fs/ext4: Change EXT4_MOUNT_DAX to EXT4_MOUNT_DAX_ALWAYS")

I think that something like this (untested) patch should work:

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d23afd6c909de..7318ca71b69eb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2080,6 +2080,16 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
  #endif
         } else if (token == Opt_dax) {
  #ifdef CONFIG_FS_DAX
+               if (is_remount && test_opt(sb, DAX)) {
+                       ext4_msg(sb, KERN_ERR, "can't mount with "
+                               "both data=journal and dax");
+                       return -1;
+               }
+               if (is_remount && !(sbi->s_mount_opt & EXT4_MOUNT_DAX)) {
+                       ext4_msg(sb, KERN_ERR, "can't change "
+                                       "dax mount option while remounting");
+                       return -1;
+               }
                 ext4_msg(sb, KERN_WARNING,
                 "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
                 sbi->s_mount_opt |= m->mount_opt;
@@ -5407,12 +5417,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
                         err = -EINVAL;
                         goto restore_opts;
                 }
-               if (test_opt(sb, DAX)) {
-                       ext4_msg(sb, KERN_ERR, "can't mount with "
-                                "both data=journal and dax");
-                       err = -EINVAL;
-                       goto restore_opts;
-               }
         } else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA) {
                 if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
                         ext4_msg(sb, KERN_ERR, "can't mount with "
@@ -5428,12 +5432,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
                 goto restore_opts;
         }
  
-       if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT4_MOUNT_DAX) {
-               ext4_msg(sb, KERN_WARNING, "warning: refusing change of "
-                       "dax flag with busy inodes while remounting");
-               sbi->s_mount_opt ^= EXT4_MOUNT_DAX;
-       }
-
         if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
                 ext4_abort(sb, EXT4_ERR_ESHUTDOWN, "Abort forced by user");
-- 
Thanks,
Sasha
