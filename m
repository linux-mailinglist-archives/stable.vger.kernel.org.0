Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5DD5922E9
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242081AbiHNPwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242097AbiHNPvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:51:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBB71A82C;
        Sun, 14 Aug 2022 08:36:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DAC860C92;
        Sun, 14 Aug 2022 15:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D29C433D6;
        Sun, 14 Aug 2022 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491410;
        bh=5gFMfx3XcOH2K4tVfplaXcH/jahGlPdetWJ5Gzl5S3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbLOFL8bPXMkNCBEVFYzNcUkyrC+XFhDGzaTFAkHrB0Rsp6rhI8zhX4xkW7TLEaLE
         usMrOT1D23yvvasRzrcJiSdzReSVk5Lc54ByGzsY1G2hTOS85J1UYlytesi2hwQ1HF
         DbNEP+KRr+331HEZRhF3d+lmvc9oC+y8EYfZyWg8rgoNr7KFAIiMEoip85r+kgmKAp
         6oe+/saNZx7wELT/pEUvZLA/s0EzWLh6uF4c+5hWjB60CdnzrneMPNO+okgLKlzASX
         QTC2+K4thTJUSHbrbXpA84OsIFexmHu0b9m7tz8vSJLoBaKQQoW99tAsFTi1lRisO1
         Ovz1tffPPogdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 8/9] ext4: avoid remove directory when directory is corrupted
Date:   Sun, 14 Aug 2022 11:36:35 -0400
Message-Id: <20220814153637.2380406-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153637.2380406-1-sashal@kernel.org>
References: <20220814153637.2380406-1-sashal@kernel.org>
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
index c5f289737d0f..2460ac22e632 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2804,11 +2804,8 @@ bool ext4_empty_dir(struct inode *inode)
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

