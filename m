Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1574EA06B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343523AbiC1Tqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343559AbiC1Tq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:46:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF89968992;
        Mon, 28 Mar 2022 12:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A2AE6128E;
        Mon, 28 Mar 2022 19:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9555FC34100;
        Mon, 28 Mar 2022 19:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496575;
        bh=8OMFyOaAk1BzOs8bd9OEu8SQHWkFyA3dMkqxRl+sTPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTVbySn7+zd335MVf2oIeaMr2iVl+Mi1C+wSg1jLfhevRuy0SrcdIiEnWTBmjg0Be
         /L5MiesYM1GzSfztp9xP4Hd5qx4gJER4lfO0ELHKQjBZ/y4GuL1SDtZEk8U+xvUa7C
         3ZdkB2Wn3aCxH/MQQdxvcfT5Ju/e2CF4RsTQGJEMPJGC9gkOAoF2MWUrhXErO9RDJ4
         s7jlLIC9pU+uxNhPJu7kd2sEDGQtvTKeLplWme3cI99Su+YCVzJJd3Xyy7SLn+M2OO
         eV5zhppOXCm2wChpsRjmot87Js7+68RhRRyaEXjhuw8VN7yqOuT/GBNYYXDhDkSZRy
         rTAdhkqCTkEeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao@kernel.org>, Chao Yu <chao.yu@oppo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, yuchao0@huawei.com,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.16 18/20] f2fs: compress: fix to print raw data size in error path of lz4 decompression
Date:   Mon, 28 Mar 2022 15:42:24 -0400
Message-Id: <20220328194226.1585920-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194226.1585920-1-sashal@kernel.org>
References: <20220328194226.1585920-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit d284af43f703760e261b1601378a0c13a19d5f1f ]

In lz4_decompress_pages(), if size of decompressed data is not equal to
expected one, we should print the size rather than size of target buffer
for decompressed data, fix it.

Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 190a3c4d4c91..ced0fd54658c 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -313,10 +313,9 @@ static int lz4_decompress_pages(struct decompress_io_ctx *dic)
 	}
 
 	if (ret != PAGE_SIZE << dic->log_cluster_size) {
-		printk_ratelimited("%sF2FS-fs (%s): lz4 invalid rlen:%zu, "
+		printk_ratelimited("%sF2FS-fs (%s): lz4 invalid ret:%d, "
 					"expected:%lu\n", KERN_ERR,
-					F2FS_I_SB(dic->inode)->sb->s_id,
-					dic->rlen,
+					F2FS_I_SB(dic->inode)->sb->s_id, ret,
 					PAGE_SIZE << dic->log_cluster_size);
 		return -EIO;
 	}
-- 
2.34.1

