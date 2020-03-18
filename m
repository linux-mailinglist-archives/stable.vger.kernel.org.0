Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF97E18A5F3
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgCRUzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbgCRUzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA275208FE;
        Wed, 18 Mar 2020 20:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564902;
        bh=Fw2Y7SJT1KxgyT/KkiFlJP+vzAotUhytvqgs9F+e2yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2ppZ9trnB7rYkhUn0JRl+dHabjvRGdzdUPoWN1Rv5dCyJcibjWkAo/NnAF+noHk1
         d0S1SHgAQlxxwsPvBfwm4K1Aj8XPp4uBUksD/Wa/eOy+CJ4zYil8V/YEx8Uw/y347z
         ZAR/hKZgCyiZGOlm9TOG61fIWAMIznZ6KWsurgjo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 69/73] i2c: acpi: put device when verifying client fails
Date:   Wed, 18 Mar 2020 16:53:33 -0400
Message-Id: <20200318205337.16279-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 8daee952b4389729358665fb91949460641659d4 ]

i2c_verify_client() can fail, so we need to put the device when that
happens.

Fixes: 525e6fabeae2 ("i2c / ACPI: add support for ACPI reconfigure notifications")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 62a1c92ab803d..ce70b5288472c 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -394,9 +394,17 @@ EXPORT_SYMBOL_GPL(i2c_acpi_find_adapter_by_handle);
 static struct i2c_client *i2c_acpi_find_client_by_adev(struct acpi_device *adev)
 {
 	struct device *dev;
+	struct i2c_client *client;
 
 	dev = bus_find_device_by_acpi_dev(&i2c_bus_type, adev);
-	return dev ? i2c_verify_client(dev) : NULL;
+	if (!dev)
+		return NULL;
+
+	client = i2c_verify_client(dev);
+	if (!client)
+		put_device(dev);
+
+	return client;
 }
 
 static int i2c_acpi_notify(struct notifier_block *nb, unsigned long value,
-- 
2.20.1

