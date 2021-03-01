Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0693C328E3B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240615AbhCAT00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:26:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241425AbhCATVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B89564EDF;
        Mon,  1 Mar 2021 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618778;
        bh=mQTy5zRyNjYqodYdSHxLCCvx4c5g5+YRv2JKQj/OTuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ht5owstdp5GdMkOCXgMJbeZwYzFwymUpTjhreBOHoKcEbK4YkV3mCT2h2ELeyqIHl
         4tKf8EkPJ6rasXkZK12YXOUJET00O6fR4Vf97nx2+7FUaoiqbdKHCy1TIfckLt6la9
         wgc2V7T2NDy3yvqjmh78M4Cnx76/mOSvWYk4cwck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Dehe Gu <gudehe@huawei.com>, Ge Qiu <qiuge@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/663] f2fs: fix a wrong condition in __submit_bio
Date:   Mon,  1 Mar 2021 17:07:41 +0100
Message-Id: <20210301161152.328500968@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 4f326bce525f7..901bd1d963ee8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -499,7 +499,7 @@ static inline void __submit_bio(struct f2fs_sb_info *sbi,
 		if (f2fs_lfs_mode(sbi) && current->plug)
 			blk_finish_plug(current->plug);
 
-		if (F2FS_IO_ALIGNED(sbi))
+		if (!F2FS_IO_ALIGNED(sbi))
 			goto submit_io;
 
 		start = bio->bi_iter.bi_size >> F2FS_BLKSIZE_BITS;
-- 
2.27.0



