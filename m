Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0692A328D30
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbhCATHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:07:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240830AbhCATBQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:01:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B6F465067;
        Mon,  1 Mar 2021 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619425;
        bh=LCLt2oOtDTkL6juqEAPn7kIHF7nvbMjBpK8BIEeSXEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6cC1SNTWLAZ0v76df6DqHMogxyfl27jGt0MH0mBiAKLyu+ONVU2uz4VCmEAXD/+y
         lKAc8tHMqqM64DYNR/Tg6fhXEyOWT+epnlJ5CODW/iBkA7EHJIKwtkA8LsIatYZgv1
         w0+KHthrdvyzUXV3XaieWzQV15pHn96/tfQPFeVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Song@vger.kernel.org
Subject: [PATCH 5.10 449/663] net: stmmac: fix CBS idleslope and sendslope calculation
Date:   Mon,  1 Mar 2021 17:11:37 +0100
Message-Id: <20210301161204.110500603@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song, Yoong Siang <yoong.siang.song@intel.com>

[ Upstream commit 24877687b375f2c476ffb726ea915fc85df09e3d ]

When link speed is not 100 Mbps, port transmit rate and speed divider
are set to 8 and 1000000 respectively. These values are incorrect for
CBS idleslope and sendslope HW values calculation if the link speed is
not 1 Gbps.

This patch adds switch statement to set the values of port transmit rate
and speed divider for 10 Gbps, 5 Gbps, 2.5 Gbps, 1 Gbps, and 100 Mbps.
Note that CBS is not supported at 10 Mbps.

Fixes: bc41a6689b30 ("net: stmmac: tc: Remove the speed dependency")
Fixes: 1f705bc61aee ("net: stmmac: Add support for CBS QDISC")
Signed-off-by: Song, Yoong Siang <yoong.siang.song@intel.com>
Link: https://lore.kernel.org/r/1613655653-11755-1-git-send-email-yoong.siang.song@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 30 ++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 6088071cb1923..40dc14d1415f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -322,6 +322,32 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 	if (!priv->dma_cap.av)
 		return -EOPNOTSUPP;
 
+	/* Port Transmit Rate and Speed Divider */
+	switch (priv->speed) {
+	case SPEED_10000:
+		ptr = 32;
+		speed_div = 10000000;
+		break;
+	case SPEED_5000:
+		ptr = 32;
+		speed_div = 5000000;
+		break;
+	case SPEED_2500:
+		ptr = 8;
+		speed_div = 2500000;
+		break;
+	case SPEED_1000:
+		ptr = 8;
+		speed_div = 1000000;
+		break;
+	case SPEED_100:
+		ptr = 4;
+		speed_div = 100000;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	mode_to_use = priv->plat->tx_queues_cfg[queue].mode_to_use;
 	if (mode_to_use == MTL_QUEUE_DCB && qopt->enable) {
 		ret = stmmac_dma_qmode(priv, priv->ioaddr, queue, MTL_QUEUE_AVB);
@@ -338,10 +364,6 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 		priv->plat->tx_queues_cfg[queue].mode_to_use = MTL_QUEUE_DCB;
 	}
 
-	/* Port Transmit Rate and Speed Divider */
-	ptr = (priv->speed == SPEED_100) ? 4 : 8;
-	speed_div = (priv->speed == SPEED_100) ? 100000 : 1000000;
-
 	/* Final adjustments for HW */
 	value = div_s64(qopt->idleslope * 1024ll * ptr, speed_div);
 	priv->plat->tx_queues_cfg[queue].idle_slope = value & GENMASK(31, 0);
-- 
2.27.0



