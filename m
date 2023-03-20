Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CC46C189A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbjCTP0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbjCTPZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:25:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B15B2F78F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9FE72CE12EF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617B0C433D2;
        Mon, 20 Mar 2023 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325531;
        bh=KTYWWFvzK9g9XVDLU4q5d6cycX96LXFxNauZDMOY11M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THSRo7sO1jtgMXjl+UOD0HOk6RYodoqufItOkUy4qV9wST5mVHJcJ7Hlzo6LX1IIb
         44/r6INQWjbN1MkKZhjRVQjwGxFh/i8JBnq6LrOvbfrhLy7ZYE4vck9RHkJ0G4ZPOT
         flvHDmL6qjX0Y7XH2AzMqd243+Z04ZLficvbnuxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/198] hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition
Date:   Mon, 20 Mar 2023 15:53:53 +0100
Message-Id: <20230320145511.537058812@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 5cde837bfd094..d1abea49f01be 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -761,6 +761,7 @@ static int xgene_hwmon_remove(struct platform_device *pdev)
 {
 	struct xgene_hwmon_dev *ctx = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&ctx->workq);
 	hwmon_device_unregister(ctx->hwmon_dev);
 	kfifo_free(&ctx->async_msg_fifo);
 	if (acpi_disabled)
-- 
2.39.2



