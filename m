Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDC766CB38
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbjAPRLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbjAPRLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:11:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E005B46708
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26D2B61037
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F54C433D2;
        Mon, 16 Jan 2023 16:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887897;
        bh=A7k0JLRPG1AYWghF/fcDyvp8aoeko8s39hYAt8NoGzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NogywRrqSh9W5eOU2rVlYOUQ7NgFITxdPqbjWM9nEhOdxIQX5ga7KeJPcpfX73I/X
         E0BCFopMj4FZf7TaYbYvJA3baOXfJUvUmwA3SZL1cbwbP6FMHVQ78aqFfDOx+tDESo
         S6mDjCt5/6D1Ap3MQtMz271P23CuJ3OWKxc5LPxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 296/521] rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()
Date:   Mon, 16 Jan 2023 16:49:18 +0100
Message-Id: <20230116154900.363196320@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 5fb733d7bd6949e90028efdce8bd528c6ab7cf1e ]

The clk_disable_unprepare() should be called in the error handling
of clk_get_rate(), fix it.

Fixes: b5b2bdfc2893 ("rtc: st: Add new driver for ST's LPC RTC")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221123014805.1993052-1-cuigaosheng1@huawei.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-st-lpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-st-lpc.c b/drivers/rtc/rtc-st-lpc.c
index bee75ca7ff79..e66439b6247a 100644
--- a/drivers/rtc/rtc-st-lpc.c
+++ b/drivers/rtc/rtc-st-lpc.c
@@ -249,6 +249,7 @@ static int st_rtc_probe(struct platform_device *pdev)
 
 	rtc->clkrate = clk_get_rate(rtc->clk);
 	if (!rtc->clkrate) {
+		clk_disable_unprepare(rtc->clk);
 		dev_err(&pdev->dev, "Unable to fetch clock rate\n");
 		return -EINVAL;
 	}
-- 
2.35.1



