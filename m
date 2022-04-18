Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490B350563F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242504AbiDRNcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241740AbiDRN06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:26:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C56A3E0E8;
        Mon, 18 Apr 2022 05:53:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4346BB80EC4;
        Mon, 18 Apr 2022 12:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FA0C385A1;
        Mon, 18 Apr 2022 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286385;
        bh=UzMnFVffMmcsXMlUXyH5IAYvyjZH2koP31kGk3TknZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfCvYRMEQzYL0ra+WYSPa5teUAy9HjFzdRnJpGubeFcXjmYK4yR2s8U2AXfS2B3ga
         R4xjTw+pzjAKhmHIUFZ0r3ub9FLFU4+4b/IVWXh/CSHSCnNnZ4k6vpCY9t7Jqduw7w
         4ZoGWaLDVdPhRqJgx2q3AbUEC2fNK2cpjPnxpP50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 117/284] power: supply: wm8350-power: Add missing free in free_charger_irq
Date:   Mon, 18 Apr 2022 14:11:38 +0200
Message-Id: <20220418121214.384872915@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 6dee930f6f6776d1e5a7edf542c6863b47d9f078 ]

In free_charger_irq(), there is no free for 'WM8350_IRQ_CHG_FAST_RDY'.
Therefore, it should be better to add it in order to avoid the memory leak.

Fixes: 14431aa0c5a4 ("power_supply: Add support for WM8350 PMU")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/wm8350_power.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/wm8350_power.c b/drivers/power/supply/wm8350_power.c
index c2a62e6568c6..5d025fcd8f3f 100644
--- a/drivers/power/supply/wm8350_power.c
+++ b/drivers/power/supply/wm8350_power.c
@@ -526,6 +526,7 @@ static void free_charger_irq(struct wm8350 *wm8350)
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_TO, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_END, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_START, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85, wm8350);
-- 
2.34.1



