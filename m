Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98188603F6E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiJSJbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbiJSJ3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246C0BBF26;
        Wed, 19 Oct 2022 02:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 009D9617B0;
        Wed, 19 Oct 2022 08:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C93C433D6;
        Wed, 19 Oct 2022 08:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169397;
        bh=ofERgBikDVQ+ar+COdBWG8wzBxL4NHGfWH2UTVp+d7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkkoVOIeJYzvZCRT1cQ97KZrI4AYsyObrrRV1RPDDu4qsg9HsdKqM/3txwmaOtZOe
         Km0uJTUBE59zmaxweMaTVELuwi0aC5suQfBNs9eRJ4syBCyJoJJhy7cMbSv49mGwK0
         M5YrNpxm83GO8cP/eVKCCrrxBAwxg6sbfzGdRA8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 260/862] wifi: rtw89: pci: fix interrupt stuck after leaving low power mode
Date:   Wed, 19 Oct 2022 10:25:47 +0200
Message-Id: <20221019083301.537271863@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit b7e715d3dcd2e9fa3a689ba0dd7ab85f8aaf6e9a ]

We turn off interrupt in ISR, and re-enable interrupt in threadfn or
napi_poll according to the mode it stays. If we are turning off interrupt,
rtwpci->running flag is unset and interrupt handler stop processing even
if it was called, so disallow to re-enable interrupt in this situation.
Or, wifi chip doesn't trigger interrupt events anymore because interrupt
status (ISR) isn't clear by interrupt handler anymore.

Fixes: c83dcd0508e2 ("rtw89: pci: add a separate interrupt handler for low power mode")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220824063312.15784-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index c68fec9eb5a6..8a093e1cb328 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -760,7 +760,8 @@ static irqreturn_t rtw89_pci_interrupt_threadfn(int irq, void *dev)
 
 enable_intr:
 	spin_lock_irqsave(&rtwpci->irq_lock, flags);
-	rtw89_chip_enable_intr(rtwdev, rtwpci);
+	if (likely(rtwpci->running))
+		rtw89_chip_enable_intr(rtwdev, rtwpci);
 	spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
 	return IRQ_HANDLED;
 }
-- 
2.35.1



