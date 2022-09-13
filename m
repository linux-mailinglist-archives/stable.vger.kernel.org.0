Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AD65B7547
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiIMPjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236723AbiIMPis (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:38:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA84D186F3;
        Tue, 13 Sep 2022 07:44:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95253614EA;
        Tue, 13 Sep 2022 14:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC43C433C1;
        Tue, 13 Sep 2022 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079424;
        bh=qUDf5XTkMr1y3mYRDLD8wyQJgOaBBW1W3YD8wCMg+Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SopX2Q+5zCHd5dLoPS+tM5a9R8mVjATtkEon8LRpKvdCSnozkCohW0MqYoSt8GhNO
         Xd7c1NjiBaa8IWGa9+FYFb90ZLm3sD3HflphxFpInUJZbPgJ1bXR+NgIxt4kHnMLGA
         bg7E7ARHYUhcczaQ72H/sr+Dyr9Hr6AJTri/pgug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Nicolas Diaz <nicolas.diaz@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 4.19 20/79] serial: fsl_lpuart: RS485 RTS polariy is inverse
Date:   Tue, 13 Sep 2022 16:06:38 +0200
Message-Id: <20220913140349.855097989@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
@@ -1102,9 +1102,9 @@ static int lpuart_config_rs485(struct ua
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


