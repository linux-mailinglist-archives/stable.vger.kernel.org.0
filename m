Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268EA1215AA
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbfLPSUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:20:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732001AbfLPST4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:19:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A1512072D;
        Mon, 16 Dec 2019 18:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520395;
        bh=emd5DjAB1F/HryIMBZY5qCDpsI+fEDZLrvujEQ4Vt98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRA0ELMbYK/cmhcR2XzuGa2oF/2BD+lP8+cUA5FjHLYj7DQLjSMQ1/ynfNgf9LaEl
         HrPoYnSwyzWHDAwN/sPQX8itg/T/GFG/fINzYKD9/V+GdS7P4sCY/hxCCBmHE/1j44
         trsxDu0HSF0t3VLxjRVmo1rPSXrbKolR/oLlXrHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 138/177] mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid of pandora_wl1251_init_card
Date:   Mon, 16 Dec 2019 18:49:54 +0100
Message-Id: <20191216174846.226256119@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit f6498b922e57aecbe3b7fa30a308d9d586c0c369 upstream.

Pandora_wl1251_init_card was used to do special pdata based
setup of the sdio mmc interface. This does no longer work with
v4.7 and later. A fix requires a device tree based mmc3 setup.

Therefore we move the special setup to omap_hsmmc.c instead
of calling some pdata supplied init_card function.

The new code checks for a DT child node compatible to wl1251
so it will not affect other MMC3 use cases.

Generally, this code was and still is a hack and should be
moved to mmc core to e.g. read such properties from optional
DT child nodes.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # v4.7+
[Ulf: Fixed up some checkpatch complaints]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/omap_hsmmc.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1512,6 +1512,36 @@ static void omap_hsmmc_init_card(struct
 
 	if (mmc_pdata(host)->init_card)
 		mmc_pdata(host)->init_card(card);
+	else if (card->type == MMC_TYPE_SDIO ||
+		 card->type == MMC_TYPE_SD_COMBO) {
+		struct device_node *np = mmc_dev(mmc)->of_node;
+
+		/*
+		 * REVISIT: should be moved to sdio core and made more
+		 * general e.g. by expanding the DT bindings of child nodes
+		 * to provide a mechanism to provide this information:
+		 * Documentation/devicetree/bindings/mmc/mmc-card.txt
+		 */
+
+		np = of_get_compatible_child(np, "ti,wl1251");
+		if (np) {
+			/*
+			 * We have TI wl1251 attached to MMC3. Pass this
+			 * information to the SDIO core because it can't be
+			 * probed by normal methods.
+			 */
+
+			dev_info(host->dev, "found wl1251\n");
+			card->quirks |= MMC_QUIRK_NONSTD_SDIO;
+			card->cccr.wide_bus = 1;
+			card->cis.vendor = 0x104c;
+			card->cis.device = 0x9066;
+			card->cis.blksize = 512;
+			card->cis.max_dtr = 24000000;
+			card->ocr = 0x80;
+			of_node_put(np);
+		}
+	}
 }
 
 static void omap_hsmmc_enable_sdio_irq(struct mmc_host *mmc, int enable)


