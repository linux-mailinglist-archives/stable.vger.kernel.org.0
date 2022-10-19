Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A215603F4F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiJSJbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbiJSJ2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:28:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C2CE6F6B;
        Wed, 19 Oct 2022 02:12:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13A416182F;
        Wed, 19 Oct 2022 09:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26617C433D6;
        Wed, 19 Oct 2022 09:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170483;
        bh=wpNuhBG9/6aQ2W+7cbuETNqCLtVcvtJT1YSt5RjOQ6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCtufBv9LIRRgLq0F3T+DsJmUAjZrsZjD7C2wYZ4ucA4Y6fZUQei/uhpjrkmgVQDX
         1xguqL4tV+It8NlcS9tMtGXGjXw3lldaNgjVFgkfkELLOUSNuUHzetXq4/CufiWv7z
         riLHZna7RO924B8wkfxzwTzDCbacCMW5+z3CVsCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yujun <linyujun809@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 640/862] clocksource/drivers/timer-gxp: Add missing error handling in gxp_timer_probe
Date:   Wed, 19 Oct 2022 10:32:07 +0200
Message-Id: <20221019083318.199357367@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



