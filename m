Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F724F30B8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiDEI0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239404AbiDEIUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30189C7494;
        Tue,  5 Apr 2022 01:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1219B81BB1;
        Tue,  5 Apr 2022 08:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285F9C385A2;
        Tue,  5 Apr 2022 08:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146355;
        bh=KoGQ+0vWP49KzgTOCU/ifdDn7F7KOjvEzSHR2vQTS+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2lZZ+a0TlvrTbgRzJlP/FULyuXHqnPy++ctFe4vLY9WlYp9BcDB+Lv4k7oVFxu/O
         +ycmMn2S1NQulIHSKU587TuiwAF6myQjVwNxoaOe6sYET4k0UX9KQgCBJTmxoyfHqR
         GRP0c0Pr/2dyLmv3fW8iA4VHN5P5xhqbLaZzuKbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qing Wang <wangqing@vivo.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0734/1126] serial: 8250_mid: Balance reference count for PCI DMA device
Date:   Tue,  5 Apr 2022 09:24:41 +0200
Message-Id: <20220405070429.134442401@linuxfoundation.org>
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

[ Upstream commit 67ec6dd0b257bd81b4e9fcac89b29da72f6265e5 ]

The pci_get_slot() increases its reference count, the caller
must decrement the reference count by calling pci_dev_put().

Fixes: 90b9aacf912a ("serial: 8250_pci: add Intel Tangier support")
Fixes: f549e94effa1 ("serial: 8250_pci: add Intel Penwell ports")
Reported-by: Qing Wang <wangqing@vivo.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Depends-on: d9eda9bab237 ("serial: 8250_pci: Intel MID UART support to its own driver")
Link: https://lore.kernel.org/r/20220215100920.41984-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mid.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mid.c b/drivers/tty/serial/8250/8250_mid.c
index efa0515139f8..e6c1791609dd 100644
--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -73,6 +73,11 @@ static int pnw_setup(struct mid8250 *mid, struct uart_port *p)
 	return 0;
 }
 
+static void pnw_exit(struct mid8250 *mid)
+{
+	pci_dev_put(mid->dma_dev);
+}
+
 static int tng_handle_irq(struct uart_port *p)
 {
 	struct mid8250 *mid = p->private_data;
@@ -124,6 +129,11 @@ static int tng_setup(struct mid8250 *mid, struct uart_port *p)
 	return 0;
 }
 
+static void tng_exit(struct mid8250 *mid)
+{
+	pci_dev_put(mid->dma_dev);
+}
+
 static int dnv_handle_irq(struct uart_port *p)
 {
 	struct mid8250 *mid = p->private_data;
@@ -330,9 +340,9 @@ static int mid8250_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, mid);
 	return 0;
+
 err:
-	if (mid->board->exit)
-		mid->board->exit(mid);
+	mid->board->exit(mid);
 	return ret;
 }
 
@@ -342,8 +352,7 @@ static void mid8250_remove(struct pci_dev *pdev)
 
 	serial8250_unregister_port(mid->line);
 
-	if (mid->board->exit)
-		mid->board->exit(mid);
+	mid->board->exit(mid);
 }
 
 static const struct mid8250_board pnw_board = {
@@ -351,6 +360,7 @@ static const struct mid8250_board pnw_board = {
 	.freq = 50000000,
 	.base_baud = 115200,
 	.setup = pnw_setup,
+	.exit = pnw_exit,
 };
 
 static const struct mid8250_board tng_board = {
@@ -358,6 +368,7 @@ static const struct mid8250_board tng_board = {
 	.freq = 38400000,
 	.base_baud = 1843200,
 	.setup = tng_setup,
+	.exit = tng_exit,
 };
 
 static const struct mid8250_board dnv_board = {
-- 
2.34.1



