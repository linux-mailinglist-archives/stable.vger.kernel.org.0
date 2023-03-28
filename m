Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B6F6CBE32
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjC1L4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjC1Lzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 07:55:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D029386AA
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 04:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CA69616F1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 11:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60464C4339B;
        Tue, 28 Mar 2023 11:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680004550;
        bh=rprREI146PVclusUMngS3iAKgqWtSrmDu6hA0yPJcLA=;
        h=Subject:To:Cc:From:Date:From;
        b=LREoK0BuoAkYg1MPWGSQ0IxPSYHG05/vLIzBxY+X4yj1P0xq996YJdWnwL0/WV0Un
         ktbrQ3PXzGV94Vz5O/pyABbzLUssaSFT69xYMDJrelMJDCX7/whMxnMyPjjhSNo3Zf
         1jGhbDDMNlzoyVIc2n5NyA9+ez7jA3lhhINfwsq8=
Subject: FAILED: patch "[PATCH] fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY" failed to apply to 5.10-stable tree
To:     ebiggers@google.com, victorhsieh@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:55:47 +0200
Message-ID: <168000454721840@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x a075bacde257f755bea0e53400c9f1cdd1b8e8e6
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '168000454721840@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

a075bacde257 ("fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY")
ed45e2016493 ("fs-verity: rename "file measurement" to "file digest"")
9e90f30e7857 ("fs-verity: rename fsverity_signed_digest to fsverity_formatted_digest")
7bf765dd8442 ("fs-verity: remove filenames from file comments")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a075bacde257f755bea0e53400c9f1cdd1b8e8e6 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 14 Mar 2023 16:31:32 -0700
Subject: [PATCH] fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY

The full pagecache drop at the end of FS_IOC_ENABLE_VERITY is causing
performance problems and is hindering adoption of fsverity.  It was
intended to solve a race condition where unverified pages might be left
in the pagecache.  But actually it doesn't solve it fully.

Since the incomplete solution for this race condition has too much
performance impact for it to be worth it, let's remove it for now.

Fixes: 3fda4c617e84 ("fs-verity: implement FS_IOC_ENABLE_VERITY ioctl")
Cc: stable@vger.kernel.org
Reviewed-by: Victor Hsieh <victorhsieh@google.com>
Link: https://lore.kernel.org/r/20230314235332.50270-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index e13db6507b38..7a0e3a84d370 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -8,7 +8,6 @@
 #include "fsverity_private.h"
 
 #include <linux/mount.h>
-#include <linux/pagemap.h>
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
 
@@ -367,25 +366,27 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 		goto out_drop_write;
 
 	err = enable_verity(filp, &arg);
-	if (err)
-		goto out_allow_write_access;
 
 	/*
-	 * Some pages of the file may have been evicted from pagecache after
-	 * being used in the Merkle tree construction, then read into pagecache
-	 * again by another process reading from the file concurrently.  Since
-	 * these pages didn't undergo verification against the file digest which
-	 * fs-verity now claims to be enforcing, we have to wipe the pagecache
-	 * to ensure that all future reads are verified.
+	 * We no longer drop the inode's pagecache after enabling verity.  This
+	 * used to be done to try to avoid a race condition where pages could be
+	 * evicted after being used in the Merkle tree construction, then
+	 * re-instantiated by a concurrent read.  Such pages are unverified, and
+	 * the backing storage could have filled them with different content, so
+	 * they shouldn't be used to fulfill reads once verity is enabled.
+	 *
+	 * But, dropping the pagecache has a big performance impact, and it
+	 * doesn't fully solve the race condition anyway.  So for those reasons,
+	 * and also because this race condition isn't very important relatively
+	 * speaking (especially for small-ish files, where the chance of a page
+	 * being used, evicted, *and* re-instantiated all while enabling verity
+	 * is quite small), we no longer drop the inode's pagecache.
 	 */
-	filemap_write_and_wait(inode->i_mapping);
-	invalidate_inode_pages2(inode->i_mapping);
 
 	/*
 	 * allow_write_access() is needed to pair with deny_write_access().
 	 * Regardless, the filesystem won't allow writing to verity files.
 	 */
-out_allow_write_access:
 	allow_write_access(filp);
 out_drop_write:
 	mnt_drop_write_file(filp);

