Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248476088E6
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiJVIZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbiJVIWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:22:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63BA13A58A;
        Sat, 22 Oct 2022 00:59:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA9F3B82DF9;
        Sat, 22 Oct 2022 07:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11740C433C1;
        Sat, 22 Oct 2022 07:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425524;
        bh=wpNuhBG9/6aQ2W+7cbuETNqCLtVcvtJT1YSt5RjOQ6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0q5V2HQ+bkOJSmdCytPHEyTlRt5hvZ+/DuEydR5VVgK4zCGrja01Zcf4ff0iootc
         vcBip9IFcmcr8r47ubvq138IeHGtfrp7mWUZ6YfkcDyPquXmQOqfQJBGrlp19PaCl6
         32B8Sxs4Ce3tU3UHOSxb2J/XTTDwXwDrLv5vNZFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yujun <linyujun809@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 522/717] clocksource/drivers/timer-gxp: Add missing error handling in gxp_timer_probe
Date:   Sat, 22 Oct 2022 09:26:41 +0200
Message-Id: <20221022072521.392405978@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Yujun <linyujun809@huawei.com>

[ Upstream commit 0e2c8e6d769bcdc4f6634a02c545356282275e68 ]

Add platform_device_put() to make sure to free the platform
device in the event platform_device_add() fails.

Fixes: 5184f4bf151b ("clocksource/drivers/timer-gxp: Add HPE GXP Timer")
Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Link: https://lore.kernel.org/r/20220914033018.97484-1-linyujun809@huawei.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-gxp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-gxp.c b/drivers/clocksource/timer-gxp.c
index 8b38b3212388..fe4fa8d7b3f1 100644
--- a/drivers/clocksource/timer-gxp.c
+++ b/drivers/clocksource/timer-gxp.c
@@ -171,6 +171,7 @@ static int gxp_timer_probe(struct platform_device *pdev)
 {
 	struct platform_device *gxp_watchdog_device;
 	struct device *dev = &pdev->dev;
+	int ret;
 
 	if (!gxp_timer) {
 		pr_err("Gxp Timer not initialized, cannot create watchdog");
@@ -187,7 +188,11 @@ static int gxp_timer_probe(struct platform_device *pdev)
 	gxp_watchdog_device->dev.platform_data = gxp_timer->counter;
 	gxp_watchdog_device->dev.parent = dev;
 
-	return platform_device_add(gxp_watchdog_device);
+	ret = platform_device_add(gxp_watchdog_device);
+	if (ret)
+		platform_device_put(gxp_watchdog_device);
+
+	return ret;
 }
 
 static const struct of_device_id gxp_timer_of_match[] = {
-- 
2.35.1



