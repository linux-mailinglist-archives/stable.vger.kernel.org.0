Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390F211B837
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbfLKPHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbfLKPHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:07:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34C020663;
        Wed, 11 Dec 2019 15:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076861;
        bh=2iLlGMrkETmSLochaz1pSpins8fUVRRprn5VD23TrUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBPDON/QeMDl5YXMoN3sWsdOTNpqscPoE6+o87pq6AcX+0eCRAgcB6eaEUS1Bouch
         qdzrmyMRXNKOuyWN4l3WRsGX8PTwL54Qcbj9xZMPgfv3R1Ec1BdZQOGuDlGTACQ7bO
         y4jRlVbKsUZ52olKzg7pdoo9EXwwuOSfpDXi+mUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 19/92] mwifiex: Re-work support for SDIO HW reset
Date:   Wed, 11 Dec 2019 16:05:10 +0100
Message-Id: <20191211150227.375343546@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit cdb2256f795e8e78cc43f32d091695b127dfb4df upstream.

The SDIO HW reset procedure in mwifiex_sdio_card_reset_work() is broken,
when the SDIO card is shared with another SDIO func driver. This is the
case when the Bluetooth btmrvl driver is being used in combination with
mwifiex. More precisely, when mwifiex_sdio_card_reset_work() runs to resets
the SDIO card, the btmrvl driver doesn't get notified about it. Beyond that
point, the btmrvl driver will fail to communicate with the SDIO card.

This is a generic problem for SDIO func drivers sharing an SDIO card, which
are about to be addressed in subsequent changes to the mmc core and the
mmc_hw_reset() interface. In principle, these changes means the
mmc_hw_reset() interface starts to return 1 if the are multiple drivers for
the SDIO card, as to indicate to the caller that the reset needed to be
scheduled asynchronously through a hotplug mechanism of the SDIO card.

Let's prepare the mwifiex driver to support the upcoming new behaviour of
mmc_hw_reset(), which means extending the mwifiex_sdio_card_reset_work() to
support the asynchronous SDIO HW reset path. This also means, we need to
allow the ->remove() callback to run, without waiting for the FW to be
loaded. Additionally, during system suspend, mwifiex_sdio_suspend() may be
called when a reset has been scheduled, but waiting to be executed. In this
scenario let's simply return -EBUSY to abort the suspend process, as to
allow the reset to be completed first.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org # v5.4+
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/main.c |    5 +++-
 drivers/net/wireless/marvell/mwifiex/main.h |    1 
 drivers/net/wireless/marvell/mwifiex/sdio.c |   33 ++++++++++++++++++----------
 3 files changed, 27 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -631,6 +631,7 @@ static int _mwifiex_fw_dpc(const struct
 
 	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
 	mwifiex_dbg(adapter, MSG, "driver_version = %s\n", fmt);
+	adapter->is_up = true;
 	goto done;
 
 err_add_intf:
@@ -1469,6 +1470,7 @@ int mwifiex_shutdown_sw(struct mwifiex_a
 	mwifiex_deauthenticate(priv, NULL);
 
 	mwifiex_uninit_sw(adapter);
+	adapter->is_up = false;
 
 	if (adapter->if_ops.down_dev)
 		adapter->if_ops.down_dev(adapter);
@@ -1730,7 +1732,8 @@ int mwifiex_remove_card(struct mwifiex_a
 	if (!adapter)
 		return 0;
 
-	mwifiex_uninit_sw(adapter);
+	if (adapter->is_up)
+		mwifiex_uninit_sw(adapter);
 
 	if (adapter->irq_wakeup >= 0)
 		device_init_wakeup(adapter->dev, false);
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1017,6 +1017,7 @@ struct mwifiex_adapter {
 
 	/* For synchronizing FW initialization with device lifecycle. */
 	struct completion *fw_done;
+	bool is_up;
 
 	bool ext_scan;
 	u8 fw_api_ver;
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -444,6 +444,9 @@ static int mwifiex_sdio_suspend(struct d
 		return 0;
 	}
 
+	if (!adapter->is_up)
+		return -EBUSY;
+
 	mwifiex_enable_wake(adapter);
 
 	/* Enable the Host Sleep */
@@ -2220,22 +2223,30 @@ static void mwifiex_sdio_card_reset_work
 	struct sdio_func *func = card->func;
 	int ret;
 
+	/* Prepare the adapter for the reset. */
 	mwifiex_shutdown_sw(adapter);
+	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
+	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
 
-	/* power cycle the adapter */
+	/* Run a HW reset of the SDIO interface. */
 	sdio_claim_host(func);
-	mmc_hw_reset(func->card->host);
+	ret = mmc_hw_reset(func->card->host);
 	sdio_release_host(func);
 
-	/* Previous save_adapter won't be valid after this. We will cancel
-	 * pending work requests.
-	 */
-	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
-	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
-
-	ret = mwifiex_reinit_sw(adapter);
-	if (ret)
-		dev_err(&func->dev, "reinit failed: %d\n", ret);
+	switch (ret) {
+	case 1:
+		dev_dbg(&func->dev, "SDIO HW reset asynchronous\n");
+		complete_all(adapter->fw_done);
+		break;
+	case 0:
+		ret = mwifiex_reinit_sw(adapter);
+		if (ret)
+			dev_err(&func->dev, "reinit failed: %d\n", ret);
+		break;
+	default:
+		dev_err(&func->dev, "SDIO HW reset failed: %d\n", ret);
+		break;
+	}
 }
 
 /* This function read/write firmware */


