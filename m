Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDCB32E943
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhCEMbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:31:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231657AbhCEMb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:31:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AE0F6502E;
        Fri,  5 Mar 2021 12:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947480;
        bh=oLmYKnqPJjauAD+4HGod3z2rZzQOABUGoPWHe/EJEfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQ6Qq0KsQ5QmM9fInCaJRmAgfYakaYDbX3E7gdPO1+h5Xe3PwyNECmyPjWCVIUmVB
         kY1+0s2lbbWXHSPvNVNs6hlaoVlHrsZ1BTYt9JgDGLYln/tIm93qfiZt06ZTR35Iq2
         7SLopKX0/xqwXyWC3qINNiMZIXEvw9gYf/aWjOY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/102] net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant
Date:   Fri,  5 Mar 2021 13:21:09 +0100
Message-Id: <20210305120905.754412867@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit f0b4f847673299577c29b71d3f3acd3c313d81b7 ]

The Ubiquiti U-Fiber Instant SFP GPON module has nonsensical information
stored in its EEPROM. It claims to support all transceiver types including
10G Ethernet. Clear all claimed modes and set only 1000baseX_Full, which is
the only one supported.

This module has also phys_id set to SFF, and the SFP subsystem currently
does not allow to use SFP modules detected as SFFs. Add exception for this
module so it can be detected as supported.

This change finally allows to detect and use SFP GPON module Ubiquiti
U-Fiber Instant on Linux system.

EEPROM content of this SFP module is (where XX is serial number):

00: 02 04 0b ff ff ff ff ff ff ff ff 03 0c 00 14 c8    ???........??.??
10: 00 00 00 00 55 42 4e 54 20 20 20 20 20 20 20 20    ....UBNT
20: 20 20 20 20 00 18 e8 29 55 46 2d 49 4e 53 54 41        .??)UF-INSTA
30: 4e 54 20 20 20 20 20 20 34 20 20 20 05 1e 00 36    NT      4   ??.6
40: 00 06 00 00 55 42 4e 54 XX XX XX XX XX XX XX XX    .?..UBNTXXXXXXXX
50: 20 20 20 20 31 34 30 31 32 33 20 20 60 80 02 41        140123  `??A

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 15 +++++++++++++++
 drivers/net/phy/sfp.c     | 17 +++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 58014feedf6c..fb954e814180 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -44,6 +44,17 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 	phylink_set(modes, 2500baseX_Full);
 }
 
+static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
+				      unsigned long *modes)
+{
+	/* Ubiquiti U-Fiber Instant module claims that support all transceiver
+	 * types including 10G Ethernet which is not truth. So clear all claimed
+	 * modes and set only one mode which module supports: 1000baseX_Full.
+	 */
+	phylink_zero(modes);
+	phylink_set(modes, 1000baseX_Full);
+}
+
 static const struct sfp_quirk sfp_quirks[] = {
 	{
 		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
@@ -63,6 +74,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "HUAWEI",
 		.part = "MA5671A",
 		.modes = sfp_quirk_2500basex,
+	}, {
+		.vendor = "UBNT",
+		.part = "UF-INSTANT",
+		.modes = sfp_quirk_ubnt_uf_instant,
 	},
 };
 
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 34aa196b7465..d8a809cf20c1 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -272,8 +272,21 @@ static const struct sff_data sff_data = {
 
 static bool sfp_module_supported(const struct sfp_eeprom_id *id)
 {
-	return id->base.phys_id == SFF8024_ID_SFP &&
-	       id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP;
+	if (id->base.phys_id == SFF8024_ID_SFP &&
+	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP)
+		return true;
+
+	/* SFP GPON module Ubiquiti U-Fiber Instant has in its EEPROM stored
+	 * phys id SFF instead of SFP. Therefore mark this module explicitly
+	 * as supported based on vendor name and pn match.
+	 */
+	if (id->base.phys_id == SFF8024_ID_SFF_8472 &&
+	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP &&
+	    !memcmp(id->base.vendor_name, "UBNT            ", 16) &&
+	    !memcmp(id->base.vendor_pn, "UF-INSTANT      ", 16))
+		return true;
+
+	return false;
 }
 
 static const struct sff_data sfp_data = {
-- 
2.30.1



