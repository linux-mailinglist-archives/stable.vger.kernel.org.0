Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5C92DEF5D
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgLSM6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:58:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbgLSM6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:48 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 21/49] e1000e: fix S0ix flow to allow S0i3.2 subset entry
Date:   Sat, 19 Dec 2020 13:58:25 +0100
Message-Id: <20201219125345.723997200@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit a379b01cd4b2aa3f12786b281a714871574e5ccb ]

Changed a configuration in the flows to align with
architecture requirements to achieve S0i3.2 substate.

This helps both i219V and i219LM configurations.

Also fixed a typo in the previous commit 632fbd5eb5b0
("e1000e: fix S0ix flows for cable connected case").

Fixes: 632fbd5eb5b0 ("e1000e: fix S0ix flows for cable connected case").
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Link: https://lore.kernel.org/r/20201208185632.151052-1-mario.limonciello@dell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6449,13 +6449,13 @@ static void e1000e_s0ix_entry_flow(struc
 
 	/* Ungate PGCB clock */
 	mac_data = er32(FEXTNVM9);
-	mac_data |= BIT(28);
+	mac_data &= ~BIT(28);
 	ew32(FEXTNVM9, mac_data);
 
 	/* Enable K1 off to enable mPHY Power Gating */
 	mac_data = er32(FEXTNVM6);
 	mac_data |= BIT(31);
-	ew32(FEXTNVM12, mac_data);
+	ew32(FEXTNVM6, mac_data);
 
 	/* Enable mPHY power gating for any link and speed */
 	mac_data = er32(FEXTNVM8);
@@ -6499,11 +6499,11 @@ static void e1000e_s0ix_exit_flow(struct
 	/* Disable K1 off */
 	mac_data = er32(FEXTNVM6);
 	mac_data &= ~BIT(31);
-	ew32(FEXTNVM12, mac_data);
+	ew32(FEXTNVM6, mac_data);
 
 	/* Disable Ungate PGCB clock */
 	mac_data = er32(FEXTNVM9);
-	mac_data &= ~BIT(28);
+	mac_data |= BIT(28);
 	ew32(FEXTNVM9, mac_data);
 
 	/* Cancel not waking from dynamic


