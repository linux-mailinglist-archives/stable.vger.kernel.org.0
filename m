Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB507594DD5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244303AbiHPBAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344401AbiHPA4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:56:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEED17B83A;
        Mon, 15 Aug 2022 13:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A278BB8114A;
        Mon, 15 Aug 2022 20:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9D3C433D6;
        Mon, 15 Aug 2022 20:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596481;
        bh=vIGpQcAgld7A+4ecjA7VklllgQvBCtIXhrhWmWy5tT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TO1VOhKVK5aOlJui03VeL1s6xjyO76+Q3M+PeLk23FZmqe9Ntm91dB0OLm5z1lqmg
         1P8/NqVnpmV40cLQxhZh5WA63bvR7XboRweTk677MQ4WWh/16YA0DOpL44ePNFse2+
         QvNrDdqlSY7crdWt25HWP7AtXJT0a6Tl0Kf39xO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1094/1157] btrfs: zoned: activate necessary block group
Date:   Mon, 15 Aug 2022 20:07:30 +0200
Message-Id: <20220815180523.983097592@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit b6a98021e4019c562a23ad151a7e40adfa9f91e5 ]

There are two places where allocating a chunk is not enough. These two
places are trying to ensure the space by allocating a chunk. To meet the
condition for active_total_bytes, we also need to activate a block group
there.

CC: stable@vger.kernel.org # 5.16+
Fixes: afba2bc036b0 ("btrfs: zoned: implement active zone tracking")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 20c78ae7d150..5627b43d4cc2 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2665,6 +2665,14 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	ret = btrfs_chunk_alloc(trans, alloc_flags, CHUNK_ALLOC_FORCE);
 	if (ret < 0)
 		goto out;
+	/*
+	 * We have allocated a new chunk. We also need to activate that chunk to
+	 * grant metadata tickets for zoned filesystem.
+	 */
+	ret = btrfs_zoned_activate_one_bg(fs_info, cache->space_info, true);
+	if (ret < 0)
+		goto out;
+
 	ret = inc_block_group_ro(cache, 0);
 	if (ret == -ETXTBSY)
 		goto unlock_out;
@@ -3890,6 +3898,14 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 		if (IS_ERR(bg)) {
 			ret = PTR_ERR(bg);
 		} else {
+			/*
+			 * We have a new chunk. We also need to activate it for
+			 * zoned filesystem.
+			 */
+			ret = btrfs_zoned_activate_one_bg(fs_info, info, true);
+			if (ret < 0)
+				return;
+
 			/*
 			 * If we fail to add the chunk item here, we end up
 			 * trying again at phase 2 of chunk allocation, at
-- 
2.35.1



