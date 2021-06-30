Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFC43B7FFA
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 11:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhF3Jdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:33:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59506 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhF3Jdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 05:33:31 -0400
Date:   Wed, 30 Jun 2021 09:31:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1625045461;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EB8XgQm4pFJU7gJLBKBzuUOj9tNIlv/rtlis7yWGjKs=;
        b=WsWZe+8QeCjSSzjO4Vg562BXzrNWTIns7lb1N6tFvj6tV4oE6N5z6C+68qi7JoPC7PDBgV
        4A9mlE3ti8+HXPtkGwuxEWn7i/rxAuyE1cvZCyg/qMp6ZZF7PqCJhYQIh1NxjkFia5K9Jp
        SlRt3RGYcg37HizWZpBwb4x5Q7ywuY2dKaC/F6f8ZtiLPqSZsdOsCA8SOLtwPN6uWa2/zc
        Lp6pnmynEK9mA8a4j01M+4yW8L4wTXjNQbDxzdOxvxx8DECEOzmrVojYLNhr3FKFEaVTFI
        ISW449QtIZTp0IKWHGBxgbktOPrzcqUKyg9V/a1lB0hJi5RlpBtPWjNkSaxu9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1625045461;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EB8XgQm4pFJU7gJLBKBzuUOj9tNIlv/rtlis7yWGjKs=;
        b=8t4QAWek8CfOr6fYXplEwh90A0SHQDrIPIIZyYwRBy3+Yrqs8r9JlhIJK7w6OHykNB/e6w
        pI2vVfP9ehuudeBw==
From:   "thermal-bot for Srinivas Pandruvada" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-pm@vger.kernel.org
To:     linux-pm@vger.kernel.org
Subject: [thermal: thermal/next] thermal/drivers/int340x/processor_thermal:
 Fix tcc setting
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, amitk@kernel.org
In-Reply-To: <20210628215803.75038-1-srinivas.pandruvada@linux.intel.com>
References: <20210628215803.75038-1-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Message-ID: <162504546041.395.12283374445354400850.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the thermal/next branch of thermal:

Commit-ID:     1264017b3ab6d903760673a8515180af6e7a7f28
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git//1264017b3ab6d903760673a8515180af6e7a7f28
Author:        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
AuthorDate:    Mon, 28 Jun 2021 14:58:03 -07:00
Committer:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitterDate: Tue, 29 Jun 2021 08:15:53 +02:00

thermal/drivers/int340x/processor_thermal: Fix tcc setting

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
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index de4fc64..0f0038a 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -78,24 +78,27 @@ static ssize_t tcc_offset_degree_celsius_show(struct device *dev,
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
@@ -104,14 +107,15 @@ static int tcc_offset_update(int tcc)
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
@@ -120,7 +124,7 @@ static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 	if (!(val & BIT(30)))
 		return -EACCES;
 
-	if (kstrtoint(buf, 0, &tcc))
+	if (kstrtouint(buf, 0, &tcc))
 		return -EINVAL;
 
 	err = tcc_offset_update(tcc);
