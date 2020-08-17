Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF9D246AFA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbgHQPq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730794AbgHQPqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:46:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A16F206FA;
        Mon, 17 Aug 2020 15:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679175;
        bh=lgSRBSo9kz+j9MyJenmkufp/zityPquo/vzYct1svQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SysJ72n+YZGRc5qgK9/v1FOTfxuRqW6/CrHKDByFPTR7aM1upMqg2HMKdBJZv7gji
         6365XON9CW8UcWlIZQUZJgJ+vP20NxtzTQrXN9dWHro/yCz48RsHZdKw+T+IlI0xvd
         F+tVCe6qNeV5x7SfW5gQty8ErbedQp/sDVkoXlaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 091/393] net: phy: mscc: restore the base page in vsc8514/8584_config_init
Date:   Mon, 17 Aug 2020 17:12:21 +0200
Message-Id: <20200817143824.041999464@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit 6119dda34e5d0821959e37641b287576826b6378 ]

In the vsc8584_config_init and vsc8514_config_init, the base page is set
to 'GPIO', configuration is done, and the page is never explicitly
restored to the standard page. No bug was triggered as it turns out
helpers called in those config_init functions do modify the base page,
and set it back to standard. But that is dangerous and any modification
to those functions would introduce bugs. This patch fixes this, to
improve maintenance, by restoring the base page to 'standard' once
'GPIO' accesses are completed.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 485a4f8a6a9a6..95bd2d277ba42 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1413,6 +1413,11 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		goto err;
 
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_STANDARD);
+	if (ret)
+		goto err;
+
 	if (!phy_interface_is_rgmii(phydev)) {
 		val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
 			PROC_CMD_READ_MOD_WRITE_PORT;
@@ -1799,7 +1804,11 @@ static int vsc8514_config_init(struct phy_device *phydev)
 	val &= ~MAC_CFG_MASK;
 	val |= MAC_CFG_QSGMII;
 	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
+	if (ret)
+		goto err;
 
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_STANDARD);
 	if (ret)
 		goto err;
 
-- 
2.25.1



