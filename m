Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7844B24F995
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgHXJrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgHXIlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:41:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D61F2087D;
        Mon, 24 Aug 2020 08:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258497;
        bh=Use45e60GxbYf6qvO5LgdZ7qaYCmDh68vpXb2tHKKr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1G58sqK0OHHi9xoPjCdRQn1n4SzgbF9eCfMmBD04rXbRNheWNzfUTjOu43iCZqO1D
         MpGOQde+rPtXpMXJ3lxnz9gvymDsba4Yl+e/FC6Pra7UTFJ8IOyWfLl3TnueG7PstJ
         5BMnFkC6yMV28pStRCjYwp2zhPXWgxd2Rrx6G7KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 038/124] f2fs: fix to check page dirty status before writeback
Date:   Mon, 24 Aug 2020 10:29:32 +0200
Message-Id: <20200824082411.290496938@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit eb1353cfa9c1e9415b03dc117f8399969fa02102 ]

In f2fs_write_raw_pages(), we need to check page dirty status before
writeback, because there could be a racer (e.g. reclaimer) helps
writebacking the dirty page.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 527d50edcb956..b397121dfa107 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1207,6 +1207,12 @@ retry_write:
 				congestion_wait(BLK_RW_ASYNC,
 						DEFAULT_IO_TIMEOUT);
 				lock_page(cc->rpages[i]);
+
+				if (!PageDirty(cc->rpages[i])) {
+					unlock_page(cc->rpages[i]);
+					continue;
+				}
+
 				clear_page_dirty_for_io(cc->rpages[i]);
 				goto retry_write;
 			}
-- 
2.25.1



