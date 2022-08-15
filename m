Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99EB594727
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiHOXYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353468AbiHOXWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:22:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EA65D138;
        Mon, 15 Aug 2022 13:05:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 726FDB80EB1;
        Mon, 15 Aug 2022 20:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEEFC433D7;
        Mon, 15 Aug 2022 20:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593923;
        bh=rfv18tYRRuE5kOUwwHi+YUZvKlCKY5Ad8oTOAlFiY/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gh6hIILyp/wi831+gcCwJuhPxI90blok2KbRAaXi9Y9wDFc5kxi/BJ57O9jPMB51X
         jsEz2W8u/a1G1zNM33Mih5gzwxlzPDDIa8JaMQCLGO+ZycIuJzQrL4Ghc4tnJLAt0y
         5OE4ie0hASZL3FD3JaGS1lHD0mb6Bes/BOVuWc4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1029/1095] btrfs: zoned: activate necessary block group
Date:   Mon, 15 Aug 2022 20:07:08 +0200
Message-Id: <20220815180511.621961976@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 88f59a2e4113..0c7fe3142d7c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2659,6 +2659,14 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
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
@@ -3853,6 +3861,14 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
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



