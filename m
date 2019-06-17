Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F92249456
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfFQVTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbfFQVTo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:19:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95F142089E;
        Mon, 17 Jun 2019 21:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806384;
        bh=XbH14dwzEOGD/utq9Pe7jfloTnsYnbypF2eZJ6RCK5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvE+AYnruAt0z0wl98vjyXA4G5VO1IGTGBSN9CtRjMEol86l9k0NLGPH6sJ965hq+
         ClovUb1Fd04oAsH6qwKrzvYYz/DpuEz/Y6N7BzYpKklfgzq23IKIviXeY5DuDnXl6o
         fYzpel9w9elTGFaIxLQUSbubbiR69aKG+VTqAzi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Forsman?= <bjorn.forsman@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 032/115] bcache: only set BCACHE_DEV_WB_RUNNING when cached device attached
Date:   Mon, 17 Jun 2019 23:08:52 +0200
Message-Id: <20190617210801.614134712@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 1f0ffa67349c56ea54c03ccfd1e073c990e7411e upstream.

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/sysfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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
 


