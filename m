Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B6A4EA073
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344052AbiC1Tuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344152AbiC1TsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:48:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D8E6A044;
        Mon, 28 Mar 2022 12:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 248F0B81214;
        Mon, 28 Mar 2022 19:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85D0C34100;
        Mon, 28 Mar 2022 19:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496622;
        bh=XQomRRf5KXr6nqUdmC6zMldedcQ+i/ySkJX5ypQsNo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co8Pfq0lvnR6qN78UYLtYOsSU4Gx0tNhFLzlie28RIuE1/yRFwzofvQfVwTFkEyT/
         pgc2E4iL6tA6vPHCnxu/DqS0BeoDGXwNSQMZnOtnpJiK2DN0/QKiF6e28k60DI6w+x
         EGBm3ROK18zj34tPZLizFymgzbr6bOuhNG+zZWqERXoizc1Nj9CEAzZjM0XarXr7av
         xJOSvRNRCbBZ3TiuuFg3fdPlOSPUeYcWC6ZN+7VMQ9ev+tlV0N824FOqyk1hH5MKE9
         NgUXGw95L6cJ0ciTCS/G8aXhH6qGwvEYVxSVoVTEbay65VQIFD6DJs+TktyUsh9j/2
         fUHFxxlQeXl5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+3c765c5248797356edaa@syzkaller.appspotmail.com,
        Anton Altaparmakov <anton@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 2/2] ntfs: add sanity check on allocation size
Date:   Mon, 28 Mar 2022 15:43:38 -0400
Message-Id: <20220328194338.1586587-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194338.1586587-1-sashal@kernel.org>
References: <20220328194338.1586587-1-sashal@kernel.org>
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
index e844b43f2eac..0acd1f02b146 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1906,6 +1906,10 @@ int ntfs_read_inode_mount(struct inode *vi)
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

