Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E902130094
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 04:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbgADDgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 22:36:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbgADDgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 22:36:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D0DE24649;
        Sat,  4 Jan 2020 03:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578109006;
        bh=c0Ud1NVHItYJqJyXLCIvPtkmPShtxJmr7y4q6ARA49M=;
        h=From:To:Cc:Subject:Date:From;
        b=q7/jnwuag/ITzngCKgoAUXvHf4FjqkNwJRnCkvcJ173r/KbDxm6SvBdUCjXYwbGkZ
         YrF0okFNb+g6WypET7Bx1kNnzEKH2i9NHdezeywdYhh+wfiQ6tklhMsTvn7gBdCJy3
         hilYbZGVe+oK3QdwP6XVuJNxCwFpCQRZLF3KLkPM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Johnson=20CH=20Chen=20=28=E9=99=B3=E6=98=AD=E5=8B=B3=29?= 
        <JohnsonCH.Chen@moxa.com>, Johnson Chen <johnsonch.chen@moxa.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/5] gpio: mpc8xxx: Add platform device to gpiochip->parent
Date:   Fri,  3 Jan 2020 22:36:40 -0500
Message-Id: <20200104033644.11121-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johnson CH Chen (陳昭勳) <JohnsonCH.Chen@moxa.com>

[ Upstream commit 322f6a3182d42df18059a89c53b09d33919f755e ]

Dear Linus Walleij,

In old kernels, some APIs still try to use parent->of_node from struct gpio_chip,
and it could be resulted in kernel panic because parent is NULL. Adding platform
device to gpiochip->parent can fix this problem.

Signed-off-by: Johnson Chen <johnsonch.chen@moxa.com>
Link: https://patchwork.kernel.org/patch/11234609
Link: https://lore.kernel.org/r/HK0PR01MB3521489269F76467DFD7843FFA450@HK0PR01MB3521.apcprd01.prod.exchangelabs.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index c8673a5d9412..ccae16a94a74 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -317,6 +317,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	gc = &mpc8xxx_gc->gc;
+	gc->parent = &pdev->dev;
 
 	if (of_property_read_bool(np, "little-endian")) {
 		ret = bgpio_init(gc, &pdev->dev, 4,
-- 
2.20.1

