Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D459B5922C3
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241735AbiHNPwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241950AbiHNPun (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:50:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7681CFDD;
        Sun, 14 Aug 2022 08:36:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F7760DDB;
        Sun, 14 Aug 2022 15:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8D5C43470;
        Sun, 14 Aug 2022 15:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491368;
        bh=k8wS7Uf+smNCIfjSZJkQR7LB3/uGDvOYL43EJA5t2ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEaxVeu7E5YtL4KtXjZpfAXa6ajd69fGb1zmaRCwuTbtcZ4EoziD7YRPNXsCJABJC
         Sq/7XjvAiZlqktez0ByS4mLK5p29d2AeuRK/yXovYxJsrHOY4s9ttde8ymPe8J/pI8
         0KzVfhGe4oCHjn4w2aNFg/L5wGG0eFotVugqok9iVaBY6048oipTtUEgTZGtec16p8
         krV729grBq5ugjH5wgR0AXIBnkw9qCWv5U9KAC8wFqTPe1cPcA0Q7z4CTc2KeE2PkQ
         87fLz5sBJhk2rqeq0bIPdVbV+ISkrWq3SmySm9o+wtzL0H46eo9i7Kdw+Bq//n+L8b
         OJK0KcsGN+pwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/21] ext4: avoid remove directory when directory is corrupted
Date:   Sun, 14 Aug 2022 11:35:30 -0400
Message-Id: <20220814153531.2379705-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153531.2379705-1-sashal@kernel.org>
References: <20220814153531.2379705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit b24e77ef1c6d4dbf42749ad4903c97539cc9755a ]

Now if check directoy entry is corrupted, ext4_empty_dir may return true
then directory will be removed when file system mounted with "errors=continue".
In order not to make things worse just return false when directory is corrupted.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220622090223.682234-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d151892db8b0..3ef57daf4a50 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2913,11 +2913,8 @@ bool ext4_empty_dir(struct inode *inode)
 		de = (struct ext4_dir_entry_2 *) (bh->b_data +
 					(offset & (sb->s_blocksize - 1)));
 		if (ext4_check_dir_entry(inode, NULL, de, bh,
-					 bh->b_data, bh->b_size, offset)) {
-			offset = (offset | (sb->s_blocksize - 1)) + 1;
-			continue;
-		}
-		if (le32_to_cpu(de->inode)) {
+					 bh->b_data, bh->b_size, offset) ||
+		    le32_to_cpu(de->inode)) {
 			brelse(bh);
 			return false;
 		}
-- 
2.35.1

