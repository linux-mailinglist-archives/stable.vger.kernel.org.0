Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4683F608611
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiJVHni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiJVHnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:43:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D396E5A3CD;
        Sat, 22 Oct 2022 00:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67ED160AD9;
        Sat, 22 Oct 2022 07:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A90FC433C1;
        Sat, 22 Oct 2022 07:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424266;
        bh=1rW26+ZwcA6tiLBS6hz+rgjIIBis7sdQ7KSHF1iXPo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qf55N6BaL/4nE5OVEDTSRDSvSagKkXkrBB0KnZwiVvDQoHje8yCuWq5ngozZOzuD/
         X9r5jYUdvErB8nIeVnVIkp6QNPYTZHLXD6ndkD2Bj7BudhR1QFOZn5oljnpqO+5Ogd
         UF+GTinzxrGajTO8Ht3P8NtfnO7EwzSLsLEyrAyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 5.19 082/717] serial: cpm_uart: Dont request IRQ too early for console port
Date:   Sat, 22 Oct 2022 09:19:21 +0200
Message-Id: <20221022072429.827158672@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 30963b2f75bfdbbcf1cc5d80bf88fec7aaba808d upstream.

The following message is seen during boot and the activation of
console port gets delayed until normal serial ports activation.

[    0.001346] irq: no irq domain found for pic@930 !

The console port doesn't need irq, perform irq reservation later,
during cpm_uart probe.

While at it, don't use NO_IRQ but 0 which is the value returned
by irq_of_parse_and_map() in case of error. By chance powerpc's
NO_IRQ has value 0 but on some architectures it is -1.

Fixes: 14d893fc6846 ("powerpc/8xx: Convert CPM1 interrupt controller to platform_device")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/8bed0f30c2e9ef16ae64fb1243a16d54a48eb8da.1664526717.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1214,12 +1214,6 @@ static int cpm_uart_init_port(struct dev
 	pinfo->port.fifosize = pinfo->tx_nrfifos * pinfo->tx_fifosize;
 	spin_lock_init(&pinfo->port.lock);
 
-	pinfo->port.irq = irq_of_parse_and_map(np, 0);
-	if (pinfo->port.irq == NO_IRQ) {
-		ret = -EINVAL;
-		goto out_pram;
-	}
-
 	for (i = 0; i < NUM_GPIOS; i++) {
 		struct gpio_desc *gpiod;
 
@@ -1229,7 +1223,7 @@ static int cpm_uart_init_port(struct dev
 
 		if (IS_ERR(gpiod)) {
 			ret = PTR_ERR(gpiod);
-			goto out_irq;
+			goto out_pram;
 		}
 
 		if (gpiod) {
@@ -1255,8 +1249,6 @@ static int cpm_uart_init_port(struct dev
 
 	return cpm_uart_request_port(&pinfo->port);
 
-out_irq:
-	irq_dispose_mapping(pinfo->port.irq);
 out_pram:
 	cpm_uart_unmap_pram(pinfo, pram);
 out_mem:
@@ -1436,11 +1428,17 @@ static int cpm_uart_probe(struct platfor
 	/* initialize the device pointer for the port */
 	pinfo->port.dev = &ofdev->dev;
 
+	pinfo->port.irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
+	if (!pinfo->port.irq)
+		return -EINVAL;
+
 	ret = cpm_uart_init_port(ofdev->dev.of_node, pinfo);
-	if (ret)
-		return ret;
+	if (!ret)
+		return uart_add_one_port(&cpm_reg, &pinfo->port);
+
+	irq_dispose_mapping(pinfo->port.irq);
 
-	return uart_add_one_port(&cpm_reg, &pinfo->port);
+	return ret;
 }
 
 static int cpm_uart_remove(struct platform_device *ofdev)


