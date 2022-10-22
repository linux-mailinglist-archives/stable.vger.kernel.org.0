Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F036088F1
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiJVIZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiJVIYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:24:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA4F5D8AE;
        Sat, 22 Oct 2022 01:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F104F60B4A;
        Sat, 22 Oct 2022 07:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128F1C433D7;
        Sat, 22 Oct 2022 07:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425031;
        bh=L/44Vb6nN7qL+IsEuzLFOvfeDrQ8j949JtBFWbHdaDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzcsI8avuisrdwkN4UkgIikEyRXI3lCpFA/v+rM0LLRiTugd6VUppH7yqTGMCwlnZ
         CA1vgVa1E42Tz7gLZ7MS98IHZFUohLS8CUBaGWC9l/XONMy0FTiyStlGT4jlz7tKQM
         1MWCu6Z79LqDw63gkrWLLOvKH8kxwClKpzuKyFLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 367/717] ext4: dont run ext4lazyinit for read-only filesystems
Date:   Sat, 22 Oct 2022 09:24:06 +0200
Message-Id: <20221022072512.863837451@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index fd358e5f88ff..5cacd513d0df 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3953,9 +3953,9 @@ int ext4_register_li_request(struct super_block *sb,
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



