Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A0C13E239
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbgAPQyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729955AbgAPQyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A9E214AF;
        Thu, 16 Jan 2020 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193679;
        bh=VXkXkjK1OcAV5Ex2Khfw/MtuZoMJCOIv3Gy5tPbePYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDtFyByddKmLOOTo6UC2wf6wRYBuDIuf822H+REQ6fCIwr4LTUlhb0YoWbpQbvmBt
         nnDzcFywUNIXyavHRpCZzWqFYbvk8HYBJyYG0Ec/sxbj4eyM+fB/ADSSw+MSxBDfry
         UUPHkAfDEZdzdeiUgnkW7a6uV1O3xNp08aCMNbjU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrew Jeffery <andrew@aj.id.au>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 203/205] gpio: aspeed: avoid return type warning
Date:   Thu, 16 Jan 2020 11:42:58 -0500
Message-Id: <20200116164300.6705-203-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 11e299de3aced4ea23a9fb1fef6c983c8d516302 ]

gcc has a hard time tracking whether BUG_ON(1) ends
execution or not:

drivers/gpio/gpio-aspeed-sgpio.c: In function 'bank_reg':
drivers/gpio/gpio-aspeed-sgpio.c:112:1: error: control reaches end of non-void function [-Werror=return-type]

Use the simpler BUG() that gcc knows cannot continue.

Fixes: f8b410e3695a ("gpio: aspeed-sgpio: Rename and add Kconfig/Makefile")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/sgpio-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/sgpio-aspeed.c b/drivers/gpio/sgpio-aspeed.c
index 7e99860ca447..8319812593e3 100644
--- a/drivers/gpio/sgpio-aspeed.c
+++ b/drivers/gpio/sgpio-aspeed.c
@@ -107,7 +107,7 @@ static void __iomem *bank_reg(struct aspeed_sgpio *gpio,
 		return gpio->base + bank->irq_regs + GPIO_IRQ_STATUS;
 	default:
 		/* acturally if code runs to here, it's an error case */
-		BUG_ON(1);
+		BUG();
 	}
 }
 
-- 
2.20.1

