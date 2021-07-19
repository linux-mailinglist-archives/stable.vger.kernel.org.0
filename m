Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8483CDFCC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345562AbhGSPLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242512AbhGSPI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:08:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F1A36138C;
        Mon, 19 Jul 2021 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709709;
        bh=L7B8jWpA0eVGQdZRPFLwWbDUxnKVm/LaZBmlk4YsjAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/gU+x3oMcqaXxtL3X5Teg0l1P0+ZtqTBF7BU3bBCEpPXPYlXKG/rTGO5m8Xbl9Q0
         O3ID7iD1qfuBSSvrlkZS0KEA/Inuvrifb/6Rjv8uMbWaxq5zfaEEt3RjcbeKqq3SKm
         tUHo3pXvQW/E9z0Im01xmhpHrmoBZgiA6DHGahCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/149] i2c: core: Disable client irq on reboot/shutdown
Date:   Mon, 19 Jul 2021 16:52:55 +0200
Message-Id: <20210719144917.219980049@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 840f59650c7c..1b93fae58ec7 100644
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
@@ -459,6 +460,8 @@ static void i2c_device_shutdown(struct device *dev)
 	driver = to_i2c_driver(dev->driver);
 	if (driver->shutdown)
 		driver->shutdown(client);
+	else if (client->irq > 0)
+		disable_irq(client->irq);
 }
 
 static void i2c_client_dev_release(struct device *dev)
-- 
2.30.2



