Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2E955E123
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243528AbiF1CVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243527AbiF1CUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BBC237EA;
        Mon, 27 Jun 2022 19:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AF10B81C00;
        Tue, 28 Jun 2022 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EACC341CA;
        Tue, 28 Jun 2022 02:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382818;
        bh=rQbr0p8ibDG2RJqUkebf/y2+gBR6dvXAokFv2zNDk8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2X8fggri35Keq2zn+DdU7CmYd7sho1393zYF9ePw/7PO+g+5ttLW9WoY+6VnI/OX
         Odzmjc0sjm4FVdc8kh7AitEbQi1dqEnG8eTICLVIz/lDX1xlFfAlkXg2WbENVrS4ad
         7jCdfNSDnrptX3nbeeYObyeNbZM5YWt3oU+cJRYXup7VjMTduOPVEyZNSJWfbfPk+t
         JGaLXKr6Pf0A0QW6hOO/dTkWJPJDG5Y4HITXtwlva+xT/pgEnfRXvDgOCSi1B4N82Z
         xBxYEKaLPssjk3MD5K70V/4C/8dFZyavF9iXnXy1YSiWPckCFF0kPEDRbbRK/wjOoT
         FqjFCNW9Ag7/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, Boris Burkov <boris@bur.io>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 36/53] btrfs: do not BUG_ON() on failure to migrate space when replacing extents
Date:   Mon, 27 Jun 2022 22:18:22 -0400
Message-Id: <20220628021839.594423-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
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
index ab882ddfb0e8..7db4f08bd8f9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2766,7 +2766,8 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 
 	ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv, rsv,
 				      min_size, false);
-	BUG_ON(ret);
+	if (WARN_ON(ret))
+		goto out_trans;
 	trans->block_rsv = rsv;
 
 	cur_offset = start;
@@ -2885,7 +2886,8 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 
 		ret = btrfs_block_rsv_migrate(&fs_info->trans_block_rsv,
 					      rsv, min_size, false);
-		BUG_ON(ret);	/* shouldn't happen */
+		if (WARN_ON(ret))
+			break;
 		trans->block_rsv = rsv;
 
 		cur_offset = drop_args.drop_end;
-- 
2.35.1

