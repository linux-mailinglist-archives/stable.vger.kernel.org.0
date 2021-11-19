Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201F04575BD
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbhKSRmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235057AbhKSRlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8720561139;
        Fri, 19 Nov 2021 17:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343529;
        bh=spmsTUE3/RWq/bfFbps4+I7b/cVQdNX7t9Uzu/giBmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ig2L5F/XcKOas0KSPsUGEa3ihGw77ruM+yfqnlzD17nW8WfyAtXLhD5XC4zCTM7ro
         fGTMXwQVrk3LfApJycioYBuTVi8FoVBjtv38KePoT6PSe11mQ58QhbNZxCf253DhVc
         vY60v8jvUg+xvnMUVjIBnc910Jlu9KhRARZenXVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Meng Li <Meng.Li@windriver.com>
Subject: [PATCH 5.10 08/21] net: stmmac: fix system hang if change mac address after interface ifdown
Date:   Fri, 19 Nov 2021 18:37:43 +0100
Message-Id: <20211119171444.156160658@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
References: <20211119171443.892729043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 4691ffb18ac908609aab07d13af7995b6b89d33c upstream.

Fix system hang with below sequences:
~# ifconfig ethx down
~# ifconfig ethx hw ether xx:xx:xx:xx:xx:xx

After ethx down, stmmac all clocks gated off and then register access causes
system hang.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4324,12 +4324,21 @@ static int stmmac_set_mac_address(struct
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	int ret = 0;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	ret = eth_mac_addr(ndev, addr);
 	if (ret)
-		return ret;
+		goto set_mac_error;
 
 	stmmac_set_umac_addr(priv, priv->hw, ndev->dev_addr, 0);
 
+set_mac_error:
+	pm_runtime_put(priv->device);
+
 	return ret;
 }
 


