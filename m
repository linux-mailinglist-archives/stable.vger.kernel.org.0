Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DB66C1680
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjCTPGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjCTPG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:06:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998542C644
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A13036158B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB3CC433EF;
        Mon, 20 Mar 2023 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324470;
        bh=2cIBWWk+UGGa8Ddj2f57odbXM2mb/Idb5klosJIgAYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drN3SRJJEJ4W3c0My20UkUZVnIjqphUY4bpqJCZMHSUkMOBw1uuMu9jhIZF46/jJZ
         slg7yHVXpzPS5kyIpObBOA5T/rtwkHYaPblzBEwQCvO8URtN6WV0hgvyG/NKoG++hq
         V0u9eJmY/NbPbYzuoW8/0Hb+ViTRC6vGT94QMaLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/60] hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition
Date:   Mon, 20 Mar 2023 15:54:43 +0100
Message-Id: <20230320145432.358331119@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit cb090e64cf25602b9adaf32d5dfc9c8bec493cd1 ]

In xgene_hwmon_probe, &ctx->workq is bound with xgene_hwmon_evt_work.
Then it will be started.

If we remove the driver which will call xgene_hwmon_remove to clean up,
there may be unfinished work.

The possible sequence is as follows:

Fix it by finishing the work before cleanup in xgene_hwmon_remove.

CPU0                  CPU1

                    |xgene_hwmon_evt_work
xgene_hwmon_remove   |
kfifo_free(&ctx->async_msg_fifo);|
                    |
                    |kfifo_out_spinlocked
                    |//use &ctx->async_msg_fifo
Fixes: 2ca492e22cb7 ("hwmon: (xgene) Fix crash when alarm occurs before driver probe")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Link: https://lore.kernel.org/r/20230310084007.1403388-1-zyytlz.wz@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index f2a5af239c956..f5d3cf86753f7 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -768,6 +768,7 @@ static int xgene_hwmon_remove(struct platform_device *pdev)
 {
 	struct xgene_hwmon_dev *ctx = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&ctx->workq);
 	hwmon_device_unregister(ctx->hwmon_dev);
 	kfifo_free(&ctx->async_msg_fifo);
 	if (acpi_disabled)
-- 
2.39.2



