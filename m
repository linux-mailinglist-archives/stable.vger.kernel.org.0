Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEBA3AEF92
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhFUQkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232362AbhFUQiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:38:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 461C861434;
        Mon, 21 Jun 2021 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292978;
        bh=J5rFiomhkGXb6uTmtgxj7bmx3aKGX3F4ApLcrBXBtng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTId6kSkq/2BKYt3h0CXala/0HAoC+K+Xk5mAIh4NrtTsueKpHkpo90UwS0zskb+F
         uRlPClYHvoKwrcpCXwMWcuUg0DVBhkfjObRMn9zgnBoP8ULi0Z5lWqaEzqciwQWloP
         hFkZfteumwL2xpSy2yrdQ+MrKnOJtruFk8MC4IYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 052/178] cxgb4: halt chip before flashing PHY firmware image
Date:   Mon, 21 Jun 2021 18:14:26 +0200
Message-Id: <20210621154924.163498220@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 6d297540f75d759489054e8b07932208fc4db2cb ]

When using firmware-assisted PHY firmware image write to flash,
halt the chip before beginning the flash write operation to allow
the running firmware to store the image persistently. Otherwise,
the running firmware will only store the PHY image in local on-chip
RAM, which will be lost after next reset.

Fixes: 4ee339e1e92a ("cxgb4: add support to flash PHY image")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 22 ++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index bc2de01d0539..df20485b5744 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1337,11 +1337,27 @@ static int cxgb4_ethtool_flash_phy(struct net_device *netdev,
 		return ret;
 	}
 
+	/* We have to RESET the chip/firmware because we need the
+	 * chip in uninitialized state for loading new PHY image.
+	 * Otherwise, the running firmware will only store the PHY
+	 * image in local RAM which will be lost after next reset.
+	 */
+	ret = t4_fw_reset(adap, adap->mbox, PIORSTMODE_F | PIORST_F);
+	if (ret < 0) {
+		dev_err(adap->pdev_dev,
+			"Set FW to RESET for flashing PHY FW failed. ret: %d\n",
+			ret);
+		return ret;
+	}
+
 	ret = t4_load_phy_fw(adap, MEMWIN_NIC, NULL, data, size);
-	if (ret)
-		dev_err(adap->pdev_dev, "Failed to load PHY FW\n");
+	if (ret < 0) {
+		dev_err(adap->pdev_dev, "Failed to load PHY FW. ret: %d\n",
+			ret);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int cxgb4_ethtool_flash_fw(struct net_device *netdev,
-- 
2.30.2



