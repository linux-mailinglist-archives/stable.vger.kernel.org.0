Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60042011E0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392229AbgFSPqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404325AbgFSP0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:26:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DDAE21582;
        Fri, 19 Jun 2020 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580392;
        bh=J2LPRJU66y4X8KcWE0g+592NbySdoJsVXoYtZI00P5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IcM2cnlxnsM+EEH/6SmHk8ajhTP1ViMTFf2rVzzk0xxvl7LIhPGrkFImDZmxzdXE
         Lqaq/PHXX0nWSy2fxNKiUIvDTb9aTOgRes/i3/PvIXBsKaWgjwoxBzf3cXCFEEbi57
         5OBIBH5V6unZXZJdZLkVhW0B7H2HmGNPUaVeyxo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 231/376] mmc: owl-mmc: Respect the cmd->busy_timeout from the mmc core
Date:   Fri, 19 Jun 2020 16:32:29 +0200
Message-Id: <20200619141721.255466678@linuxfoundation.org>
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

[ Upstream commit f37ac1ae3ca93d0995553ad9604a25eadfe9406d ]

For commands that doesn't involve to prepare a data transfer, owl-mmc is
using a fixed 30s response timeout. This is a bit problematic.

For some commands it means waiting longer than needed for the completion to
expire, which may not a big issue, but still. For other commands, like for
an erase (CMD38) that uses a R1B response, may require longer timeouts than
30s. In these cases, we may end up treating the command as it failed, while
it just needed some more time to complete successfully.

Fix the problem by respecting the cmd->busy_timeout, which is provided by
the mmc core.

Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200414161413.3036-8-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/owl-mmc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/owl-mmc.c b/drivers/mmc/host/owl-mmc.c
index 01ffe51f413d..5e20c099fe03 100644
--- a/drivers/mmc/host/owl-mmc.c
+++ b/drivers/mmc/host/owl-mmc.c
@@ -92,6 +92,8 @@
 #define OWL_SD_STATE_RC16ER		BIT(1)
 #define OWL_SD_STATE_CRC7ER		BIT(0)
 
+#define OWL_CMD_TIMEOUT_MS		30000
+
 struct owl_mmc_host {
 	struct device *dev;
 	struct reset_control *reset;
@@ -172,6 +174,7 @@ static void owl_mmc_send_cmd(struct owl_mmc_host *owl_host,
 			     struct mmc_command *cmd,
 			     struct mmc_data *data)
 {
+	unsigned long timeout;
 	u32 mode, state, resp[2];
 	u32 cmd_rsp_mask = 0;
 
@@ -239,7 +242,10 @@ static void owl_mmc_send_cmd(struct owl_mmc_host *owl_host,
 	if (data)
 		return;
 
-	if (!wait_for_completion_timeout(&owl_host->sdc_complete, 30 * HZ)) {
+	timeout = msecs_to_jiffies(cmd->busy_timeout ? cmd->busy_timeout :
+		OWL_CMD_TIMEOUT_MS);
+
+	if (!wait_for_completion_timeout(&owl_host->sdc_complete, timeout)) {
 		dev_err(owl_host->dev, "CMD interrupt timeout\n");
 		cmd->error = -ETIMEDOUT;
 		return;
-- 
2.25.1



