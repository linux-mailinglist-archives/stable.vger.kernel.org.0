Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3181F2A55DE
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgKCVXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:23:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388005AbgKCVEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:04:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC3A6205ED;
        Tue,  3 Nov 2020 21:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437479;
        bh=6k3Rv2TFBDOhHAM997ZTHP+m9n50T5c3X0cKrYf5zxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6FMbPK6TdF2MdUiClgH2sY6Qb6Q9cB7vqLPUqDMwUmjD83PFP2MQw9uofRoG8EJU
         u79KO8WcqbaiVBWLMScwiMPcNsfp5sC2BodsjMAUDxR6GZcmzx1pHudfnCAHeyWFzK
         QTUMyl5E6DYA8+PxAVoc5tYK84o7/jUOR8v8T1A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/191] bnxt_en: Log unknown link speed appropriately.
Date:   Tue,  3 Nov 2020 21:36:27 +0100
Message-Id: <20201103203242.741923616@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 8eddb3e7ce124dd6375d3664f1aae13873318b0f ]

If the VF virtual link is set to always enabled, the speed may be
unknown when the physical link is down.  The driver currently logs
the link speed as 4294967295 Mbps which is SPEED_UNKNOWN.  Modify
the link up log message as "speed unknown" which makes more sense.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/1602493854-29283-7-git-send-email-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c3f04fb319556..01d28ede1fb20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6326,6 +6326,11 @@ static void bnxt_report_link(struct bnxt *bp)
 		u16 fec;
 
 		netif_carrier_on(bp->dev);
+		speed = bnxt_fw_to_ethtool_speed(bp->link_info.link_speed);
+		if (speed == SPEED_UNKNOWN) {
+			netdev_info(bp->dev, "NIC Link is Up, speed unknown\n");
+			return;
+		}
 		if (bp->link_info.duplex == BNXT_LINK_DUPLEX_FULL)
 			duplex = "full";
 		else
@@ -6338,7 +6343,6 @@ static void bnxt_report_link(struct bnxt *bp)
 			flow_ctrl = "ON - receive";
 		else
 			flow_ctrl = "none";
-		speed = bnxt_fw_to_ethtool_speed(bp->link_info.link_speed);
 		netdev_info(bp->dev, "NIC Link is Up, %u Mbps %s duplex, Flow control: %s\n",
 			    speed, duplex, flow_ctrl);
 		if (bp->flags & BNXT_FLAG_EEE_CAP)
-- 
2.27.0



