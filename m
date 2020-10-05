Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FED283A5C
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgJEPd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbgJEPdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCEA32085B;
        Mon,  5 Oct 2020 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912001;
        bh=2SZ4vk7oql5z2JTtf35v3BNzZoNWaj5yxxKXDNLXKng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Myc2H59C5Cxhf5ZHEJ8C6d68dy+rPG7fvIaYozwfKw5jatwsSYWH6McbWFAXD5kv5
         kqPg62eUtIyc7Pfi8tHYqGGrd8Zbzc/UehcIivKGRZeEGHSOSovjWz2C32DZHHp1OO
         OThKW8vlopFG8rptKx4xB9AbGascr4V0TL0h3qek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Li <ye.li@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 62/85] gpio: pca953x: Fix uninitialized pending variable
Date:   Mon,  5 Oct 2020 17:26:58 +0200
Message-Id: <20201005142117.711433312@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Li <ye.li@nxp.com>

[ Upstream commit e43c26e12dd49a41cf5a4cd5c5b59a1eb98ed11e ]

When pca953x_irq_pending returns false, the pending parameter won't
be set. But pca953x_irq_handler continues using this uninitialized
variable as pending irqs and will cause problem.
Fix the issue by initializing pending to 0.

Fixes: 064c73afe738 ("gpio: pca953x: Synchronize interrupt handler properly")
Signed-off-by: Ye Li <ye.li@nxp.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index a3b9bdedbe443..cc95f1630feb0 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -813,7 +813,7 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 {
 	struct pca953x_chip *chip = devid;
 	struct gpio_chip *gc = &chip->gpio_chip;
-	DECLARE_BITMAP(pending, MAX_LINE);
+	DECLARE_BITMAP(pending, MAX_LINE) = {};
 	int level;
 	bool ret;
 
-- 
2.25.1



