Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE7B5012C6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241649AbiDNNw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245250AbiDNNnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:43:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736C324087;
        Thu, 14 Apr 2022 06:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1E6261D70;
        Thu, 14 Apr 2022 13:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4D9C385A1;
        Thu, 14 Apr 2022 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943571;
        bh=CcmxZVqWt0C3IfMQFSdot6JDjR60nIDCK88Be3lD5kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymWpk1wPV5jNHQbXgkrfZN+XBlk/HZy+YuIwILoQx9E0x+wJ18WMdn6faKOEStHd4
         /NooD/6uDXUMrqKLk0YmUgOVSq5nR7Nu2CcfkvbdMbW5IuqJQz/Moj7fQ2pFm9NkmL
         5/LSsb6CEg5EqErWSYLblAErfNi/HGOaHSdQa0cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/475] power: supply: wm8350-power: Add missing free in free_charger_irq
Date:   Thu, 14 Apr 2022 15:09:48 +0200
Message-Id: <20220414110900.810310992@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 0762ab13fa56..4fe9ea9721b3 100644
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



