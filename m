Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C4E126B9C
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbfLSSyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbfLSSyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07DF9206EC;
        Thu, 19 Dec 2019 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781675;
        bh=3ES9370mW67huKRscDNwlyDxGs8a4q6eF+E6RqcTyrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XlCL8x7IFq49zl/+HVAk8PKirimZTIWJk9bceNBc/+WUR4dp1FCePKAH26hcBRCA
         LmO+akUWm2Z9A/v0D7n/nyYGvbcsh10anuqlWJK0Ma5OkoIlObsneOOA1B1N9SYlPF
         vyO25S8n+O5SKMGYpTS3ZKWRAxtTLvYusrJC3h0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 05/80] mmc: core: Re-work HW reset for SDIO cards
Date:   Thu, 19 Dec 2019 19:33:57 +0100
Message-Id: <20191219183034.971092272@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 2ac55d5e5ec9ad0a07e194f0eaca865fe5aa3c40 upstream.

It have turned out that it's not a good idea to unconditionally do a power
cycle and then to re-initialize the SDIO card, as currently done through
mmc_hw_reset() -> mmc_sdio_hw_reset(). This because there may be multiple
SDIO func drivers probed, who also shares the same SDIO card.

To address these scenarios, one may be tempted to use a notification
mechanism, as to allow the core to inform each of the probed func drivers,
about an ongoing HW reset. However, supporting such an operation from the
func driver point of view, may not be entirely trivial.

Therefore, let's use a more simplistic approach to solve the problem, by
instead forcing the card to be removed and re-detected, via scheduling a
rescan-work. In this way, we can rely on existing infrastructure, as the
func driver's ->remove() and ->probe() callbacks, becomes invoked to deal
with the cleanup and the re-initialization.

This solution may be considered as rather heavy, especially if a func
driver doesn't share its card with other func drivers. To address this,
let's keep the current immediate HW reset option as well, but run it only
when there is one func driver probed for the card.

Finally, to allow the caller of mmc_hw_reset(), to understand if the reset
is being asynchronously managed from a scheduled work, it returns 1
(propagated from mmc_sdio_hw_reset()). If the HW reset is executed
successfully and synchronously it returns 0, which maintains the existing
behaviour.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/core.c     |    5 ++---
 drivers/mmc/core/core.h     |    2 ++
 drivers/mmc/core/sdio.c     |   28 +++++++++++++++++++++++++++-
 drivers/mmc/core/sdio_bus.c |    9 ++++++++-
 include/linux/mmc/card.h    |    1 +
 5 files changed, 40 insertions(+), 5 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1469,8 +1469,7 @@ void mmc_detach_bus(struct mmc_host *hos
 	mmc_bus_put(host);
 }
 
-static void _mmc_detect_change(struct mmc_host *host, unsigned long delay,
-				bool cd_irq)
+void _mmc_detect_change(struct mmc_host *host, unsigned long delay, bool cd_irq)
 {
 	/*
 	 * If the device is configured as wakeup, we prevent a new sleep for
@@ -2129,7 +2128,7 @@ int mmc_hw_reset(struct mmc_host *host)
 	ret = host->bus_ops->hw_reset(host);
 	mmc_bus_put(host);
 
-	if (ret)
+	if (ret < 0)
 		pr_warn("%s: tried to HW reset card, got error %d\n",
 			mmc_hostname(host), ret);
 
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -70,6 +70,8 @@ void mmc_rescan(struct work_struct *work
 void mmc_start_host(struct mmc_host *host);
 void mmc_stop_host(struct mmc_host *host);
 
+void _mmc_detect_change(struct mmc_host *host, unsigned long delay,
+			bool cd_irq);
 int _mmc_detect_card_removed(struct mmc_host *host);
 int mmc_detect_card_removed(struct mmc_host *host);
 
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -1048,9 +1048,35 @@ static int mmc_sdio_runtime_resume(struc
 	return ret;
 }
 
+/*
+ * SDIO HW reset
+ *
+ * Returns 0 if the HW reset was executed synchronously, returns 1 if the HW
+ * reset was asynchronously scheduled, else a negative error code.
+ */
 static int mmc_sdio_hw_reset(struct mmc_host *host)
 {
-	mmc_power_cycle(host, host->card->ocr);
+	struct mmc_card *card = host->card;
+
+	/*
+	 * In case the card is shared among multiple func drivers, reset the
+	 * card through a rescan work. In this way it will be removed and
+	 * re-detected, thus all func drivers becomes informed about it.
+	 */
+	if (atomic_read(&card->sdio_funcs_probed) > 1) {
+		if (mmc_card_removed(card))
+			return 1;
+		host->rescan_entered = 0;
+		mmc_card_set_removed(card);
+		_mmc_detect_change(host, 0, false);
+		return 1;
+	}
+
+	/*
+	 * A single func driver has been probed, then let's skip the heavy
+	 * hotplug dance above and execute the reset immediately.
+	 */
+	mmc_power_cycle(host, card->ocr);
 	return mmc_sdio_reinit_card(host);
 }
 
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -138,6 +138,8 @@ static int sdio_bus_probe(struct device
 	if (ret)
 		return ret;
 
+	atomic_inc(&func->card->sdio_funcs_probed);
+
 	/* Unbound SDIO functions are always suspended.
 	 * During probe, the function is set active and the usage count
 	 * is incremented.  If the driver supports runtime PM,
@@ -153,7 +155,10 @@ static int sdio_bus_probe(struct device
 	/* Set the default block size so the driver is sure it's something
 	 * sensible. */
 	sdio_claim_host(func);
-	ret = sdio_set_block_size(func, 0);
+	if (mmc_card_removed(func->card))
+		ret = -ENOMEDIUM;
+	else
+		ret = sdio_set_block_size(func, 0);
 	sdio_release_host(func);
 	if (ret)
 		goto disable_runtimepm;
@@ -165,6 +170,7 @@ static int sdio_bus_probe(struct device
 	return 0;
 
 disable_runtimepm:
+	atomic_dec(&func->card->sdio_funcs_probed);
 	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD)
 		pm_runtime_put_noidle(dev);
 	dev_pm_domain_detach(dev, false);
@@ -181,6 +187,7 @@ static int sdio_bus_remove(struct device
 		pm_runtime_get_sync(dev);
 
 	drv->remove(func);
+	atomic_dec(&func->card->sdio_funcs_probed);
 
 	if (func->irq_handler) {
 		pr_warn("WARNING: driver %s did not remove its interrupt handler!\n",
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -291,6 +291,7 @@ struct mmc_card {
 	struct sd_switch_caps	sw_caps;	/* switch (CMD6) caps */
 
 	unsigned int		sdio_funcs;	/* number of SDIO functions */
+	atomic_t		sdio_funcs_probed; /* number of probed SDIO funcs */
 	struct sdio_cccr	cccr;		/* common card info */
 	struct sdio_cis		cis;		/* common tuple info */
 	struct sdio_func	*sdio_func[SDIO_MAX_FUNCS]; /* SDIO functions (devices) */


