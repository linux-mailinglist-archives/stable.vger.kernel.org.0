Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F8A676E47
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjAVPIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjAVPIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:08:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF19C1F4BC
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:08:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5993060C5F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF0EC433D2;
        Sun, 22 Jan 2023 15:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400128;
        bh=ewHeviZSBgpKeVwNQlDBs6z57Vp9T3BtBhbT0QDBu5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpFQjRnCoLtBOLwlgTQVJkAYFYaAQ4KSL8wRFB+7tV9CyoaO7daWspMQRmkCeqEmN
         UNglmficEUZt0M7OaaxAQCSWYY7J3wRJRLw72uTmqoGm+ocrajACqFL2YeIbQqYoa9
         4asKEveF6LQ3ktnMtS+FjTQteURv/to/70dLI9T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/55] f2fs: lets avoid panic if extent_tree is not created
Date:   Sun, 22 Jan 2023 16:03:52 +0100
Message-Id: <20230122150222.471859853@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit df9d44b645b83fffccfb4e28c1f93376585fdec8 ]

This patch avoids the below panic.

pc : __lookup_extent_tree+0xd8/0x760
lr : f2fs_do_write_data_page+0x104/0x87c
sp : ffffffc010cbb3c0
x29: ffffffc010cbb3e0 x28: 0000000000000000
x27: ffffff8803e7f020 x26: ffffff8803e7ed40
x25: ffffff8803e7f020 x24: ffffffc010cbb460
x23: ffffffc010cbb480 x22: 0000000000000000
x21: 0000000000000000 x20: ffffffff22e90900
x19: 0000000000000000 x18: ffffffc010c5d080
x17: 0000000000000000 x16: 0000000000000020
x15: ffffffdb1acdbb88 x14: ffffff888759e2b0
x13: 0000000000000000 x12: ffffff802da49000
x11: 000000000a001200 x10: ffffff8803e7ed40
x9 : ffffff8023195800 x8 : ffffff802da49078
x7 : 0000000000000001 x6 : 0000000000000000
x5 : 0000000000000006 x4 : ffffffc010cbba28
x3 : 0000000000000000 x2 : ffffffc010cbb480
x1 : 0000000000000000 x0 : ffffff8803e7ed40
Call trace:
 __lookup_extent_tree+0xd8/0x760
 f2fs_do_write_data_page+0x104/0x87c
 f2fs_write_single_data_page+0x420/0xb60
 f2fs_write_cache_pages+0x418/0xb1c
 __f2fs_write_data_pages+0x428/0x58c
 f2fs_write_data_pages+0x30/0x40
 do_writepages+0x88/0x190
 __writeback_single_inode+0x48/0x448
 writeback_sb_inodes+0x468/0x9e8
 __writeback_inodes_wb+0xb8/0x2a4
 wb_writeback+0x33c/0x740
 wb_do_writeback+0x2b4/0x400
 wb_workfn+0xe4/0x34c
 process_one_work+0x24c/0x5bc
 worker_thread+0x3e8/0xa50
 kthread+0x150/0x1b4

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/extent_cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 05b17a741ccc..dd53c9294ad9 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -381,7 +381,8 @@ static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
 	struct extent_node *en;
 	bool ret = false;
 
-	f2fs_bug_on(sbi, !et);
+	if (!et)
+		return false;
 
 	trace_f2fs_lookup_extent_tree_start(inode, pgofs);
 
-- 
2.35.1



