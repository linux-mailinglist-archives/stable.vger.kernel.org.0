Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C3C561BAC
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbiF3NsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235317AbiF3Nr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DBE2F03E;
        Thu, 30 Jun 2022 06:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 691CD61FF6;
        Thu, 30 Jun 2022 13:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEC9C34115;
        Thu, 30 Jun 2022 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596867;
        bh=2VWJ2Tt2rteN35orcPyK48VLRO1P2rxOlKwKbC1B5Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCK76pyObdEMYGKKHHJ9hlE1kc9Ch8ml0RA2uJfw3T7Tm5JG4rEzZL/cGk5w8CZ1A
         yvOr6Pyt472/bJJ+yCMlmldYsDsLZ0HKcoSAm+Ya4X8JsjasWLcpkJsSEoreB/x7B3
         jygSdIPK9RXqOikVs8nZGJGSSqvNmfsxo3NXsnE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 4.9 10/29] igb: Make DMA faster when CPU is active on the PCIe link
Date:   Thu, 30 Jun 2022 15:46:10 +0200
Message-Id: <20220630133231.506958689@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 4e0effd9007ea0be31f7488611eb3824b4541554 ]

Intel I210 on some Intel Alder Lake platforms can only achieve ~750Mbps
Tx speed via iperf. The RR2DCDELAY shows around 0x2xxx DMA delay, which
will be significantly lower when 1) ASPM is disabled or 2) SoC package
c-state stays above PC3. When the RR2DCDELAY is around 0x1xxx the Tx
speed can reach to ~950Mbps.

According to the I210 datasheet "8.26.1 PCIe Misc. Register - PCIEMISC",
"DMA Idle Indication" doesn't seem to tie to DMA coalesce anymore, so
set it to 1b for "DMA is considered idle when there is no Rx or Tx AND
when there are no TLPs indicating that CPU is active detected on the
PCIe link (such as the host executes CSR or Configuration register read
or write operation)" and performing Tx should also fall under "active
CPU on PCIe link" case.

In addition to that, commit b6e0c419f040 ("igb: Move DMA Coalescing init
code to separate function.") seems to wrongly changed from enabling
E1000_PCIEMISC_LX_DECISION to disabling it, also fix that.

Fixes: b6e0c419f040 ("igb: Move DMA Coalescing init code to separate function.")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20220621221056.604304-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index d825e527ec1a..2e713e5f75cd 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8161,11 +8161,10 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 	struct e1000_hw *hw = &adapter->hw;
 	u32 dmac_thr;
 	u16 hwm;
+	u32 reg;
 
 	if (hw->mac.type > e1000_82580) {
 		if (adapter->flags & IGB_FLAG_DMAC) {
-			u32 reg;
-
 			/* force threshold to 0. */
 			wr32(E1000_DMCTXTH, 0);
 
@@ -8198,7 +8197,6 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			/* Disable BMC-to-OS Watchdog Enable */
 			if (hw->mac.type != e1000_i354)
 				reg &= ~E1000_DMACR_DC_BMC2OSW_EN;
-
 			wr32(E1000_DMACR, reg);
 
 			/* no lower threshold to disable
@@ -8215,12 +8213,12 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			 */
 			wr32(E1000_DMCTXTH, (IGB_MIN_TXPBSIZE -
 			     (IGB_TX_BUF_4096 + adapter->max_frame_size)) >> 6);
+		}
 
-			/* make low power state decision controlled
-			 * by DMA coal
-			 */
+		if (hw->mac.type >= e1000_i210 ||
+		    (adapter->flags & IGB_FLAG_DMAC)) {
 			reg = rd32(E1000_PCIEMISC);
-			reg &= ~E1000_PCIEMISC_LX_DECISION;
+			reg |= E1000_PCIEMISC_LX_DECISION;
 			wr32(E1000_PCIEMISC, reg);
 		} /* endif adapter->dmac is not disabled */
 	} else if (hw->mac.type == e1000_82580) {
-- 
2.35.1



