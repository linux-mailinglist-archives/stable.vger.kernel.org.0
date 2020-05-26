Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FA51E2D78
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392047AbgEZTLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392044AbgEZTLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:11:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7748C20776;
        Tue, 26 May 2020 19:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520267;
        bh=PDcNWk7tK3/K5vhT/4s7JhrcaQv+MLrWcsh7waWalH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mrr8PESgUkQntWrxW5hJ7Ukc0R7LwdoLRyRxarOswsmXF4NluaifE5bsb+yy4GYdp
         s28qDfxcikxS7fSpm0Zws/0zxR+nB7uOfJCU6Y7yrU1iWLtsjYmu/D3USYF6gg/siZ
         W9GHO1tqtids9u165csbshclO/jOPoS6LrnAXdrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@st.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 013/126] i2c: fix missing pm_runtime_put_sync in i2c_device_probe
Date:   Tue, 26 May 2020 20:52:30 +0200
Message-Id: <20200526183938.689403399@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 
@@ -408,6 +414,10 @@ err_detach_pm_domain:
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



