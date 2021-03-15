Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24F833B99A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhCOOGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233464AbhCOOBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 150C864F39;
        Mon, 15 Mar 2021 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816898;
        bh=PTcLLVHr/9HBRIE549YIz8JnuFcy9FkCf0zgoZIqlec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcsH3lXuXhvf2WoN/9n1Usq6XyCK6rlZTKRrmlK0Q9dts1qtrYcwIHeb3U5KlFGZ6
         v0/SenWoMRFttZuqaZoiImrBCXuTJin196V8s2WsyqUFFbH82ebNHUssrpu6LMmKPp
         XRBcwk+Ru+bOEzyNUnwH5nHIV258Odeor5sScDQc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yann Gautier <yann.gautier@foss.st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.11 189/306] mmc: mmci: Add MMC_CAP_NEED_RSP_BUSY for the stm32 variants
Date:   Mon, 15 Mar 2021 14:54:12 +0100
Message-Id: <20210315135514.001542867@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Yann Gautier <yann.gautier@foss.st.com>

commit 774514bf977377c9137640a0310bd64eed0f7323 upstream.

An issue has been observed on STM32MP157C-EV1 board, with an erase command
with secure erase argument, ending up waiting for ~4 hours before timeout.

The requested busy timeout from the mmc core ends up with 14784000ms (~4
hours), but the supported host->max_busy_timeout is 86767ms, which leads to
that the core switch to use an R1 response in favor of the R1B and polls
for busy with the host->card_busy() ops. In this case the polling doesn't
work as expected, as we never detects that the card stops signaling busy,
which leads to the following message:

 mmc1: Card stuck being busy! __mmc_poll_for_busy

The problem boils done to that the stm32 variants can't use R1 responses in
favor of R1B responses, as it leads to an internal state machine in the
controller to get stuck. To continue to process requests, it would need to
be reset.

To fix this problem, let's set MMC_CAP_NEED_RSP_BUSY for the stm32 variant,
which prevent the mmc core from switching to R1 responses. Additionally,
let's cap the cmd->busy_timeout to the host->max_busy_timeout, thus rely on
86767ms to be sufficient (~66 seconds was need for this test case).

Fixes: 94fe2580a2f3 ("mmc: core: Enable erase/discard/trim support for all mmc hosts")
Signed-off-by: Yann Gautier <yann.gautier@foss.st.com>
Link: https://lore.kernel.org/r/20210225145454.12780-1-yann.gautier@foss.st.com
Cc: stable@vger.kernel.org
[Ulf: Simplified the code and extended the commit message]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1241,7 +1241,11 @@ mmci_start_command(struct mmci_host *hos
 		if (!cmd->busy_timeout)
 			cmd->busy_timeout = 10 * MSEC_PER_SEC;
 
-		clks = (unsigned long long)cmd->busy_timeout * host->cclk;
+		if (cmd->busy_timeout > host->mmc->max_busy_timeout)
+			clks = (unsigned long long)host->mmc->max_busy_timeout * host->cclk;
+		else
+			clks = (unsigned long long)cmd->busy_timeout * host->cclk;
+
 		do_div(clks, MSEC_PER_SEC);
 		writel_relaxed(clks, host->base + MMCIDATATIMER);
 	}
@@ -2091,6 +2095,10 @@ static int mmci_probe(struct amba_device
 		mmc->caps |= MMC_CAP_WAIT_WHILE_BUSY;
 	}
 
+	/* Variants with mandatory busy timeout in HW needs R1B responses. */
+	if (variant->busy_timeout)
+		mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
+
 	/* Prepare a CMD12 - needed to clear the DPSM on some variants. */
 	host->stop_abort.opcode = MMC_STOP_TRANSMISSION;
 	host->stop_abort.arg = 0;


