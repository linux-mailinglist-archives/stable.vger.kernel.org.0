Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C00215B18
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbfEGFjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728514AbfEGFjs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:39:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E4D205ED;
        Tue,  7 May 2019 05:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207587;
        bh=mUmzi0R84Qcg29KZmmx+diwga44z3ZgjBf6zUAg0VwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4F5FEk5A7ygjcv/EPRtWpkRRAZ+ni7ZGhde8wCXJ19KNOEIpmNc52wZpKoUBs180
         l1dm2WG0BuLycBUxz8uEPsStcdcG7rLFtd1/xXgDZZyblGkCzvbuH7hwJzBWotXFtk
         joIyLr/8qvfPdP60YccaynCh3M52pPQw42W+DIak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Junhui <tang.junhui.linux@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 38/95] bcache: correct dirty data statistics
Date:   Tue,  7 May 2019 01:37:27 -0400
Message-Id: <20190507053826.31622-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Junhui <tang.junhui.linux@gmail.com>

[ Upstream commit 2e17a262a2371d38d2ec03614a2675a32cef9912 ]

When bcache device is clean, dirty keys may still exist after
journal replay, so we need to count these dirty keys even
device in clean status, otherwise after writeback, the amount
of dirty data would be incorrect.

Signed-off-by: Tang Junhui <tang.junhui.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fe6e4c319b7c..9e875aba41b9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1045,12 +1045,13 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	}
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
-		bch_sectors_dirty_init(&dc->disk);
 		atomic_set(&dc->has_dirty, 1);
 		atomic_inc(&dc->count);
 		bch_writeback_queue(dc);
 	}
 
+	bch_sectors_dirty_init(&dc->disk);
+
 	bch_cached_dev_run(dc);
 	bcache_device_link(&dc->disk, c, "bdev");
 
-- 
2.20.1

