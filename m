Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FC6371A7E
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhECQjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhECQif (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:38:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D96F613B3;
        Mon,  3 May 2021 16:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059812;
        bh=fh8NTrcVEp7XEynMX0wepwrZy+rJKZt3MliX/P9XDEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCBpXsKMKNmzWfh/GCR+5Haci9uCINm6Lahldm4U3rV0fxCRtqt25oENQu22PKj9r
         HY/dJbNmICn9zUcQf4JyBMjq2VZxLbCBYovIXSLyfpysHWtYHmkkE5/N5qwL3VlddT
         Nl3+gKW+f9VSmQBXeTIUZRKs+yx0Qa4rN0lK5tFRPKrKTNLt1sE+JSWxjghhkCBanJ
         RC+ZYDJi5MAutQPMLFuCbbyT0PrRxDg5nMZ0je6wmKsMPRxMpbLdZis3E7qkdCUXBf
         4HHm4Utjg6vgt0iIh6+BXPfcbmsc1db1NRFufwKs55ug1Gmdp19DGevUdnymQLLpk0
         52gjO6XEGTzVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Fan <peng.fan@nxp.com>, Bough Chen <haobo.chen@nxp.com>,
        Alice Guo <alice.guo@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 063/134] mmc: sdhci-esdhc-imx: validate pinctrl before use it
Date:   Mon,  3 May 2021 12:34:02 -0400
Message-Id: <20210503163513.2851510-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
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
index a20459744d21..94327988da91 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1488,7 +1488,7 @@ sdhci_esdhc_imx_probe_dt(struct platform_device *pdev,
 
 	mmc_of_parse_voltage(np, &host->ocr_mask);
 
-	if (esdhc_is_usdhc(imx_data)) {
+	if (esdhc_is_usdhc(imx_data) && !IS_ERR(imx_data->pinctrl)) {
 		imx_data->pins_100mhz = pinctrl_lookup_state(imx_data->pinctrl,
 						ESDHC_PINCTRL_STATE_100MHZ);
 		imx_data->pins_200mhz = pinctrl_lookup_state(imx_data->pinctrl,
-- 
2.30.2

