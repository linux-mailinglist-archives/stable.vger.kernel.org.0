Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6352378649
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhEJLFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231830AbhEJK5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CFFB619E6;
        Mon, 10 May 2021 10:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643917;
        bh=fh8NTrcVEp7XEynMX0wepwrZy+rJKZt3MliX/P9XDEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvtC00UJ8WtfXQbbVqlo49SBN0BOZLYbcXTQGDst+xARW4rNVuw5EbbMBkKxMZYLa
         X8o/jGLoUOZDhkQrkW2bsjm2CIxPgQqPS7Xc5YjEw7uTjVUYX3eE+WFc7BfodyM0kc
         wa3cEJOEbp/EihOD0jmtqsLZ1q8iOEg3zimMAlXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bough Chen <haobo.chen@nxp.com>,
        Alice Guo <alice.guo@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 178/342] mmc: sdhci-esdhc-imx: validate pinctrl before use it
Date:   Mon, 10 May 2021 12:19:28 +0200
Message-Id: <20210510102015.987100110@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



