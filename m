Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C93C3B7AF0
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 02:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhF3AZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 20:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhF3AZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 20:25:14 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D796CC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 17:22:44 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id r16so671935ljk.9
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 17:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2+Aq7RVmAVKaJ4JkaGZh0ZX7UOpAsv33bJEZnA5j3w0=;
        b=GzfblDNdc6cDzVX8RyOs5INBZgjLxEZPm3JNniL4g0au5zv9s3iinE9/ubt8AQLtoJ
         dENfTIq1R5UH+ACbjB2MRQUj7fIA2Opod0MRiiGLqQISQ/+IaNwWBa29nwSMgJkyexwi
         Y7a51dPeXa1Q7Q9V7N6jyci8DlfpaQ/DoMhH65bL4v6rnI0uaq+rY3Yv2cRQP/ipacvU
         6LOPauilg+ZWvjBHkS6r+JHuFZrz4k1+OHg98Uxt8B16bI4K9mBdFvkfdCn7MOFMZeSa
         XFxZJzxZjkGTuAxNN4go3c6GBKM54bI/1rSfJefu8/nUSFBeknVSlH7YuRneoqojBXPN
         t6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2+Aq7RVmAVKaJ4JkaGZh0ZX7UOpAsv33bJEZnA5j3w0=;
        b=s07UI5X3UYtyYPrBSPIBrKUzWH/iUjftxQ3Oq7m3hyeewe0ZN0RQ/jxHPxmy1pJwsL
         HxzVf7VTZmUikH0fomelCUVDVK4XTqR26wesKyzFGIXGb0Qrt1n/kFqoSLvxkXLXd6F9
         nfNS0M6d3joqGOa/zDq0Sc2SbObnlpuYwFMMjn3ZJLM0lR1LyUWzjWyoU24uc398/JQj
         bmSkonvHdIxmfM4u4fo8gqZv82Mq9AVAxiDPpovxM5/D3hC1btFe4xGaxX73mIxRfSar
         FbngGn2KaI/kC6i8j9ymsxBqVQ7G57yoWLLoWqgp9HAQc8nwz1h9k13EoCH35QXRcEzu
         HAgw==
X-Gm-Message-State: AOAM5329aykUUdJ6Rn3zBi9x1uecnzl58chBc8C3MHk4jb1o6VSdR6Ly
        RtyKuh/RiOY6igTqNFGNU6e3oQ==
X-Google-Smtp-Source: ABdhPJwAtOHA52ZtGXAjywr35gs4lswWH53NHxhjjd/wNO4bhmq3dl+qWWAIKpLvC+yz5frUTYqX9Q==
X-Received: by 2002:a2e:9e82:: with SMTP id f2mr5919557ljk.192.1625012563113;
        Tue, 29 Jun 2021 17:22:43 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p11sm1315208ljg.122.2021.06.29.17.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 17:22:42 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>, stable@vger.kernel.org,
        phone-devel@vger.kernel.org, Ludovic Barre <ludovic.barre@st.com>,
        Stephan Gerhold <stephan@gerhold.net>, newbyte@disroot.org
Subject: [PATCH v2] mmc: core: Add a card quirk for non-hw busy detection
Date:   Wed, 30 Jun 2021 02:20:39 +0200
Message-Id: <20210630002039.3527237-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some boot partitions on the Samsung 4GB KLM4G1YE4C "4YMD1R" and "M4G1YC"
cards appear broken when accessed randomly. CMD6 to switch back to the main
partition randomly stalls after CMD18 access to the boot partition 1, and
the card never comes back online. The accesses to the boot partitions work
several times before this happens.

Some problematic eMMC cards are found in the Samsung GT-S7710 mobile phone.

I tried using only single blocks with CMD17 on the boot partitions with the
result that it crashed even faster.

The card may survive on older kernels, but this seems to be because recent
kernel partition parsers are accessing the boot partitions more, and we get
more block traffic to the boot partitions during kernel startup.

After applying this patch, the main partition can be accessed and mounted
without problems.

After a bit of root cause analysis it turns out that these old eMMC cards
cannot do hardware busy detection (monitoring DAT0) properly. This explains
why older kernels work since we only recently added support for this to the
MMCI driver which is used with these cards on these platforms.

Construct a quirk that makes the MMC cord avoid using the ->card_busy()
callback if the card is listed with MMC_QUIRK_BROKEN_HW_BUSY_DETECT and
register the known problematic cards. The core changes are pretty
straight-forward with a helper inline to check of we can use hardware
busy detection.

On the MMCI host we have to counter the fact that if the host was able to
use busy detect, it would be used unsolicited in the command IRQ callback.
Rewrite this so that MMCI will not attempt to use hardware busy detection
in the command IRQ until:
- A card is attached to the host and
- We know that the card can handle this busy detection

I have glanced over the ->card_busy() callbacks on some other hosts and
they seem to mostly read a register reflecting the value of DAT0 for this
which works fine with the quirk in this patch. However if the error appear
on other hosts they might need additional fixes.

Fixes: cb0335b778c7 ("mmc: mmci: add busy_complete callback")
Cc: stable@vger.kernel.org
Cc: phone-devel@vger.kernel.org
Cc: Ludovic Barre <ludovic.barre@st.com>
Cc: Stephan Gerhold <stephan@gerhold.net>
Reported-by: newbyte@disroot.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Rewrite to reflect the actual problem of broken busy detection.
---
 drivers/mmc/core/core.c    |  8 ++++----
 drivers/mmc/core/core.h    | 17 +++++++++++++++++
 drivers/mmc/core/mmc_ops.c |  4 ++--
 drivers/mmc/core/quirks.h  | 21 +++++++++++++++++++++
 drivers/mmc/host/mmci.c    | 22 ++++++++++++++++++++--
 include/linux/mmc/card.h   |  1 +
 6 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index f194940c5974..7142a806f6a6 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -232,7 +232,7 @@ static void __mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 	 * And bypass I/O abort, reset and bus suspend operations.
 	 */
 	if (sdio_is_io_busy(mrq->cmd->opcode, mrq->cmd->arg) &&
-	    host->ops->card_busy) {
+	    mmc_hw_busy_detect(host)) {
 		int tries = 500; /* Wait aprox 500ms at maximum */
 
 		while (host->ops->card_busy(host) && --tries)
@@ -1197,7 +1197,7 @@ int mmc_set_uhs_voltage(struct mmc_host *host, u32 ocr)
 	 */
 	if (!host->ops->start_signal_voltage_switch)
 		return -EPERM;
-	if (!host->ops->card_busy)
+	if (!mmc_hw_busy_detect(host))
 		pr_warn("%s: cannot verify signal voltage switch\n",
 			mmc_hostname(host));
 
@@ -1217,7 +1217,7 @@ int mmc_set_uhs_voltage(struct mmc_host *host, u32 ocr)
 	 * after the response of cmd11, but wait 1 ms to be sure
 	 */
 	mmc_delay(1);
-	if (host->ops->card_busy && !host->ops->card_busy(host)) {
+	if (mmc_hw_busy_detect(host) && !host->ops->card_busy(host)) {
 		err = -EAGAIN;
 		goto power_cycle;
 	}
@@ -1238,7 +1238,7 @@ int mmc_set_uhs_voltage(struct mmc_host *host, u32 ocr)
 	 * Failure to switch is indicated by the card holding
 	 * dat[0:3] low
 	 */
-	if (host->ops->card_busy && host->ops->card_busy(host))
+	if (mmc_hw_busy_detect(host) && host->ops->card_busy(host))
 		err = -EAGAIN;
 
 power_cycle:
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index db3c9c68875d..68091bbba580 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -172,4 +172,21 @@ static inline bool mmc_cache_enabled(struct mmc_host *host)
 	return false;
 }
 
+/**
+ * mmc_hw_busy_detect() - Can we use hw busy detection?
+ * @host: the host in question
+ */
+static inline bool mmc_hw_busy_detect(struct mmc_host *host)
+{
+	struct mmc_card *card = host->card;
+	bool has_ops;
+	bool able = true;
+
+	has_ops = (host->ops->card_busy != NULL);
+	if (card)
+		able = !(card->quirks & MMC_QUIRK_BROKEN_HW_BUSY_DETECT);
+
+	return (has_ops && able);
+}
+
 #endif
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 5756781fef37..5f37e280dc1c 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -431,7 +431,7 @@ static int mmc_busy_status(struct mmc_card *card, bool retry_crc_err,
 	u32 status = 0;
 	int err;
 
-	if (host->ops->card_busy) {
+	if (mmc_hw_busy_detect(host)) {
 		*busy = host->ops->card_busy(host);
 		return 0;
 	}
@@ -480,7 +480,7 @@ static int __mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
 	 * capable of polling by using ->card_busy(), then rely on waiting the
 	 * stated timeout to be sufficient.
 	 */
-	if (!send_status && !host->ops->card_busy) {
+	if (!send_status && mmc_hw_busy_detect(host)) {
 		mmc_delay(timeout_ms);
 		return 0;
 	}
diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index d68e6e513a4f..8da6526f0eb0 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -99,6 +99,27 @@ static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
 	MMC_FIXUP("V10016", CID_MANFID_KINGSTON, CID_OEMID_ANY, add_quirk_mmc,
 		  MMC_QUIRK_TRIM_BROKEN),
 
+	/*
+	 * Some older Samsung eMMCs have broken hardware busy detection.
+	 * Enabling this feature in the host controller can make the card
+	 * accesses lock up completely.
+	 */
+	MMC_FIXUP("4YMD1R", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
+	/* Samsung KLMxGxxE4x eMMCs from 2012: 4, 8, 16, 32 and 64 GB */
+	MMC_FIXUP("M4G1YC", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
+	MMC_FIXUP("M8G1WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
+	MMC_FIXUP("MAG2WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
+	MMC_FIXUP("MBG4WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
+	MMC_FIXUP("MAG2WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
+	MMC_FIXUP("MCG8WA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_BROKEN_HW_BUSY_DETECT),
+
 	END_FIXUP
 };
 
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 984d35055156..3046917b2b67 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -347,6 +347,24 @@ static int mmci_card_busy(struct mmc_host *mmc)
 	return busy;
 }
 
+/* Use this if the MMCI variant AND the card supports it */
+static bool mmci_use_busy_detect(struct mmci_host *host)
+{
+	struct mmc_card *card = host->mmc->card;
+
+	if (!host->variant->busy_detect)
+		return false;
+
+	/* We don't allow this until we know that the card can handle it */
+	if (!card)
+		return false;
+
+	if (card->quirks & MMC_QUIRK_BROKEN_HW_BUSY_DETECT)
+		return false;
+
+	return true;
+}
+
 static void mmci_reg_delay(struct mmci_host *host)
 {
 	/*
@@ -1381,7 +1399,7 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
 		return;
 
 	/* Handle busy detection on DAT0 if the variant supports it. */
-	if (busy_resp && host->variant->busy_detect)
+	if (busy_resp && mmci_use_busy_detect(host))
 		if (!host->ops->busy_complete(host, status, err_msk))
 			return;
 
@@ -1725,7 +1743,7 @@ static void mmci_set_max_busy_timeout(struct mmc_host *mmc)
 	struct mmci_host *host = mmc_priv(mmc);
 	u32 max_busy_timeout = 0;
 
-	if (!host->variant->busy_detect)
+	if (!mmci_use_busy_detect(host))
 		return;
 
 	if (host->variant->busy_timeout && mmc->actual_clock)
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index f9ad35dd6012..b9a12e925a5b 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -259,6 +259,7 @@ struct mmc_card {
 						/* for byte mode */
 #define MMC_QUIRK_NONSTD_SDIO	(1<<2)		/* non-standard SDIO card attached */
 						/* (missing CIA registers) */
+#define MMC_QUIRK_BROKEN_HW_BUSY_DETECT (1<<3)	/* Disable hardware busy detection on DAT0 */
 #define MMC_QUIRK_NONSTD_FUNC_IF (1<<4)		/* SDIO card has nonstd function interfaces */
 #define MMC_QUIRK_DISABLE_CD	(1<<5)		/* disconnect CD/DAT[3] resistor */
 #define MMC_QUIRK_INAND_CMD38	(1<<6)		/* iNAND devices have broken CMD38 */
-- 
2.31.1

