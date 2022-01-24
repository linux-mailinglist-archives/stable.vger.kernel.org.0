Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305974999E1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456301AbiAXVia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447543AbiAXVK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:10:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8AFC09D326;
        Mon, 24 Jan 2022 12:09:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B68B8122C;
        Mon, 24 Jan 2022 20:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2782C340E5;
        Mon, 24 Jan 2022 20:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054941;
        bh=r8GhSghsTWhs/kPYweBGTn+V7itGNTAEK1ngaeBmVa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzUXSVPVkV6kzN9cwHe9FW41GizXazz4rfaqvLwAY76PTe1R5fig+xoWNrIgZRCTV
         XM3hpdigPno6om4joDqTAPkPDtJcUug2yJlBynZYTDmVNRmf/oO+bcF72Bg5LRx9gs
         PzP6zJC3FXPrQz5q6TfX+V2aQPkkgg6m5o5ZYzrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E7=85=A7=E5=B1=B1=E5=91=A8=E4=B8=80=E9=83=8E?= 
        <teruyama@springboard-inc.jp>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 553/563] net: sfp: fix high power modules without diagnostic monitoring
Date:   Mon, 24 Jan 2022 19:45:18 +0100
Message-Id: <20220124184043.566189264@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 5765cee119bf5a36c94d20eceb37c445508934be upstream.

Commit 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change
modules") unintetionally changed the semantics for high power modules
without the digital diagnostics monitoring. We repeatedly attempt to
read the power status from the non-existing 0xa2 address in a futile
hope this failure is temporary:

[    8.856051] sfp sfp-eth3: module NTT              0000000000000000 rev 0000  sn 0000000000000000 dc 160408
[    8.865843] mvpp2 f4000000.ethernet eth3: switched to inband/1000base-x link mode
[    8.873469] sfp sfp-eth3: Failed to read EEPROM: -5
[    8.983251] sfp sfp-eth3: Failed to read EEPROM: -5
[    9.103250] sfp sfp-eth3: Failed to read EEPROM: -5

We previosuly assumed such modules were powered up in the correct mode,
continuing without further configuration as long as the required power
class was supported by the host.

Restore this behaviour, while preserving the intent of subsequent
patches to avoid the "Address Change Sequence not supported" warning
if we are not going to be accessing the DDM address.

Fixes: 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change modules")
Reported-by: 照山周一郎 <teruyama@springboard-inc.jp>
Tested-by: 照山周一郎 <teruyama@springboard-inc.jp>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1589,17 +1589,20 @@ static int sfp_sm_probe_for_phy(struct s
 static int sfp_module_parse_power(struct sfp *sfp)
 {
 	u32 power_mW = 1000;
+	bool supports_a2;
 
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
 		power_mW = 1500;
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
 		power_mW = 2000;
 
+	supports_a2 = sfp->id.ext.sff8472_compliance !=
+				SFP_SFF8472_COMPLIANCE_NONE ||
+		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
+
 	if (power_mW > sfp->max_power_mW) {
 		/* Module power specification exceeds the allowed maximum. */
-		if (sfp->id.ext.sff8472_compliance ==
-			SFP_SFF8472_COMPLIANCE_NONE &&
-		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
+		if (!supports_a2) {
 			/* The module appears not to implement bus address
 			 * 0xa2, so assume that the module powers up in the
 			 * indicated mode.
@@ -1616,11 +1619,25 @@ static int sfp_module_parse_power(struct
 		}
 	}
 
+	if (power_mW <= 1000) {
+		/* Modules below 1W do not require a power change sequence */
+		sfp->module_power_mW = power_mW;
+		return 0;
+	}
+
+	if (!supports_a2) {
+		/* The module power level is below the host maximum and the
+		 * module appears not to implement bus address 0xa2, so assume
+		 * that the module powers up in the indicated mode.
+		 */
+		return 0;
+	}
+
 	/* If the module requires a higher power mode, but also requires
 	 * an address change sequence, warn the user that the module may
 	 * not be functional.
 	 */
-	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
+	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
 		dev_warn(sfp->dev,
 			 "Address Change Sequence not supported but module requires %u.%uW, module may not be functional\n",
 			 power_mW / 1000, (power_mW / 100) % 10);


