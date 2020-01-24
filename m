Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE5147630
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgAXBSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:18:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730926AbgAXBSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:18:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 831AF21D7E;
        Fri, 24 Jan 2020 01:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828684;
        bh=5VmfApHX4ZzJLyJpFJ8t3OaOyeFXTWF7+VPoG/+fcn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBqLWSWF2Pz0xPV/Jai+XtvZvyQg6ZePzMefZh0U8Uf4enYgF0h4OB2Jl9iOvYfBy
         JquBMELRujNxm9wgi5gKV5Sy1P9RyOc9KlLLo4RQY8eLYeJ7yFjcQmN9RwaECsW1Tf
         XTJyUVqP19TxXaZoVf9WhCIHTyt4B+8MRPHoGfPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Chris Chiu <chiu@endlessm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 2/5] mfd: intel-lpss: Add default I2C device properties for Gemini Lake
Date:   Thu, 23 Jan 2020 20:17:58 -0500
Message-Id: <20200124011801.18712-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011801.18712-1-sashal@kernel.org>
References: <20200124011801.18712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 3f31bc67e4dc6a555341dffefe328ddd58e8b431 ]

It turned out Intel Gemini Lake doesn't use the same I2C timing
parameters as Broxton.

I got confirmation from the Windows team that Gemini Lake systems should
use updated timing parameters that differ from those used in Broxton
based systems.

Fixes: f80e78aa11ad ("mfd: intel-lpss: Add Intel Gemini Lake PCI IDs")
Tested-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss-pci.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
index 2b7e8eeaa59e9..0504761516f7b 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -126,6 +126,18 @@ static const struct intel_lpss_platform_info apl_i2c_info = {
 	.properties = apl_i2c_properties,
 };
 
+static struct property_entry glk_i2c_properties[] = {
+	PROPERTY_ENTRY_U32("i2c-sda-hold-time-ns", 313),
+	PROPERTY_ENTRY_U32("i2c-sda-falling-time-ns", 171),
+	PROPERTY_ENTRY_U32("i2c-scl-falling-time-ns", 290),
+	{ },
+};
+
+static const struct intel_lpss_platform_info glk_i2c_info = {
+	.clk_rate = 133000000,
+	.properties = glk_i2c_properties,
+};
+
 static const struct intel_lpss_platform_info cnl_i2c_info = {
 	.clk_rate = 216000000,
 	.properties = spt_i2c_properties,
@@ -165,14 +177,14 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x1ac6), (kernel_ulong_t)&bxt_info },
 	{ PCI_VDEVICE(INTEL, 0x1aee), (kernel_ulong_t)&bxt_uart_info },
 	/* GLK */
-	{ PCI_VDEVICE(INTEL, 0x31ac), (kernel_ulong_t)&bxt_i2c_info },
-	{ PCI_VDEVICE(INTEL, 0x31ae), (kernel_ulong_t)&bxt_i2c_info },
-	{ PCI_VDEVICE(INTEL, 0x31b0), (kernel_ulong_t)&bxt_i2c_info },
-	{ PCI_VDEVICE(INTEL, 0x31b2), (kernel_ulong_t)&bxt_i2c_info },
-	{ PCI_VDEVICE(INTEL, 0x31b4), (kernel_ulong_t)&bxt_i2c_info },
-	{ PCI_VDEVICE(INTEL, 0x31b6), (kernel_ulong_t)&bxt_i2c_info },
-	{ PCI_VDEVICE(INTEL, 0x31b8), (kernel_ulong_t)&bxt_i2c_info },
-	{ PCI_VDEVICE(INTEL, 0x31ba), (kernel_ulong_t)&bxt_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x31ac), (kernel_ulong_t)&glk_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x31ae), (kernel_ulong_t)&glk_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x31b0), (kernel_ulong_t)&glk_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x31b2), (kernel_ulong_t)&glk_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x31b4), (kernel_ulong_t)&glk_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x31b6), (kernel_ulong_t)&glk_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x31b8), (kernel_ulong_t)&glk_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x31ba), (kernel_ulong_t)&glk_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0x31bc), (kernel_ulong_t)&bxt_uart_info },
 	{ PCI_VDEVICE(INTEL, 0x31be), (kernel_ulong_t)&bxt_uart_info },
 	{ PCI_VDEVICE(INTEL, 0x31c0), (kernel_ulong_t)&bxt_uart_info },
-- 
2.20.1

