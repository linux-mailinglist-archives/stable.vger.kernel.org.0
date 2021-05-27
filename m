Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA04392B2E
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhE0J5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbhE0J5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 05:57:08 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88657C061574;
        Thu, 27 May 2021 02:55:34 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id s6so119314edu.10;
        Thu, 27 May 2021 02:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C58IMTIWG3aGpI31cvyq0/QCn2aAGcF3IZlr8Z32K/Y=;
        b=AucBLzD1N+8LtmRlcHZj0bnRH597i8Rv5zSBdhDLzjoBgCqC8pa0xXJzg8WoHd4EiA
         hzlkKVKxj6si3zT9ui9jP7tJQco7DXEN3fgi5H9k307nc0pGu26YUL6MGbF2jRuQfr/c
         C5RZf2e0A554MP0GdifknkmBmgwZvO7IPXfVvZudjBpQSJ6cBl3D+EQtS515fvgSJ7ZC
         HcTljKeD0z/mBtvPBrl1yODTAsFCsnt+Pt5zBxEt0yES4tMbuKHfPJ+KIBVyJsXZi08f
         JUXVj6V7mSZEBszlWV1qKkghI0FuvdD3p0zBoJ04J6hiKZPYMwynaPDT9Rglc3de/pEC
         pQsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C58IMTIWG3aGpI31cvyq0/QCn2aAGcF3IZlr8Z32K/Y=;
        b=VjCxbIna+o7XJqwp189lmfVT9tIsrh7V+bKWlVZsNGtqdUgSvDlomc1nNN0zQa3CUk
         ON/Ecz9NfiL5pDUkQq6LcJD8aVMaB5hwl13MvDJAkR7pUZ2Bc4EzZhQZc0AsdNH0qbL/
         ONDysMQGu0Th43AiURyQtFqto87J+McIVCYG9P7ycDHjpvt6963tfWUoCwYA2wK3FX+p
         3A9NfRWB0y4p5dwfU2D8S15XWPVPQKZuOPtVHDcLeRulNOeOhOoUawUW0DrHc8HGzmsE
         OXeuNsRHVd1KU91k+FH1p6DjNfJtAFEXwh01PDp2HrAK7OiQD0Wiq1ZTcv2nX1p7bKpp
         FvFg==
X-Gm-Message-State: AOAM532+EmfLSvhqN1sDQ68RnwYEr83E6SnPFj+MVjjmuf0rnIs8cCUu
        h0kUdVD5GohoDfkY27VpdqWjqGjTJoEyfQ==
X-Google-Smtp-Source: ABdhPJxLJFoLPIpTk320Qan+reXcWHDotN+ksDZCmebp6yt3LtUtr0B6dIkx+wMTpySH/TodtK4L3w==
X-Received: by 2002:a05:6402:74f:: with SMTP id p15mr3166309edy.333.1622109332779;
        Thu, 27 May 2021 02:55:32 -0700 (PDT)
Received: from localhost.localdomain.at (62-178-82-229.cable.dynamic.surfer.at. [62.178.82.229])
        by smtp.gmail.com with ESMTPSA id l19sm70623edw.58.2021.05.27.02.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 02:55:32 -0700 (PDT)
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Gmeiner <christian.gmeiner@gmail.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Tobias Diedrich <tobiasdiedrich@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Du Huanpeng <u74147@gmail.com>,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        linux-serial@vger.kernel.org
Subject: [PATCH] serial: 8250_pci: handle FL_NOIRQ board flag
Date:   Thu, 27 May 2021 11:54:40 +0200
Message-Id: <20210527095529.26281-1-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 8428413b1d14 ("serial: 8250_pci: Implement MSI(-X) support")
the way the irq gets allocated was changed. With that change the
handling FL_NOIRQ got lost. Restore the old behaviour.

Fixes: 8428413b1d14 ("serial: 8250_pci: Implement MSI(-X) support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/tty/serial/8250/8250_pci.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 689d8227f95f..3b8217844c0b 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -3944,21 +3944,26 @@ pciserial_init_ports(struct pci_dev *dev, const struct pciserial_board *board)
 	uart.port.flags = UPF_SKIP_TEST | UPF_BOOT_AUTOCONF | UPF_SHARE_IRQ;
 	uart.port.uartclk = board->base_baud * 16;
 
-	if (pci_match_id(pci_use_msi, dev)) {
-		dev_dbg(&dev->dev, "Using MSI(-X) interrupts\n");
-		pci_set_master(dev);
-		rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (board->flags & FL_NOIRQ) {
+		uart.port.irq = 0;
 	} else {
-		dev_dbg(&dev->dev, "Using legacy interrupts\n");
-		rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_LEGACY);
-	}
-	if (rc < 0) {
-		kfree(priv);
-		priv = ERR_PTR(rc);
-		goto err_deinit;
+		if (pci_match_id(pci_use_msi, dev)) {
+			dev_dbg(&dev->dev, "Using MSI(-X) interrupts\n");
+			pci_set_master(dev);
+			rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_ALL_TYPES);
+		} else {
+			dev_dbg(&dev->dev, "Using legacy interrupts\n");
+			rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_LEGACY);
+		}
+		if (rc < 0) {
+			kfree(priv);
+			priv = ERR_PTR(rc);
+			goto err_deinit;
+		}
+
+		uart.port.irq = pci_irq_vector(dev, 0);
 	}
 
-	uart.port.irq = pci_irq_vector(dev, 0);
 	uart.port.dev = &dev->dev;
 
 	for (i = 0; i < nr_ports; i++) {
-- 
2.31.1

