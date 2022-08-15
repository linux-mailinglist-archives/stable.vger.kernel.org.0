Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5B45950EC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiHPErH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiHPEqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:46:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D2A177616;
        Mon, 15 Aug 2022 13:43:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C4C61234;
        Mon, 15 Aug 2022 20:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B493C433D6;
        Mon, 15 Aug 2022 20:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596236;
        bh=3cfjUBEI47FCH8s8YM21aQm7CshxOzd1w+K3D7ClE/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+SqqGCqgVJvKpWxXk60QusM1mitPXSzavB+mk+1s60FpKUh1cZU+QAYSc4aK+xyg
         J6ItElHAZkwpKTewiTOi33W1QOGcsVHQrHy5olrWv1a1ujEzOHWE3OBfT1Wer7lefU
         +0o/SOx4/FAy2ocIo/N+syOlowM9W08E2XoKWOFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Chao Liu <liuchao@coolpad.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1008/1157] f2fs: fix to remove F2FS_COMPR_FL and tag F2FS_NOCOMP_FL at the same time
Date:   Mon, 15 Aug 2022 20:06:04 +0200
Message-Id: <20220815180520.153837637@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Chao Liu <liuchao@coolpad.com>

[ Upstream commit 8ee236dcaa690d09ca612622e8bc8d09c302021d ]

If the inode has the compress flag, it will fail to use
'chattr -c +m' to remove its compress flag and tag no compress flag.
However, the same command will be successful when executed again,
as shown below:

  $ touch foo.txt
  $ chattr +c foo.txt
  $ chattr -c +m foo.txt
  chattr: Invalid argument while setting flags on foo.txt
  $ chattr -c +m foo.txt
  $ f2fs_io getflags foo.txt
  get a flag on foo.txt ret=0, flags=nocompression,inline_data

Fix this by removing some checks in f2fs_setflags_common()
that do not affect the original logic. I go through all the
possible scenarios, and the results are as follows. Bold is
the only thing that has changed.

+---------------+-----------+-----------+----------+
|               |            file flags            |
+ command       +-----------+-----------+----------+
|               | no flag   | compr     | nocompr  |
+---------------+-----------+-----------+----------+
| chattr +c     | compr     | compr     | -EINVAL  |
| chattr -c     | no flag   | no flag   | nocompr  |
| chattr +m     | nocompr   | -EINVAL   | nocompr  |
| chattr -m     | no flag   | compr     | no flag  |
| chattr +c +m  | -EINVAL   | -EINVAL   | -EINVAL  |
| chattr +c -m  | compr     | compr     | compr    |
| chattr -c +m  | nocompr   | *nocompr* | nocompr  |
| chattr -c -m  | no flag   | no flag   | no flag  |
+---------------+-----------+-----------+----------+

Link: https://lore.kernel.org/linux-f2fs-devel/20220621064833.1079383-1-chaoliu719@gmail.com/
Fixes: 4c8ff7095bef ("f2fs: support data compression")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Chao Liu <liuchao@coolpad.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index bd14cef1b08f..110c459c78b6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1873,10 +1873,7 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
 		if (masked_flags & F2FS_COMPR_FL) {
 			if (!f2fs_disable_compressed_file(inode))
 				return -EINVAL;
-		}
-		if (iflags & F2FS_NOCOMP_FL)
-			return -EINVAL;
-		if (iflags & F2FS_COMPR_FL) {
+		} else {
 			if (!f2fs_may_compress(inode))
 				return -EINVAL;
 			if (S_ISREG(inode->i_mode) && inode->i_size)
@@ -1885,10 +1882,6 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
 			set_compress_context(inode);
 		}
 	}
-	if ((iflags ^ masked_flags) & F2FS_NOCOMP_FL) {
-		if (masked_flags & F2FS_COMPR_FL)
-			return -EINVAL;
-	}
 
 	fi->i_flags = iflags | (fi->i_flags & ~mask);
 	f2fs_bug_on(F2FS_I_SB(inode), (fi->i_flags & F2FS_COMPR_FL) &&
-- 
2.35.1



