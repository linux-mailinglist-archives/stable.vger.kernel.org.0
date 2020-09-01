Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC4C25946F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgIAPjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731471AbgIAPjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:39:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EC9F205F4;
        Tue,  1 Sep 2020 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974784;
        bh=4P0E1TdwEUvHFMgvNrSm/DXS5S0ovHvkEWD5HGQ/MOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNS+zAgbXOEB3KxCncMYw1o3fsomsiR+5GSYyIWJKIN688loTXMIdO4I/s+2fOQqM
         jyK21DG8JiecDYLQQAFGOjfhTOkq/6JzINP8hfd17eXCRBfbVsLhw71wxdUzhIJAtS
         Zs2GqoRtk/0ndBrEubBEGJ2MOATsq9xqkfgYR30o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Guifu <bluce.liguifu@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 049/255] f2fs: fix use-after-free issue
Date:   Tue,  1 Sep 2020 17:08:25 +0200
Message-Id: <20200901151003.082217220@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Guifu <bluce.liguifu@huawei.com>

[ Upstream commit 99c787cfd2bd04926f1f553b30bd7dcea2caaba1 ]

During umount, f2fs_put_super() unregisters procfs entries after
f2fs_destroy_segment_manager(), it may cause use-after-free
issue when umount races with procfs accessing, fix it by relocating
f2fs_unregister_sysfs().

[Chao Yu: change commit title/message a bit]

Signed-off-by: Li Guifu <bluce.liguifu@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 20e56b0fa46a9..0deb839da0a03 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1173,6 +1173,9 @@ static void f2fs_put_super(struct super_block *sb)
 	int i;
 	bool dropped;
 
+	/* unregister procfs/sysfs entries in advance to avoid race case */
+	f2fs_unregister_sysfs(sbi);
+
 	f2fs_quota_off_umount(sb);
 
 	/* prevent remaining shrinker jobs */
@@ -1238,8 +1241,6 @@ static void f2fs_put_super(struct super_block *sb)
 
 	kvfree(sbi->ckpt);
 
-	f2fs_unregister_sysfs(sbi);
-
 	sb->s_fs_info = NULL;
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
-- 
2.25.1



