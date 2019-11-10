Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A68ECF6448
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfKJC4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727641AbfKJC4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEBDA2248C;
        Sun, 10 Nov 2019 02:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354081;
        bh=zruDnVJMljDs/bDjpZySQhScOXxkBULXSigdRF4c80A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6Zx5j377IUXjtoUIMI7oHLaFuODYa31y+d1ivEWxmowaCoB9jPlzpP8K13Pb4ml9
         XRjol1jeoH43kgfrpoP/HYu0qLPS6A9NhG2oGeWpgNg585rdhL0SDg4upnPqgzQ1c0
         Z8HRnfncFexUVGnrb4YPBF3okROlRvEsAlqMjs8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 079/109] f2fs: mark inode dirty explicitly in recover_inode()
Date:   Sat,  9 Nov 2019 21:45:11 -0500
Message-Id: <20191110024541.31567-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 4a1728cad6340bfbe17bd17fd158b2165cd99508 ]

Mark inode dirty explicitly in the end of recover_inode() to make sure
that all recoverable fields can be persisted later.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 87942cf2afe1f..2eef266b656b5 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -227,6 +227,8 @@ static void recover_inode(struct inode *inode, struct page *page)
 	F2FS_I(inode)->i_advise = raw->i_advise;
 	F2FS_I(inode)->i_flags = le32_to_cpu(raw->i_flags);
 
+	f2fs_mark_inode_dirty_sync(inode, true);
+
 	if (file_enc_name(inode))
 		name = "<encrypted>";
 	else
-- 
2.20.1

