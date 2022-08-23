Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024E359D7DF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbiHWJmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352234AbiHWJlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:41:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01A379634;
        Tue, 23 Aug 2022 01:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF33061538;
        Tue, 23 Aug 2022 08:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037D7C433C1;
        Tue, 23 Aug 2022 08:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244074;
        bh=XZPsukZTb+hTMSm+/vEq+mEJkXlwXdR0DPErYIV/FtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrM3y7AqoNmqtXnElp4NLwNMMBtEH+Kow3n73sTFVdeAn77/ODI/5VzFI263ApZMJ
         MAkHdct+y440zcK6VuNoca0olCBVHptF7ZQHjuiDPKzuy2lzZRBhSedeTJmIjZgWUO
         +EqCFaLWyhtrmaGeqE55jeQ2OnE106MnwNQ+A67c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/229] can: hi311x: do not report txerr and rxerr during bus-off
Date:   Tue, 23 Aug 2022 10:24:03 +0200
Message-Id: <20220823080056.666348242@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit a22bd630cfff496b270211745536e50e98eb3a45 ]

During bus off, the error count is greater than 255 and can not fit in
a u8.

Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
Link: https://lore.kernel.org/all/20220719143550.3681-6-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/hi311x.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 472175e37055..5f730f791c27 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -688,8 +688,6 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 
 			txerr = hi3110_read(spi, HI3110_READ_TEC);
 			rxerr = hi3110_read(spi, HI3110_READ_REC);
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
 			tx_state = txerr >= rxerr ? new_state : 0;
 			rx_state = txerr <= rxerr ? new_state : 0;
 			can_change_state(net, cf, tx_state, rx_state);
@@ -702,6 +700,9 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 					hi3110_hw_sleep(spi);
 					break;
 				}
+			} else {
+				cf->data[6] = txerr;
+				cf->data[7] = rxerr;
 			}
 		}
 
-- 
2.35.1



