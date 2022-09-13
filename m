Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE3A5B7319
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbiIMPAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiIMO7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:59:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EE974365;
        Tue, 13 Sep 2022 07:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D94D614D4;
        Tue, 13 Sep 2022 14:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EC8C433C1;
        Tue, 13 Sep 2022 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079147;
        bh=thDh15MSPH6KZKlEJMV8KoCLQ1nMTMaT1qagdRvUDu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okIjNpZRhfgAQuUnkigYOUql0hEtUb2Q5pP2G5pyhbOrGmce50yJ2CU79tzPS2fp4
         eqv4JkXrt5yHZjnzPf4rxvDaGNfhBkn4Bmww1pyu70bK6BgLzEJfwWyq6fJTS4F+Ck
         RkAgk67xFpPm4YRrXAVXL+6jEmw3FU3adrrcUOfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Nicolas Diaz <nicolas.diaz@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 5.4 021/108] serial: fsl_lpuart: RS485 RTS polariy is inverse
Date:   Tue, 13 Sep 2022 16:05:52 +0200
Message-Id: <20220913140354.519307517@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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
@@ -1277,9 +1277,9 @@ static int lpuart_config_rs485(struct ua
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


