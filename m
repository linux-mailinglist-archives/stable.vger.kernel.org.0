Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2713137818A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhEJK1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231374AbhEJK0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:26:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A552461574;
        Mon, 10 May 2021 10:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642334;
        bh=am4yCvCqepaXfaCxCE2/BgsmmG/JwxboL0ErhGzBseY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYn5yuqAoRGX2fJKlenwcLTY4DDkbva1LGYukxmzgiEReejdeGFCIGjEZ1Hbaabb3
         EUc1r6T9TJDzC2oPAjAuN04k2qAzqlDlSO7aso4oI+FtOjBiOBDjoFyTz4Sdv7L3dA
         HjR9UNdAl1lvLpGGMupzByYjzzAlOiXhABpNAEDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Pradeep P V K <pragalla@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 017/184] mmc: sdhci: Check for reset prior to DMA address unmap
Date:   Mon, 10 May 2021 12:18:31 +0200
Message-Id: <20210510101950.783394194@linuxfoundation.org>
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

From: Pradeep P V K <pragalla@codeaurora.org>

commit 21e35e898aa9ef7781632959db8613a5380f2eae upstream.

For data read commands, SDHC may initiate data transfers even before it
completely process the command response. In case command itself fails,
driver un-maps the memory associated with data transfer but this memory
can still be accessed by SDHC for the already initiated data transfer.
This scenario can lead to un-mapped memory access error.

To avoid this scenario, reset SDHC (when command fails) prior to
un-mapping memory. Resetting SDHC ensures that all in-flight data
transfers are either aborted or completed. So we don't run into this
scenario.

Swap the reset, un-map steps sequence in sdhci_request_done().

Suggested-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Signed-off-by: Pradeep P V K <pragalla@codeaurora.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/1614760331-43499-1-git-send-email-pragalla@qti.qualcomm.com
Cc: stable@vger.kernel.org # v4.9+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |   60 ++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2648,6 +2648,37 @@ static bool sdhci_request_done(struct sd
 	}
 
 	/*
+	 * The controller needs a reset of internal state machines
+	 * upon error conditions.
+	 */
+	if (sdhci_needs_reset(host, mrq)) {
+		/*
+		 * Do not finish until command and data lines are available for
+		 * reset. Note there can only be one other mrq, so it cannot
+		 * also be in mrqs_done, otherwise host->cmd and host->data_cmd
+		 * would both be null.
+		 */
+		if (host->cmd || host->data_cmd) {
+			spin_unlock_irqrestore(&host->lock, flags);
+			return true;
+		}
+
+		/* Some controllers need this kick or reset won't work here */
+		if (host->quirks & SDHCI_QUIRK_CLOCK_BEFORE_RESET)
+			/* This is to force an update */
+			host->ops->set_clock(host, host->clock);
+
+		/*
+		 * Spec says we should do both at the same time, but Ricoh
+		 * controllers do not like that.
+		 */
+		sdhci_do_reset(host, SDHCI_RESET_CMD);
+		sdhci_do_reset(host, SDHCI_RESET_DATA);
+
+		host->pending_reset = false;
+	}
+
+	/*
 	 * Always unmap the data buffers if they were mapped by
 	 * sdhci_prepare_data() whenever we finish with a request.
 	 * This avoids leaking DMA mappings on error.
@@ -2699,35 +2730,6 @@ static bool sdhci_request_done(struct sd
 		}
 	}
 
-	/*
-	 * The controller needs a reset of internal state machines
-	 * upon error conditions.
-	 */
-	if (sdhci_needs_reset(host, mrq)) {
-		/*
-		 * Do not finish until command and data lines are available for
-		 * reset. Note there can only be one other mrq, so it cannot
-		 * also be in mrqs_done, otherwise host->cmd and host->data_cmd
-		 * would both be null.
-		 */
-		if (host->cmd || host->data_cmd) {
-			spin_unlock_irqrestore(&host->lock, flags);
-			return true;
-		}
-
-		/* Some controllers need this kick or reset won't work here */
-		if (host->quirks & SDHCI_QUIRK_CLOCK_BEFORE_RESET)
-			/* This is to force an update */
-			host->ops->set_clock(host, host->clock);
-
-		/* Spec says we should do both at the same time, but Ricoh
-		   controllers do not like that. */
-		sdhci_do_reset(host, SDHCI_RESET_CMD);
-		sdhci_do_reset(host, SDHCI_RESET_DATA);
-
-		host->pending_reset = false;
-	}
-
 	host->mrqs_done[i] = NULL;
 
 	spin_unlock_irqrestore(&host->lock, flags);


