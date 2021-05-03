Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9264371BD1
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhECQsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232979AbhECQqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:46:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42B446162C;
        Mon,  3 May 2021 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059974;
        bh=c1XL8kzC2yP2Nq+PsuvD7ah+97YXIbGx7cHbBa2zjqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGkfQL1N9UcxZuvE75GWz7mgS17/BsuWdHs0z0to1BEpuckD1VeGILmQcJ4vWb1mn
         yAJpZX7olWhIM6ubkpOQLVAvaas+Db9Ih0NFio0dn7lGp9m/w9ms4ojbv+3jhr5m43
         9Hzl94bX6yJqrTH+nIq0nS10QlN8f/rNC8bKbek3FW1YiDI1cDdtsfnWPcmnNbfEGf
         W0UbhO6QmO3jAu0lZcA5QF4WJj4NZt0Efzh2U5hhoPxtw2pehtdxmUnfDP1cpm6I94
         w/OIPwLE5xkUT8yQzGoXuMvYe5RM3EVrlUgFqjWJCKTFcOP/gQzRllmbnLn/h2Yv1W
         FHX3sKIN8fSEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Fan <peng.fan@nxp.com>, Bough Chen <haobo.chen@nxp.com>,
        Alice Guo <alice.guo@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 042/100] mmc: sdhci-esdhc-imx: validate pinctrl before use it
Date:   Mon,  3 May 2021 12:37:31 -0400
Message-Id: <20210503163829.2852775-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f410ee0aa2df050a9505f5c261953e9b18e21206 ]

When imx_data->pinctrl is not a valid pointer, pinctrl_lookup_state
will trigger kernel panic.

When we boot Dual OS on Jailhouse hypervisor, we let the 1st Linux to
configure pinmux ready for the 2nd OS, so the 2nd OS not have pinctrl
settings.

Similar to this commit b62eee9f804e ("mmc: sdhci-esdhc-imx: no fail when no pinctrl available").

Reviewed-by: Bough Chen <haobo.chen@nxp.com>
Reviewed-by: Alice Guo <alice.guo@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/1614222604-27066-6-git-send-email-peng.fan@oss.nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 5d9b3106d2f7..d28809e47962 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1504,7 +1504,7 @@ sdhci_esdhc_imx_probe_dt(struct platform_device *pdev,
 
 	mmc_of_parse_voltage(np, &host->ocr_mask);
 
-	if (esdhc_is_usdhc(imx_data)) {
+	if (esdhc_is_usdhc(imx_data) && !IS_ERR(imx_data->pinctrl)) {
 		imx_data->pins_100mhz = pinctrl_lookup_state(imx_data->pinctrl,
 						ESDHC_PINCTRL_STATE_100MHZ);
 		imx_data->pins_200mhz = pinctrl_lookup_state(imx_data->pinctrl,
-- 
2.30.2

