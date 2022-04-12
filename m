Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE5D4FC971
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242271AbiDLAqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241901AbiDLAqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:46:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2ED11A09;
        Mon, 11 Apr 2022 17:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B75FFB819C4;
        Tue, 12 Apr 2022 00:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93160C385A3;
        Tue, 12 Apr 2022 00:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724261;
        bh=P5EeSz5zXZBIBzwc6fodeVqt/66st5RIV/b+fNLsgSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0TubDknDvC47ldY/OjsScWLvcnYBHcQmwuESFADtODRR2ItElEJPYS+arKcdyJ+Y
         99JWLU6UUOyntFJZFDom4jBC+zzstcU47KKRvqjQ/NZBY60r5eP/LEGjz5JqWJpiqj
         vZZxknkilZINkBzxzDM4kTa2q6RS43azMlh4kVeZTSW3WfiTkAWiOq8jwOsI9nZsjc
         2x03SmPzJv/MpkNqu2G8neCAmmdegRscdM5E1WZsY4doSAVJU+gn73ZbHyXm+uryBB
         pAegNeEDpf71cfC8BuF5xdovfjvRD0OGlewJ22Yp2MxhLsrfZNiZplmp6uCXmM69lE
         8SriVq/eYk7zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 04/49] btrfs: do not warn for free space inode in cow_file_range
Date:   Mon, 11 Apr 2022 20:43:22 -0400
Message-Id: <20220412004411.349427-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
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
index 0f4408f9dadd..ffa2fde25f9c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1130,7 +1130,6 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	int ret = 0;
 
 	if (btrfs_is_free_space_inode(inode)) {
-		WARN_ON_ONCE(1);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.35.1

