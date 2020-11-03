Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E032A58F0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgKCUoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:44:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730356AbgKCUoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E34C223EA;
        Tue,  3 Nov 2020 20:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436283;
        bh=+wh9kULOBVXz2BWqRIiL4gH3gi7yQClSIeMc4bNKACk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+wFsQYayTHeJSFenAPgDM1PQWScRmsXSefSgw3CxTEPwVFdaus8ejK0xXfX75tRP
         C6TguHg1OQ7CFKWLk7SUX9owRjdIacRrrD/bLdekqJiITt2UlkW7GSXekw96V4dyeG
         hTULdGxPWPOZ41++YaAh4dQHAKoewTmknnIGipI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 145/391] bnxt_en: Log unknown link speed appropriately.
Date:   Tue,  3 Nov 2020 21:33:16 +0100
Message-Id: <20201103203356.615308422@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
index 7b5d521924872..b8d534b719d4f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8735,6 +8735,11 @@ static void bnxt_report_link(struct bnxt *bp)
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
@@ -8747,7 +8752,6 @@ static void bnxt_report_link(struct bnxt *bp)
 			flow_ctrl = "ON - receive";
 		else
 			flow_ctrl = "none";
-		speed = bnxt_fw_to_ethtool_speed(bp->link_info.link_speed);
 		netdev_info(bp->dev, "NIC Link is Up, %u Mbps %s duplex, Flow control: %s\n",
 			    speed, duplex, flow_ctrl);
 		if (bp->flags & BNXT_FLAG_EEE_CAP)
-- 
2.27.0



