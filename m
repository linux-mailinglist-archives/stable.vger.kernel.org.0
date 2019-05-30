Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77472F323
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfE3E0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729893AbfE3DOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:32 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A2A624502;
        Thu, 30 May 2019 03:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186071;
        bh=TIFyNDY9FzGlyx5lxUxH4rwVPK55GjuPa0XuZBHjypo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQ7E34jbvxGB4/qj/MOvNnpiSyQiDDV88jxXw/OECoFUQQ7M9u06pIQXre7bsv1U4
         yVklXbqPHnu+nj/82DpdHwlTT+B+/QneYR4OVPWMg4XV/SLZcA2Qq3zk8VhdMMXV22
         jQIvR4n/EfyEdg5lu2YaGc2gPo9JGR8jI/bfaS6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Merello <andrea.merello@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 186/346] mmc: core: make pwrseq_emmc (partially) support sleepy GPIO controllers
Date:   Wed, 29 May 2019 20:04:19 -0700
Message-Id: <20190530030550.516654553@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 002ee28e8b322d4d4b7b83234b5d0f4ebd428eda ]

pwrseq_emmc.c implements a HW reset procedure for eMMC chip by driving a
GPIO line.

It registers the .reset() cb on mmc_pwrseq_ops and it registers a system
restart notification handler; both of them perform reset by unconditionally
calling gpiod_set_value().

If the eMMC reset line is tied to a GPIO controller whose driver can sleep
(i.e. I2C GPIO controller), then the kernel would spit warnings when trying
to reset the eMMC chip by means of .reset() mmc_pwrseq_ops cb (that is
exactly what I'm seeing during boot).

Furthermore, on system reset we would gets to the system restart
notification handler with disabled interrupts - local_irq_disable() is
called in machine_restart() at least on ARM/ARM64 - and we would be in
trouble when the GPIO driver tries to sleep (which indeed doesn't happen
here, likely because in my case the machine specific code doesn't call
do_kernel_restart(), I guess..).

This patch fixes the .reset() cb to make use of gpiod_set_value_cansleep(),
so that the eMMC gets reset on boot without complaints, while, since there
isn't that much we can do, we avoid register the restart handler if the
GPIO controller has a sleepy driver (and we spit a dev_notice() message to
let people know)..

This had been tested on a downstream 4.9 kernel with backported
commit 83f37ee7ba33 ("mmc: pwrseq: Add reset callback to the struct
mmc_pwrseq_ops") and commit ae60fb031cf2 ("mmc: core: Don't do eMMC HW
reset when resuming the eMMC card"), because I couldn't boot my board
otherwise. Maybe worth to RFT.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/pwrseq_emmc.c | 38 ++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/mmc/core/pwrseq_emmc.c b/drivers/mmc/core/pwrseq_emmc.c
index efb8a7965dd4a..154f4204d58cb 100644
--- a/drivers/mmc/core/pwrseq_emmc.c
+++ b/drivers/mmc/core/pwrseq_emmc.c
@@ -30,19 +30,14 @@ struct mmc_pwrseq_emmc {
 
 #define to_pwrseq_emmc(p) container_of(p, struct mmc_pwrseq_emmc, pwrseq)
 
-static void __mmc_pwrseq_emmc_reset(struct mmc_pwrseq_emmc *pwrseq)
-{
-	gpiod_set_value(pwrseq->reset_gpio, 1);
-	udelay(1);
-	gpiod_set_value(pwrseq->reset_gpio, 0);
-	udelay(200);
-}
-
 static void mmc_pwrseq_emmc_reset(struct mmc_host *host)
 {
 	struct mmc_pwrseq_emmc *pwrseq =  to_pwrseq_emmc(host->pwrseq);
 
-	__mmc_pwrseq_emmc_reset(pwrseq);
+	gpiod_set_value_cansleep(pwrseq->reset_gpio, 1);
+	udelay(1);
+	gpiod_set_value_cansleep(pwrseq->reset_gpio, 0);
+	udelay(200);
 }
 
 static int mmc_pwrseq_emmc_reset_nb(struct notifier_block *this,
@@ -50,8 +45,11 @@ static int mmc_pwrseq_emmc_reset_nb(struct notifier_block *this,
 {
 	struct mmc_pwrseq_emmc *pwrseq = container_of(this,
 					struct mmc_pwrseq_emmc, reset_nb);
+	gpiod_set_value(pwrseq->reset_gpio, 1);
+	udelay(1);
+	gpiod_set_value(pwrseq->reset_gpio, 0);
+	udelay(200);
 
-	__mmc_pwrseq_emmc_reset(pwrseq);
 	return NOTIFY_DONE;
 }
 
@@ -72,14 +70,18 @@ static int mmc_pwrseq_emmc_probe(struct platform_device *pdev)
 	if (IS_ERR(pwrseq->reset_gpio))
 		return PTR_ERR(pwrseq->reset_gpio);
 
-	/*
-	 * register reset handler to ensure emmc reset also from
-	 * emergency_reboot(), priority 255 is the highest priority
-	 * so it will be executed before any system reboot handler.
-	 */
-	pwrseq->reset_nb.notifier_call = mmc_pwrseq_emmc_reset_nb;
-	pwrseq->reset_nb.priority = 255;
-	register_restart_handler(&pwrseq->reset_nb);
+	if (!gpiod_cansleep(pwrseq->reset_gpio)) {
+		/*
+		 * register reset handler to ensure emmc reset also from
+		 * emergency_reboot(), priority 255 is the highest priority
+		 * so it will be executed before any system reboot handler.
+		 */
+		pwrseq->reset_nb.notifier_call = mmc_pwrseq_emmc_reset_nb;
+		pwrseq->reset_nb.priority = 255;
+		register_restart_handler(&pwrseq->reset_nb);
+	} else {
+		dev_notice(dev, "EMMC reset pin tied to a sleepy GPIO driver; reset on emergency-reboot disabled\n");
+	}
 
 	pwrseq->pwrseq.ops = &mmc_pwrseq_emmc_ops;
 	pwrseq->pwrseq.dev = dev;
-- 
2.20.1



