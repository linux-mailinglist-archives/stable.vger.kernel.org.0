Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59C44F6F78
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiDGBMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbiDGBMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:12:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D3D36E21;
        Wed,  6 Apr 2022 18:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DC58B8248B;
        Thu,  7 Apr 2022 01:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED462C385A6;
        Thu,  7 Apr 2022 01:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293835;
        bh=cexE1aFde1gdOEfAfUUm4v7S/Vt5OzCWmuXeGZWXGpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZd9dFn4CJR3Ze3p3vn7ou4z51OVa7XtI68vAppuv6Vrx2Sh/iYoMKxS2JFtwS5aE
         +shSeOoVyqJH5z4YUT5q3w5c07rWFyU/D8PcUFQjjgPl+ERWW9j3cwFZoNUCfWy75l
         60IZtN6aJI4+3SOajUkU9cJ1U9+2WGURaCU6vv1iqTn/Fe+O47FCGJZfYyUqQ6wiNB
         jLUAqWK9p00R0CpW1Lp77I4w5BHXt1nfm6EE1kjW5PUeN1/iV054XuxFVmhiqkGkOr
         AfEJ1xBPE24Z0RMkJe3TXIRIj40vVaZmjBzCQABybWOu02S2UoLawDzNpAMdfQoxY5
         nIGyZ53Zn2DcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 04/31] rtc: fix use-after-free on device removal
Date:   Wed,  6 Apr 2022 21:10:02 -0400
Message-Id: <20220407011029.113321-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011029.113321-1-sashal@kernel.org>
References: <20220407011029.113321-1-sashal@kernel.org>
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
index 4b460c61f1d8..40d504dac1a9 100644
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
 	mutex_destroy(&rtc->ops_lock);
-- 
2.35.1

