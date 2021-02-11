Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F50319263
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 19:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBKSfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 13:35:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhBKSdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 13:33:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C88364E92;
        Thu, 11 Feb 2021 18:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068269;
        bh=hlk/iCkcVGg8yCpybnXwj8qJoF1gh5itR+WtLG/6Mao=;
        h=Date:From:To:Subject:From;
        b=c3HEGomYf2TWJysOyyPYcEHciYn6W+o88GuxCJbXyeQ9QP4286sIYVzq7XCob7oRs
         uU8KAfPSGL/Po2hPewVcDWZ/zeyQxCB0ZVBg3aUFkvkhHFyxz+QLID5Ps4j6aejCCQ
         aX4bG2zpY7RX89Smo760uRlHNMd6W8GZ/iS11bB4=
Date:   Thu, 11 Feb 2021 10:31:09 -0800
From:   akpm@linux-foundation.org
To:     joachim.henke@t-systems.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged] nilfs2-make-splice-write-available-again.patch
 removed from -mm tree
Message-ID: <20210211183109.CfZzts4Df%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: make splice write available again
has been removed from the -mm tree.  Its filename was
     nilfs2-make-splice-write-available-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joachim Henke <joachim.henke@t-systems.com>
Subject: nilfs2: make splice write available again

Since 5.10, splice() or sendfile() to NILFS2 return EINVAL.  This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write without
explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Link: https://lkml.kernel.org/r/1612784101-14353-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Joachim Henke <joachim.henke@t-systems.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/file.c~nilfs2-make-splice-write-available-again
+++ a/fs/nilfs2/file.c
@@ -141,6 +141,7 @@ const struct file_operations nilfs_file_
 	/* .release	= nilfs_release_file, */
 	.fsync		= nilfs_sync_file,
 	.splice_read	= generic_file_splice_read,
+	.splice_write   = iter_file_splice_write,
 };
 
 const struct inode_operations nilfs_file_inode_operations = {
_

Patches currently in -mm which might be from joachim.henke@t-systems.com are


