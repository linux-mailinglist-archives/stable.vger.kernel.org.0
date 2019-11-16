Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AADFF2D8
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfKPPn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:43:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728738AbfKPPn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:28 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D20E20815;
        Sat, 16 Nov 2019 15:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919007;
        bh=vmPorgr1AqtidpatjFnUpqU7k2gwi5CeAXMZW/HP/W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oL+VRJzvCi3FJYjGL9WLaaGqg/Pget3WjSLzJmwVlsiiTzP3eac8yrrZW201yzwln
         t+lG5AAI5WnsNDc3W3kr4l5aCqEZ3kQJK6uU8grH3qwY4B8AIy53TeIq+h78/xi4sH
         /0U4tDboTKJBIwzLM7fimBVolBTH0XClbzzxH+ZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 110/237] mfd: mc13xxx-core: Fix PMIC shutdown when reading ADC values
Date:   Sat, 16 Nov 2019 10:39:05 -0500
Message-Id: <20191116154113.7417-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <fabio.estevam@nxp.com>

[ Upstream commit 55143439b7b501882bea9d95a54adfe00ffc79a3 ]

When trying to read any MC13892 ADC channel on a imx51-babbage board:

The MC13892 PMIC shutdowns completely.

After debugging this issue and comparing the MC13892 and MC13783
initializations done in the vendor kernel, it was noticed that the
CHRGRAWDIV bit of the ADC0 register was not being set.

This bit is set by default after power on, but the driver was
clearing it.

After setting this bit it is possible to read the ADC values correctly.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
Tested-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mc13xxx-core.c  | 3 ++-
 include/linux/mfd/mc13xxx.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 234febfe6398b..d0bf50e3568d7 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -278,7 +278,8 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 	if (ret)
 		goto out;
 
-	adc0 = MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2;
+	adc0 = MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2 |
+	       MC13XXX_ADC0_CHRGRAWDIV;
 	adc1 = MC13XXX_ADC1_ADEN | MC13XXX_ADC1_ADTRIGIGN | MC13XXX_ADC1_ASC;
 
 	/*
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index 54a3cd808f9e6..2ad9bdc0a5ec8 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -249,6 +249,7 @@ struct mc13xxx_platform_data {
 #define MC13XXX_ADC0_TSMOD0		(1 << 12)
 #define MC13XXX_ADC0_TSMOD1		(1 << 13)
 #define MC13XXX_ADC0_TSMOD2		(1 << 14)
+#define MC13XXX_ADC0_CHRGRAWDIV		(1 << 15)
 #define MC13XXX_ADC0_ADINC1		(1 << 16)
 #define MC13XXX_ADC0_ADINC2		(1 << 17)
 
-- 
2.20.1

