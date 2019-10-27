Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E57E6776
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731875AbfJ0VVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731870AbfJ0VVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:21:11 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 180E8208C0;
        Sun, 27 Oct 2019 21:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211270;
        bh=BTbYBLePp+9uCeyYrl7wI5G+3XjBonWbTYXj63iJmqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSjF2WIk4EvhgXXnQNYK817hohz0hP84BWlOFukdrDEMDJm2cpjw6upgMjFchIXG1
         eDbg4/D28H7nQOXmbpS/+5FbsrxpmSRGlWna3ROWQ6B0sF053C0dAE5X+asbw82xS2
         XKXndFCphyiUclVoyGK8gd9ifWtdcCkHWrb0Vrkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 038/197] net: stmmac: xgmac: Not all Unicast addresses may be available
Date:   Sun, 27 Oct 2019 21:59:16 +0100
Message-Id: <20191027203353.777116238@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 9a2ae7b3960eb2426a8560cbc3251e3453230d21 ]

Some setups may not have all Unicast addresses filters available. Let's
check this before trying to setup filters.

Fixes: 0efedbf11f07 ("net: stmmac: xgmac: Fix XGMAC selftests")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 85c68b7ee8c6a..46d74f407aab6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -370,7 +370,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 	dwxgmac2_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > XGMAC_ADDR_MAX) {
+	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
 		value |= XGMAC_FILTER_PR;
 	} else {
 		struct netdev_hw_addr *ha;
-- 
2.20.1



