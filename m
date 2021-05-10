Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF2F378156
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhEJK0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhEJKZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 527C861075;
        Mon, 10 May 2021 10:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642258;
        bh=RmrvKtA+7uOahgRmDbLYU0msLqsynrr90PKSEainPMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UM92bP8YytlkE5kg16IVxe1tgWi6CFodY+xuzXcgSKnF5zf9VdGzj6uYqZpfzWkoz
         vTfuSIleLit4IvNXpGJcrRUsnuXsY9I/zTJgNRgiUkLUxBRkXYXBJOuD4eC8sIQ/YQ
         dR+XAhCXMphqpdAZZh+Z1nEulLuXaaOdSVzbNd5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiwoong Kim <kwmad.kim@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 023/184] mmc: core: Fix hanging on I/O during system suspend for removable cards
Date:   Mon, 10 May 2021 12:18:37 +0200
Message-Id: <20210510101950.998299292@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 17a17bf50612e6048a9975450cf1bd30f93815b5 upstream.

The mmc core uses a PM notifier to temporarily during system suspend, turn
off the card detection mechanism for removal/insertion of (e)MMC/SD/SDIO
cards. Additionally, the notifier may be used to remove an SDIO card
entirely, if a corresponding SDIO functional driver don't have the system
suspend/resume callbacks assigned. This behaviour has been around for a
very long time.

However, a recent bug report tells us there are problems with this
approach. More precisely, when receiving the PM_SUSPEND_PREPARE
notification, we may end up hanging on I/O to be completed, thus also
preventing the system from getting suspended.

In the end what happens, is that the cancel_delayed_work_sync() in
mmc_pm_notify() ends up waiting for mmc_rescan() to complete - and since
mmc_rescan() wants to claim the host, it needs to wait for the I/O to be
completed first.

Typically, this problem is triggered in Android, if there is ongoing I/O
while the user decides to suspend, resume and then suspend the system
again. This due to that after the resume, an mmc_rescan() work gets punted
to the workqueue, which job is to verify that the card remains inserted
after the system has resumed.

To fix this problem, userspace needs to become frozen to suspend the I/O,
prior to turning off the card detection mechanism. Therefore, let's drop
the PM notifiers for mmc subsystem altogether and rely on the card
detection to be turned off/on as a part of the system_freezable_wq, that we
are already using.

Moreover, to allow and SDIO card to be removed during system suspend, let's
manage this from a ->prepare() callback, assigned at the mmc_host_class
level. In this way, we can use the parent device (the mmc_host_class
device), to remove the card device that is the child, in the
device_prepare() phase.

Reported-by: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: stable@vger.kernel.org # v4.5+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210310152900.149380-1-ulf.hansson@linaro.org
Reviewed-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/core.c  |   74 -----------------------------------------------
 drivers/mmc/core/core.h  |    8 -----
 drivers/mmc/core/host.c  |   40 +++++++++++++++++++++++--
 drivers/mmc/core/sdio.c  |   28 +++++++++++++----
 include/linux/mmc/host.h |    3 -
 5 files changed, 59 insertions(+), 94 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2392,80 +2392,6 @@ void mmc_stop_host(struct mmc_host *host
 	mmc_release_host(host);
 }
 
-#ifdef CONFIG_PM_SLEEP
-/* Do the card removal on suspend if card is assumed removeable
- * Do that in pm notifier while userspace isn't yet frozen, so we will be able
-   to sync the card.
-*/
-static int mmc_pm_notify(struct notifier_block *notify_block,
-			unsigned long mode, void *unused)
-{
-	struct mmc_host *host = container_of(
-		notify_block, struct mmc_host, pm_notify);
-	unsigned long flags;
-	int err = 0;
-
-	switch (mode) {
-	case PM_HIBERNATION_PREPARE:
-	case PM_SUSPEND_PREPARE:
-	case PM_RESTORE_PREPARE:
-		spin_lock_irqsave(&host->lock, flags);
-		host->rescan_disable = 1;
-		spin_unlock_irqrestore(&host->lock, flags);
-		cancel_delayed_work_sync(&host->detect);
-
-		if (!host->bus_ops)
-			break;
-
-		/* Validate prerequisites for suspend */
-		if (host->bus_ops->pre_suspend)
-			err = host->bus_ops->pre_suspend(host);
-		if (!err)
-			break;
-
-		if (!mmc_card_is_removable(host)) {
-			dev_warn(mmc_dev(host),
-				 "pre_suspend failed for non-removable host: "
-				 "%d\n", err);
-			/* Avoid removing non-removable hosts */
-			break;
-		}
-
-		/* Calling bus_ops->remove() with a claimed host can deadlock */
-		host->bus_ops->remove(host);
-		mmc_claim_host(host);
-		mmc_detach_bus(host);
-		mmc_power_off(host);
-		mmc_release_host(host);
-		host->pm_flags = 0;
-		break;
-
-	case PM_POST_SUSPEND:
-	case PM_POST_HIBERNATION:
-	case PM_POST_RESTORE:
-
-		spin_lock_irqsave(&host->lock, flags);
-		host->rescan_disable = 0;
-		spin_unlock_irqrestore(&host->lock, flags);
-		_mmc_detect_change(host, 0, false);
-
-	}
-
-	return 0;
-}
-
-void mmc_register_pm_notifier(struct mmc_host *host)
-{
-	host->pm_notify.notifier_call = mmc_pm_notify;
-	register_pm_notifier(&host->pm_notify);
-}
-
-void mmc_unregister_pm_notifier(struct mmc_host *host)
-{
-	unregister_pm_notifier(&host->pm_notify);
-}
-#endif
-
 static int __init mmc_init(void)
 {
 	int ret;
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -94,14 +94,6 @@ int mmc_execute_tuning(struct mmc_card *
 int mmc_hs200_to_hs400(struct mmc_card *card);
 int mmc_hs400_to_hs200(struct mmc_card *card);
 
-#ifdef CONFIG_PM_SLEEP
-void mmc_register_pm_notifier(struct mmc_host *host);
-void mmc_unregister_pm_notifier(struct mmc_host *host);
-#else
-static inline void mmc_register_pm_notifier(struct mmc_host *host) { }
-static inline void mmc_unregister_pm_notifier(struct mmc_host *host) { }
-#endif
-
 void mmc_wait_for_req_done(struct mmc_host *host, struct mmc_request *mrq);
 bool mmc_is_req_done(struct mmc_host *host, struct mmc_request *mrq);
 
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -33,6 +33,42 @@
 
 static DEFINE_IDA(mmc_host_ida);
 
+#ifdef CONFIG_PM_SLEEP
+static int mmc_host_class_prepare(struct device *dev)
+{
+	struct mmc_host *host = cls_dev_to_mmc_host(dev);
+
+	/*
+	 * It's safe to access the bus_ops pointer, as both userspace and the
+	 * workqueue for detecting cards are frozen at this point.
+	 */
+	if (!host->bus_ops)
+		return 0;
+
+	/* Validate conditions for system suspend. */
+	if (host->bus_ops->pre_suspend)
+		return host->bus_ops->pre_suspend(host);
+
+	return 0;
+}
+
+static void mmc_host_class_complete(struct device *dev)
+{
+	struct mmc_host *host = cls_dev_to_mmc_host(dev);
+
+	_mmc_detect_change(host, 0, false);
+}
+
+static const struct dev_pm_ops mmc_host_class_dev_pm_ops = {
+	.prepare = mmc_host_class_prepare,
+	.complete = mmc_host_class_complete,
+};
+
+#define MMC_HOST_CLASS_DEV_PM_OPS (&mmc_host_class_dev_pm_ops)
+#else
+#define MMC_HOST_CLASS_DEV_PM_OPS NULL
+#endif
+
 static void mmc_host_classdev_release(struct device *dev)
 {
 	struct mmc_host *host = cls_dev_to_mmc_host(dev);
@@ -43,6 +79,7 @@ static void mmc_host_classdev_release(st
 static struct class mmc_host_class = {
 	.name		= "mmc_host",
 	.dev_release	= mmc_host_classdev_release,
+	.pm		= MMC_HOST_CLASS_DEV_PM_OPS,
 };
 
 int mmc_register_host_class(void)
@@ -477,8 +514,6 @@ int mmc_add_host(struct mmc_host *host)
 #endif
 
 	mmc_start_host(host);
-	mmc_register_pm_notifier(host);
-
 	return 0;
 }
 
@@ -494,7 +529,6 @@ EXPORT_SYMBOL(mmc_add_host);
  */
 void mmc_remove_host(struct mmc_host *host)
 {
-	mmc_unregister_pm_notifier(host);
 	mmc_stop_host(host);
 
 #ifdef CONFIG_DEBUG_FS
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -924,21 +924,37 @@ out:
  */
 static int mmc_sdio_pre_suspend(struct mmc_host *host)
 {
-	int i, err = 0;
+	int i;
 
 	for (i = 0; i < host->card->sdio_funcs; i++) {
 		struct sdio_func *func = host->card->sdio_func[i];
 		if (func && sdio_func_present(func) && func->dev.driver) {
 			const struct dev_pm_ops *pmops = func->dev.driver->pm;
-			if (!pmops || !pmops->suspend || !pmops->resume) {
+			if (!pmops || !pmops->suspend || !pmops->resume)
 				/* force removal of entire card in that case */
-				err = -ENOSYS;
-				break;
-			}
+				goto remove;
 		}
 	}
 
-	return err;
+	return 0;
+
+remove:
+	if (!mmc_card_is_removable(host)) {
+		dev_warn(mmc_dev(host),
+			 "missing suspend/resume ops for non-removable SDIO card\n");
+		/* Don't remove a non-removable card - we can't re-detect it. */
+		return 0;
+	}
+
+	/* Remove the SDIO card and let it be re-detected later on. */
+	mmc_sdio_remove(host);
+	mmc_claim_host(host);
+	mmc_detach_bus(host);
+	mmc_power_off(host);
+	mmc_release_host(host);
+	host->pm_flags = 0;
+
+	return 0;
 }
 
 /*
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -281,9 +281,6 @@ struct mmc_host {
 	u32			ocr_avail_sdio;	/* SDIO-specific OCR */
 	u32			ocr_avail_sd;	/* SD-specific OCR */
 	u32			ocr_avail_mmc;	/* MMC-specific OCR */
-#ifdef CONFIG_PM_SLEEP
-	struct notifier_block	pm_notify;
-#endif
 	u32			max_current_330;
 	u32			max_current_300;
 	u32			max_current_180;


