Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F460868D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiJVHux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiJVHsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:48:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3E817F9A5;
        Sat, 22 Oct 2022 00:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5ED1B82E19;
        Sat, 22 Oct 2022 07:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1968CC433D6;
        Sat, 22 Oct 2022 07:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424649;
        bh=ERDI38QKblPmR1f8XYJ2sDWZUWQpi0wgXYYc/TKJcSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0ZO2wB6Z+ZbnzJfGbCReBmMYssYQTmTSb7xBZXW8PC1v0gCBChoZuLBqhiyTT/Ww
         BUQ+55sxg1nds0f09crFgkb51tlbbZHeYJVHlhmQFyy3GkCdcccCDhWx6qHDyCVNjv
         +JKCCNXZjX/CFPYffjlhYowpxqSpv7QS4MF4ROkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 224/717] wifi: rtw89: pci: fix interrupt stuck after leaving low power mode
Date:   Sat, 22 Oct 2022 09:21:43 +0200
Message-Id: <20221022072454.761173516@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 0ef7821b2e0f..622f95bc3ffc 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -756,7 +756,8 @@ static irqreturn_t rtw89_pci_interrupt_threadfn(int irq, void *dev)
 
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



