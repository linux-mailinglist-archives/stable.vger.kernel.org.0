Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4A55E156
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243999AbiF1CXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244026AbiF1CWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:22:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE489252A0;
        Mon, 27 Jun 2022 19:22:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A07EB81C16;
        Tue, 28 Jun 2022 02:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487BEC341CB;
        Tue, 28 Jun 2022 02:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382925;
        bh=kbRhszq9lP/uQKW/h4SWDMh1yaZZQ2Mth90fqXk601E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBQsQbndkp3Kg/YbDXBg1ABL6iaYMvU9Fdy6MPdhJaENavU1KvFrGOVQ2MuRmUhew
         VeklXF9/mAsFlY3WUbhlHLw5c0H6LYz1kdNe7FwVoH4/EvzwwthVawamXLeoLq2P86
         Ggec3yY0FN7Bjj62Qj1r0eU/DJ/ivte1nIP/nV2iEBELueXNyj5MGnYwT58IqHdr5X
         vdBuMZU/KbDvFJ0eyvTUQz0FV740OZApDKFKaxHKaX/FMoV2N29zRFJzQvE68f+hVI
         ByOp7V31vKYRjs8NkZVBz7n9Aw2VkjPXhtwUs/j2+AnW3/SGUP0slYVjRlYKBMZJZh
         UgcY9Db5pOy5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, Boris Burkov <boris@bur.io>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 25/41] btrfs: do not BUG_ON() on failure to migrate space when replacing extents
Date:   Mon, 27 Jun 2022 22:20:44 -0400
Message-Id: <20220628022100.595243-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 650c9caba32a0167a018cca0fab32a2965d23513 ]

At btrfs_replace_file_extents(), if we fail to migrate reserved metadata
space from the transaction block reserve into the local block reserve,
we trigger a BUG_ON(). This is because it should not be possible to have
a failure here, as we reserved more space when we started the transaction
than the space we want to migrate. However having a BUG_ON() is way too
drastic, we can perfectly handle the failure and return the error to the
caller. So just do that instead, and add a WARN_ON() to make it easier
to notice the failure if it ever happens (which is particularly useful
for fstests, and the warning will trigger a failure of a test case).

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 07ec05a810b4..a4849a7001e6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2745,7 +2745,8 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 
 	ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv, rsv,
 				      min_size, false);
-	BUG_ON(ret);
+	if (WARN_ON(ret))
+		goto out_trans;
 	trans->block_rsv = rsv;
 
 	cur_offset = start;
@@ -2864,7 +2865,8 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 
 		ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv,
 					      rsv, min_size, false);
-		BUG_ON(ret);	/* shouldn't happen */
+		if (WARN_ON(ret))
+			break;
 		trans->block_rsv = rsv;
 
 		cur_offset = drop_args.drop_end;
-- 
2.35.1

