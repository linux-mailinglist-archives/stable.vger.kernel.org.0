Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6BC26A752
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgIOOkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgIOOjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2387E23D20;
        Tue, 15 Sep 2020 14:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180197;
        bh=YyA7VUKTSTDrFSQMiIR9540oXL+Hk7219jpS6Lyi+XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+vkyOBInf9lGruEazH56SP+2BpGKiEcUQV8NSreyXxZv4Sju8UnGTLXMAHJTNDWN
         Zn8YARpX74+vFg1q1pBRKFdQffRAnodpZIIa6iqGjYiatjc/X4JVWqlgiGJAzzaIay
         keMqAaXEKwqmO1q7b7malSh9ZrxuZQ1RqEkxmYSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.8 146/177] mmc: sdio: Use mmc_pre_req() / mmc_post_req()
Date:   Tue, 15 Sep 2020 16:13:37 +0200
Message-Id: <20200915140700.651150531@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit f0c393e2104e48c8a881719a8bd37996f71b0aee upstream.

SDHCI changed from using a tasklet to finish requests, to using an IRQ
thread i.e. commit c07a48c2651965 ("mmc: sdhci: Remove finish_tasklet").
Because this increased the latency to complete requests, a preparatory
change was made to complete the request from the IRQ handler if
possible i.e. commit 19d2f695f4e827 ("mmc: sdhci: Call mmc_request_done()
from IRQ handler if possible").  That alleviated the situation for MMC
block devices because the MMC block driver makes use of mmc_pre_req()
and mmc_post_req() so that successful requests are completed in the IRQ
handler and any DMA unmapping is handled separately in mmc_post_req().
However SDIO was still affected, and an example has been reported with
up to 20% degradation in performance.

Looking at SDIO I/O helper functions, sdio_io_rw_ext_helper() appeared
to be a possible candidate for making use of asynchronous requests
within its I/O loops, but analysis revealed that these loops almost
never iterate more than once, so the complexity of the change would not
be warrented.

Instead, mmc_pre_req() and mmc_post_req() are added before and after I/O
submission (mmc_wait_for_req) in mmc_io_rw_extended().  This still has
the potential benefit of reducing the duration of interrupt handlers, as
well as addressing the latency issue for SDHCI.  It also seems a more
reasonable solution than forcing drivers to do everything in the IRQ
handler.

Reported-by: Dmitry Osipenko <digetx@gmail.com>
Fixes: c07a48c2651965 ("mmc: sdhci: Remove finish_tasklet")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200903082007.18715-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sdio_ops.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -121,6 +121,7 @@ int mmc_io_rw_extended(struct mmc_card *
 	struct sg_table sgtable;
 	unsigned int nents, left_size, i;
 	unsigned int seg_size = card->host->max_seg_size;
+	int err;
 
 	WARN_ON(blksz == 0);
 
@@ -170,28 +171,32 @@ int mmc_io_rw_extended(struct mmc_card *
 
 	mmc_set_data_timeout(&data, card);
 
-	mmc_wait_for_req(card->host, &mrq);
+	mmc_pre_req(card->host, &mrq);
 
-	if (nents > 1)
-		sg_free_table(&sgtable);
+	mmc_wait_for_req(card->host, &mrq);
 
 	if (cmd.error)
-		return cmd.error;
-	if (data.error)
-		return data.error;
-
-	if (mmc_host_is_spi(card->host)) {
+		err = cmd.error;
+	else if (data.error)
+		err = data.error;
+	else if (mmc_host_is_spi(card->host))
 		/* host driver already reported errors */
-	} else {
-		if (cmd.resp[0] & R5_ERROR)
-			return -EIO;
-		if (cmd.resp[0] & R5_FUNCTION_NUMBER)
-			return -EINVAL;
-		if (cmd.resp[0] & R5_OUT_OF_RANGE)
-			return -ERANGE;
-	}
+		err = 0;
+	else if (cmd.resp[0] & R5_ERROR)
+		err = -EIO;
+	else if (cmd.resp[0] & R5_FUNCTION_NUMBER)
+		err = -EINVAL;
+	else if (cmd.resp[0] & R5_OUT_OF_RANGE)
+		err = -ERANGE;
+	else
+		err = 0;
+
+	mmc_post_req(card->host, &mrq, err);
+
+	if (nents > 1)
+		sg_free_table(&sgtable);
 
-	return 0;
+	return err;
 }
 
 int sdio_reset(struct mmc_host *host)


