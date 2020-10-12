Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7BB28C058
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390839AbgJLTD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390144AbgJLTDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE94421BE5;
        Mon, 12 Oct 2020 19:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529389;
        bh=GxyUJ336LKwVyiU9N8vXJbaW07K1JUB7kHNAeeWC/Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkMuuLDwZ9RTuK4sRq/SVAfPIhq4Mthc6s5UQy4GtJ+CMnfrYzmcbQ+TrzwY/+ZYA
         tcaJrkSgbl56sR3QFuykZrlMa4RISaPB0f+p00XCM+O7VSYYAvob+ID3gOXITBLOop
         QSSTE3Ia48yAm6GWQZ9uaQdnM5JcPmSlUPuYewbA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 23/24] gpio: pca953x: Survive spurious interrupts
Date:   Mon, 12 Oct 2020 15:02:38 -0400
Message-Id: <20201012190239.3279198-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 8b81edd80baf12d64420daff1759380aa9a14998 ]

The pca953x driver never checks the result of irq_find_mapping(),
which returns 0 when no mapping is found. When a spurious interrupt
is delivered (which can happen under obscure circumstances), the
kernel explodes as it still tries to handle the error code as
a real interrupt.

Handle this particular case and warn on spurious interrupts.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201005140217.1390851-1-maz@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 11c3bbd105f11..1de182b85e4c4 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -821,8 +821,21 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 	ret = pca953x_irq_pending(chip, pending);
 	mutex_unlock(&chip->i2c_lock);
 
-	for_each_set_bit(level, pending, gc->ngpio)
-		handle_nested_irq(irq_find_mapping(gc->irq.domain, level));
+	if (ret) {
+		ret = 0;
+
+		for_each_set_bit(level, pending, gc->ngpio) {
+			int nested_irq = irq_find_mapping(gc->irq.domain, level);
+
+			if (unlikely(nested_irq <= 0)) {
+				dev_warn_ratelimited(gc->parent, "unmapped interrupt %d\n", level);
+				continue;
+			}
+
+			handle_nested_irq(nested_irq);
+			ret = 1;
+		}
+	}
 
 	return IRQ_RETVAL(ret);
 }
-- 
2.25.1

