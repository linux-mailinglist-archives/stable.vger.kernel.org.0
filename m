Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5E93F67C7
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhHXRhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242432AbhHXRfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CBBC61BCF;
        Tue, 24 Aug 2021 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824810;
        bh=z8rd4b6+JLdPQtvEFVd5V/UFtC1lMaWBjf48Z+QV1uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfaequGQzsCoTq2SFfw9J5AocZ2tuD7qLqB6yr4qrklBkIschch7WLiopL3RNzXYm
         OyP0Zo78gDboVMbahzfX5Xml1dulQJjTPDaWOm/TSEgQR0/01nhBTV8iVAqWRUjShe
         MU24pvB2o0iIQ1l7ktfKILw6sS183lJ2+ufMGxIniR7rC76UP4u1a1+YR4I5qNjxZg
         hKYPHw0fGpowAuY0mvFlQYVWpiDWf9y+woj5kXRA8LPHfAHWnsYgdg4fYALeqPqMbO
         dMk4Kvck/cYpgos6F3YbpGoJoZ6xWOz5thubxxcy6jQzqAWfgzlOTHzZjQy1Mgu0ko
         FNLRJplS5ClUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 35/43] mmc: dw_mmc: call the dw_mci_prep_stop_abort() by default
Date:   Tue, 24 Aug 2021 13:06:06 -0400
Message-Id: <20210824170614.710813-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaehoon Chung <jh80.chung@samsung.com>

[ Upstream commit e13c3c081845b51e8ba71a90e91c52679cfdbf89 ]

stop_cmdr should be set to values relevant to stop command.
It migth be assigned to values whatever there is mrq->stop or not.
Then it doesn't need to use dw_mci_prepare_command().
It's enough to use the prep_stop_abort for preparing stop command.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index d9c7fd0cabaf..4b3e1079c39f 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -380,7 +380,7 @@ static void dw_mci_start_command(struct dw_mci *host,
 
 static inline void send_stop_abort(struct dw_mci *host, struct mmc_data *data)
 {
-	struct mmc_command *stop = data->stop ? data->stop : &host->stop_abort;
+	struct mmc_command *stop = &host->stop_abort;
 
 	dw_mci_start_command(host, stop, host->stop_cmdr);
 }
@@ -1280,10 +1280,7 @@ static void __dw_mci_start_request(struct dw_mci *host,
 		spin_unlock_irqrestore(&host->irq_lock, irqflags);
 	}
 
-	if (mrq->stop)
-		host->stop_cmdr = dw_mci_prepare_command(slot->mmc, mrq->stop);
-	else
-		host->stop_cmdr = dw_mci_prep_stop_abort(host, cmd);
+	host->stop_cmdr = dw_mci_prep_stop_abort(host, cmd);
 }
 
 static void dw_mci_start_request(struct dw_mci *host,
@@ -1895,8 +1892,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
 				dw_mci_stop_dma(host);
-				if (data->stop ||
-				    !(host->data_status & (SDMMC_INT_DRTO |
+				if (!(host->data_status & (SDMMC_INT_DRTO |
 							   SDMMC_INT_EBE)))
 					send_stop_abort(host, data);
 				state = STATE_DATA_ERROR;
@@ -1932,8 +1928,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
 				dw_mci_stop_dma(host);
-				if (data->stop ||
-				    !(host->data_status & (SDMMC_INT_DRTO |
+				if (!(host->data_status & (SDMMC_INT_DRTO |
 							   SDMMC_INT_EBE)))
 					send_stop_abort(host, data);
 				state = STATE_DATA_ERROR;
@@ -2009,7 +2004,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			host->cmd = NULL;
 			host->data = NULL;
 
-			if (mrq->stop)
+			if (!mrq->sbc && mrq->stop)
 				dw_mci_command_complete(host, mrq->stop);
 			else
 				host->cmd_status = 0;
-- 
2.30.2

