Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6644659A0BA
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351586AbiHSQNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351519AbiHSQLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:11:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7218B113DFC;
        Fri, 19 Aug 2022 08:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8808F616FD;
        Fri, 19 Aug 2022 15:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CB4C433C1;
        Fri, 19 Aug 2022 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924650;
        bh=wnngqfsE+bRxrgxv6Enaz7IS0b9Cs5VTQ2A8SW40pXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wolNbPex2RPpYkAFAtKeirAF2Fk+5LzKuBUuH6wiQu7027j/5lewlu9jtjUtUaBrg
         TMy2UW1QFF0LVryII5KbzcUKRqYHLizBPZsQMpKeBSciFqvRve9ejTMzKMCR1FPusF
         Kq3sjK3uiRizJUKEjKs4aKWPNt41tOLQlWmF3uKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/545] can: hi311x: do not report txerr and rxerr during bus-off
Date:   Fri, 19 Aug 2022 17:40:08 +0200
Message-Id: <20220819153840.008799325@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 7d2315c8cacb..28273e84171a 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -670,8 +670,6 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 
 			txerr = hi3110_read(spi, HI3110_READ_TEC);
 			rxerr = hi3110_read(spi, HI3110_READ_REC);
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
 			tx_state = txerr >= rxerr ? new_state : 0;
 			rx_state = txerr <= rxerr ? new_state : 0;
 			can_change_state(net, cf, tx_state, rx_state);
@@ -684,6 +682,9 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
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



