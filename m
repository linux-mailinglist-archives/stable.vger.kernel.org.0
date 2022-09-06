Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1F45AEA17
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbiIFNhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240678AbiIFNg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:36:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CD311A07;
        Tue,  6 Sep 2022 06:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5B4E61548;
        Tue,  6 Sep 2022 13:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE904C433C1;
        Tue,  6 Sep 2022 13:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471271;
        bh=HelgyPzEVycb3BjhZewL1eRduBpx8grzH+zzcATmFA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekI9AHaXs5m+Ce8XYFJgP8Hfk+fuAKhRwo+5NFxwyrNuBSmbgdURRa3ltEHLybaxV
         pOw9q3mUbqF0fsFS5HR4PGqBaAqqcXsNnPyDzK0+Aj6J9BIf5B/OymV2GJDllThI7M
         MCNcHL5pMNYgFNcW3OqVFxV6R6hP2D1excHEvf60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Nicolas Diaz <nicolas.diaz@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 5.10 21/80] serial: fsl_lpuart: RS485 RTS polariy is inverse
Date:   Tue,  6 Sep 2022 15:30:18 +0200
Message-Id: <20220906132817.830007730@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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

From: Shenwei Wang <shenwei.wang@nxp.com>

commit 846651eca073e2e02e37490a4a52752415d84781 upstream.

The setting of RS485 RTS polarity is inverse in the current driver.

When the property of 'rs485-rts-active-low' is enabled in the dts node,
the RTS signal should be LOW during sending. Otherwise, if there is no
such a property, the RTS should be HIGH during sending.

Fixes: 03895cf41d18 ("tty: serial: fsl_lpuart: Add support for RS-485")
Cc: stable <stable@kernel.org>
Signed-off-by: Nicolas Diaz <nicolas.diaz@nxp.com>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Link: https://lore.kernel.org/r/20220805144529.604856-1-shenwei.wang@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1376,9 +1376,9 @@ static int lpuart32_config_rs485(struct
 		 * Note: UART is assumed to be active high.
 		 */
 		if (rs485->flags & SER_RS485_RTS_ON_SEND)
-			modem &= ~UARTMODEM_TXRTSPOL;
-		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
 			modem |= UARTMODEM_TXRTSPOL;
+		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
+			modem &= ~UARTMODEM_TXRTSPOL;
 	}
 
 	/* Store the new configuration */


