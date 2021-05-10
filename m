Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D1437857D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhEJLAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234258AbhEJK4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFF2C6197F;
        Mon, 10 May 2021 10:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643501;
        bh=J55OhXl7bt+Rg0RRs1ct9kI544Z6zpEdcRAC0jMMGlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jB7V0EB1YXkLxCxWlGVrwmWRrhcdt7O0g1PSI44Y4lE1D+9jo/khnzuGtjbNvR5/f
         7XDVQDuOQl11u4gsnG80U/VDvMagfuCS68ttLOqJOiUUgHAHVsUGZVshxPU1tCBzpF
         W+eNY5El6Dw8JvBun8Ki7iz+wjw+Yae9uCNmEDiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Pradeep P V K <pragalla@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.11 040/342] mmc: sdhci: Check for reset prior to DMA address unmap
Date:   Mon, 10 May 2021 12:17:10 +0200
Message-Id: <20210510102011.417074405@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
@@ -2998,6 +2998,37 @@ static bool sdhci_request_done(struct sd
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
@@ -3060,35 +3091,6 @@ static bool sdhci_request_done(struct sd
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


