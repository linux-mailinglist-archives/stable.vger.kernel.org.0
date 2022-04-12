Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E3E4FD124
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbiDLG5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351490AbiDLGxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603CD17E35;
        Mon, 11 Apr 2022 23:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A901B818C8;
        Tue, 12 Apr 2022 06:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825C3C385A1;
        Tue, 12 Apr 2022 06:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745683;
        bh=t0g3o+vjO6oyTmJLg+UH2gahFuYs6k7jNgBfmjGR/W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySvK2ty2necCgqhvjyriP/iOi9cvmiP/ulgXTorz9WiWN2UQjbdbMmBPSqn+xfLH0
         h/fs3m8T6zQj2WjJkAxpFNJCkfvZ39wnF0ig7tZg+cjBv11wwkZd7tpbufUC0dk0Od
         t3U9TxkP+KE9J4Rmr0HfD4rMTaiIuXauEWU8iGWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/277] rtc: wm8350: Handle error for wm8350_register_irq
Date:   Tue, 12 Apr 2022 08:26:46 +0200
Message-Id: <20220412062942.127953634@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 43f0269b6b89c1eec4ef83c48035608f4dcdd886 ]

As the potential failure of the wm8350_register_irq(),
it should be better to check it and return error if fails.
Also, it need not free 'wm_rtc->rtc' since it will be freed
automatically.

Fixes: 077eaf5b40ec ("rtc: rtc-wm8350: add support for WM8350 RTC")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220303085030.291793-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-wm8350.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 2018614f258f..6eaa9321c074 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -432,14 +432,21 @@ static int wm8350_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_SEC,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_RTC_SEC,
 			    wm8350_rtc_update_handler, 0,
 			    "RTC Seconds", wm8350);
+	if (ret)
+		return ret;
+
 	wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
 
-	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_ALM,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_RTC_ALM,
 			    wm8350_rtc_alarm_handler, 0,
 			    "RTC Alarm", wm8350);
+	if (ret) {
+		wm8350_free_irq(wm8350, WM8350_IRQ_RTC_SEC, wm8350);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.35.1



