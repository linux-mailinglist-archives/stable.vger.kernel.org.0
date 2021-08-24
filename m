Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFAC3F682C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241877AbhHXRlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242121AbhHXRjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:39:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F8B61BF3;
        Tue, 24 Aug 2021 17:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824889;
        bh=53r71JBP8p2LfzAQiH3+5iKfFwea/zlRyLgqLIzUNZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kL+itDfmUtshExne2+/F5OrMUGjIUuxtSlOCYndfZflc0CEuCYIjw4HbB27tFaTd9
         mX3xTRSGjhIbMftRw7sBofo3pvakhZOrRFpSPjzf2570tDs+PFfX7kyZ++l2tanPNg
         KmfuLbqL35p7g2PcmoyV1UV7jIxlMXgVtYLOeqQYCaBZfUwZn/Yo8WIJVByy3CviFJ
         2g2rG5Z3yxJq/0nBGWwPeeoV54rim4yd4JNVwOOvL6AfInKrwn+SoBFFfgse0u31dA
         tUHZjV9KhlKPY1+vspaC8+27kpK/xLiCWvGQWUlwSqrjUCa1Jn54d7O3EhYXSXLlqr
         MJzynaCefe2KQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 26/31] mmc: dw_mmc: call the dw_mci_prep_stop_abort() by default
Date:   Tue, 24 Aug 2021 13:07:38 -0400
Message-Id: <20210824170743.710957-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
index afdf539e06e9..72ab0623293c 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -380,7 +380,7 @@ static void dw_mci_start_command(struct dw_mci *host,
 
 static inline void send_stop_abort(struct dw_mci *host, struct mmc_data *data)
 {
-	struct mmc_command *stop = data->stop ? data->stop : &host->stop_abort;
+	struct mmc_command *stop = &host->stop_abort;
 
 	dw_mci_start_command(host, stop, host->stop_cmdr);
 }
@@ -1202,10 +1202,7 @@ static void __dw_mci_start_request(struct dw_mci *host,
 		spin_unlock_irqrestore(&host->irq_lock, irqflags);
 	}
 
-	if (mrq->stop)
-		host->stop_cmdr = dw_mci_prepare_command(slot->mmc, mrq->stop);
-	else
-		host->stop_cmdr = dw_mci_prep_stop_abort(host, cmd);
+	host->stop_cmdr = dw_mci_prep_stop_abort(host, cmd);
 }
 
 static void dw_mci_start_request(struct dw_mci *host,
@@ -1797,8 +1794,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
 				dw_mci_stop_dma(host);
-				if (data->stop ||
-				    !(host->data_status & (SDMMC_INT_DRTO |
+				if (!(host->data_status & (SDMMC_INT_DRTO |
 							   SDMMC_INT_EBE)))
 					send_stop_abort(host, data);
 				state = STATE_DATA_ERROR;
@@ -1835,8 +1831,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
 				dw_mci_stop_dma(host);
-				if (data->stop ||
-				    !(host->data_status & (SDMMC_INT_DRTO |
+				if (!(host->data_status & (SDMMC_INT_DRTO |
 							   SDMMC_INT_EBE)))
 					send_stop_abort(host, data);
 				state = STATE_DATA_ERROR;
@@ -1913,7 +1908,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			host->cmd = NULL;
 			host->data = NULL;
 
-			if (mrq->stop)
+			if (!mrq->sbc && mrq->stop)
 				dw_mci_command_complete(host, mrq->stop);
 			else
 				host->cmd_status = 0;
-- 
2.30.2

