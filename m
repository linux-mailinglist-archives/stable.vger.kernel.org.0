Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224832A5943
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731012AbgKCWGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730014AbgKCUln (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:41:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD2652224E;
        Tue,  3 Nov 2020 20:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436103;
        bh=JLplXyY8y8y3p4QwaVfHP09sC69eM8s1cDPWAhIlVgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xR/o+CqGrdTkFTV5SPJp/vCy7HX/l3hnibujoTMQVXAzUoljpskCTe7KBbSgq53ic
         l2CpSvweASpyiKDH4Dt/cHB5+PBnkE7hEze2f+1rbJhBDnm+wEQ/dXVqdr61BPZX/8
         GPBBMPOMm+A58BLuD/OvN4kpOQ/MjAVARAIzBouw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 056/391] f2fs: compress: fix to disallow enabling compress on non-empty file
Date:   Tue,  3 Nov 2020 21:31:47 +0100
Message-Id: <20201103203351.210726314@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 519a5a2f37b850f4eb86674a10d143088670a390 ]

Compressed inode and normal inode has different layout, so we should
disallow enabling compress on non-empty file to avoid race condition
during inode .i_addr array parsing and updating.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
[Jaegeuk Kim: Fix missing condition]
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8a422400e824d..4ec10256dc67f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1836,6 +1836,8 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
 		if (iflags & F2FS_COMPR_FL) {
 			if (!f2fs_may_compress(inode))
 				return -EINVAL;
+			if (S_ISREG(inode->i_mode) && inode->i_size)
+				return -EINVAL;
 
 			set_compress_context(inode);
 		}
-- 
2.27.0



