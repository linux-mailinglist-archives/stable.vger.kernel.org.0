Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F61F50817
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbfFXKEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729720AbfFXKEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:32 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D242E205ED;
        Mon, 24 Jun 2019 10:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370671;
        bh=KHO38U2dHAzaozzkX+x+gHyMcZPA45/LPjh9bicnzVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E64Rim/HdfZcXH39rs+gtfkjLQD3TvgT4dqLh3o97JduIdEdI4bjePQQVictqDmyL
         spDjLLlf7Kllw6IPWpo6GPP2hFPXvzZupv81Yj8kzDWiOpCDlwDygpLOTJ9RlpxsUq
         zTOql04cqx7XRgJ6wm3EP5kir5o3RDh+UWGdRd8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 13/90] mmc: core: API to temporarily disable retuning for SDIO CRC errors
Date:   Mon, 24 Jun 2019 17:56:03 +0800
Message-Id: <20190624092314.890271230@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 0a55f4ab9678413a01e740c86e9367ba0c612b36 upstream.

Normally when the MMC core sees an "-EILSEQ" error returned by a host
controller then it will trigger a retuning of the card.  This is
generally a good idea.

However, if a command is expected to sometimes cause transfer errors
then these transfer errors shouldn't cause a re-tuning.  This
re-tuning will be a needless waste of time.  One example case where a
transfer is expected to cause errors is when transitioning between
idle (sometimes referred to as "sleep" in Broadcom code) and active
state on certain Broadcom WiFi SDIO cards.  Specifically if the card
was already transitioning between states when the command was sent it
could cause an error on the SDIO bus.

Let's add an API that the SDIO function drivers can call that will
temporarily disable the auto-tuning functionality.  Then we can add a
call to this in the Broadcom WiFi driver and any other driver that
might have similar needs.

NOTE: this makes the assumption that the card is already tuned well
enough that it's OK to disable the auto-retuning during one of these
error-prone situations.  Presumably the driver code performing the
error-prone transfer knows how to recover / retry from errors.  ...and
after we can get back to a state where transfers are no longer
error-prone then we can enable the auto-retuning again.  If we truly
find ourselves in a case where the card needs to be retuned sometimes
to handle one of these error-prone transfers then we can always try a
few transfers first without auto-retuning and then re-try with
auto-retuning if the first few fail.

Without this change on rk3288-veyron-minnie I periodically see this in
the logs of a machine just sitting there idle:
  dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to XYZ

Cc: stable@vger.kernel.org #v4.18+
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/core.c       |    5 +++--
 drivers/mmc/core/sdio_io.c    |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h      |    1 +
 include/linux/mmc/sdio_func.h |    3 +++
 4 files changed, 44 insertions(+), 2 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -144,8 +144,9 @@ void mmc_request_done(struct mmc_host *h
 	int err = cmd->error;
 
 	/* Flag re-tuning needed on CRC errors */
-	if ((cmd->opcode != MMC_SEND_TUNING_BLOCK &&
-	    cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200) &&
+	if (cmd->opcode != MMC_SEND_TUNING_BLOCK &&
+	    cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200 &&
+	    !host->retune_crc_disable &&
 	    (err == -EILSEQ || (mrq->sbc && mrq->sbc->error == -EILSEQ) ||
 	    (mrq->data && mrq->data->error == -EILSEQ) ||
 	    (mrq->stop && mrq->stop->error == -EILSEQ)))
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -725,3 +725,40 @@ int sdio_set_host_pm_flags(struct sdio_f
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sdio_set_host_pm_flags);
+
+/**
+ *	sdio_retune_crc_disable - temporarily disable retuning on CRC errors
+ *	@func: SDIO function attached to host
+ *
+ *	If the SDIO card is known to be in a state where it might produce
+ *	CRC errors on the bus in response to commands (like if we know it is
+ *	transitioning between power states), an SDIO function driver can
+ *	call this function to temporarily disable the SD/MMC core behavior of
+ *	triggering an automatic retuning.
+ *
+ *	This function should be called while the host is claimed and the host
+ *	should remain claimed until sdio_retune_crc_enable() is called.
+ *	Specifically, the expected sequence of calls is:
+ *	- sdio_claim_host()
+ *	- sdio_retune_crc_disable()
+ *	- some number of calls like sdio_writeb() and sdio_readb()
+ *	- sdio_retune_crc_enable()
+ *	- sdio_release_host()
+ */
+void sdio_retune_crc_disable(struct sdio_func *func)
+{
+	func->card->host->retune_crc_disable = true;
+}
+EXPORT_SYMBOL_GPL(sdio_retune_crc_disable);
+
+/**
+ *	sdio_retune_crc_enable - re-enable retuning on CRC errors
+ *	@func: SDIO function attached to host
+ *
+ *	This is the compement to sdio_retune_crc_disable().
+ */
+void sdio_retune_crc_enable(struct sdio_func *func)
+{
+	func->card->host->retune_crc_disable = false;
+}
+EXPORT_SYMBOL_GPL(sdio_retune_crc_enable);
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -395,6 +395,7 @@ struct mmc_host {
 	unsigned int		retune_now:1;	/* do re-tuning at next req */
 	unsigned int		retune_paused:1; /* re-tuning is temporarily disabled */
 	unsigned int		use_blk_mq:1;	/* use blk-mq */
+	unsigned int		retune_crc_disable:1; /* don't trigger retune upon crc */
 
 	int			rescan_disable;	/* disable card detection */
 	int			rescan_entered;	/* used with nonremovable devices */
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -159,4 +159,7 @@ extern void sdio_f0_writeb(struct sdio_f
 extern mmc_pm_flag_t sdio_get_host_pm_caps(struct sdio_func *func);
 extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
 
+extern void sdio_retune_crc_disable(struct sdio_func *func);
+extern void sdio_retune_crc_enable(struct sdio_func *func);
+
 #endif /* LINUX_MMC_SDIO_FUNC_H */


