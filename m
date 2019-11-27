Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACFC410B90C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbfK0UtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730226AbfK0UtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:49:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B875220678;
        Wed, 27 Nov 2019 20:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887759;
        bh=vm84ASlpradK3YRp36649IF0WvfGXEHeTtm8gY3B1AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaRVgaB4NqfpZOUEwBYRqMZhT+6R0xXFmfJeFF4WtBoXcZf7sjfjWNeXtoh7xFLQ1
         Birfn+i2JIAOvP1qpcVls8uNLYQa1L2UDpMZZ8hvAcjk6VPiTkRtk/kv0jl+b5/T0U
         RjT4xPdPM5/8vOBpbSWV/2v64Eq0Pn+AhfLJk+CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/211] mfd: mc13xxx-core: Fix PMIC shutdown when reading ADC values
Date:   Wed, 27 Nov 2019 21:30:15 +0100
Message-Id: <20191127203101.531647847@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6c16f170529f5..75d52034f89da 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -278,7 +278,8 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 	if (ret)
 		goto out;
 
-	adc0 = MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2;
+	adc0 = MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2 |
+	       MC13XXX_ADC0_CHRGRAWDIV;
 	adc1 = MC13XXX_ADC1_ADEN | MC13XXX_ADC1_ADTRIGIGN | MC13XXX_ADC1_ASC;
 
 	if (channel > 7)
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index 638222e43e489..93011c61aafd2 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -247,6 +247,7 @@ struct mc13xxx_platform_data {
 #define MC13XXX_ADC0_TSMOD0		(1 << 12)
 #define MC13XXX_ADC0_TSMOD1		(1 << 13)
 #define MC13XXX_ADC0_TSMOD2		(1 << 14)
+#define MC13XXX_ADC0_CHRGRAWDIV		(1 << 15)
 #define MC13XXX_ADC0_ADINC1		(1 << 16)
 #define MC13XXX_ADC0_ADINC2		(1 << 17)
 
-- 
2.20.1



