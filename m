Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A218760A868
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiJXNFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiJXNDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:03:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A22842D48;
        Mon, 24 Oct 2022 05:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3182B815DF;
        Mon, 24 Oct 2022 12:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E85C433C1;
        Mon, 24 Oct 2022 12:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613695;
        bh=/IDR0zTm2lJPM0MK7UW3XnXItapXnLnqvTqAjER0wR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc6Jkkr1uDcT3rD+29DtrQMDh5IiJpRf7EeP2/oTmpjUq14cEJLPBkYc/qJV7IlQx
         bz9Npyup3aP5Nr/WiFoEaEPrJPC59eIM8i7qemdU833GLpvAYuRTBRngWA8crn2fAA
         yCWR3irbOEI2kAjVKSS8CBHw5eMTMe2YEmr739NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 235/255] bcache: fix set_at_max_writeback_rate() for multiple attached devices
Date:   Mon, 24 Oct 2022 13:32:25 +0200
Message-Id: <20221024113011.010431941@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit d2d05b88035d2d51a5bb6c5afec88a0880c73df4 ]

Inside set_at_max_writeback_rate() the calculation in following if()
check is wrong,
	if (atomic_inc_return(&c->idle_counter) <
	    atomic_read(&c->attached_dev_nr) * 6)

Because each attached backing device has its own writeback thread
running and increasing c->idle_counter, the counter increates much
faster than expected. The correct calculation should be,
	(counter / dev_nr) < dev_nr * 6
which equals to,
	counter < dev_nr * dev_nr * 6

This patch fixes the above mistake with correct calculation, and helper
routine idle_counter_exceeded() is added to make code be more clear.

Reported-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@suse.de>
Acked-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Link: https://lore.kernel.org/r/20220919161647.81238-6-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/writeback.c | 73 +++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 0b02210ab435..5767ff6c13e3 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -119,27 +119,61 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	dc->writeback_rate_target = target;
 }
 
+static bool idle_counter_exceeded(struct cache_set *c)
+{
+	int counter, dev_nr;
+
+	/*
+	 * If c->idle_counter is overflow (idel for really long time),
+	 * reset as 0 and not set maximum rate this time for code
+	 * simplicity.
+	 */
+	counter = atomic_inc_return(&c->idle_counter);
+	if (counter <= 0) {
+		atomic_set(&c->idle_counter, 0);
+		return false;
+	}
+
+	dev_nr = atomic_read(&c->attached_dev_nr);
+	if (dev_nr == 0)
+		return false;
+
+	/*
+	 * c->idle_counter is increased by writeback thread of all
+	 * attached backing devices, in order to represent a rough
+	 * time period, counter should be divided by dev_nr.
+	 * Otherwise the idle time cannot be larger with more backing
+	 * device attached.
+	 * The following calculation equals to checking
+	 *	(counter / dev_nr) < (dev_nr * 6)
+	 */
+	if (counter < (dev_nr * dev_nr * 6))
+		return false;
+
+	return true;
+}
+
+/*
+ * Idle_counter is increased every time when update_writeback_rate() is
+ * called. If all backing devices attached to the same cache set have
+ * identical dc->writeback_rate_update_seconds values, it is about 6
+ * rounds of update_writeback_rate() on each backing device before
+ * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
+ * to each dc->writeback_rate.rate.
+ * In order to avoid extra locking cost for counting exact dirty cached
+ * devices number, c->attached_dev_nr is used to calculate the idle
+ * throushold. It might be bigger if not all cached device are in write-
+ * back mode, but it still works well with limited extra rounds of
+ * update_writeback_rate().
+ */
 static bool set_at_max_writeback_rate(struct cache_set *c,
 				       struct cached_dev *dc)
 {
 	/* Don't set max writeback rate if gc is running */
 	if (!c->gc_mark_valid)
 		return false;
-	/*
-	 * Idle_counter is increased everytime when update_writeback_rate() is
-	 * called. If all backing devices attached to the same cache set have
-	 * identical dc->writeback_rate_update_seconds values, it is about 6
-	 * rounds of update_writeback_rate() on each backing device before
-	 * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
-	 * to each dc->writeback_rate.rate.
-	 * In order to avoid extra locking cost for counting exact dirty cached
-	 * devices number, c->attached_dev_nr is used to calculate the idle
-	 * throushold. It might be bigger if not all cached device are in write-
-	 * back mode, but it still works well with limited extra rounds of
-	 * update_writeback_rate().
-	 */
-	if (atomic_inc_return(&c->idle_counter) <
-	    atomic_read(&c->attached_dev_nr) * 6)
+
+	if (!idle_counter_exceeded(c))
 		return false;
 
 	if (atomic_read(&c->at_max_writeback_rate) != 1)
@@ -153,13 +187,10 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
 	dc->writeback_rate_change = 0;
 
 	/*
-	 * Check c->idle_counter and c->at_max_writeback_rate agagain in case
-	 * new I/O arrives during before set_at_max_writeback_rate() returns.
-	 * Then the writeback rate is set to 1, and its new value should be
-	 * decided via __update_writeback_rate().
+	 * In case new I/O arrives during before
+	 * set_at_max_writeback_rate() returns.
 	 */
-	if ((atomic_read(&c->idle_counter) <
-	     atomic_read(&c->attached_dev_nr) * 6) ||
+	if (!idle_counter_exceeded(c) ||
 	    !atomic_read(&c->at_max_writeback_rate))
 		return false;
 
-- 
2.35.1



