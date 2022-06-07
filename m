Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAA45407EA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348482AbiFGRxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350009AbiFGRvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2007213FD46;
        Tue,  7 Jun 2022 10:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 78527CE23DB;
        Tue,  7 Jun 2022 17:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62646C385A5;
        Tue,  7 Jun 2022 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623235;
        bh=K9Ad/0R0mUekL1RxqmlSHPscuZ/RJP8hFmg2yJpGxb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7moO3dgPPwiwGMULvPGgJV8ShwvUspv0VygFwIT6/2zftsfP5sLO/KIMT7etHWKJ
         D+39buJmmsVKS2Z8MYpAT9f832IHUO4v1rdArBQdTgaL1SUnXqyX3gkiaoRsHDDP+D
         fV5Jukdt74JyttEe8aZOP63/ZIaDvrZHNFoC+o7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 345/452] f2fs: fix to do sanity check on block address in f2fs_do_zero_range()
Date:   Tue,  7 Jun 2022 19:03:22 +0200
Message-Id: <20220607164918.837780678@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 25f8236213a91efdf708b9d77e9e51b6fc3e141c upstream.

As Yanming reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215894

I have encountered a bug in F2FS file system in kernel v5.17.

I have uploaded the system call sequence as case.c, and a fuzzed image can
be found in google net disk

The kernel should enable CONFIG_KASAN=y and CONFIG_KASAN_INLINE=y. You can
reproduce the bug by running the following commands:

kernel BUG at fs/f2fs/segment.c:2291!
Call Trace:
 f2fs_invalidate_blocks+0x193/0x2d0
 f2fs_fallocate+0x2593/0x4a70
 vfs_fallocate+0x2a5/0xac0
 ksys_fallocate+0x35/0x70
 __x64_sys_fallocate+0x8e/0xf0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The root cause is, after image was fuzzed, block mapping info in inode
will be inconsistent with SIT table, so in f2fs_fallocate(), it will cause
panic when updating SIT with invalid blkaddr.

Let's fix the issue by adding sanity check on block address before updating
SIT table with it.

Cc: stable@vger.kernel.org
Reported-by: Ming Yan <yanming@tju.edu.cn>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1413,11 +1413,19 @@ static int f2fs_do_zero_range(struct dno
 			ret = -ENOSPC;
 			break;
 		}
-		if (dn->data_blkaddr != NEW_ADDR) {
-			f2fs_invalidate_blocks(sbi, dn->data_blkaddr);
-			dn->data_blkaddr = NEW_ADDR;
-			f2fs_set_data_blkaddr(dn);
+
+		if (dn->data_blkaddr == NEW_ADDR)
+			continue;
+
+		if (!f2fs_is_valid_blkaddr(sbi, dn->data_blkaddr,
+					DATA_GENERIC_ENHANCE)) {
+			ret = -EFSCORRUPTED;
+			break;
 		}
+
+		f2fs_invalidate_blocks(sbi, dn->data_blkaddr);
+		dn->data_blkaddr = NEW_ADDR;
+		f2fs_set_data_blkaddr(dn);
 	}
 
 	f2fs_update_extent_cache_range(dn, start, 0, index - start);


