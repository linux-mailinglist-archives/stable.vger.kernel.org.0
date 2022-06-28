Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAC255CBC5
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244507AbiF1C1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244347AbiF1CZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:25:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94375252A6;
        Mon, 27 Jun 2022 19:23:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D867B81C0A;
        Tue, 28 Jun 2022 02:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77C8C341CB;
        Tue, 28 Jun 2022 02:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383018;
        bh=zDGWP84UOtOm/F16kz2QOdVz4sqM/WTG/Zdro3Zs9qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMf3V70ZsJbSrkxk5uZx2irjayLNr8V2I9dqc7hERt6yZqVZeVKediIqtdqfKubss
         WgrFvwnu7BD3EwR9Mq6e/WAmzmxtAj+2BCAZVaGc5BxxdnyljlhGgDbZ6ABe7EuVRa
         hiCpA1jaSWZCZrETJcK2hw+vzx2fEg00E143Yqh8fzaBOeeG2eGlcB1Hcg0Z1NBQBV
         p9TLS35+4gk1i1etyqLaB1Q1miwE5xHfXmoDv2XUXiRqndbvppR+9eEiKe1H/LU1TI
         Y1cpTNsBJ95CH1Bmu2BcGk+tnhtf0HkH9NCwBww6CtWz4keu8mAil29UKyoVwxRh07
         DH5Tu/Wuam3fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, Boris Burkov <boris@bur.io>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/34] btrfs: do not BUG_ON() on failure to migrate space when replacing extents
Date:   Mon, 27 Jun 2022 22:22:27 -0400
Message-Id: <20220628022241.595835-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022241.595835-1-sashal@kernel.org>
References: <20220628022241.595835-1-sashal@kernel.org>
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
index 416a1b753ff6..b574143653e8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2651,7 +2651,8 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 
 	ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv, rsv,
 				      min_size, false);
-	BUG_ON(ret);
+	if (WARN_ON(ret))
+		goto out_trans;
 	trans->block_rsv = rsv;
 
 	cur_offset = start;
@@ -2743,7 +2744,8 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 
 		ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv,
 					      rsv, min_size, false);
-		BUG_ON(ret);	/* shouldn't happen */
+		if (WARN_ON(ret))
+			break;
 		trans->block_rsv = rsv;
 
 		if (!extent_info) {
-- 
2.35.1

