Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846C36BA3C8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 00:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCNXzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 19:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjCNXzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 19:55:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5086031E25;
        Tue, 14 Mar 2023 16:55:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E6FDB81A58;
        Tue, 14 Mar 2023 23:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8251C433EF;
        Tue, 14 Mar 2023 23:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678838102;
        bh=sK41F8mfq0X+DO7fQqzz02ceVWx9O4ku4cQdMPCKO7A=;
        h=From:To:Cc:Subject:Date:From;
        b=avvY7suVO7a+acydZ8aA2pOmMdTo6L8QWU4zdHCbBTNNYAgKTp1pOEmiISuElvHvO
         dCXb6p9u7Hk/8EZXcx4fMTRDTb1cqw1ZEy5K7fm+fsZ/Unsp0VGiYYft/PR35x/aNx
         1vWHLATypK4xooppqbFmWAKSOGOB9fiHoQqAuPz7lbAwvkdwoZABSRvTWvC28F7nvU
         8rKz/7l3cTgQmZ3htfXJjUbA8E/ijOJQ6SZCQ5UJZ6cNqlUMprGmYQQBUUYXStjhIU
         MVMSnM5HEyCGvxd+K5431oGPwcDoj2lePol/98LQ6O+MLluMSUW6/k1Ck//kcywbAt
         lnzA2vvtvRWFg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fsverity@lists.linux.dev
Cc:     linux-fsdevel@vger.kernel.org,
        Victor Hsieh <victorhsieh@google.com>, stable@vger.kernel.org
Subject: [PATCH] fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY
Date:   Tue, 14 Mar 2023 16:53:32 -0700
Message-Id: <20230314235332.50270-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The full pagecache drop at the end of FS_IOC_ENABLE_VERITY is causing
performance problems and is hindering adoption of fsverity.  It was
intended to solve a race condition where unverified pages might be left
in the pagecache.  But actually it doesn't solve it fully.

Since the incomplete solution for this race condition has too much
performance impact for it to be worth it, let's remove it for now.

Fixes: 3fda4c617e84 ("fs-verity: implement FS_IOC_ENABLE_VERITY ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/enable.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index e13db6507b38b..7a0e3a84d370b 100644
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

base-commit: f959325e6ac3f499450088b8d9c626d1177be160
-- 
2.39.2

