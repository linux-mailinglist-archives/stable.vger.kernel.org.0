Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02423C2EAE
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhGJC2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233789AbhGJC1R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF5AD613F3;
        Sat, 10 Jul 2021 02:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883859;
        bh=ck5Q6GVks57jWIqjHyZOElFXukj7+nakjKh8+cKT8/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKbVVUf09IS76F9e3tMY4AZ1+WrwbsWTKQvDBiI+Oq3VIbKTFc1HWofy/RPmfZY4f
         FgsR8XtTxZZmzypMy5u587JQe1Milp9LBnhzgSIIb8wPoCQApcR9qKV56XKcMdowNI
         P91XTNTauSRPeIGZ5j0AcPDSCSHpu4X4qPUS/EpHSpIA84ZTCH5rSNvTqYx3lpoHAV
         JrgSgvA8FjDHLbsK58mVhUrPePG3uSJ80ogUDLEl5i1qd7q7GMZjjXYG5SNmG5QSSD
         9cIZD1lwm2O6Fu1XboF1TUjBZ617hv3u1cpqrO9DVjQag+GQhNT3GXLYN1kdJ3VhZb
         WdEk4QlxnmbFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 101/104] i2c: core: Disable client irq on reboot/shutdown
Date:   Fri,  9 Jul 2021 22:21:53 -0400
Message-Id: <20210710022156.3168825-101-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
 drivers/i2c/i2c-core-base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index f21362355973..8e4be0d4ce34 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -24,6 +24,7 @@
 #include <linux/i2c-smbus.h>
 #include <linux/idr.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/irqflags.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
@@ -587,6 +588,8 @@ static void i2c_device_shutdown(struct device *dev)
 	driver = to_i2c_driver(dev->driver);
 	if (driver->shutdown)
 		driver->shutdown(client);
+	else if (client->irq > 0)
+		disable_irq(client->irq);
 }
 
 static void i2c_client_dev_release(struct device *dev)
-- 
2.30.2

