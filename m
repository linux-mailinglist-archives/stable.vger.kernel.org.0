Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C637E188066
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgCQLJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728997AbgCQLJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:09:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D689C205ED;
        Tue, 17 Mar 2020 11:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443392;
        bh=nmnAmAtfwbc4F9EFKZ40OhfJ5P1Y5hVQU9+FDlSpypo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zR/lg+tZ48Npz7kipqpJZyiS6OV2BnRjPDqsUVxFjASIecLpU3zM0qIo3KwtKV2yw
         E1c0TIcqoxhedrVs5oK2WrMvFE6auVD37US7lpDYS2jWlblDRca46bV6UMESg573u2
         8ODoX+vhulEC0AQMK4ZzVH3djs1GF8nSOdvz4nco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 069/151] net: dsa: Dont instantiate phylink for CPU/DSA ports unless needed
Date:   Tue, 17 Mar 2020 11:54:39 +0100
Message-Id: <20200317103331.400454009@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit a20f997010c4ec76eaa55b8cc047d76dcac69f70 ]

By default, DSA drivers should configure CPU and DSA ports to their
maximum speed. In many configurations this is sufficient to make the
link work.

In some cases it is necessary to configure the link to run slower,
e.g. because of limitations of the SoC it is connected to. Or back to
back PHYs are used and the PHY needs to be driven in order to
establish link. In this case, phylink is used.

Only instantiate phylink if it is required. If there is no PHY, or no
fixed link properties, phylink can upset a link which works in the
default configuration.

Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/port.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -653,9 +653,14 @@ err_phy_connect:
 int dsa_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
+	struct device_node *phy_np;
 
-	if (!ds->ops->adjust_link)
-		return dsa_port_phylink_register(dp);
+	if (!ds->ops->adjust_link) {
+		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
+		if (of_phy_is_fixed_link(dp->dn) || phy_np)
+			return dsa_port_phylink_register(dp);
+		return 0;
+	}
 
 	dev_warn(ds->dev,
 		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
@@ -670,11 +675,12 @@ void dsa_port_link_unregister_of(struct
 {
 	struct dsa_switch *ds = dp->ds;
 
-	if (!ds->ops->adjust_link) {
+	if (!ds->ops->adjust_link && dp->pl) {
 		rtnl_lock();
 		phylink_disconnect_phy(dp->pl);
 		rtnl_unlock();
 		phylink_destroy(dp->pl);
+		dp->pl = NULL;
 		return;
 	}
 


