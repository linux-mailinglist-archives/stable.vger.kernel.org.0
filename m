Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8BE47AE21
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbhLTO6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:58:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34004 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbhLTO4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B515B80EF1;
        Mon, 20 Dec 2021 14:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40630C36AE8;
        Mon, 20 Dec 2021 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012178;
        bh=D6xK+5gOCR/rbKuVXFuy2hwnNPGZejSPsj0q1tRZegM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQ7uHM7dxgQT/1q/WqL2//ZSmRoJNY5Hzx9gTdLNk/uuKcEpL+/xzJHmDnrUgHDL/
         Pr1sw/2tK3cTfwA7faBrENy2WN6pMOEVVaUAgkwBW+HmoiraBnTEBkar9j5gLd5BvY
         duS6UBqt7bg6pwMQuU47m/HqZcqlEIZKox5h1WQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/177] net: stmmac: dwmac-rk: fix oob read in rk_gmac_setup
Date:   Mon, 20 Dec 2021 15:34:11 +0100
Message-Id: <20211220143043.498360966@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit 0546b224cc7717cc8a2db076b0bb069a9c430794 ]

KASAN reports an out-of-bounds read in rk_gmac_setup on the line:

	while (ops->regs[i]) {

This happens for most platforms since the regs flexible array member is
empty, so the memory after the ops structure is being read here.  It
seems that mostly this happens to contain zero anyway, so we get lucky
and everything still works.

To avoid adding redundant data to nearly all the ops structures, add a
new flag to indicate whether the regs field is valid and avoid this loop
when it is not.

Fixes: 3bb3d6b1c195 ("net: stmmac: Add RK3566/RK3568 SoC support")
Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 6924a6aacbd53..c469abc91fa1b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -33,6 +33,7 @@ struct rk_gmac_ops {
 	void (*set_rgmii_speed)(struct rk_priv_data *bsp_priv, int speed);
 	void (*set_rmii_speed)(struct rk_priv_data *bsp_priv, int speed);
 	void (*integrated_phy_powerup)(struct rk_priv_data *bsp_priv);
+	bool regs_valid;
 	u32 regs[];
 };
 
@@ -1092,6 +1093,7 @@ static const struct rk_gmac_ops rk3568_ops = {
 	.set_to_rmii = rk3568_set_to_rmii,
 	.set_rgmii_speed = rk3568_set_gmac_speed,
 	.set_rmii_speed = rk3568_set_gmac_speed,
+	.regs_valid = true,
 	.regs = {
 		0xfe2a0000, /* gmac0 */
 		0xfe010000, /* gmac1 */
@@ -1383,7 +1385,7 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 	 * to be distinguished.
 	 */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res) {
+	if (res && ops->regs_valid) {
 		int i = 0;
 
 		while (ops->regs[i]) {
-- 
2.33.0



