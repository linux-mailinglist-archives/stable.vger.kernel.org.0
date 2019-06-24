Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2325071D
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfFXKEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbfFXKEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:35 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 857E4205ED;
        Mon, 24 Jun 2019 10:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370674;
        bh=G3VghlHuhV17ROShXCPAGydoKabEC4qFB4PEIl/ZNz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcX//l6QuG9j1EmM1mnH5XBrapFy/NGNNnPxmrM6RppBzqyZPz9nDhotkHKYUc69l
         yGnikmol9sJyRYp286pUp/u4Ze/hxvig4rZcGIkchGVHekoVXG3ykl+9r7strG/bgs
         8QEFPRCO6I+P8vZ11ZuFC7NO6Vqo5RjTRgkneF8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 14/90] mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()
Date:   Mon, 24 Jun 2019 17:56:04 +0800
Message-Id: <20190624092314.948277415@linuxfoundation.org>
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

commit b4c9f938d542d5f88c501744d2d12fad4fd2915f upstream.

We want SDIO drivers to be able to temporarily stop retuning when the
driver knows that the SDIO card is not in a state where retuning will
work (maybe because the card is asleep).  We'll move the relevant
functions to a place where drivers can call them.

Cc: stable@vger.kernel.org #v4.18+
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sdio_io.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/sdio_func.h |    3 +++
 2 files changed, 43 insertions(+)

--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -18,6 +18,7 @@
 #include "sdio_ops.h"
 #include "core.h"
 #include "card.h"
+#include "host.h"
 
 /**
  *	sdio_claim_host - exclusively claim a bus for a certain SDIO function
@@ -762,3 +763,42 @@ void sdio_retune_crc_enable(struct sdio_
 	func->card->host->retune_crc_disable = false;
 }
 EXPORT_SYMBOL_GPL(sdio_retune_crc_enable);
+
+/**
+ *	sdio_retune_hold_now - start deferring retuning requests till release
+ *	@func: SDIO function attached to host
+ *
+ *	This function can be called if it's currently a bad time to do
+ *	a retune of the SDIO card.  Retune requests made during this time
+ *	will be held and we'll actually do the retune sometime after the
+ *	release.
+ *
+ *	This function could be useful if an SDIO card is in a power state
+ *	where it can respond to a small subset of commands that doesn't
+ *	include the retuning command.  Care should be taken when using
+ *	this function since (presumably) the retuning request we might be
+ *	deferring was made for a good reason.
+ *
+ *	This function should be called while the host is claimed.
+ */
+void sdio_retune_hold_now(struct sdio_func *func)
+{
+	mmc_retune_hold_now(func->card->host);
+}
+EXPORT_SYMBOL_GPL(sdio_retune_hold_now);
+
+/**
+ *	sdio_retune_release - signal that it's OK to retune now
+ *	@func: SDIO function attached to host
+ *
+ *	This is the complement to sdio_retune_hold_now().  Calling this
+ *	function won't make a retune happen right away but will allow
+ *	them to be scheduled normally.
+ *
+ *	This function should be called while the host is claimed.
+ */
+void sdio_retune_release(struct sdio_func *func)
+{
+	mmc_retune_release(func->card->host);
+}
+EXPORT_SYMBOL_GPL(sdio_retune_release);
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -162,4 +162,7 @@ extern int sdio_set_host_pm_flags(struct
 extern void sdio_retune_crc_disable(struct sdio_func *func);
 extern void sdio_retune_crc_enable(struct sdio_func *func);
 
+extern void sdio_retune_hold_now(struct sdio_func *func);
+extern void sdio_retune_release(struct sdio_func *func);
+
 #endif /* LINUX_MMC_SDIO_FUNC_H */


