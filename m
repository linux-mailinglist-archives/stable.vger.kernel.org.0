Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B57947AE7F
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbhLTPBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239288AbhLTO6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B10C0613A1;
        Mon, 20 Dec 2021 06:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC6DB80EE3;
        Mon, 20 Dec 2021 14:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD71C36AE7;
        Mon, 20 Dec 2021 14:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011822;
        bh=4n8EdVgXsAbM/IvKUAZywoQNE0i2iBaOhhI3Kvjlls0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08/ctcsX73z3aJ0WQnzWEEbc3MB7W8lzzWrXz9jZzPebN2PtlAxfo8u/Q5vfTSeDM
         gR09TQvZN0+b/5wAe69QohJ/lJ0IDG4FQQ+lYZBFuBQsQkdE9tSaFlX26S5FG8A0Fx
         TT8H6ha+h2oYazoLbr9Ya9ytetGrDBDsFs33Sr2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyril Novikov <cnovikov@lynx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 54/99] ixgbe: set X550 MDIO speed before talking to PHY
Date:   Mon, 20 Dec 2021 15:34:27 +0100
Message-Id: <20211220143031.209726616@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cyril Novikov <cnovikov@lynx.com>

[ Upstream commit bf0a375055bd1afbbf02a0ef45f7655da7b71317 ]

The MDIO bus speed must be initialized before talking to the PHY the first
time in order to avoid talking to it using a speed that the PHY doesn't
support.

This fixes HW initialization error -17 (IXGBE_ERR_PHY_ADDR_INVALID) on
Denverton CPUs (a.k.a. the Atom C3000 family) on ports with a 10Gb network
plugged in. On those devices, HLREG0[MDCSPD] resets to 1, which combined
with the 10Gb network results in a 24MHz MDIO speed, which is apparently
too fast for the connected PHY. PHY register reads over MDIO bus return
garbage, leading to initialization failure.

Reproduced with Linux kernel 4.19 and 5.15-rc7. Can be reproduced using
the following setup:

* Use an Atom C3000 family system with at least one X552 LAN on the SoC
* Disable PXE or other BIOS network initialization if possible
  (the interface must not be initialized before Linux boots)
* Connect a live 10Gb Ethernet cable to an X550 port
* Power cycle (not reset, doesn't always work) the system and boot Linux
* Observe: ixgbe interfaces w/ 10GbE cables plugged in fail with error -17

Fixes: e84db7272798 ("ixgbe: Introduce function to control MDIO speed")
Signed-off-by: Cyril Novikov <cnovikov@lynx.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index 5e339afa682a6..37f2bc6de4b65 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -3405,6 +3405,9 @@ static s32 ixgbe_reset_hw_X550em(struct ixgbe_hw *hw)
 	/* flush pending Tx transactions */
 	ixgbe_clear_tx_pending(hw);
 
+	/* set MDIO speed before talking to the PHY in case it's the 1st time */
+	ixgbe_set_mdio_speed(hw);
+
 	/* PHY ops must be identified and initialized prior to reset */
 	status = hw->phy.ops.init(hw);
 	if (status == IXGBE_ERR_SFP_NOT_SUPPORTED ||
-- 
2.33.0



