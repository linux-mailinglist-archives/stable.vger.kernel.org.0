Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C589CFA495
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfKMBza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbfKMBz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F0722470;
        Wed, 13 Nov 2019 01:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610129;
        bh=EYGUwQYilh4pekqnanWVL0ztc04HiI88xFpbAfHhJyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlGhVcLxHQNAjPQpHGBSi4u1KQYLT33gxNHoB3B39tUBGT2uQjFQHeUo7zlBc2KYd
         /aH5pRJm/L+RBM8u+HQDr8FFqcXnDgBftxt8SoBleQfeWq2zWCPzo7BYP8+s7nlP19
         5MOh5N7wNzNMLZLeCFLTAi3Nm9VBnQSRgDRFAH0Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 179/209] gpio: syscon: Fix possible NULL ptr usage
Date:   Tue, 12 Nov 2019 20:49:55 -0500
Message-Id: <20191113015025.9685-179-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 70728c29465bc4bfa7a8c14304771eab77e923c7 ]

The priv->data->set can be NULL while flags contains GPIO_SYSCON_FEAT_OUT
and chip->set is valid pointer. This happens in case the controller uses
the default GPIO setter. Always use chip->set to access the setter to avoid
possible NULL pointer dereferencing.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-syscon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-syscon.c b/drivers/gpio/gpio-syscon.c
index 87c18a5445137..7f3da34c78746 100644
--- a/drivers/gpio/gpio-syscon.c
+++ b/drivers/gpio/gpio-syscon.c
@@ -122,7 +122,7 @@ static int syscon_gpio_dir_out(struct gpio_chip *chip, unsigned offset, int val)
 				   BIT(offs % SYSCON_REG_BITS));
 	}
 
-	priv->data->set(chip, offset, val);
+	chip->set(chip, offset, val);
 
 	return 0;
 }
-- 
2.20.1

