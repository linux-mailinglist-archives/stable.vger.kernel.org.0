Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9736D4F2CD7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiDEI0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239405AbiDEIUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FE78F994;
        Tue,  5 Apr 2022 01:12:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE1BD609D0;
        Tue,  5 Apr 2022 08:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFABAC385A1;
        Tue,  5 Apr 2022 08:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146358;
        bh=ZrBx/V3acJlgQ12UnqLhqWAttKiqFm6Qs4xSb9E1cPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgdxbDhhvB0GR/u/gOpOrn3yF4QFFOz6BRXAqMTNM1bOPL3xG7M2SyIapINJrZnin
         pzw962blBxw06lwbHzJKWnmtUzkuT0I5QDYAQPH2eHDAt5dXSI6lX4csb9TjknN1tP
         sxoMMIckLnMw69pvbKfk6BCQyLXOrHkFL2A3wCTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qing Wang <wangqing@vivo.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0735/1126] serial: 8250_lpss: Balance reference count for PCI DMA device
Date:   Tue,  5 Apr 2022 09:24:42 +0200
Message-Id: <20220405070429.163520154@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5318f70da7e82649d794fc27d8a127c22aa3566e ]

The pci_get_slot() increases its reference count, the caller
must decrement the reference count by calling pci_dev_put().

Fixes: 9a1870ce812e ("serial: 8250: don't use slave_id of dma_slave_config")
Depends-on: a13e19cf3dc1 ("serial: 8250_lpss: split LPSS driver to separate module")
Reported-by: Qing Wang <wangqing@vivo.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220223151240.70248-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_lpss.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index d3bafec7619d..0f5af061e0b4 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -117,8 +117,7 @@ static int byt_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 {
 	struct dw_dma_slave *param = &lpss->dma_param;
 	struct pci_dev *pdev = to_pci_dev(port->dev);
-	unsigned int dma_devfn = PCI_DEVFN(PCI_SLOT(pdev->devfn), 0);
-	struct pci_dev *dma_dev = pci_get_slot(pdev->bus, dma_devfn);
+	struct pci_dev *dma_dev;
 
 	switch (pdev->device) {
 	case PCI_DEVICE_ID_INTEL_BYT_UART1:
@@ -137,6 +136,8 @@ static int byt_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 		return -EINVAL;
 	}
 
+	dma_dev = pci_get_slot(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
+
 	param->dma_dev = &dma_dev->dev;
 	param->m_master = 0;
 	param->p_master = 1;
@@ -152,6 +153,14 @@ static int byt_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 	return 0;
 }
 
+static void byt_serial_exit(struct lpss8250 *lpss)
+{
+	struct dw_dma_slave *param = &lpss->dma_param;
+
+	/* Paired with pci_get_slot() in the byt_serial_setup() above */
+	put_device(param->dma_dev);
+}
+
 static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 {
 	struct uart_8250_dma *dma = &lpss->data.dma;
@@ -170,6 +179,13 @@ static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 	return 0;
 }
 
+static void ehl_serial_exit(struct lpss8250 *lpss)
+{
+	struct uart_8250_port *up = serial8250_get_port(lpss->data.line);
+
+	up->dma = NULL;
+}
+
 #ifdef CONFIG_SERIAL_8250_DMA
 static const struct dw_dma_platform_data qrk_serial_dma_pdata = {
 	.nr_channels = 2,
@@ -344,8 +360,7 @@ static int lpss8250_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_exit:
-	if (lpss->board->exit)
-		lpss->board->exit(lpss);
+	lpss->board->exit(lpss);
 	pci_free_irq_vectors(pdev);
 	return ret;
 }
@@ -356,8 +371,7 @@ static void lpss8250_remove(struct pci_dev *pdev)
 
 	serial8250_unregister_port(lpss->data.line);
 
-	if (lpss->board->exit)
-		lpss->board->exit(lpss);
+	lpss->board->exit(lpss);
 	pci_free_irq_vectors(pdev);
 }
 
@@ -365,12 +379,14 @@ static const struct lpss8250_board byt_board = {
 	.freq = 100000000,
 	.base_baud = 2764800,
 	.setup = byt_serial_setup,
+	.exit = byt_serial_exit,
 };
 
 static const struct lpss8250_board ehl_board = {
 	.freq = 200000000,
 	.base_baud = 12500000,
 	.setup = ehl_serial_setup,
+	.exit = ehl_serial_exit,
 };
 
 static const struct lpss8250_board qrk_board = {
-- 
2.34.1



