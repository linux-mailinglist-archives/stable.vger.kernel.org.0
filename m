Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA2A24F437
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgHXId5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgHXId4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3FFC2075B;
        Mon, 24 Aug 2020 08:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258036;
        bh=7MMjWtjppeUjXZn3kegXmGywdbugRJzfUujLOMhLPcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5i91WrfyeaZ5xzcD0qjIxgEuKkmz7cVF8Pq5kt5qpZy/E8WA+LVIN+WyYzk4X4BM
         Q2mc+omkvFnCoARE99JzPnxIcgXyjM1POAVc8SYqxfis4wB9LfUtLPd7ERL/pWvRhr
         5GAK7yDpRl/ibckaQVxUu0ZAh6Cdyamj74Kjl4KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 049/148] f2fs: fix to check page dirty status before writeback
Date:   Mon, 24 Aug 2020 10:29:07 +0200
Message-Id: <20200824082416.420939909@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
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
index f6fbe61b1251e..2390f7943f6c8 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1310,6 +1310,12 @@ retry_write:
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



