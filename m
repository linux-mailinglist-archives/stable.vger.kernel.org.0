Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72764EA0A4
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344059AbiC1Tul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245629AbiC1TrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:47:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F8722B26;
        Mon, 28 Mar 2022 12:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EF75612CD;
        Mon, 28 Mar 2022 19:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2015CC36AE2;
        Mon, 28 Mar 2022 19:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496602;
        bh=a3X9AFzHlu8+WSu53lKw4fxPUWErvt/B1kO6xdYwI7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgjeVwVv7lQgKojL3a//HCvFUs95En6IseDshBlnkdhkbplkO4xTxiSLeCrrcbz+J
         8T4ZMXlJbai5i5/KR+15GMxtEm7NnSY8N/pj5VRHf7BZ/NHEHtxJUxsdejhAkDbw/8
         aKnRkBc4XGy8SrpcHIw8aSp9BY1SVWxtz52IrwizVU8WJo9fLBzwGz/wrxhomnRcFo
         UnHuK10NVz1A3MQ9CKr+7dNemGCowBDVgVlX2KkfyixEtMpYRY8hZoMS6tUCc+xwmc
         kFcjlTC4DfpcdmfsjUKaXNPhBho350UFlJ3lzIL6TpCKYnc6rkU9RIzaoE8HlmfVnl
         SlZkfp81NITYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+3c765c5248797356edaa@syzkaller.appspotmail.com,
        Anton Altaparmakov <anton@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.15 16/16] ntfs: add sanity check on allocation size
Date:   Mon, 28 Mar 2022 15:42:59 -0400
Message-Id: <20220328194300.1586178-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194300.1586178-1-sashal@kernel.org>
References: <20220328194300.1586178-1-sashal@kernel.org>
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 714fbf2647b1a33d914edd695d4da92029c7e7c0 ]

ntfs_read_inode_mount invokes ntfs_malloc_nofs with zero allocation
size.  It triggers one BUG in the __ntfs_malloc function.

Fix this by adding sanity check on ni->attr_list_size.

Link: https://lkml.kernel.org/r/20220120094914.47736-1-dzm91@hust.edu.cn
Reported-by: syzbot+3c765c5248797356edaa@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 4474adb393ca..517b71c73aa9 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1881,6 +1881,10 @@ int ntfs_read_inode_mount(struct inode *vi)
 		}
 		/* Now allocate memory for the attribute list. */
 		ni->attr_list_size = (u32)ntfs_attr_size(a);
+		if (!ni->attr_list_size) {
+			ntfs_error(sb, "Attr_list_size is zero");
+			goto put_err_out;
+		}
 		ni->attr_list = ntfs_malloc_nofs(ni->attr_list_size);
 		if (!ni->attr_list) {
 			ntfs_error(sb, "Not enough memory to allocate buffer "
-- 
2.34.1

