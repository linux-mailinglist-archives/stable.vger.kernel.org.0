Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCCB5956BD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiHPJj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbiHPJja (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E9F1365F8;
        Tue, 16 Aug 2022 01:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9116F611F2;
        Tue, 16 Aug 2022 08:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A48C433C1;
        Tue, 16 Aug 2022 08:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660638492;
        bh=kn/cDzx5wgLfYQgDaZMLwVmKJJDcenaMUgsJ7D0lmXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWKY8C2GcbgTNqhHhuZhYFir9funE6n/P4pENhoRIJd/oAk2M+cpmYlGh0tHRvzur
         LNzpuaA/0+J6Y2PrMjqHHO+lWiRWkJpjGm2beJvCpG4rKjlahzhyrAo8/NN2UijSLV
         +P15i/QlyobPuje8dvZKtv3dlGcUxhsbo4euUq2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 713/779] serial: 8250_pci: Refactor the loop in pci_ite887x_init()
Date:   Mon, 15 Aug 2022 20:05:57 +0200
Message-Id: <20220815180407.929169761@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 35b4f17231923e2f64521bdf7a2793ce2c3c74a6 ]

The loop can be refactored by using ARRAY_SIZE() instead of NULL terminator.
This reduces code base and makes it easier to read and understand.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jiri Slaby <jslaby@kernel.org>
Link: https://lore.kernel.org/r/20211022135147.70965-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index e7b9805903f4..ef44e5320bef 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -897,18 +897,16 @@ static int pci_netmos_init(struct pci_dev *dev)
 /* enable IO_Space bit */
 #define ITE_887x_POSIO_ENABLE		(1 << 31)
 
+/* inta_addr are the configuration addresses of the ITE */
+static const short inta_addr[] = { 0x2a0, 0x2c0, 0x220, 0x240, 0x1e0, 0x200, 0x280 };
 static int pci_ite887x_init(struct pci_dev *dev)
 {
-	/* inta_addr are the configuration addresses of the ITE */
-	static const short inta_addr[] = { 0x2a0, 0x2c0, 0x220, 0x240, 0x1e0,
-							0x200, 0x280, 0 };
 	int ret, i, type;
 	struct resource *iobase = NULL;
 	u32 miscr, uartbar, ioport;
 
 	/* search for the base-ioport */
-	i = 0;
-	while (inta_addr[i] && iobase == NULL) {
+	for (i = 0; i < ARRAY_SIZE(inta_addr); i++) {
 		iobase = request_region(inta_addr[i], ITE_887x_IOSIZE,
 								"ite887x");
 		if (iobase != NULL) {
@@ -925,12 +923,10 @@ static int pci_ite887x_init(struct pci_dev *dev)
 				break;
 			}
 			release_region(iobase->start, ITE_887x_IOSIZE);
-			iobase = NULL;
 		}
-		i++;
 	}
 
-	if (!inta_addr[i]) {
+	if (i == ARRAY_SIZE(inta_addr)) {
 		dev_err(&dev->dev, "ite887x: could not find iobase\n");
 		return -ENODEV;
 	}
-- 
2.35.1



