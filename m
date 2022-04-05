Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1BE4F37B5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359472AbiDELTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiDEJtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4E263B1;
        Tue,  5 Apr 2022 02:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDD89B81C19;
        Tue,  5 Apr 2022 09:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F63C385A1;
        Tue,  5 Apr 2022 09:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151711;
        bh=TkRjkbHf35GwvaY8YoQCXT3xu4BK4ElnagkTLzoI8O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kThMRwPtZJGQj15fEuBAH5B8gLaTkixYiQWFAkVlh8tMGFGKHqeHUFFl42BCplfqB
         N0Rumc3GbIWMQY4BByUcZyCUPGqLQLGrbKmC8v9vFxH2z/rTu1luUOZidoijDKwR8v
         +2hDBqEGxQUWt1Dr0WM7jDDlHWOZgwzjVwNPOGaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 514/913] power: supply: wm8350-power: Add missing free in free_charger_irq
Date:   Tue,  5 Apr 2022 09:26:16 +0200
Message-Id: <20220405070355.261188313@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 9c46c48dccb1..908cfd45d262 100644
--- a/drivers/power/supply/wm8350_power.c
+++ b/drivers/power/supply/wm8350_power.c
@@ -524,6 +524,7 @@ static void free_charger_irq(struct wm8350 *wm8350)
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_TO, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_END, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_START, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85, wm8350);
-- 
2.34.1



