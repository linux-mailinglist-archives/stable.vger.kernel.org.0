Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6874A4498
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350544AbiAaLb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376829AbiAaLZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D17C034001;
        Mon, 31 Jan 2022 03:15:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616176114C;
        Mon, 31 Jan 2022 11:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398AFC340EE;
        Mon, 31 Jan 2022 11:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627740;
        bh=CtCfpmu/GsjzbOZzsDm4khr6nu+WwOokajq7Jrq0Vm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exyNz2bYqayhs5eow3SiJh2qK28rwv2aETMHYx7wXsMFvXgvJbVPwrRg715/V3b4y
         tkWYdKRHeonYxf4IdHepkv3seU9NWwxpVEaEBvRrUXBw4HJV5xKwFizE3dd3ev1jQg
         OnvgQpaj772ih8oRjMmbGg88j4am/Q5X4mCluB34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 011/200] net: stmmac: configure PTP clock source prior to PTP initialization
Date:   Mon, 31 Jan 2022 11:54:34 +0100
Message-Id: <20220131105233.940945572@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

commit 94c82de43e01ef5747a95e4a590880de863fe423 upstream.

For Intel platform, it is required to configure PTP clock source prior PTP
initialization in MAC. So, need to move ptp_clk_freq_config execution from
stmmac_ptp_register() to stmmac_init_ptp().

Fixes: 76da35dc99af ("stmmac: intel: Add PSE and PCH PTP clock source selection")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c  |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -899,6 +899,9 @@ static int stmmac_init_ptp(struct stmmac
 	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
 	int ret;
 
+	if (priv->plat->ptp_clk_freq_config)
+		priv->plat->ptp_clk_freq_config(priv);
+
 	ret = stmmac_init_tstamp_counter(priv, STMMAC_HWTS_ACTIVE);
 	if (ret)
 		return ret;
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -297,9 +297,6 @@ void stmmac_ptp_register(struct stmmac_p
 {
 	int i;
 
-	if (priv->plat->ptp_clk_freq_config)
-		priv->plat->ptp_clk_freq_config(priv);
-
 	for (i = 0; i < priv->dma_cap.pps_out_num; i++) {
 		if (i >= STMMAC_PPS_MAX)
 			break;


