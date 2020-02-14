Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C032415F0EE
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387936AbgBNR6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388146AbgBNP5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CEFB24688;
        Fri, 14 Feb 2020 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695830;
        bh=aubW97k/Xs3s9/rVKeTyIj14taE5kacqXBl/gi0ji2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU6dYAJcfbcYDWQrS+IPtnMnzHsq1DPeF3jrAUD6jhb0P6g5ZIv8kUiC01MAw5+ht
         z0W1NgswLw3GYETIboUL16jbnRY7qt1+gRiD9Gaoc9A7fHMlq6ywhrhSvwUcZR+R5b
         JFdzZF3aGXILrS0W8sOv/9/N5ivI2VtcjpOHtrBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Hao <haokexin@gmail.com>, kbuild test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 383/542] gpio: Fix the no return statement warning
Date:   Fri, 14 Feb 2020 10:46:15 -0500
Message-Id: <20200214154854.6746-383-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 9c6722d85e92233082da2b3623685bba54d6093e ]

In commit 242587616710 ("gpiolib: Add support for the irqdomain which
doesn't use irq_fwspec as arg") we have changed the return type of
gpiochip_populate_parent_fwspec_twocell/fourcell() from void to void *,
but forgot to add a return statement for these two dummy functions.
Add "return NULL" to fix the build warnings.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Link: https://lore.kernel.org/r/20200116095003.30324-1-haokexin@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/gpio/driver.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index e2480ef94c559..5dce9c67a961e 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -553,6 +553,7 @@ static inline void gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chi
 						    unsigned int parent_hwirq,
 						    unsigned int parent_type)
 {
+	return NULL;
 }
 
 static inline void gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
@@ -560,6 +561,7 @@ static inline void gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *ch
 						     unsigned int parent_hwirq,
 						     unsigned int parent_type)
 {
+	return NULL;
 }
 
 #endif /* CONFIG_IRQ_DOMAIN_HIERARCHY */
-- 
2.20.1

