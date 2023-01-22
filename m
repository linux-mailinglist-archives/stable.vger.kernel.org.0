Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F8C676E40
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjAVPIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjAVPIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:08:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7041C336
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:08:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6779B60C58
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD30C433D2;
        Sun, 22 Jan 2023 15:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400115;
        bh=wZzHjUoDUl7JxU7U7wO8gkbbtJfJzQPuQE4U2xUGOxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjEyeWNcCWQ4yCTJwTq2tNNu27+Tma2pdsKQLE1+BXTpIRsvys01udTB92rUqOZp1
         z2OnTzea98jqxN8Vs5TjkDrkTdZb7z4/DJT0mjYN+GlxHqWbgyvAlEcbGNtXVufBZW
         9rWlfWSPJL0PlllyeRIj7XGwXeynz32m3soXaD54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/37] Revert "ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline"
Date:   Sun, 22 Jan 2023 16:04:30 +0100
Message-Id: <20230122150220.936968056@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 1ed1eef0551bebee8e56973ccd0900e3578edfb7 which is
commit 131294c35ed6f777bd4e79d42af13b5c41bf2775 upstream.

Eric writes:
	I recommend not backporting this patch or the other three
	patches apparently intended to support it to 4.19 stable.  All
	these patches are related to ext4's bigalloc feature, which was
	experimental as of 4.19 (expressly noted by contemporary
	versions of e2fsprogs) and also suffered from a number of bugs.
	A significant number of additional patches that were applied to
	5.X kernels over time would have to be backported to 4.19 for
	the patch below to function correctly. It's really not worth
	doing that given bigalloc's experimental status as of 4.19 and
	the very rare combination of the bigalloc and inline features.

Link: https://lore.kernel.org/r/Y8mAe1SlcLD5fykg@debian-BULLSEYE-live-builder-AMD64
Cc: Eric Whitney <enwlinux@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5984,14 +5984,6 @@ int ext4_clu_mapped(struct inode *inode,
 	struct ext4_extent *extent;
 	ext4_lblk_t first_lblk, first_lclu, last_lclu;
 
-	/*
-	 * if data can be stored inline, the logical cluster isn't
-	 * mapped - no physical clusters have been allocated, and the
-	 * file has no extents
-	 */
-	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
-		return 0;
-
 	/* search for the extent closest to the first block in the cluster */
 	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
 	if (IS_ERR(path)) {


