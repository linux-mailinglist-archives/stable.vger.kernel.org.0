Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE62633B6C6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhCON6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232252AbhCON6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41AB364F36;
        Mon, 15 Mar 2021 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816686;
        bh=HHA26jaEx0TVIHhjA6y4M+tOOuCMpp/jBGSy2ZKii+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0j9jTEUrlvZTx84esilYoEtlswEjkxvTZ373m9Ggmo6jE4QK7MXtMx3toJ0dYhszG
         nhf/WtKxZRv2bEgb/chdMZwJzFP7MZFoNkGLo9QN8CZNSwl3ayLobT8GLS376tRAfn
         CPZsr0L9Re9PiNwcIz/CeyNqUtoD3e38AsWuM7dc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wong Vee Khee <vee.khee.wong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 055/290] stmmac: intel: Fixes clock registration error seen for multiple interfaces
Date:   Mon, 15 Mar 2021 14:52:28 +0100
Message-Id: <20210315135543.794433623@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Wong Vee Khee <vee.khee.wong@intel.com>

commit 8eb37ab7cc045ec6305a6a1a9c32374695a1a977 upstream.

Issue seen when enumerating multiple Intel mGbE interfaces in EHL.

[    6.898141] intel-eth-pci 0000:00:1d.2: enabling device (0000 -> 0002)
[    6.900971] intel-eth-pci 0000:00:1d.2: Fail to register stmmac-clk
[    6.906434] intel-eth-pci 0000:00:1d.2: User ID: 0x51, Synopsys ID: 0x52

We fix it by making the clock name to be unique following the format
of stmmac-pci_name(pci_dev) so that we can differentiate the clock for
these Intel mGbE interfaces in EHL platform as follow:

  /sys/kernel/debug/clk/stmmac-0000:00:1d.1
  /sys/kernel/debug/clk/stmmac-0000:00:1d.2
  /sys/kernel/debug/clk/stmmac-0000:00:1e.4

Fixes: 58da0cfa6cf1 ("net: stmmac: create dwmac-intel.c to contain all Intel platform")
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Co-developed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -233,6 +233,7 @@ static void common_default_data(struct p
 static int intel_mgbe_common_data(struct pci_dev *pdev,
 				  struct plat_stmmacenet_data *plat)
 {
+	char clk_name[20];
 	int ret;
 	int i;
 
@@ -300,8 +301,10 @@ static int intel_mgbe_common_data(struct
 	plat->eee_usecs_rate = plat->clk_ptp_rate;
 
 	/* Set system clock */
+	sprintf(clk_name, "%s-%s", "stmmac", pci_name(pdev));
+
 	plat->stmmac_clk = clk_register_fixed_rate(&pdev->dev,
-						   "stmmac-clk", NULL, 0,
+						   clk_name, NULL, 0,
 						   plat->clk_ptp_rate);
 
 	if (IS_ERR(plat->stmmac_clk)) {


