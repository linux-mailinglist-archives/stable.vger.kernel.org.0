Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929C82062A5
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389496AbgFWVGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391278AbgFWUgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:36:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 580BE20781;
        Tue, 23 Jun 2020 20:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944585;
        bh=JW5oZEcVIjKvNl5OWuJjJdw+UlXjXTk3oylQaUFQl1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y29wscPCn8jRZgGtLtkqpsy//+z1NKiZLMlG1Tyusu82A/hNdjUC/Ya/8NaC+UcHI
         YlIZR8SJaz/eZFGPnpFoFDdTm5K5wtYUAAB574TwASaDTuxvXdudlp9Ow20pfKsMeC
         etRuPaqztVuW+DJeQ+MpWzbiuns9meknYEq7g3Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/206] mfd: wm8994: Fix driver operation if loaded as modules
Date:   Tue, 23 Jun 2020 21:55:57 +0200
Message-Id: <20200623195318.411590800@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit d4f9b5428b53dd67f49ee8deed8d4366ed6b1933 ]

WM8994 chip has built-in regulators, which might be used for chip
operation. They are controlled by a separate wm8994-regulator driver,
which should be loaded before this driver calls regulator_get(), because
that driver also provides consumer-supply mapping for the them. If that
driver is not yet loaded, regulator core substitute them with dummy
regulator, what breaks chip operation, because the built-in regulators are
never enabled. Fix this by annotating this driver with MODULE_SOFTDEP()
"pre" dependency to "wm8994_regulator" module.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wm8994-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 22bd6525e09cf..933a50049d729 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -704,3 +704,4 @@ module_i2c_driver(wm8994_i2c_driver);
 MODULE_DESCRIPTION("Core support for the WM8994 audio CODEC");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_SOFTDEP("pre: wm8994_regulator");
-- 
2.25.1



