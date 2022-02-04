Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC284A96A2
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357957AbiBDJ1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53970 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358249AbiBDJ0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:26:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A89EB836BA;
        Fri,  4 Feb 2022 09:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA71C004E1;
        Fri,  4 Feb 2022 09:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966771;
        bh=VXbeeVkNkzOG24jf0vx5BOfcM06+BBpyEMjPdjTt5Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WacFyFc0Vh4WEi/m0Yl6Mx01MfVscyDRuAXDLnEHHignW2Mk8qmDBOR2M/o0DT33J
         4VjyaTtD7F/QqhnebnnpHMA7GCi9T4eBOidAycui3ImiEsTmzIkRQgoe9EanbcHqq1
         cusEfLM3P7QqBk5KgOVhpqnle3biDgOMLHHsrsFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 08/43] net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
Date:   Fri,  4 Feb 2022 10:22:15 +0100
Message-Id: <20220204091917.455414849@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

commit 881cc731df6af99a21622e9be25a23b81adcd10b upstream.

A typo in qca808x_read_status means we try to set SMII mode on the port
rather than SGMII when the link speed is not 2.5Gb/s. This results in no
traffic due to the mismatch in configuration between the phy and the
mac.

v2:
 Only change interface mode when the link is up

Fixes: 79c7bc0521545 ("net: phy: add qca8081 read_status")
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan McDowell <noodles@earth.li>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/at803x.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1688,19 +1688,19 @@ static int qca808x_read_status(struct ph
 	if (ret < 0)
 		return ret;
 
-	if (phydev->link && phydev->speed == SPEED_2500)
-		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
-	else
-		phydev->interface = PHY_INTERFACE_MODE_SMII;
-
-	/* generate seed as a lower random value to make PHY linked as SLAVE easily,
-	 * except for master/slave configuration fault detected.
-	 * the reason for not putting this code into the function link_change_notify is
-	 * the corner case where the link partner is also the qca8081 PHY and the seed
-	 * value is configured as the same value, the link can't be up and no link change
-	 * occurs.
-	 */
-	if (!phydev->link) {
+	if (phydev->link) {
+		if (phydev->speed == SPEED_2500)
+			phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
+		else
+			phydev->interface = PHY_INTERFACE_MODE_SGMII;
+	} else {
+		/* generate seed as a lower random value to make PHY linked as SLAVE easily,
+		 * except for master/slave configuration fault detected.
+		 * the reason for not putting this code into the function link_change_notify is
+		 * the corner case where the link partner is also the qca8081 PHY and the seed
+		 * value is configured as the same value, the link can't be up and no link change
+		 * occurs.
+		 */
 		if (phydev->master_slave_state == MASTER_SLAVE_STATE_ERR) {
 			qca808x_phy_ms_seed_enable(phydev, false);
 		} else {


