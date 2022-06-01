Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E1E53A75E
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354143AbiFAN74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354025AbiFAN7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:59:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0301A0D0D;
        Wed,  1 Jun 2022 06:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D594615A7;
        Wed,  1 Jun 2022 13:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00885C34119;
        Wed,  1 Jun 2022 13:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091712;
        bh=FTiI156Bl/R9a/IH+dywYgcf8JKm5MuzE4oQ6KL5C9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfw54+CycT1PMuu0YOt3GqT1dMm94ZJlRTDnZkbOjkfvewuhF6pOWIdLKJZj7T4+W
         1O8bwSntTTmR4RFtuQs0Hby0XdIj1ybliQ+jDFF0psZLsyNy5mACuFCZanVSf6yQv5
         988S+I2Ly+2pvEk+EznLOBZ8pJaq/1VDH7pgMSlqu/pRhkH0lLyjJHgj5Te5FSqKmR
         zoeEXrQtZw9zJquPHX1+akvRJNdVE8f6tkgvyb3qHl/thQsbx+CYbL9OzLijjJD5mU
         p/wFjgTxmzo8tTTmKtn2ziBLmOo6PCt7rwYuLxUSpusu9kZqdPZRkahC7DM8K9NtQ2
         XGTJa2ocGklTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        qianfan <qianfanguijin@163.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.17 21/48] fat: add ratelimit to fat*_ent_bread()
Date:   Wed,  1 Jun 2022 09:53:54 -0400
Message-Id: <20220601135421.2003328-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

[ Upstream commit 183c3237c928109d2008c0456dff508baf692b20 ]

fat*_ent_bread() can be the cause of too many report on I/O error path.
So use fat_msg_ratelimit() instead.

Link: https://lkml.kernel.org/r/87bkxogfeq.fsf@mail.parknet.co.jp
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: qianfan <qianfanguijin@163.com>
Tested-by: qianfan <qianfanguijin@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/fatent.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 978ac6751aeb..1db348f8f887 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -94,7 +94,8 @@ static int fat12_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 err_brelse:
 	brelse(bhs[0]);
 err:
-	fat_msg(sb, KERN_ERR, "FAT read failed (blocknr %llu)", (llu)blocknr);
+	fat_msg_ratelimit(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
+			  (llu)blocknr);
 	return -EIO;
 }
 
@@ -107,8 +108,8 @@ static int fat_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 	fatent->fat_inode = MSDOS_SB(sb)->fat_inode;
 	fatent->bhs[0] = sb_bread(sb, blocknr);
 	if (!fatent->bhs[0]) {
-		fat_msg(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
-		       (llu)blocknr);
+		fat_msg_ratelimit(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
+				  (llu)blocknr);
 		return -EIO;
 	}
 	fatent->nr_bhs = 1;
-- 
2.35.1

