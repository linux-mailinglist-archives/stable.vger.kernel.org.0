Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE31419C58
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbhI0R1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237840AbhI0RZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:25:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A2CA6137D;
        Mon, 27 Sep 2021 17:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762966;
        bh=KgZq1ZE8/doT7Nt57rOj+QIGkvp8AmoT5NR5RYCp7PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjxZpmb79JSMoz62T0PtIIKogpvlzcD0LvtRSvzbJeuv4M4Uv8A6ieX4xUUPT8Z+/
         0XDmeg5bm0D5L7RJuFRsdYmnue5QCYnG3+p/3JbDQ/54lS3pBjDMjeozz5p1VY+JbC
         ArX/7up7dTGdfppI7sab98fmYahZYKX8cx7ya8WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Rossi <nathan.rossi@digi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 117/162] net: phylink: Update SFP selected interface on advertising changes
Date:   Mon, 27 Sep 2021 19:02:43 +0200
Message-Id: <20210927170237.496979747@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

[ Upstream commit ea269a6f720782ed94171fb962b14ce07c372138 ]

Currently changes to the advertising state via ethtool do not cause any
reselection of the configured interface mode after the SFP is already
inserted and initially configured.

While it is not typical to change the advertised link modes for an
interface using an SFP in certain use cases it is desirable. In the case
of a SFP port that is capable of handling both SFP and SFP+ modules it
will automatically select between 1G and 10G modes depending on the
supported mode of the SFP. However if the SFP module is capable of
working in multiple modes (e.g. a SFP+ DAC that can operate at 1G or
10G), one end of the cable may be attached to a SFP 1000base-x port thus
the SFP+ end must be manually configured to the 1000base-x mode in order
for the link to be established.

This change causes the ethtool setting of advertised mode changes to
reselect the interface mode so that the link can be established.
Additionally when a module is inserted the advertising mode is reset to
match the supported modes of the module.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 42e5a681183f..0d3d9c3ee83c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1604,6 +1604,32 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
 		return -EINVAL;
 
+	/* If this link is with an SFP, ensure that changes to advertised modes
+	 * also cause the associated interface to be selected such that the
+	 * link can be configured correctly.
+	 */
+	if (pl->sfp_port && pl->sfp_bus) {
+		config.interface = sfp_select_interface(pl->sfp_bus,
+							config.advertising);
+		if (config.interface == PHY_INTERFACE_MODE_NA) {
+			phylink_err(pl,
+				    "selection of interface failed, advertisement %*pb\n",
+				    __ETHTOOL_LINK_MODE_MASK_NBITS,
+				    config.advertising);
+			return -EINVAL;
+		}
+
+		/* Revalidate with the selected interface */
+		linkmode_copy(support, pl->supported);
+		if (phylink_validate(pl, support, &config)) {
+			phylink_err(pl, "validation of %s/%s with support %*pb failed\n",
+				    phylink_an_mode_str(pl->cur_link_an_mode),
+				    phy_modes(config.interface),
+				    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
+			return -EINVAL;
+		}
+	}
+
 	mutex_lock(&pl->state_mutex);
 	pl->link_config.speed = config.speed;
 	pl->link_config.duplex = config.duplex;
@@ -2183,7 +2209,9 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
 		return -EINVAL;
 
-	changed = !linkmode_equal(pl->supported, support);
+	changed = !linkmode_equal(pl->supported, support) ||
+		  !linkmode_equal(pl->link_config.advertising,
+				  config.advertising);
 	if (changed) {
 		linkmode_copy(pl->supported, support);
 		linkmode_copy(pl->link_config.advertising, config.advertising);
-- 
2.33.0



