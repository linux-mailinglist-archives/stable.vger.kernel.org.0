Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199BA6CC950
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 19:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjC1RdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 13:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC1RdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 13:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085AFD310
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 10:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B3296177C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED243C4339B;
        Tue, 28 Mar 2023 17:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680024787;
        bh=4HwFt+u19oZDx6r8WlYLiMQmmYR06P41KH3Z/3WL0os=;
        h=From:To:Cc:Subject:Date:From;
        b=XxmXS8dRj4wc1QIFZd7x8YJF+4Ztz8IDuCGCRME9D0HoN+HBialYG+dZK5hfQ2Asp
         PZAfCnbEDMfuvV1azTYi+oYheRxD38LZ9shwDEzQlkXjJEh1QxBfHwjr/XRZas2G29
         6bERYq3ofM9Z5VvPOYIDzfqqq1A6kw3/gJZ7sorhfblEnq8vKOs0HCGjucnThYlea4
         Enx3GTudAxbxh2KMzWTdhnGCKnNNsz22XtdF9z8YbT6Nttdjpi33YWiAr4wUu3ij+e
         N+WAFYYpZYEowIzbjZD5j4OKKg7B/zr0KnlpU4CopyvFAVPX5xT7Kn2sQjXe6m7tHH
         /nOkiT2O0LTBQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     fsverity@lists.linux.dev, Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH 6.1,5.15] fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY
Date:   Tue, 28 Mar 2023 10:32:26 -0700
Message-Id: <20230328173226.65244-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit a075bacde257f755bea0e53400c9f1cdd1b8e8e6 upstream.
[Please apply to 6.1-stable and 5.15-stable.]

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
---
 fs/verity/enable.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index df6b499bf6a14..400c264bf8930 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -390,25 +390,27 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
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
-- 
2.40.0

