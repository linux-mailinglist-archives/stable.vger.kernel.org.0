Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2262E1601
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgLWC40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgLWCUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C793229CA;
        Wed, 23 Dec 2020 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690014;
        bh=y3xnCdMjaalb1+NugOTJYOLDazlf9ZWnnOZtAxErUFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rd8m5iXPXeN9I4gwE+Eu3ekGn753SeGoUjn9JUY+HS3f4Oe1JJAvdaU6VtSQE5+t0
         YmB7jvpYNnWx5e1FWxDiCiLheGk41UZJIHeDjLHqibzkkBMth3gupfOKNbG+SATTU6
         yHua82QgCRh5b2bVdNdUGhLihvk9rs6mV+HlRSUiIL6VA49gmw1aAxI4NEA6fgg8aE
         3mXGI5tBti+Jz5t/cPejabRbNPQbdaoIV6mUJet+k57/6rnfs08Pdu7IuiiHJ5pAAb
         vca76KOvkPhDopah/nM+nOuhnYyOyUO3GXqYIMe0m9IfhqtqlxqgWvRC9KO8zvxmII
         pUyrZI7uirwxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 093/130] bcache: fix race between setting bdev state to none and new write request direct to backing
Date:   Tue, 22 Dec 2020 21:17:36 -0500
Message-Id: <20201223021813.2791612-93-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongsheng Yang <dongsheng.yang@easystack.cn>

[ Upstream commit df4ad53242158f9f1f97daf4feddbb4f8b77f080 ]

There is a race condition in detaching as below:
A. detaching			B. Write request
(1) writing back
(2) write back done, set bdev
    state to clean.
(3) cached_dev_put() and
    schedule_work(&dc->detach);
				(4) write data [0 - 4K] directly
				    into backing and ack to user.
(5) power-failure...

When we restart this bcache device, this bdev is clean but not detached,
and read [0 - 4K], we will get unexpected old data from cache device.

To fix this problem, set the bdev state to none when we writeback done
in detaching, and then if power-failure happened as above, the data in
cache will not be used in next bcache device starting, it's detached, we
will read the correct data from backing derectly.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c     | 9 ---------
 drivers/md/bcache/writeback.c | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 63f5ce18311bb..a251c1f35afa9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1040,9 +1040,6 @@ static void cancel_writeback_rate_update_dwork(struct cached_dev *dc)
 static void cached_dev_detach_finish(struct work_struct *w)
 {
 	struct cached_dev *dc = container_of(w, struct cached_dev, detach);
-	struct closure cl;
-
-	closure_init_stack(&cl);
 
 	BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
 	BUG_ON(refcount_read(&dc->count));
@@ -1056,12 +1053,6 @@ static void cached_dev_detach_finish(struct work_struct *w)
 		dc->writeback_thread = NULL;
 	}
 
-	memset(&dc->sb.set_uuid, 0, 16);
-	SET_BDEV_STATE(&dc->sb, BDEV_STATE_NONE);
-
-	bch_write_bdev_super(dc, &cl);
-	closure_sync(&cl);
-
 	mutex_lock(&bch_register_lock);
 
 	calc_cached_dev_sectors(dc->disk.c);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 0b02210ab4355..38b5c6cc18c7b 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -703,6 +703,15 @@ static int bch_writeback_thread(void *arg)
 			 * bch_cached_dev_detach().
 			 */
 			if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags)) {
+				struct closure cl;
+
+				closure_init_stack(&cl);
+				memset(&dc->sb.set_uuid, 0, 16);
+				SET_BDEV_STATE(&dc->sb, BDEV_STATE_NONE);
+
+				bch_write_bdev_super(dc, &cl);
+				closure_sync(&cl);
+
 				up_write(&dc->writeback_lock);
 				break;
 			}
-- 
2.27.0

