Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD06113452
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbfLDSDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbfLDSDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:03:44 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADDD0206DF;
        Wed,  4 Dec 2019 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482624;
        bh=jF9IsxwYOSuw62P1PeeupxUbte4FfaAr0h/JklSur88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzcDsE1CEiWihP/C5dx7cgspqlhl4sAne8dXBs9rvM9p2dRjiM6qqgz7E+Geb4xMw
         UrwEglD0ijDCOmHfv/RMVF1MC/xcJYmXXsVxyGgF9TaiKGAtLyyyD+bmR+Op86je9r
         oaWgqWOLKTa0aHx3pChOeT2FZ2l1rdnfp2LazDas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/209] bnxt_en: query force speeds before disabling autoneg mode.
Date:   Wed,  4 Dec 2019 18:54:42 +0100
Message-Id: <20191204175326.102644595@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 56d374624778652d2a999e18c87a25338b127b41 ]

With autoneg enabled, PHY loopback test fails. To disable autoneg,
driver needs to send a valid forced speed to FW. FW is not sending
async event for invalid speeds. To fix this, query forced speeds
and send the correct speed when disabling autoneg mode.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 22 ++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 4879371ad0c75..fc8e185718a1d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2258,17 +2258,37 @@ static int bnxt_hwrm_mac_loopback(struct bnxt *bp, bool enable)
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
+static int bnxt_query_force_speeds(struct bnxt *bp, u16 *force_speeds)
+{
+	struct hwrm_port_phy_qcaps_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_port_phy_qcaps_input req = {0};
+	int rc;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_PHY_QCAPS, -1, -1);
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc)
+		*force_speeds = le16_to_cpu(resp->supported_speeds_force_mode);
+
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
 static int bnxt_disable_an_for_lpbk(struct bnxt *bp,
 				    struct hwrm_port_phy_cfg_input *req)
 {
 	struct bnxt_link_info *link_info = &bp->link_info;
-	u16 fw_advertising = link_info->advertising;
+	u16 fw_advertising;
 	u16 fw_speed;
 	int rc;
 
 	if (!link_info->autoneg)
 		return 0;
 
+	rc = bnxt_query_force_speeds(bp, &fw_advertising);
+	if (rc)
+		return rc;
+
 	fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_1GB;
 	if (netif_carrier_ok(bp->dev))
 		fw_speed = bp->link_info.link_speed;
-- 
2.20.1



