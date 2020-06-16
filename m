Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F91FB9A9
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731992AbgFPQFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730466AbgFPPsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:48:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A1E821475;
        Tue, 16 Jun 2020 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322526;
        bh=7iKMm7KSRQUJ5Y+WeKndqu7co8tjv7zaxZdV9VUdtYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4JtVA3jDLq3jcUuL5/g4dHnFf9UtdRVaWuffgV9aq+E0LQ+jOgVtdJabXS+z6W1Z
         o92v1nXY+s77W7waqTaxkSR9WgnkhFfXtCaYvXlGQhICy/mUo5PPJbCX6hZJJI3l3N
         gyF8e7VqKgZ+9nyNNBBUcRq7aQEXfNohefmIhHoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.7 157/163] mmc: sdio: Fix several potential memory leaks in mmc_sdio_init_card()
Date:   Tue, 16 Jun 2020 17:35:31 +0200
Message-Id: <20200616153114.326712847@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit a94a59f43749b4f8cd81b8be87c95f9ef898d19d upstream.

Over the years, the code in mmc_sdio_init_card() has grown to become quite
messy. Unfortunate this has also lead to that several paths are leaking
memory in form of an allocated struct mmc_card, which includes additional
data, such as initialized struct device for example.

Unfortunate, it's a too complex task find each offending commit. Therefore,
this change fixes all memory leaks at once.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200430091640.455-3-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sdio.c |   58 ++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -584,7 +584,7 @@ try_again:
 	 */
 	err = mmc_send_io_op_cond(host, ocr, &rocr);
 	if (err)
-		goto err;
+		return err;
 
 	/*
 	 * For SPI, enable CRC as appropriate.
@@ -592,17 +592,15 @@ try_again:
 	if (mmc_host_is_spi(host)) {
 		err = mmc_spi_set_crc(host, use_spi_crc);
 		if (err)
-			goto err;
+			return err;
 	}
 
 	/*
 	 * Allocate card structure.
 	 */
 	card = mmc_alloc_card(host, NULL);
-	if (IS_ERR(card)) {
-		err = PTR_ERR(card);
-		goto err;
-	}
+	if (IS_ERR(card))
+		return PTR_ERR(card);
 
 	if ((rocr & R4_MEMORY_PRESENT) &&
 	    mmc_sd_get_cid(host, ocr & rocr, card->raw_cid, NULL) == 0) {
@@ -610,19 +608,15 @@ try_again:
 
 		if (oldcard && (oldcard->type != MMC_TYPE_SD_COMBO ||
 		    memcmp(card->raw_cid, oldcard->raw_cid, sizeof(card->raw_cid)) != 0)) {
-			mmc_remove_card(card);
-			pr_debug("%s: Perhaps the card was replaced\n",
-				mmc_hostname(host));
-			return -ENOENT;
+			err = -ENOENT;
+			goto mismatch;
 		}
 	} else {
 		card->type = MMC_TYPE_SDIO;
 
 		if (oldcard && oldcard->type != MMC_TYPE_SDIO) {
-			mmc_remove_card(card);
-			pr_debug("%s: Perhaps the card was replaced\n",
-				mmc_hostname(host));
-			return -ENOENT;
+			err = -ENOENT;
+			goto mismatch;
 		}
 	}
 
@@ -677,7 +671,7 @@ try_again:
 	if (!oldcard && card->type == MMC_TYPE_SD_COMBO) {
 		err = mmc_sd_get_csd(host, card);
 		if (err)
-			return err;
+			goto remove;
 
 		mmc_decode_cid(card);
 	}
@@ -704,7 +698,12 @@ try_again:
 			mmc_set_timing(card->host, MMC_TIMING_SD_HS);
 		}
 
-		goto finish;
+		if (oldcard)
+			mmc_remove_card(card);
+		else
+			host->card = card;
+
+		return 0;
 	}
 
 	/*
@@ -730,16 +729,14 @@ try_again:
 		goto remove;
 
 	if (oldcard) {
-		int same = (card->cis.vendor == oldcard->cis.vendor &&
-			    card->cis.device == oldcard->cis.device);
-		mmc_remove_card(card);
-		if (!same) {
-			pr_debug("%s: Perhaps the card was replaced\n",
-				mmc_hostname(host));
-			return -ENOENT;
+		if (card->cis.vendor == oldcard->cis.vendor &&
+		    card->cis.device == oldcard->cis.device) {
+			mmc_remove_card(card);
+			card = oldcard;
+		} else {
+			err = -ENOENT;
+			goto mismatch;
 		}
-
-		card = oldcard;
 	}
 	card->ocr = ocr_card;
 	mmc_fixup_device(card, sdio_fixup_methods);
@@ -800,16 +797,15 @@ try_again:
 		err = -EINVAL;
 		goto remove;
 	}
-finish:
-	if (!oldcard)
-		host->card = card;
+
+	host->card = card;
 	return 0;
 
+mismatch:
+	pr_debug("%s: Perhaps the card was replaced\n", mmc_hostname(host));
 remove:
-	if (!oldcard)
+	if (oldcard != card)
 		mmc_remove_card(card);
-
-err:
 	return err;
 }
 


