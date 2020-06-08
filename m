Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADE81F2EED
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgFHXLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgFHXLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9DBD20897;
        Mon,  8 Jun 2020 23:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657893;
        bh=J2LPRJU66y4X8KcWE0g+592NbySdoJsVXoYtZI00P5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROP1rxkHmSif6KNnYX1KxXVihi18D7znAeCVKrM4JfqmcpMAO2N5DGoWqSkR+DckI
         9bG3th7dla5RoL0AlyciPDYvYRlw+AqeKhvBN1HOydba8dt8EPmEJ1Ce/4CEhdQaSA
         +FZmqdizTHwRR7Bh7T/2UgUoC5LNoVvtimsm9Kl8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 248/274] mmc: owl-mmc: Respect the cmd->busy_timeout from the mmc core
Date:   Mon,  8 Jun 2020 19:05:41 -0400
Message-Id: <20200608230607.3361041-248-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

