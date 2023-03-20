Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED5E6C191E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbjCTPat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbjCTPaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:30:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E069C38B7F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E047B80ED6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24E1C433EF;
        Mon, 20 Mar 2023 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325781;
        bh=KTYWWFvzK9g9XVDLU4q5d6cycX96LXFxNauZDMOY11M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWOETkreCnyu6f0wC3T/QCkKfecXcUHU3G0i4pf2YEQavHU1JsIxrRUBc0OiB4SYC
         qnPmlA9UfIj7pXUM2Ut1M4ngyHhV46/X8PayUALxavQcIkvRzhlk9eY8ujgUpF8JAi
         wLUEGHdudRM6z8Dt+UhpMFmHiN2F+wR/12TH4HmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 100/211] hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition
Date:   Mon, 20 Mar 2023 15:53:55 +0100
Message-Id: <20230320145517.479971710@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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



