Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470F654942A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349190AbiFMK77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350369AbiFMK6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:58:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C337013D6B;
        Mon, 13 Jun 2022 03:32:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06FDE60EF5;
        Mon, 13 Jun 2022 10:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF3AC341C7;
        Mon, 13 Jun 2022 10:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116345;
        bh=H4I09whxsh8ywfnFdOqNSd9DPvOqk92y/LG+KTeXnp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvIgO7irOHKjoAxP7DFCsKnMNIRlUx2PJLxac9LEMzLITt03xXlhtO5AVeXQlsOON
         1B0JalkOwGvkY/WRgv2UZdAGar9hp0s2moq7l8tDm5orU9ntv6E2KiXmib+NyHAkHw
         xkVj/RZ4w+RLVpUhXRFhzhrrYcTMY/ELDTe3DOMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        qianfan <qianfanguijin@163.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/411] fat: add ratelimit to fat*_ent_bread()
Date:   Mon, 13 Jun 2022 12:05:42 +0200
Message-Id: <20220613094930.585944291@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



