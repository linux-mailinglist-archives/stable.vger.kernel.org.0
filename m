Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43B71F276C
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbgFHX0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731974AbgFHX0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:26:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A2C020775;
        Mon,  8 Jun 2020 23:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658789;
        bh=dA8deVe8Oc5xCiWh0RcR44ajduoZk4p5UPFlT99UIfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi3xE4nIktiVbBUD4HB7oxIv2jHWe7xb7gVn+LdY4VNfB+LEJjmFUgy7sYm3pAx6W
         Yy03luoe7CzRjaVg+MhKRdo96B6gEe50D20Wagm+doB0dFgzfkcvJAHEWwksP+Ccdr
         UF4+wM81qbO0v7hNSkuBWDryfi4kK4dCg8ZA05Uc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 65/72] mmc: via-sdmmc: Respect the cmd->busy_timeout from the mmc core
Date:   Mon,  8 Jun 2020 19:24:53 -0400
Message-Id: <20200608232500.3369581-65-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 966244ccd2919e28f25555a77f204cd1c109cad8 ]

Using a fixed 1s timeout for all commands (and data transfers) is a bit
problematic.

For some commands it means waiting longer than needed for the timer to
expire, which may not a big issue, but still. For other commands, like for
an erase (CMD38) that uses a R1B response, may require longer timeouts than
1s. In these cases, we may end up treating the command as it failed, while
it just needed some more time to complete successfully.

Fix the problem by respecting the cmd->busy_timeout, which is provided by
the mmc core.

Cc: Bruce Chang <brucechang@via.com.tw>
Cc: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200414161413.3036-17-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/via-sdmmc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index a838bf5480d8..a863a345fc59 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -323,6 +323,8 @@ struct via_crdr_mmc_host {
 /* some devices need a very long delay for power to stabilize */
 #define VIA_CRDR_QUIRK_300MS_PWRDELAY	0x0001
 
+#define VIA_CMD_TIMEOUT_MS		1000
+
 static const struct pci_device_id via_ids[] = {
 	{PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_9530,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
@@ -555,14 +557,17 @@ static void via_sdc_send_command(struct via_crdr_mmc_host *host,
 {
 	void __iomem *addrbase;
 	struct mmc_data *data;
+	unsigned int timeout_ms;
 	u32 cmdctrl = 0;
 
 	WARN_ON(host->cmd);
 
 	data = cmd->data;
-	mod_timer(&host->timer, jiffies + HZ);
 	host->cmd = cmd;
 
+	timeout_ms = cmd->busy_timeout ? cmd->busy_timeout : VIA_CMD_TIMEOUT_MS;
+	mod_timer(&host->timer, jiffies + msecs_to_jiffies(timeout_ms));
+
 	/*Command index*/
 	cmdctrl = cmd->opcode << 8;
 
-- 
2.25.1

