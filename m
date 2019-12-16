Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2C01218FB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfLPRyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:54:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727407AbfLPRyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32F4120663;
        Mon, 16 Dec 2019 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518876;
        bh=fILLnvAxvEczC53mWgcn9FqojH3F0b9g/obpbhr42SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/gBQ4MOIlmSUjbFsyWtcrhmeMZcEGMPCDNKpj+9SehLSGJq7pFS6LsGWEPeTiCHM
         cqA+IXeOX59yVi6sVHZVvPiRPrnlbWmovnzScC/5q5tTYhMelktY3svlA0P8LXcQ1h
         3A9pHR3ojjUbSg5+TcI7XMhuFhvuZJOJP9dzJUc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunlong Song <yunlong.song@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 066/267] f2fs: change segment to section in f2fs_ioc_gc_range
Date:   Mon, 16 Dec 2019 18:46:32 +0100
Message-Id: <20191216174856.049950091@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunlong Song <yunlong.song@huawei.com>

[ Upstream commit 67b0e42b768c9ddc3fd5ca1aee3db815cfaa635c ]

f2fs_ioc_gc_range skips blocks_per_seg each time, however, f2fs_gc moves
blocks of section each time, so fix it from segment to section.

Signed-off-by: Yunlong Song <yunlong.song@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d68b0132718a6..a90173b856f6d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2029,7 +2029,7 @@ do_more:
 	}
 
 	ret = f2fs_gc(sbi, range.sync, true, GET_SEGNO(sbi, range.start));
-	range.start += sbi->blocks_per_seg;
+	range.start += BLKS_PER_SEC(sbi);
 	if (range.start <= end)
 		goto do_more;
 out:
-- 
2.20.1



