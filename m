Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08B938365B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244506AbhEQPbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244822AbhEQP2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0A861931;
        Mon, 17 May 2021 14:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262238;
        bh=7GQ9d/NA/jG23TAEWUeUrr5usm8s4sDa+11gvcze7JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7/mWIcO2Im1Ss0baQ/xf0ohUfpSrC/FlmJ+uHg/c5rOhpdHYZYu/KlQUvsPL/Ex+
         Ux58VtnM1CJVpheMJ7EG5hfyTxmJqX01UCz9i0Gq1lDiPSiWMgLA78bXqgnOrJnaSQ
         ySUj2pnyXmbdOOhNPfcsLb4KdWE7dFL6H91iU6sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/289] f2fs: fix to avoid accessing invalid fio in f2fs_allocate_data_block()
Date:   Mon, 17 May 2021 16:00:39 +0200
Message-Id: <20210517140309.010449104@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 25ae837e61dee712b4b1df36602ebfe724b2a0b6 ]

Callers may pass fio parameter with NULL value to f2fs_allocate_data_block(),
so we should make sure accessing fio's field after fio's validation check.

Fixes: f608c38c59c6 ("f2fs: clean up parameter of f2fs_allocate_data_block()")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1c264fd5a0dd..d04b449978aa 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3407,12 +3407,12 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 		f2fs_inode_chksum_set(sbi, page);
 	}
 
-	if (F2FS_IO_ALIGNED(sbi))
-		fio->retry = false;
-
 	if (fio) {
 		struct f2fs_bio_info *io;
 
+		if (F2FS_IO_ALIGNED(sbi))
+			fio->retry = false;
+
 		INIT_LIST_HEAD(&fio->list);
 		fio->in_list = true;
 		io = sbi->write_io[fio->type] + fio->temp;
-- 
2.30.2



