Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCF437891A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237871AbhEJLZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237986AbhEJLQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6622C61376;
        Mon, 10 May 2021 11:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645112;
        bh=U34j+TrFogrOrDROvDuMaPEkYSRCDC3GOxwpZsUAbPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0aSi1tW5ji9F2jxIKKdjvvQdDrDA3VUqs7zD7zv/C9qsmlRthBdArwbMGVhwnduK
         1VYgVCS+RH2c010IaH+LVrK5w+ZTwpCDjACixk0oHCY3u3loFWB3DmLOvW0DOVO5/A
         lWakT/5EhCMLGtR9D+dHZT4T/mnvaUpQe1w0XV/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 340/384] ext4: always panic when errors=panic is specified
Date:   Mon, 10 May 2021 12:22:09 +0200
Message-Id: <20210510102025.987901117@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit ac2f7ca51b0929461ea49918f27c11b680f28995 upstream.

Before commit 014c9caa29d3 ("ext4: make ext4_abort() use
__ext4_error()"), the following series of commands would trigger a
panic:

1. mount /dev/sda -o ro,errors=panic test
2. mount /dev/sda -o remount,abort test

After commit 014c9caa29d3, remounting a file system using the test
mount option "abort" will no longer trigger a panic.  This commit will
restore the behaviour immediately before commit 014c9caa29d3.
(However, note that the Linux kernel's behavior has not been
consistent; some previous kernel versions, including 5.4 and 4.19
similarly did not panic after using the mount option "abort".)

This also makes a change to long-standing behaviour; namely, the
following series commands will now cause a panic, when previously it
did not:

1. mount /dev/sda -o ro,errors=panic test
2. echo test > /sys/fs/ext4/sda/trigger_fs_error

However, this makes ext4's behaviour much more consistent, so this is
a good thing.

Cc: stable@kernel.org
Fixes: 014c9caa29d3 ("ext4: make ext4_abort() use __ext4_error()")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20210401081903.3421208-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -667,9 +667,6 @@ static void ext4_handle_error(struct sup
 			ext4_commit_super(sb);
 	}
 
-	if (sb_rdonly(sb) || continue_fs)
-		return;
-
 	/*
 	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
 	 * could panic during 'reboot -f' as the underlying device got already
@@ -679,6 +676,10 @@ static void ext4_handle_error(struct sup
 		panic("EXT4-fs (device %s): panic forced after error\n",
 			sb->s_id);
 	}
+
+	if (sb_rdonly(sb) || continue_fs)
+		return;
+
 	ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 	/*
 	 * Make sure updated value of ->s_mount_flags will be visible before


