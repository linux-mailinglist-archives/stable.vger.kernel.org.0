Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA4132885A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbhCARjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238238AbhCARb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:31:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE56965097;
        Mon,  1 Mar 2021 16:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617546;
        bh=nZ+BKGMHeaaOFeICb6e/aN0O+528dcxZAkMoqF9LNGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1t+6lzDRaYf5Op9K1jLHt6OJRyRpip2nMMjb2snD6a0n8KP0218h3GN8SxKeQULH9
         bn8F9Vlhz2JMAzeNZcEV9E8bExtwB0omUhMwatYfQPf35/wRc121Fnml1OmXQ0o04k
         h/J8j6VBtcKGrIdLi5XAsxcehzt+LYSzTETgGy5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Dehe Gu <gudehe@huawei.com>, Ge Qiu <qiuge@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/340] f2fs: fix a wrong condition in __submit_bio
Date:   Mon,  1 Mar 2021 17:10:56 +0100
Message-Id: <20210301161053.850005716@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dehe Gu <gudehe@huawei.com>

[ Upstream commit 39f71b7e40e21805d6b15fc7750bdd9cab6a5010 ]

We should use !F2FS_IO_ALIGNED() to check and submit_io directly.

Fixes: 8223ecc456d0 ("f2fs: fix to add missing F2FS_IO_ALIGNED() condition")
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Dehe Gu <gudehe@huawei.com>
Signed-off-by: Ge Qiu <qiuge@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 68be334afc286..64ee2a064e339 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -318,7 +318,7 @@ static inline void __submit_bio(struct f2fs_sb_info *sbi,
 		if (test_opt(sbi, LFS) && current->plug)
 			blk_finish_plug(current->plug);
 
-		if (F2FS_IO_ALIGNED(sbi))
+		if (!F2FS_IO_ALIGNED(sbi))
 			goto submit_io;
 
 		start = bio->bi_iter.bi_size >> F2FS_BLKSIZE_BITS;
-- 
2.27.0



