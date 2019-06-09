Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F503AC54
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 00:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfFIWPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 18:15:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:36608 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729306AbfFIWPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 18:15:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D7460AE4B;
        Sun,  9 Jun 2019 22:15:07 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        rolf@rolffokkens.nl, pierre.juhen@orange.fr,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org
Subject: [PATCH 2/2] bcache: only set BCACHE_DEV_WB_RUNNING when cached device attached
Date:   Mon, 10 Jun 2019 06:13:35 +0800
Message-Id: <20190609221335.24616-3-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190609221335.24616-1-colyli@suse.de>
References: <20190609221335.24616-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When people set a writeback percent via sysfs file,
  /sys/block/bcache<N>/bcache/writeback_percent
current code directly sets BCACHE_DEV_WB_RUNNING to dc->disk.flags
and schedules kworker dc->writeback_rate_update.

If there is no cache set attached to, the writeback kernel thread is
not running indeed, running dc->writeback_rate_update does not make
sense and may cause NULL pointer deference when reference cache set
pointer inside update_writeback_rate().

This patch checks whether the cache set point (dc->disk.c) is NULL in
sysfs interface handler, and only set BCACHE_DEV_WB_RUNNING and
schedule dc->writeback_rate_update when dc->disk.c is not NULL (it
means the cache device is attached to a cache set).

This problem might be introduced from initial bcache commit, but
commit 3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
changes part of the original code piece, so I add 'Fixes: 3fd47bfe55b0'
to indicate from which commit this patch can be applied.

Fixes: 3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
Reported-by: Bjørn Forsman <bjorn.forsman@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Bjørn Forsman <bjorn.forsman@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/sysfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 6cd44d3cf906..bfb437ffb13c 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -431,8 +431,13 @@ STORE(bch_cached_dev)
 			bch_writeback_queue(dc);
 	}
 
+	/*
+	 * Only set BCACHE_DEV_WB_RUNNING when cached device attached to
+	 * a cache set, otherwise it doesn't make sense.
+	 */
 	if (attr == &sysfs_writeback_percent)
-		if (!test_and_set_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
+		if ((dc->disk.c != NULL) &&
+		    (!test_and_set_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags)))
 			schedule_delayed_work(&dc->writeback_rate_update,
 				      dc->writeback_rate_update_seconds * HZ);
 
-- 
2.16.4

