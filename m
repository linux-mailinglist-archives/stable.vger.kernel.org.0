Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87351113426
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbfLDSWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:22:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729824AbfLDSFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:05:25 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D510B2081B;
        Wed,  4 Dec 2019 18:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482725;
        bh=uAYZUiGgVZVA8TdMU5/qfdvQ0kgDh1SXmr8vRZKpNZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeBiyh0mGR2RmO67ujwV4NQaxPZ1L32Cq8UID0RTD9wWi73l9w5T/GdO8tyeD3SjO
         uIqse54dka3idgXMtuRbORrTt/NdyVepuTO2oL1zmhMKe70JdruhVN86pREuL2pMNS
         KpJQMi7qxWzpsQJ2hZWK+NkUOWANG0kPXiVSRyjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 111/209] f2fs: fix to dirty inode synchronously
Date:   Wed,  4 Dec 2019 18:55:23 +0100
Message-Id: <20191204175329.699008290@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit b32e019049e959ee10ec359893c9dd5d057dad55 ]

If user change inode's i_flags via ioctl, let's add it into global
dirty list, so that checkpoint can guarantee its persistence before
fsync, it can make checkpoint keeping strong consistency.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1b17921994459..d68b0132718a6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1593,7 +1593,7 @@ static int __f2fs_ioc_setflags(struct inode *inode, unsigned int flags)
 
 	inode->i_ctime = current_time(inode);
 	f2fs_set_inode_flags(inode);
-	f2fs_mark_inode_dirty_sync(inode, false);
+	f2fs_mark_inode_dirty_sync(inode, true);
 	return 0;
 }
 
-- 
2.20.1



