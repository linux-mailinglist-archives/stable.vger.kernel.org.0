Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19901F235F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgFHXOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbgFHXOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B05120C09;
        Mon,  8 Jun 2020 23:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658043;
        bh=ZEhSSl1cG6zZR1BIQ9zMUFW/bSq6ytLJgq3m5lTArCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsMnxDwHbg0Q6sGPApPqbn0V8f2+J/2V60M6J/JSmLRkZopuEnSL5k4MOntei1WHF
         OM1h1L8UpzXyFmu79bd2AK6Y7ZdbK/FwjBRI/OJTAQeVyAYNi46KzTjuXVbnxPZeRU
         tzacullZEYwZk7KZjKlasS14Mp5B2/v8sA+YzvOk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <alain.volmat@st.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 092/606] i2c: fix missing pm_runtime_put_sync in i2c_device_probe
Date:   Mon,  8 Jun 2020 19:03:37 -0400
Message-Id: <20200608231211.3363633-92-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@st.com>

[ Upstream commit 3c3dd56f760da056e821ac177e3ad0de4209a435 ]

In case of the I2C client exposes the flag I2C_CLIENT_HOST_NOTIFY,
pm_runtime_get_sync is called in order to always keep active the
adapter. However later on, pm_runtime_put_sync is never called
within the function in case of an error. This commit add this
error handling.

Fixes: 72bfcee11cf8 ("i2c: Prevent runtime suspend of adapter when Host Notify is required")
Signed-off-by: Alain Volmat <alain.volmat@st.com>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index cefad0881942..fd3199782b6e 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -338,8 +338,10 @@ static int i2c_device_probe(struct device *dev)
 		} else if (ACPI_COMPANION(dev)) {
 			irq = i2c_acpi_get_irq(client);
 		}
-		if (irq == -EPROBE_DEFER)
-			return irq;
+		if (irq == -EPROBE_DEFER) {
+			status = irq;
+			goto put_sync_adapter;
+		}
 
 		if (irq < 0)
 			irq = 0;
@@ -353,15 +355,19 @@ static int i2c_device_probe(struct device *dev)
 	 */
 	if (!driver->id_table &&
 	    !i2c_acpi_match_device(dev->driver->acpi_match_table, client) &&
-	    !i2c_of_match_device(dev->driver->of_match_table, client))
-		return -ENODEV;
+	    !i2c_of_match_device(dev->driver->of_match_table, client)) {
+		status = -ENODEV;
+		goto put_sync_adapter;
+	}
 
 	if (client->flags & I2C_CLIENT_WAKE) {
 		int wakeirq;
 
 		wakeirq = of_irq_get_byname(dev->of_node, "wakeup");
-		if (wakeirq == -EPROBE_DEFER)
-			return wakeirq;
+		if (wakeirq == -EPROBE_DEFER) {
+			status = wakeirq;
+			goto put_sync_adapter;
+		}
 
 		device_init_wakeup(&client->dev, true);
 
@@ -408,6 +414,10 @@ static int i2c_device_probe(struct device *dev)
 err_clear_wakeup_irq:
 	dev_pm_clear_wake_irq(&client->dev);
 	device_init_wakeup(&client->dev, false);
+put_sync_adapter:
+	if (client->flags & I2C_CLIENT_HOST_NOTIFY)
+		pm_runtime_put_sync(&client->adapter->dev);
+
 	return status;
 }
 
-- 
2.25.1

