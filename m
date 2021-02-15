Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E03D31BD20
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhBOPkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:40:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231508AbhBOPhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D7B364EA9;
        Mon, 15 Feb 2021 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403207;
        bh=RppSirFCsVPvW+Wn8oeCGsI2fjKkHITVWvdtGTMFZ0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zz4bYIdXCfkWMhqem4qsL6vYsZGkMfZkTWx6S543hzGVWgEDhXGGKPfsKIEefiVBo
         czlX8Hmqd/EPlSvVOPtXcrFL0I9et+FMw/ovwY55Q9J4JMgpsXcfwazGAYAbrqayVO
         ihf1Ie0FdIzS5+KJqSzMt8+T3wdp9JdE4AmbisGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Song@vger.kernel.org
Subject: [PATCH 5.10 067/104] net: stmmac: set TxQ mode back to DCB after disabling CBS
Date:   Mon, 15 Feb 2021 16:27:20 +0100
Message-Id: <20210215152721.631015300@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

[ Upstream commit f317e2ea8c88737aa36228167b2292baef3f0430 ]

When disable CBS, mode_to_use parameter is not updated even the operation
mode of Tx Queue is changed to Data Centre Bridging (DCB). Therefore,
when tc_setup_cbs() function is called to re-enable CBS, the operation
mode of Tx Queue remains at DCB, which causing CBS fails to work.

This patch updates the value of mode_to_use parameter to MTL_QUEUE_DCB
after operation mode of Tx Queue is changed to DCB in stmmac_dma_qmode()
callback function.

Fixes: 1f705bc61aee ("net: stmmac: Add support for CBS QDISC")
Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: Song, Yoong Siang <yoong.siang.song@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://lore.kernel.org/r/1612447396-20351-1-git-send-email-yoong.siang.song@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 06553d028d746..6088071cb1923 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -330,7 +330,12 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 
 		priv->plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_AVB;
 	} else if (!qopt->enable) {
-		return stmmac_dma_qmode(priv, priv->ioaddr, queue, MTL_QUEUE_DCB);
+		ret = stmmac_dma_qmode(priv, priv->ioaddr, queue,
+				       MTL_QUEUE_DCB);
+		if (ret)
+			return ret;
+
+		priv->plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_DCB;
 	}
 
 	/* Port Transmit Rate and Speed Divider */
-- 
2.27.0



