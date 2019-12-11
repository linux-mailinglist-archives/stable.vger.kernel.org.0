Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DA411B670
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731876AbfLKQAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731486AbfLKPNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E6124688;
        Wed, 11 Dec 2019 15:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077221;
        bh=mnM0pqkvhIGDKUdKdcPkorlp2nZEimXF2wDbAzyLPhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyShlHHzVkfGX0tMiugZz43TtejvqUHUsUngIHrma/KGEHz/m26zqixuvevZlWuxU
         Sv8dQGVC5buZGyTd9Zfc1RNnxqMd+ZS++/n+1oufapGBBLrTMn6kjZFxSS4BMQEhM/
         2NkDkIbfb25Qezz6d9ni+lSIlpyPj/5frLo231kM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 101/134] gpio/mpc8xxx: fix qoriq GPIO reading
Date:   Wed, 11 Dec 2019 10:11:17 -0500
Message-Id: <20191211151150.19073-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 787b64a43f7acacf8099329ea08872e663f1e74f ]

Qoriq requires the IBE register to be set to enable GPIO inputs to be
read.  Set it.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1iX3HC-00069N-0T@rmk-PC.armlinux.org.uk
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 16a47de29c94c..b863421ae7309 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -386,6 +386,9 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 
 	gc->to_irq = mpc8xxx_gpio_to_irq;
 
+	if (of_device_is_compatible(np, "fsl,qoriq-gpio"))
+		gc->write_reg(mpc8xxx_gc->regs + GPIO_IBE, 0xffffffff);
+
 	ret = gpiochip_add_data(gc, mpc8xxx_gc);
 	if (ret) {
 		pr_err("%pOF: GPIO chip registration failed with status %d\n",
-- 
2.20.1

