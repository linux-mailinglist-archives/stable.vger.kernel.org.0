Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C251015D9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbfKSFrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:47:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731288AbfKSFry (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:47:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3F0C21823;
        Tue, 19 Nov 2019 05:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142473;
        bh=ZOehDVMaWStqEmiOOoCjPotJCupJyzR/F/AhshevsMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXIoMVJVct3B4vllb1oNowmf4Q68JfNgBpthdckLCtXyRCNF5jLtBKmUHt755QbVA
         9kkSwBj+vVMv4/y3x+yqoSGPeN+to1vAy6E3pV1d+5CbLzAa2F34Cke0Kpj+zK5411
         C8Fk0YMU+IWFumu7Jy9Ltac9EARJqvW37LSt9y2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 094/239] f2fs: fix memory leak of percpu counter in fill_super()
Date:   Tue, 19 Nov 2019 06:18:14 +0100
Message-Id: <20191119051321.328671665@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 4a70e255449c9a13eed7a6eeecc85a1ea63cef76 ]

In fill_super -> init_percpu_info, we should destroy percpu counter
in error path, otherwise memory allcoated for percpu counter will
leak.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 0f3209b23c940..e4aabfc21bd43 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2123,8 +2123,12 @@ static int init_percpu_info(struct f2fs_sb_info *sbi)
 	if (err)
 		return err;
 
-	return percpu_counter_init(&sbi->total_valid_inode_count, 0,
+	err = percpu_counter_init(&sbi->total_valid_inode_count, 0,
 								GFP_KERNEL);
+	if (err)
+		percpu_counter_destroy(&sbi->alloc_valid_block_count);
+
+	return err;
 }
 
 #ifdef CONFIG_BLK_DEV_ZONED
-- 
2.20.1



