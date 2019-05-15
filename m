Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D881F1E6
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbfEOL5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730377AbfEOLRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:17:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC452084E;
        Wed, 15 May 2019 11:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919040;
        bh=1UczZCQc5x+59X5jdJ/yq07EnrU2Dd/9+SuVc8m4S8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDrX+sCHyVJ+mAsY7B2h03YU89pY2QIkF7n3FnGAd8mAlmz5q4mGqv1XKgbYal6//
         jd2EGUxIyQA4TkomFeLVqJHxeaBa1QYDzATuTc3xYX40J+TVOQEGwoSOSGg6Gj5K+g
         5N8M1AIbwXNakYaVopuilEb+FZ994Q+JjZ42Vl7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Junhui <tang.junhui.linux@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 043/115] bcache: correct dirty data statistics
Date:   Wed, 15 May 2019 12:55:23 +0200
Message-Id: <20190515090702.631103131@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index fe6e4c319b7cf..9e875aba41b9b 100644
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



