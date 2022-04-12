Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B7E4FCACE
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245544AbiDLA4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbiDLAzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:55:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9675815FCA;
        Mon, 11 Apr 2022 17:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C532B819B4;
        Tue, 12 Apr 2022 00:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D24AC385A3;
        Tue, 12 Apr 2022 00:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724552;
        bh=IE8kZKRy47IvvMkoGbDFPP2fqcW3TlmKejad7IWGKfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNkgRU1lZyHOiL9qlJAKOAyXJWrzJB1IO9P2qUTyg9cCj6JhF9+5Yu+bl14aTX08H
         8T/GfU0LMcZ+ZNWnaSNXppxmbn1MhRf74HEvX58bqHDxKIAs5gNFSyhyNRx73gdOVE
         Kpnscut2B16jd79X1bynxOwx5WRtfvdq9LFCfji+PHtH1yp3AaxptidxuZV9sRumbS
         ff/lQb+DGwRkUR6zSZ01pR0qweCrYbU5ZEpZ9MLzr/LRRYIVV/bLXRpCfUSYfnwG89
         O61G7H8dDFLzFe5WvKbl6OYEL7Gv+s9nBAK0oonZYPCqt52AszGqdRYJqTYlqZBdAT
         gT8/F6FOxYiYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/30] btrfs: do not warn for free space inode in cow_file_range
Date:   Mon, 11 Apr 2022 20:48:37 -0400
Message-Id: <20220412004906.350678-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 1d9262a35473..00eccbd25e5c 100644
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

