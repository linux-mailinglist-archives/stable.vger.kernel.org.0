Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C43A43A144
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbhJYTh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236660AbhJYTfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 479B9603E5;
        Mon, 25 Oct 2021 19:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190329;
        bh=OaManoyddLXjqRvxOTuMW98sSUZrZV8ZN0DMlLKwaUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvV77Hh6ILnjaWgoGoWaY/SYY+5Qjv5Wu51px/7+mf1sax9rVbulM/ACaIGYlNkCc
         og8wDlWtMuk6nrol90fRAmI90+Zp+SUcpiecFIaBl+LlUS1hr7yEVvqn6UUiilHeAv
         Zt3Y0cVSaEzDp60Xh22eJYbkCwgfXc4poG0nYbjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Mark Pearson <markpearson@lenovo.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/95] e1000e: Fix packet loss on Tiger Lake and later
Date:   Mon, 25 Oct 2021 21:14:27 +0200
Message-Id: <20211025191001.275291909@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 639e298f432fb058a9496ea16863f53b1ce935fe ]

Update the HW MAC initialization flow. Do not gate DMA clock from
the modPHY block. Keeping this clock will prevent dropped packets
sent in burst mode on the Kumeran interface.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213651
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213377
Fixes: fb776f5d57ee ("e1000e: Add support for Tiger Lake")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Mark Pearson <markpearson@lenovo.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 11 ++++++++++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 854c585de2e1..3cbb8d1ed67f 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -4811,7 +4811,7 @@ static s32 e1000_reset_hw_ich8lan(struct e1000_hw *hw)
 static s32 e1000_init_hw_ich8lan(struct e1000_hw *hw)
 {
 	struct e1000_mac_info *mac = &hw->mac;
-	u32 ctrl_ext, txdctl, snoop;
+	u32 ctrl_ext, txdctl, snoop, fflt_dbg;
 	s32 ret_val;
 	u16 i;
 
@@ -4870,6 +4870,15 @@ static s32 e1000_init_hw_ich8lan(struct e1000_hw *hw)
 		snoop = (u32)~(PCIE_NO_SNOOP_ALL);
 	e1000e_set_pcie_no_snoop(hw, snoop);
 
+	/* Enable workaround for packet loss issue on TGP PCH
+	 * Do not gate DMA clock from the modPHY block
+	 */
+	if (mac->type >= e1000_pch_tgp) {
+		fflt_dbg = er32(FFLT_DBG);
+		fflt_dbg |= E1000_FFLT_DBG_DONT_GATE_WAKE_DMA_CLK;
+		ew32(FFLT_DBG, fflt_dbg);
+	}
+
 	ctrl_ext = er32(CTRL_EXT);
 	ctrl_ext |= E1000_CTRL_EXT_RO_DIS;
 	ew32(CTRL_EXT, ctrl_ext);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index e757896287eb..8f2a8f4ce0ee 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -286,6 +286,9 @@
 /* Proprietary Latency Tolerance Reporting PCI Capability */
 #define E1000_PCI_LTR_CAP_LPT		0xA8
 
+/* Don't gate wake DMA clock */
+#define E1000_FFLT_DBG_DONT_GATE_WAKE_DMA_CLK	0x1000
+
 void e1000e_write_protect_nvm_ich8lan(struct e1000_hw *hw);
 void e1000e_set_kmrn_lock_loss_workaround_ich8lan(struct e1000_hw *hw,
 						  bool state);
-- 
2.33.0



