Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9822235CD74
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbhDLQhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245693AbhDLQfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0B4061363;
        Mon, 12 Apr 2021 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244813;
        bh=ZAdFpjqXGlMBSS3hY+bf62oct3zQ62S2kRoT445sZvE=;
        h=From:To:Cc:Subject:Date:From;
        b=AEBemaRHGlNWZjSG7K5pg7N6EEoz2MG/Aq4dMqNZYi4rdxAfIVdL8CaP9xRsR+oDw
         52n/OJN75DgDmR+4lbEgJJhO1gQBoFXZh9wtQXcLnABRDwRkAfcsym87Q7Bs1ZrC51
         /T4fXzRMtD2N9IcUvcoeVWAv7P1ZOh1eiliZwH73tpfhhH1px+sD8x60BDXJduA7Rr
         eL9VHk3MGuvl4tTgQQFyDs5ZQ/QQuOwwtggduUmUS7r/kfykQ6mFXKplbmRXSCE5g1
         krSziHLUSe4U9Xtq4J3YTEPa2DeMmRxkf3NaOoJuUBGqXRrM8uu+L1oJx3BaVCJSpA
         kUKXnoLotpV4Q==
Received: by pali.im (Postfix)
        id 5925F687; Mon, 12 Apr 2021 18:26:51 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: sfp: relax bitrate-derived mode check
Date:   Mon, 12 Apr 2021 18:26:11 +0200
Message-Id: <20210412162611.17441-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 7a77233ec6d114322e2c4f71b4e26dbecd9ea8a7 ]

Do not check the encoding when deriving 1000BASE-X from the bitrate
when no other modes are discovered. Some GPON modules (VSOL V2801F
and CarlitoxxPro CPGOS03-0490 v2.0) indicate NRZ encoding with a
1200Mbaud bitrate, but should be driven with 1000BASE-X on the host
side.

Tested-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
Please apply this commit to all stable releases where was already
backported commit 0d035bed2a4a6c4878518749348be61bf082d12a
("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
as it depends on this commit. If I checked it correctly patch should
go into 5.10 release.
---
 drivers/net/phy/sfp-bus.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 58014feedf6c..20b91f5dfc6e 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -334,14 +334,13 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	}
 
 	/* If we haven't discovered any modes that this module supports, try
-	 * the encoding and bitrate to determine supported modes. Some BiDi
-	 * modules (eg, 1310nm/1550nm) are not 1000BASE-BX compliant due to
-	 * the differing wavelengths, so do not set any transceiver bits.
+	 * the bitrate to determine supported modes. Some BiDi modules (eg,
+	 * 1310nm/1550nm) are not 1000BASE-BX compliant due to the differing
+	 * wavelengths, so do not set any transceiver bits.
 	 */
 	if (bitmap_empty(modes, __ETHTOOL_LINK_MODE_MASK_NBITS)) {
-		/* If the encoding and bit rate allows 1000baseX */
-		if (id->base.encoding == SFF8024_ENCODING_8B10B && br_nom &&
-		    br_min <= 1300 && br_max >= 1200)
+		/* If the bit rate allows 1000baseX */
+		if (br_nom && br_min <= 1300 && br_max >= 1200)
 			phylink_set(modes, 1000baseX_Full);
 	}
 
-- 
2.20.1

