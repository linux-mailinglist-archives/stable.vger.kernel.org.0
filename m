Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C5621FC64
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgGNTIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730230AbgGNSt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:49:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0A1422AAA;
        Tue, 14 Jul 2020 18:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752596;
        bh=GHn24gGp4o4CF2M+4AG8BhCear5O6ry4EQVDfn60o9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6w2kVS049SIEr3DpBqLWmi4GG8kYYt69FvOFZNWfzMysl/RkCywXqs4uWK2Y7mJT
         j53UEZ6Kg6W2MkPjX4eMEQuLlxt608c4Zl+q/R/rc3j++ibvn+DDdQZhgtEU7c+phI
         a9ZtUDJcYSgdCUpq1T+lTw4MyqrbxuQSMK7BtVWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/109] gpio: pca953x: Fix GPIO resource leak on Intel Galileo Gen 2
Date:   Tue, 14 Jul 2020 20:43:40 +0200
Message-Id: <20200714184107.296596201@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5d8913504ccfeea6120df5ae1c6f4479ff09b931 ]

When adding a quirk for IRQ on Intel Galileo Gen 2 the commit ba8c90c61847
("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
missed GPIO resource release. We can safely do this in the same quirk, since
IRQ will be locked by GPIO framework when requested and unlocked on freeing.

Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index c935019c0257c..81f5103dccb6f 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -176,7 +176,12 @@ static int pca953x_acpi_get_irq(struct device *dev)
 	if (ret)
 		return ret;
 
-	return gpio_to_irq(pin);
+	ret = gpio_to_irq(pin);
+
+	/* When pin is used as an IRQ, no need to keep it requested */
+	gpio_free(pin);
+
+	return ret;
 }
 #endif
 
-- 
2.25.1



