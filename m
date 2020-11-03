Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FE52A57D7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbgKCVqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:46:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732084AbgKCUwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7B182053B;
        Tue,  3 Nov 2020 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436743;
        bh=mYP6hsVgr30qs75UEcald8x2OWbI/jHV+A2dSbiRPD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXWar/zLercpC3b0kXKUD89b79TPYMVSuBD5X+SBmUDOgnTAqc8cahiNgk2Syz0ao
         1lTYEnwswumAWGlZYXInvkpVn9AyY3yA+J/LZJuF6+Tc1PtkU3yrKdVWsMFJuoDSm3
         e+y2sTLHe0YXh+JRjm5l7SqXDVjl3U3FL4Hkf0tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.9 346/391] ext4: fix bdev write error check failed when mount fs with ro
Date:   Tue,  3 Nov 2020 21:36:37 +0100
Message-Id: <20201103203410.483682406@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 9704a322ea67fdb05fc66cf431fdd01c2424bbd9 upstream.

Consider a situation when a filesystem was uncleanly shutdown and the
orphan list is not empty and a read-only mount is attempted. The orphan
list cleanup during mount will fail with:

ext4_check_bdev_write_error:193: comm mount: Error while async write back metadata

This happens because sbi->s_bdev_wb_err is not initialized when mounting
the filesystem in read only mode and so ext4_check_bdev_write_error()
falsely triggers.

Initialize sbi->s_bdev_wb_err unconditionally to avoid this problem.

Fixes: bc71726c7257 ("ext4: abort the filesystem if failed to async write metadata buffer")
Cc: stable@kernel.org
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200928020556.710971-1-zhangxiaoxu5@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4826,9 +4826,8 @@ no_journal:
 	 * used to detect the metadata async write error.
 	 */
 	spin_lock_init(&sbi->s_bdev_wb_lock);
-	if (!sb_rdonly(sb))
-		errseq_check_and_advance(&sb->s_bdev->bd_inode->i_mapping->wb_err,
-					 &sbi->s_bdev_wb_err);
+	errseq_check_and_advance(&sb->s_bdev->bd_inode->i_mapping->wb_err,
+				 &sbi->s_bdev_wb_err);
 	sb->s_bdev->bd_super = sb;
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
@@ -5721,14 +5720,6 @@ static int ext4_remount(struct super_blo
 			}
 
 			/*
-			 * Update the original bdev mapping's wb_err value
-			 * which could be used to detect the metadata async
-			 * write error.
-			 */
-			errseq_check_and_advance(&sb->s_bdev->bd_inode->i_mapping->wb_err,
-						 &sbi->s_bdev_wb_err);
-
-			/*
 			 * Mounting a RDONLY partition read-write, so reread
 			 * and store the current valid flag.  (It may have
 			 * been changed by e2fsck since we originally mounted


