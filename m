Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2423C31B0
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhGJCns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235400AbhGJCmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A637D613CA;
        Sat, 10 Jul 2021 02:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884749;
        bh=BC0d3JEZTjVg/cD/fz//KnLazwuydKt7zuKa+28OpfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goEL54qN3dhGWn78R3dvm4wGh5y/4Ret/qnW5mOWzXpfHnMd7CpvaqyvuMWINIWdZ
         aSh1arC91LPNDtOPYcS6EmyrPnCa6GzlpZy1AcwSfKdQxO6Nt6f0eJGgBK3Rf/bykh
         bNdNb3ZQtop3HZ2jirDNuIXKODmFVbdZQTSTOQVaaaC2R6FcVU15dgzNzZsPsj06fh
         FYk4GIxRPZBwFHXcGP8cVijFSookoCVtLiHLF7ERrbnFjmeO4tIxxj55kEjV+QEkOs
         hfH0Q+4S+nif4pGa1Vbcg/Q/UpGj5YI9Qdisl9llQhRihCnB+uXesVgMG71hmQsMbb
         vqBvje/1DTgEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 25/26] i2c: core: Disable client irq on reboot/shutdown
Date:   Fri,  9 Jul 2021 22:36:03 -0400
Message-Id: <20210710023604.3172486-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit b64210f2f7c11c757432ba3701d88241b2b98fb1 ]

If an i2c client receives an interrupt during reboot or shutdown it may
be too late to service it by making an i2c transaction on the bus
because the i2c controller has already been shutdown. This can lead to
system hangs if the i2c controller tries to make a transfer that is
doomed to fail because the access to the i2c pins is already shut down,
or an iommu translation has been torn down so i2c controller register
access doesn't work.

Let's simply disable the irq if there isn't a shutdown callback for an
i2c client when there is an irq associated with the device. This will
make sure that irqs don't come in later than the time that we can handle
it. We don't do this if the i2c client device already has a shutdown
callback because presumably they're doing the right thing and quieting
the device so irqs don't come in after the shutdown callback returns.

Reported-by: kernel test robot <lkp@intel.com>
[swboyd@chromium.org: Dropped newline, added commit text, added
interrupt.h for robot build error]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 4fd7bfda2f9d..67e44e990777 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -42,6 +42,7 @@
 #include <linux/i2c.h>
 #include <linux/idr.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/irqflags.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
@@ -1003,6 +1004,8 @@ static void i2c_device_shutdown(struct device *dev)
 	driver = to_i2c_driver(dev->driver);
 	if (driver->shutdown)
 		driver->shutdown(client);
+	else if (client->irq > 0)
+		disable_irq(client->irq);
 }
 
 static void i2c_client_dev_release(struct device *dev)
-- 
2.30.2

