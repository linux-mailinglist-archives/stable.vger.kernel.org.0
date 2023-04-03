Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490F66D4856
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbjDCO1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbjDCO1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:27:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF70B31986
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68EED61DBF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E77FC433D2;
        Mon,  3 Apr 2023 14:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532065;
        bh=47lRmrx7uCPZlxOezZwG7MoxG6/HATx7nbsYiwJ5PTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jubn1OSJetNIbzVSfmzuiLJNXycodrFlpSgzE6FtYOA3v0B9NDc9r0/5UijmcaCz1
         XRb7vpw4EYhdMobFdPNl3/FSXQgL6OP0n9YXad635waJ5jdr3pqRRSbZUN3abnh5Qk
         mg/9vd/mdO+fe/y6Sg8903yaHJ8aB/DNO3Irj9RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Victor Hsieh <victorhsieh@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/173] fsverity: dont drop pagecache at end of FS_IOC_ENABLE_VERITY
Date:   Mon,  3 Apr 2023 16:08:47 +0200
Message-Id: <20230403140418.063414707@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit a075bacde257f755bea0e53400c9f1cdd1b8e8e6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/verity/enable.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 734862e608fd3..5ceae66e1ae02 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -391,25 +391,27 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 		goto out_drop_write;
 
 	err = enable_verity(filp, &arg);
-	if (err)
-		goto out_allow_write_access;
 
 	/*
-	 * Some pages of the file may have been evicted from pagecache after
-	 * being used in the Merkle tree construction, then read into pagecache
-	 * again by another process reading from the file concurrently.  Since
-	 * these pages didn't undergo verification against the file measurement
-	 * which fs-verity now claims to be enforcing, we have to wipe the
-	 * pagecache to ensure that all future reads are verified.
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
2.39.2



