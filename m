Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE694F7063
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbiDGBVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240196AbiDGBTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:19:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F241193206;
        Wed,  6 Apr 2022 18:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5ECCDCE25B2;
        Thu,  7 Apr 2022 01:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F26DC385AF;
        Thu,  7 Apr 2022 01:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294125;
        bh=ASIjV+pChRoTXWfJg0esXtdUYY+xsNmlwSH37KNsLMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8AYelZ7XjnbT/PIdqLH0kyAEkl5ktuoXP6yRrRXsdwkghBLtHWxtcL2R5d2beyRD
         di8LTkynaNIV8EPEmh4VEc5f4AQsBt3hhmLU+WoCvjGoggqHIgSO/IroX4NsSDsJk9
         TZmZBkc0H6g0A+gz+0u89EBzTi4r79KVAtuWOX/81an6IcY4R7VMCr23RvbuFjOKg7
         0Bdotsiq4Z0Hx+R/I7rJnKYP4So7MJG5LsEP89cusVLRCStMEXCTdTUBArnuajZqtp
         1k7Ciik2Qb85H0lppNM3Pgmm77A15gDNAknzXkO539fm3Zhk9owDYrXmCtcPi2q6uP
         56kStJnrcVfXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/17] rtc: fix use-after-free on device removal
Date:   Wed,  6 Apr 2022 21:15:06 -0400
Message-Id: <20220407011521.115014-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011521.115014-1-sashal@kernel.org>
References: <20220407011521.115014-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit c8fa17d9f08a448184f03d352145099b5beb618e ]

If the irqwork is still scheduled or running while the RTC device is
removed, a use-after-free occurs in rtc_timer_do_work().  Cleanup the
timerqueue and ensure the work is stopped to fix this.

 BUG: KASAN: use-after-free in mutex_lock+0x94/0x110
 Write of size 8 at addr ffffff801d846338 by task kworker/3:1/41

 Workqueue: events rtc_timer_do_work
 Call trace:
  mutex_lock+0x94/0x110
  rtc_timer_do_work+0xec/0x630
  process_one_work+0x5fc/0x1344
  ...

 Allocated by task 551:
  kmem_cache_alloc_trace+0x384/0x6e0
  devm_rtc_allocate_device+0xf0/0x574
  devm_rtc_device_register+0x2c/0x12c
  ...

 Freed by task 572:
  kfree+0x114/0x4d0
  rtc_device_release+0x64/0x80
  device_release+0x8c/0x1f4
  kobject_put+0x1c4/0x4b0
  put_device+0x20/0x30
  devm_rtc_release_device+0x1c/0x30
  devm_action_release+0x54/0x90
  release_nodes+0x124/0x310
  devres_release_group+0x170/0x240
  i2c_device_remove+0xd8/0x314
  ...

 Last potentially related work creation:
  insert_work+0x5c/0x330
  queue_work_on+0xcc/0x154
  rtc_set_time+0x188/0x5bc
  rtc_dev_ioctl+0x2ac/0xbd0
  ...

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211210160951.7718-1-vincent.whitchurch@axis.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/class.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 9458e6d6686a..8b434213bc7a 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -26,6 +26,15 @@ struct class *rtc_class;
 static void rtc_device_release(struct device *dev)
 {
 	struct rtc_device *rtc = to_rtc_device(dev);
+	struct timerqueue_head *head = &rtc->timerqueue;
+	struct timerqueue_node *node;
+
+	mutex_lock(&rtc->ops_lock);
+	while ((node = timerqueue_getnext(head)))
+		timerqueue_del(head, node);
+	mutex_unlock(&rtc->ops_lock);
+
+	cancel_work_sync(&rtc->irqwork);
 
 	ida_simple_remove(&rtc_ida, rtc->id);
 	kfree(rtc);
-- 
2.35.1

