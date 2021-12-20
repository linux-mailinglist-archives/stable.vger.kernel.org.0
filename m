Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FA547ABEC
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhLTOkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:40:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47604 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbhLTOjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:39:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B767B80EE5;
        Mon, 20 Dec 2021 14:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FBCC36AEB;
        Mon, 20 Dec 2021 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011154;
        bh=Aaz9U4wlM/ajVy3dJJS+RuQPQn4U/kNeGHJNKtx4c3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6K56dlCP7QyaHislJynN2uaErHrXVfKeJoyE7kib4I9/irarfaGb5HQSifYsPKes
         MKcwfPTtyPGpO1+ueP7zKSvzkna9AaN3HM2o16gb7qLekNp073ikQJSi8xHB91tNfS
         1MZfOxQvkINF/VfVYlq737qj/LuCWxiqoL781bgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cyril Novikov <cnovikov@lynx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/45] ixgbe: set X550 MDIO speed before talking to PHY
Date:   Mon, 20 Dec 2021 15:34:17 +0100
Message-Id: <20211220143023.012584883@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
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
index a37c951b07530..10fa0e095ec37 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -3397,6 +3397,9 @@ static s32 ixgbe_reset_hw_X550em(struct ixgbe_hw *hw)
 	/* flush pending Tx transactions */
 	ixgbe_clear_tx_pending(hw);
 
+	/* set MDIO speed before talking to the PHY in case it's the 1st time */
+	ixgbe_set_mdio_speed(hw);
+
 	/* PHY ops must be identified and initialized prior to reset */
 
 	/* Identify PHY and related function pointers */
-- 
2.33.0



