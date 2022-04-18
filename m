Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FC35053B5
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240726AbiDRNBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241237AbiDRM63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:58:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D061F615;
        Mon, 18 Apr 2022 05:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 892A5B80EDB;
        Mon, 18 Apr 2022 12:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4009C385A1;
        Mon, 18 Apr 2022 12:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285527;
        bh=6m8ulu5yeovjhGdSHv2UnzVM3/FBsEj8ZYy2VGUeLao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jo8o0TZs3wlXvkUm71dlrcfpBFSWzMHNFJZNGSudnwnTGZJYavxuA+zT91sOgNDVK
         sgprCtgHGs4X49VLAhO46JNZhXn4dtVRd8Kf9O7wzlVmxysCRLjGqaaaLF86e54No2
         i2rl8+y77+IYsCGG66ZUIUYWcQsNMmQT4dKj4g8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/105] btrfs: do not warn for free space inode in cow_file_range
Date:   Mon, 18 Apr 2022 14:12:46 +0200
Message-Id: <20220418121147.730198052@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a7d16d9a07bbcb7dcd5214a1bea75c808830bc0d ]

This is a long time leftover from when I originally added the free space
inode, the point was to catch cases where we weren't honoring the NOCOW
flag.  However there exists a race with relocation, if we allocate our
free space inode in a block group that is about to be relocated, we
could trigger the COW path before the relocation has the opportunity to
find the extents and delete the free space cache.  In production where
we have auto-relocation enabled we're seeing this WARN_ON_ONCE() around
5k times in a 2 week period, so not super common but enough that it's at
the top of our metrics.

We're properly handling the error here, and with us phasing out v1 space
cache anyway just drop the WARN_ON_ONCE.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f7f4ac01589b..4a5248097d7a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -995,7 +995,6 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	int ret = 0;
 
 	if (btrfs_is_free_space_inode(inode)) {
-		WARN_ON_ONCE(1);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.35.1



