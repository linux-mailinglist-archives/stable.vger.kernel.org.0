Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533F1592142
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbiHNPe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240518AbiHNPeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:34:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDE1DF35;
        Sun, 14 Aug 2022 08:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB044CE0B63;
        Sun, 14 Aug 2022 15:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5E3C4347C;
        Sun, 14 Aug 2022 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491022;
        bh=oLdac/GYfJCC8DaGqXUjQX2LUFe0uX1PO4NaTektQbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVzpOGUQWtXu8pCalKewfQbmAIgKGO1MgmsYTBLv/uS1qq5x/uVTu1iPWxa4QPx26
         S2089C7HE60WVnNJ8taRX1Gc12sZLt7xwdiLQC2KEbQCDs6sm1PE+tuND0Cz5SyDM9
         9E5cN46xEF8rJiCpjZyz4CiPfpltHxMVuH3RRPqkubOJUKNznEU4X3I0ehN85YJ56R
         wxOJIQbYhjI8m6vE8zKza69bx3b3TcFLbt+MG5UAQcUw5BJ+DTBCCsJvS16ivc8MVg
         lq3Etrkqx8UbnfkwEW7+JBgD/Q+fn3x1wwU2kDARm45CbxgxakT8PrcIqezGWck3Mk
         B7OB5U6Cbl2XQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 62/64] ext4: avoid remove directory when directory is corrupted
Date:   Sun, 14 Aug 2022 11:24:35 -0400
Message-Id: <20220814152437.2374207-62-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
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
index db4ba99d1ceb..1c6725ecca1a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3067,11 +3067,8 @@ bool ext4_empty_dir(struct inode *inode)
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

