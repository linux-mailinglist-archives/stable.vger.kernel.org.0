Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F04226528
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgGTPvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730605AbgGTPvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:51:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FEEA2065E;
        Mon, 20 Jul 2020 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260277;
        bh=ICAXmvJ2UtAA73+028ULe6eIpG2Xrikt3jvu8MQl9s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQqVO5SR0Z1ug9MBuCjtD/yBtWok41MJxJbi+zVDLRoN0F+p4m6bh4j0rpfIfY90x
         RQbp5G/oWFIo8IVl1+fIxtil1Fu3O2m8vVwMEAymtiXo4Um+1MImIJc797tsXExnzi
         YKitNKKXcNkX2W8igAkInYhWlmh+Y7+V2trbnNhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/133] net: sfp: add some quirks for GPON modules
Date:   Mon, 20 Jul 2020 17:36:32 +0200
Message-Id: <20200720152805.888246253@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit b0eae33b2583dceb36224619f9fd85e6140ae594 ]

Marc Micalizzi reports that Huawei MA5671A and Alcatel/Lucent G-010S-P
modules are capable of 2500base-X, but incorrectly report their
capabilities in the EEPROM.  It seems rather common that GPON modules
mis-report.

Let's fix these modules by adding some quirks.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index bd3ea01bff0b8..1fe7783c28712 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -37,7 +37,32 @@ struct sfp_bus {
 	bool started;
 };
 
+static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
+				unsigned long *modes)
+{
+	phylink_set(modes, 2500baseX_Full);
+}
+
 static const struct sfp_quirk sfp_quirks[] = {
+	{
+		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
+		// incorrectly report 2500MBd NRZ in their EEPROM
+		.vendor = "ALCATELLUCENT",
+		.part = "G010SP",
+		.modes = sfp_quirk_2500basex,
+	}, {
+		// Alcatel Lucent G-010S-A can operate at 2500base-X, but
+		// report 3.2GBd NRZ in their EEPROM
+		.vendor = "ALCATELLUCENT",
+		.part = "3FE46541AA",
+		.modes = sfp_quirk_2500basex,
+	}, {
+		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
+		// NRZ in their EEPROM
+		.vendor = "HUAWEI",
+		.part = "MA5671A",
+		.modes = sfp_quirk_2500basex,
+	},
 };
 
 static size_t sfp_strlen(const char *str, size_t maxlen)
-- 
2.25.1



