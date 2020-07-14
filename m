Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080E821FBDA
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgGNSzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730833AbgGNSzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5E3A22BEF;
        Tue, 14 Jul 2020 18:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752916;
        bh=bhSzwi+A4XN32hFzoNnB5HCq3CxGtguLBScwRiUtXq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGnMxe316GpOWXQqGITaVB3l/AAqb8nqlfyLrNLrXJCOgOcjfVfcBjAyBr6ygF0ED
         01eCOXj+S5mTKu5Feb5Xa+i9xz3Bpq1m7fWCR14JObsQAunSpQnMTrpPFkaYJT7ww0
         C0BnYzAJ646jb8xZu67Q3sC/UxzPw6K73D58V+t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 049/166] gpio: pca953x: Fix direction setting when configure an IRQ
Date:   Tue, 14 Jul 2020 20:43:34 +0200
Message-Id: <20200714184118.223750703@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0b22c25e1b81c5f718e89c4d759e6a359be24417 ]

The commit 0f25fda840a9 ("gpio: pca953x: Zap ad-hoc reg_direction cache")
seems inadvertently made a typo in pca953x_irq_bus_sync_unlock().

When the direction bit is 1 it means input, and the piece of code in question
was looking for output ones that should be turned to inputs.

Fix direction setting when configure an IRQ by injecting a bitmap complement
operation.

Fixes: 0f25fda840a9 ("gpio: pca953x: Zap ad-hoc reg_direction cache")
Depends-on: 35d13d94893f ("gpio: pca953x: convert to use bitmap API")
Cc: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 8571e54512476..a10411958e3f2 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -686,8 +686,6 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	int level;
 
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
-
 	if (chip->driver_data & PCA_PCAL) {
 		/* Enable latch on interrupt-enabled inputs */
 		pca953x_write_regs(chip, PCAL953X_IN_LATCH, chip->irq_mask);
@@ -698,7 +696,11 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 		pca953x_write_regs(chip, PCAL953X_INT_MASK, irq_mask);
 	}
 
+	/* Switch direction to input if needed */
+	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+
 	bitmap_or(irq_mask, chip->irq_trig_fall, chip->irq_trig_raise, gc->ngpio);
+	bitmap_complement(reg_direction, reg_direction, gc->ngpio);
 	bitmap_and(irq_mask, irq_mask, reg_direction, gc->ngpio);
 
 	/* Look for any newly setup interrupt */
-- 
2.25.1



