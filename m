Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F1B47AD75
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbhLTOwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:52:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41982 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238225AbhLTOuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:50:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F3DF6119C;
        Mon, 20 Dec 2021 14:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63991C36AE9;
        Mon, 20 Dec 2021 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011819;
        bh=3kqhqbfbqsdyzaL66YJCT1UkRYcBkhpS2LPgGIMxF0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNjNTCQgPXhABAHWwTADUcVDUFE/2ifwTzALqjD0ovR+ib0HDMmfpcGHEu9cnUxns
         7R49Ia9RSGyXA1Fic1hNi7RnNcstsDRjLD0tAF7Sei18iwPkZKcAEzkSn5VvdVoMfL
         rkDWe0ZT/5leI03tibNvZQfdMGm9nOGxBM5m7rtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Schlabbach <robert_s@gmx.net>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/99] ixgbe: Document how to enable NBASE-T support
Date:   Mon, 20 Dec 2021 15:34:26 +0100
Message-Id: <20211220143031.175925081@linuxfoundation.org>
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

From: Robert Schlabbach <robert_s@gmx.net>

[ Upstream commit 271225fd57c2f1e0b3f8826df51be6c634affefe ]

Commit a296d665eae1 ("ixgbe: Add ethtool support to enable 2.5 and 5.0
Gbps support") introduced suppression of the advertisement of NBASE-T
speeds by default, according to Todd Fujinaka to accommodate customers
with network switches which could not cope with advertised NBASE-T
speeds, as posted in the E1000-devel mailing list:

https://sourceforge.net/p/e1000/mailman/message/37106269/

However, the suppression was not documented at all, nor was how to
enable NBASE-T support.

Properly document the NBASE-T suppression and how to enable NBASE-T
support.

Fixes: a296d665eae1 ("ixgbe: Add ethtool support to enable 2.5 and 5.0 Gbps support")
Reported-by: Robert Schlabbach <robert_s@gmx.net>
Signed-off-by: Robert Schlabbach <robert_s@gmx.net>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../device_drivers/ethernet/intel/ixgbe.rst      | 16 ++++++++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |  4 ++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst b/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
index f1d5233e5e510..0a233b17c664e 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
@@ -440,6 +440,22 @@ NOTE: For 82599-based network connections, if you are enabling jumbo frames in
 a virtual function (VF), jumbo frames must first be enabled in the physical
 function (PF). The VF MTU setting cannot be larger than the PF MTU.
 
+NBASE-T Support
+---------------
+The ixgbe driver supports NBASE-T on some devices. However, the advertisement
+of NBASE-T speeds is suppressed by default, to accommodate broken network
+switches which cannot cope with advertised NBASE-T speeds. Use the ethtool
+command to enable advertising NBASE-T speeds on devices which support it::
+
+  ethtool -s eth? advertise 0x1800000001028
+
+On Linux systems with INTERFACES(5), this can be specified as a pre-up command
+in /etc/network/interfaces so that the interface is always brought up with
+NBASE-T support, e.g.::
+
+  iface eth? inet dhcp
+       pre-up ethtool -s eth? advertise 0x1800000001028 || true
+
 Generic Receive Offload, aka GRO
 --------------------------------
 The driver supports the in-kernel software implementation of GRO. GRO has
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ffe322136c584..a3a02e2f92f64 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5532,6 +5532,10 @@ static int ixgbe_non_sfp_link_config(struct ixgbe_hw *hw)
 	if (!speed && hw->mac.ops.get_link_capabilities) {
 		ret = hw->mac.ops.get_link_capabilities(hw, &speed,
 							&autoneg);
+		/* remove NBASE-T speeds from default autonegotiation
+		 * to accommodate broken network switches in the field
+		 * which cannot cope with advertised NBASE-T speeds
+		 */
 		speed &= ~(IXGBE_LINK_SPEED_5GB_FULL |
 			   IXGBE_LINK_SPEED_2_5GB_FULL);
 	}
-- 
2.33.0



