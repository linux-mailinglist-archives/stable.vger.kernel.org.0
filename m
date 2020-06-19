Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8542011DE
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391943AbgFSPq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404332AbgFSP0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:26:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AFB521582;
        Fri, 19 Jun 2020 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580394;
        bh=MHM7Fdo3PdvDzgIUfO+YIaHewyH4D4uZ7SHnfgDihPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHYg1ePxYhWMu0mVfhj2BkcyOq4x9p6OFzLGNNL8m/cb9M8iX08W1jPjCEpBLIQuE
         cbw/yDv4ewzf7JaX27NzbhCAp5PhnTl9qiZBAB4qc+vpVv7J1C/cSkws/Ak/ebsOuS
         240WiRgbxXWdsh6moN/tWctZiNx7ywSMhFmHD3AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 232/376] mmc: via-sdmmc: Respect the cmd->busy_timeout from the mmc core
Date:   Fri, 19 Jun 2020 16:32:30 +0200
Message-Id: <20200619141721.303067965@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e48bddd95ce6..ef95bce50889 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -319,6 +319,8 @@ struct via_crdr_mmc_host {
 /* some devices need a very long delay for power to stabilize */
 #define VIA_CRDR_QUIRK_300MS_PWRDELAY	0x0001
 
+#define VIA_CMD_TIMEOUT_MS		1000
+
 static const struct pci_device_id via_ids[] = {
 	{PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_9530,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
@@ -551,14 +553,17 @@ static void via_sdc_send_command(struct via_crdr_mmc_host *host,
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



