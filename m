Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0756F62A4
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfKJCo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbfKJCo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B49CC21D7E;
        Sun, 10 Nov 2019 02:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353868;
        bh=CtT6uTW0IPM2Nq6HBc1wilGUrLZyI4sUEyoHHr7e/+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hp/tn0Tc9sQassthkEyE/CIEDFZ5oRVgov07rDa/jsa/E1yGzi16GxrJR8VFBlqjr
         amJZGto+zW8Fdo+yWSMeseI42fJ+tVCSgmQG/bSdmnswapO/lYEdB4BWF6ldAvK7qc
         +TgiqG2rryOkPRIB0fkyJW4pZw9dytrlT09eFWk4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 148/191] f2fs: mark inode dirty explicitly in recover_inode()
Date:   Sat,  9 Nov 2019 21:39:30 -0500
Message-Id: <20191110024013.29782-148-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
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
index 01636d996ba41..733f005b85d65 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -247,6 +247,8 @@ static void recover_inode(struct inode *inode, struct page *page)
 
 	recover_inline_flags(inode, raw);
 
+	f2fs_mark_inode_dirty_sync(inode, true);
+
 	if (file_enc_name(inode))
 		name = "<encrypted>";
 	else
-- 
2.20.1

