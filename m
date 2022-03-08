Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC8B4D15D3
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 12:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346303AbiCHLLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 06:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346300AbiCHLLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 06:11:06 -0500
X-Greylist: delayed 550 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 03:10:03 PST
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E3F457B4;
        Tue,  8 Mar 2022 03:10:03 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.195.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C59A93F650;
        Tue,  8 Mar 2022 11:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646737252;
        bh=GaYM2Dx1zt1949KCl9Cue2trqHMpQ7C/c/kIfuWSIfk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=AvBjFgdO+OxZL5Hub4sP30zlQCBtQweyeNNT4fYQjpoWtXdc0C0pl+FtDXuhaNiog
         h3dJXxci9LhTWcxBZfh3Ts1HjXITCFQWIzaJXOWkEUZv3bCL1IIBfe0JEM05wp0bqo
         3GIRtsPI2QoCHZmukThrxDeCyIM+oO08cGQxMnR9H0G1LwdIW0P7w7x6HLpNzlNd01
         G9CiRr/yahOuaiRGaqhlcNPZoR3QiSCyQPcZp/aFHmqjB1Q7CG5IEOoZ3WSKI35+4o
         IpJOYCRSGHHI95kvRq8p29AGfAKlGHPmvN3fh5VfNN/MscBwiERLLDhGa6YVq8R/HI
         DaBU2gbq5zR/Q==
From:   Hui Wang <hui.wang@canonical.com>
To:     linux-serial@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, jringle@gridpoint.com,
        u.kleine-koenig@pengutronix.de, hui.wang@canonical.com
Subject: [PATCH] serial: sc16is7xx: Clear RS485 bits in the shutdown
Date:   Tue,  8 Mar 2022 19:00:42 +0800
Message-Id: <20220308110042.108451-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We tested RS485 function on an EVB which has SC16IS752, after
finishing the test, we started the RS232 function test, but found the
RTS is still working in the RS485 mode.

That is because both startup and shutdown call port_update() to set
the EFCR_REG, this will not clear the RS485 bits once the bits are set
in the reconf_rs485(). To fix it, clear the RS485 bits in shutdown.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/tty/serial/sc16is7xx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 3a6c68e19c80..6adc51d9ecf3 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1055,10 +1055,12 @@ static void sc16is7xx_shutdown(struct uart_port *port)
 
 	/* Disable all interrupts */
 	sc16is7xx_port_write(port, SC16IS7XX_IER_REG, 0);
-	/* Disable TX/RX */
+	/* Disable TX/RX, clear auto RS485 and RTS invert */
 	sc16is7xx_port_update(port, SC16IS7XX_EFCR_REG,
 			      SC16IS7XX_EFCR_RXDISABLE_BIT |
-			      SC16IS7XX_EFCR_TXDISABLE_BIT,
+			      SC16IS7XX_EFCR_TXDISABLE_BIT |
+			      SC16IS7XX_EFCR_AUTO_RS485_BIT |
+			      SC16IS7XX_EFCR_RTS_INVERT_BIT,
 			      SC16IS7XX_EFCR_RXDISABLE_BIT |
 			      SC16IS7XX_EFCR_TXDISABLE_BIT);
 
-- 
2.25.1

