Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EA13833D1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbhEQPCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241332AbhEQPAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9284D619D2;
        Mon, 17 May 2021 14:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261612;
        bh=vCrC3Wl1kdxy967ft+K0SkQLfc37tQKnZBhmt/vm3hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCgAnF7kuWwLCKxCwJHMrX2fmyqoOGhcQsOB8rjkBqtTAtMyYDAS4QjWUmH28ztPp
         XVgezemRokR94pAlok4+r/W85EZB/LwOaC2szDqiqUHtgzVatE1473a5dqzmBwS0to
         c5bdbX//oVbRAwgm5NJiB7eOr84wrN2tov7Fg1t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 135/329] f2fs: fix to avoid accessing invalid fio in f2fs_allocate_data_block()
Date:   Mon, 17 May 2021 16:00:46 +0200
Message-Id: <20210517140306.679437320@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index af765d60351f..b053e3c32e1f 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3414,12 +3414,12 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
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



