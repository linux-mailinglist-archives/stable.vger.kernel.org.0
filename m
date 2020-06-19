Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E8F201556
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394668AbgFSQVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388718AbgFSPAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:00:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 578022193E;
        Fri, 19 Jun 2020 15:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578847;
        bh=4ljtbtWFQHlpXv5YMNSizjWjGiVY5t/bwWmBU85FxWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOCu/Yyqk12ZXJgSq74y1AxMVW5gCTwd8j2jIWb1gBpqVDak983vSDrq23xFc9Qih
         hM9YSruRoKEqvMjxiNQ84bENGgM5kAyf086DbMKuQxa056i9rUN2+aoxZwMGTQdY1R
         nD7M7gYHHnmhma24lFZA+drYEjd11A4aeFzZTmMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 179/267] mmc: via-sdmmc: Respect the cmd->busy_timeout from the mmc core
Date:   Fri, 19 Jun 2020 16:32:44 +0200
Message-Id: <20200619141657.367848960@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
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
index 32c4211506fc..246dc6255e69 100644
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



