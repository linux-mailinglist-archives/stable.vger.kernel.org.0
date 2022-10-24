Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF91860BAE2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbiJXUlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiJXUku (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:40:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D2E5073C;
        Mon, 24 Oct 2022 11:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C7FFB819BE;
        Mon, 24 Oct 2022 12:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBFCC433C1;
        Mon, 24 Oct 2022 12:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615483;
        bh=rTECyuwnDRsfCecgHfMJhEbyMSE/f5if0+WnpjsNg1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5WVg3lJfdNJAupjWzXO/5PoPEkC5viMaiqZW8slCQlF2fHw2+GtALO+i9ScZzEH5
         O4UOHoTukkXoP3GQhxytqLj3x2Jz0o2YQhFrgdx6x8I1e6vuAEkFgQ+tXo5EuHt5oJ
         9uBz/e4lwR+wSWBbBBidXcOlYC7AnTRpTEmhgvxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/530] ext4: dont run ext4lazyinit for read-only filesystems
Date:   Mon, 24 Oct 2022 13:30:05 +0200
Message-Id: <20221024113056.873876510@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

[ Upstream commit 426d15ad11419066f7042ffa8fbf1b5c21a1ecbe ]

On a read-only filesystem, we won't invoke the block allocator, so we
don't need to prefetch the block bitmaps.

This avoids starting and running the ext4lazyinit thread at all on a
system with no read-write ext4 filesystems (for instance, a container VM
with read-only filesystems underneath an overlayfs).

Fixes: 21175ca434c5 ("ext4: make prefetch_block_bitmaps default")
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Link: https://lore.kernel.org/r/48b41da1498fcac3287e2e06b660680646c1c050.1659323972.git.josh@joshtriplett.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eec41990fa65..985d79fb6128 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3587,9 +3587,9 @@ int ext4_register_li_request(struct super_block *sb,
 		goto out;
 	}
 
-	if (test_opt(sb, NO_PREFETCH_BLOCK_BITMAPS) &&
-	    (first_not_zeroed == ngroups || sb_rdonly(sb) ||
-	     !test_opt(sb, INIT_INODE_TABLE)))
+	if (sb_rdonly(sb) ||
+	    (test_opt(sb, NO_PREFETCH_BLOCK_BITMAPS) &&
+	     (first_not_zeroed == ngroups || !test_opt(sb, INIT_INODE_TABLE))))
 		goto out;
 
 	elr = ext4_li_request_new(sb, first_not_zeroed);
-- 
2.35.1



