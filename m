Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE4656FDA0
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiGKJ60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiGKJ6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:58:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01433C8DF;
        Mon, 11 Jul 2022 02:27:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EC306135F;
        Mon, 11 Jul 2022 09:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDE0C341C8;
        Mon, 11 Jul 2022 09:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531628;
        bh=cQt35amAe1aytsNuFRRAiFO5nBqm46vCBpFexZL0QAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kaq5PNiGVEk40YqDPlbWJvhTKFh9sNOm8yPyTPTxsPspjKRTjywjvg1ypXkcLPhHi
         BpAOYiPcBVdviIXilDlOsyBke68yqasCeHazX9uiUZu8YOqCDORhWeqRuooaQXQoKe
         SbashjVr8HxXlZrU8cw9iG4kRcSi3MRBOGghq3OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>
Subject: [PATCH 5.15 172/230] Revert "serial: sc16is7xx: Clear RS485 bits in the shutdown"
Date:   Mon, 11 Jul 2022 11:07:08 +0200
Message-Id: <20220711090608.941499183@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Hui Wang <hui.wang@canonical.com>

commit 41c606879f89623dd5269eaffea640b915e9e17c upstream.

This reverts commit 927728a34f11b5a27f4610bdb7068317d6fdc72a.

Once the uart_port->rs485->flag is set to SER_RS485_ENABLED, the port
should always work in RS485 mode. If users want the port to leave
RS485 mode, they need to call ioctl() to clear SER_RS485_ENABLED.

So here we shouldn't clear the RS485 bits in the shutdown().

Fixes: 927728a34f11 ("serial: sc16is7xx: Clear RS485 bits in the shutdown")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20220418094339.678144-1-hui.wang@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1055,12 +1055,10 @@ static void sc16is7xx_shutdown(struct ua
 
 	/* Disable all interrupts */
 	sc16is7xx_port_write(port, SC16IS7XX_IER_REG, 0);
-	/* Disable TX/RX, clear auto RS485 and RTS invert */
+	/* Disable TX/RX */
 	sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG,
 			      SC16IS7XX_EFCR_RXDISABLE_BIT |
-			      SC16IS7XX_EFCR_TXDISABLE_BIT |
-			      SC16IS7XX_EFCR_AUTO_RS485_BIT |
-			      SC16IS7XX_EFCR_RTS_INVERT_BIT,
+			      SC16IS7XX_EFCR_TXDISABLE_BIT,
 			      SC16IS7XX_EFCR_RXDISABLE_BIT |
 			      SC16IS7XX_EFCR_TXDISABLE_BIT);
 


