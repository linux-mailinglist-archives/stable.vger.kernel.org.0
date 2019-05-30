Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7F2F259
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfE3EU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730194AbfE3DPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDBC2244EF;
        Thu, 30 May 2019 03:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186115;
        bh=VXyRPV+AZqNbT4pLdeZ9aZNRbMmkTY9wRADnGD5Tbac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wjxc0JgxEAXoiN+dtZwWgycStxqKAhUVH0Qhmm06n6apOedCAqB/4Az+oRqWptIgT
         47b+yTCXuoRvc1HeV9jI2DAlzqvZ1Bx/qr7hl9DJ6Jo8nHDN//SfwUlyrzMxqtVdXU
         qY31vtRY2G/2ffaz/cLHKMB+4kBXvbfkS9iTQv54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George Hilliard <thirtythreeforty@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 268/346] staging: mt7621-mmc: Initialize completions a single time during probe
Date:   Wed, 29 May 2019 20:05:41 -0700
Message-Id: <20190530030554.553156406@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7ca8c2c8bbeda2a2a2a9898cd35066bc1dc83836 ]

The module was initializing completions whenever it was going to wait on
them, and not when the completion was allocated.  This is incorrect
according to the completion docs:

    Calling init_completion() on the same completion object twice is
    most likely a bug [...]

Re-initialization is also unnecessary because the module never uses
complete_all().  Fix this by only ever initializing the completion a
single time, and log if the completions are not consumed as intended
(this is not a fatal problem, but should not go unnoticed).

Signed-off-by: George Hilliard <thirtythreeforty@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-mmc/sd.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/mt7621-mmc/sd.c b/drivers/staging/mt7621-mmc/sd.c
index 4b26ec896a96f..74f0e57ad2f15 100644
--- a/drivers/staging/mt7621-mmc/sd.c
+++ b/drivers/staging/mt7621-mmc/sd.c
@@ -468,7 +468,11 @@ static unsigned int msdc_command_start(struct msdc_host   *host,
 	host->cmd     = cmd;
 	host->cmd_rsp = resp;
 
-	init_completion(&host->cmd_done);
+	// The completion should have been consumed by the previous command
+	// response handler, because the mmc requests should be serialized
+	if (completion_done(&host->cmd_done))
+		dev_err(mmc_dev(host->mmc),
+			"previous command was not handled\n");
 
 	sdr_set_bits(host->base + MSDC_INTEN, wints);
 	sdc_send_cmd(rawcmd, cmd->arg);
@@ -490,7 +494,6 @@ static unsigned int msdc_command_resp(struct msdc_host   *host,
 		    MSDC_INT_ACMD19_DONE;
 
 	BUG_ON(in_interrupt());
-	//init_completion(&host->cmd_done);
 	//sdr_set_bits(host->base + MSDC_INTEN, wints);
 
 	spin_unlock(&host->lock);
@@ -674,7 +677,13 @@ static int msdc_do_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		//msdc_clr_fifo(host);  /* no need */
 
 		msdc_dma_on();  /* enable DMA mode first!! */
-		init_completion(&host->xfer_done);
+
+		// The completion should have been consumed by the previous
+		// xfer response handler, because the mmc requests should be
+		// serialized
+		if (completion_done(&host->cmd_done))
+			dev_err(mmc_dev(host->mmc),
+				"previous transfer was not handled\n");
 
 		/* start the command first*/
 		if (msdc_command_start(host, cmd, CMD_TIMEOUT) != 0)
@@ -693,7 +702,6 @@ static int msdc_do_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		/* for read, the data coming too fast, then CRC error
 		 *  start DMA no business with CRC.
 		 */
-		//init_completion(&host->xfer_done);
 		msdc_dma_start(host);
 
 		spin_unlock(&host->lock);
@@ -1688,6 +1696,8 @@ static int msdc_drv_probe(struct platform_device *pdev)
 	}
 	msdc_init_gpd_bd(host, &host->dma);
 
+	init_completion(&host->cmd_done);
+	init_completion(&host->xfer_done);
 	INIT_DELAYED_WORK(&host->card_delaywork, msdc_tasklet_card);
 	spin_lock_init(&host->lock);
 	msdc_init_hw(host);
-- 
2.20.1



