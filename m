Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004814EA044
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343942AbiC1TuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344093AbiC1TsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:48:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607E45C643;
        Mon, 28 Mar 2022 12:43:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6B9161291;
        Mon, 28 Mar 2022 19:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F099CC3410F;
        Mon, 28 Mar 2022 19:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496632;
        bh=ingGZxMaEc9r5alfLYbLed9tPRonczPlahQ4UPFgo+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZV3WP2VKPTjmjJFBcO+8pWbwtEftxB0eDC2nhK4MFXNVEu2XBn81igEkLohJJMXz
         Of9A1dW6slpGSAgcCDzsZWMLoCJkeS6uLSubFSx3eiCHxOeyhwgnMSBcFyV7XaL2mA
         7ijCgnwx7JtV/BDYGMdRGrbFcA4mMFOoswjtaCPuOqIinjDrMYg9tLMcmoG1iGhSVh
         jIC5HxjyMMtl+tjtiZZDYqSvkYL2EkRYl9V+Kk5TRwzpwMuMjc5dRu8Dx41SeUybIm
         B//ufYlmQ45yZcCwFNdR8jABnKa4cjJK4YhEt6bccnLFhi4Dc7PZ+0E3qlURe+e3py
         bwD6+MPuANu9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+3c765c5248797356edaa@syzkaller.appspotmail.com,
        Anton Altaparmakov <anton@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 2/2] ntfs: add sanity check on allocation size
Date:   Mon, 28 Mar 2022 15:43:47 -0400
Message-Id: <20220328194347.1586667-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194347.1586667-1-sashal@kernel.org>
References: <20220328194347.1586667-1-sashal@kernel.org>
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
index 8cd134750ebb..4150b3633f77 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1915,6 +1915,10 @@ int ntfs_read_inode_mount(struct inode *vi)
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

