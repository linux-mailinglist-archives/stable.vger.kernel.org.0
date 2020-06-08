Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AC71F2761
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731890AbgFHXpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731997AbgFHX0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:26:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C454D2078D;
        Mon,  8 Jun 2020 23:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658796;
        bh=qwUWf6gPEAo0RWe2h0rpmiMF6XJTd6r4hEWaMEbOJBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6G3QVILLq7sUxxjl/Etm6vxsO/2FMQRCTH72f6cayd5APDe0oZZrF6QT0a+yamI6
         KKYEWUxGXNr7tGi81Mj/Odm913ug9yPAEhsI00Rx1/1EiNkfNA0ISdBgOysaq4YWjU
         dQWm4VS6d2L2Vl7asDezlA5C0wfsozPgzsTFzngQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 70/72] platform/x86: hp-wmi: Convert simple_strtoul() to kstrtou32()
Date:   Mon,  8 Jun 2020 19:24:58 -0400
Message-Id: <20200608232500.3369581-70-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5cdc45ed3948042f0d73c6fec5ee9b59e637d0d2 ]

First of all, unsigned long can overflow u32 value on 64-bit machine.
Second, simple_strtoul() doesn't check for overflow in the input.

Convert simple_strtoul() to kstrtou32() to eliminate above issues.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 06a3c1ef8eee..952544ca0d84 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -474,8 +474,14 @@ static ssize_t postcode_show(struct device *dev, struct device_attribute *attr,
 static ssize_t als_store(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
-	u32 tmp = simple_strtoul(buf, NULL, 10);
-	int ret = hp_wmi_perform_query(HPWMI_ALS_QUERY, HPWMI_WRITE, &tmp,
+	u32 tmp;
+	int ret;
+
+	ret = kstrtou32(buf, 10, &tmp);
+	if (ret)
+		return ret;
+
+	ret = hp_wmi_perform_query(HPWMI_ALS_QUERY, HPWMI_WRITE, &tmp,
 				       sizeof(tmp), sizeof(tmp));
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
-- 
2.25.1

