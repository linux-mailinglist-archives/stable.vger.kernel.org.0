Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E3453A804
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbiFAOHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355695AbiFAOGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:06:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D38EB41D1;
        Wed,  1 Jun 2022 06:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F536B81AE7;
        Wed,  1 Jun 2022 13:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83187C3411E;
        Wed,  1 Jun 2022 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091962;
        bh=H4I09whxsh8ywfnFdOqNSd9DPvOqk92y/LG+KTeXnp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0ZH5224CAY/7SXROKyOC7vYIXtqneBEjoUVMVd7uqwBA+16KZcnn5I5thFD5ihS0
         TGaDaD+mi79KEfHWUjUgapdaV3MRyo7vOROaD/MqOvxmhPOSpSqHcZoIqrVdh87hx6
         NZNzczlaFDXZZ/HHT0lUTbMQiBjRxUj4yFnlCpwsWD2WASBeogtKTdjBiRmNv8z6RP
         3fnYMu8gZSFUS46JzRO52HTua9MCgeAO5MbyAbZWbQ5LYmaHuX9Vm6ohrl3KpOiEIJ
         cnzSWd02z3tHPrOFFV61jZhe1+H2iicZbCAq17HJnvoTiSh6UPiKloZWdFuGYibdyl
         aoJKM8k60Wh+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        qianfan <qianfanguijin@163.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 09/20] fat: add ratelimit to fat*_ent_bread()
Date:   Wed,  1 Jun 2022 09:58:51 -0400
Message-Id: <20220601135902.2004823-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135902.2004823-1-sashal@kernel.org>
References: <20220601135902.2004823-1-sashal@kernel.org>
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
index 3647c65a0f48..0191eb1dc7f6 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -93,7 +93,8 @@ static int fat12_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 err_brelse:
 	brelse(bhs[0]);
 err:
-	fat_msg(sb, KERN_ERR, "FAT read failed (blocknr %llu)", (llu)blocknr);
+	fat_msg_ratelimit(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
+			  (llu)blocknr);
 	return -EIO;
 }
 
@@ -106,8 +107,8 @@ static int fat_ent_bread(struct super_block *sb, struct fat_entry *fatent,
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

