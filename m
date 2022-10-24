Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF460A5A3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbiJXM1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbiJXM1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:27:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF434855BE;
        Mon, 24 Oct 2022 05:01:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF486B81185;
        Mon, 24 Oct 2022 11:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4920BC433C1;
        Mon, 24 Oct 2022 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611896;
        bh=fV9OYAn4uPLUfTAI0RPNnM65cKXMaGX+Gz+hE0+4RBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcCFF40UpsWCeCK2pI5q8vYzvaeyAPefVLGOyjzTTgjcVQeUVNAhlS7LephTFKRtA
         o3DfM+zck4RalD0DycPE7Lp5CHcsOusOsMTQ7SpfRNojxJVCMFBqRxF7GbLx71neV2
         pxJy4zFgTAoreUaMIx+qivcnVB4Uwzk5tjMLS0xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 122/159] f2fs: fix race condition on setting FI_NO_EXTENT flag
Date:   Mon, 24 Oct 2022 13:31:16 +0200
Message-Id: <20221024112953.958322926@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 07725adc55c0a414c10acb5c8c86cea34b95ddef ]

The following scenarios exist.
process A:               process B:
->f2fs_drop_extent_tree  ->f2fs_update_extent_cache_range
                          ->f2fs_update_extent_tree_range
                           ->write_lock
 ->set_inode_flag
                           ->is_inode_flag_set
                           ->__free_extent_tree // Shouldn't
                                                // have been
                                                // cleaned up
                                                // here
  ->write_lock

In this case, the "FI_NO_EXTENT" flag is set between
f2fs_update_extent_tree_range and is_inode_flag_set
by other process. it leads to clearing the whole exten
tree which should not have happened. And we fix it by
move the setting it to the range of write_lock.

Fixes:5f281fab9b9a3 ("f2fs: disable extent_cache for fcollapse/finsert inodes")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/extent_cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index d7b8c8b5fc39..3f872145a988 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -650,9 +650,8 @@ void f2fs_drop_extent_tree(struct inode *inode)
 	if (!f2fs_may_extent_tree(inode))
 		return;
 
-	set_inode_flag(inode, FI_NO_EXTENT);
-
 	write_lock(&et->lock);
+	set_inode_flag(inode, FI_NO_EXTENT);
 	__free_extent_tree(sbi, et);
 	__drop_largest_extent(inode, 0, UINT_MAX);
 	write_unlock(&et->lock);
-- 
2.35.1



