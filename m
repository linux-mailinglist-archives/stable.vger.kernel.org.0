Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FB23CA95A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242504AbhGOTGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241820AbhGOTFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D00C613DC;
        Thu, 15 Jul 2021 19:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375705;
        bh=LzPTVCKk5pTrMWa6qyP+fACmjrQbtz4UR69fbiu+ICk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9kvkhfWyKwYNlFohKIzGsPGK2mPN/51IrnbI+mYrM+DL1GI4vumM205PZkuqgYXc
         Gw/UmZ6oaiDBC/k+JNGfmlpmNi/0broBVvrQu6woFljMWc1yIIY526taxyR7+0Ucvy
         pGBUAx1Wlidh+qfPEf1RVMJ2fk8xJbs+VgTj5gQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.12 199/242] thermal/drivers/int340x/processor_thermal: Fix tcc setting
Date:   Thu, 15 Jul 2021 20:39:21 +0200
Message-Id: <20210715182628.257866003@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit fe6a6de6692e7f7159c1ff42b07ecd737df712b4 upstream.

The following fixes are done for tcc sysfs interface:
- TCC is 6 bits only from bit 29-24
- TCC of 0 is valid
- When BIT(31) is set, this register is read only
- Check for invalid tcc value
- Error for negative values

Fixes: fdf4f2fb8e899 ("drivers: thermal: processor_thermal_device: Export sysfs interface for TCC offset")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210628215803.75038-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c |   20 ++++++----
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -100,24 +100,27 @@ static ssize_t tcc_offset_degree_celsius
 	if (err)
 		return err;
 
-	val = (val >> 24) & 0xff;
+	val = (val >> 24) & 0x3f;
 	return sprintf(buf, "%d\n", (int)val);
 }
 
-static int tcc_offset_update(int tcc)
+static int tcc_offset_update(unsigned int tcc)
 {
 	u64 val;
 	int err;
 
-	if (!tcc)
+	if (tcc > 63)
 		return -EINVAL;
 
 	err = rdmsrl_safe(MSR_IA32_TEMPERATURE_TARGET, &val);
 	if (err)
 		return err;
 
-	val &= ~GENMASK_ULL(31, 24);
-	val |= (tcc & 0xff) << 24;
+	if (val & BIT(31))
+		return -EPERM;
+
+	val &= ~GENMASK_ULL(29, 24);
+	val |= (tcc & 0x3f) << 24;
 
 	err = wrmsrl_safe(MSR_IA32_TEMPERATURE_TARGET, val);
 	if (err)
@@ -126,14 +129,15 @@ static int tcc_offset_update(int tcc)
 	return 0;
 }
 
-static int tcc_offset_save;
+static unsigned int tcc_offset_save;
 
 static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
 {
+	unsigned int tcc;
 	u64 val;
-	int tcc, err;
+	int err;
 
 	err = rdmsrl_safe(MSR_PLATFORM_INFO, &val);
 	if (err)
@@ -142,7 +146,7 @@ static ssize_t tcc_offset_degree_celsius
 	if (!(val & BIT(30)))
 		return -EACCES;
 
-	if (kstrtoint(buf, 0, &tcc))
+	if (kstrtouint(buf, 0, &tcc))
 		return -EINVAL;
 
 	err = tcc_offset_update(tcc);


