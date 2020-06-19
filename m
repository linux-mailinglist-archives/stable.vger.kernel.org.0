Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BB8200C4D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388514AbgFSOny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388511AbgFSOnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:43:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2493221556;
        Fri, 19 Jun 2020 14:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577832;
        bh=L3YK4HhwSLCxtVLyXo4PKwaZSioEb4283EpfEjbdwFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBoAoHQkc125SPDodIpYOd/OOJu0WbAECjoH4OuXgH2cQy/2OIrUkIsVUCwusg+RJ
         0lL021LT+0mj7j14dJPmcbyCn/dzoNSkNb0kaTyFNdKTUKKHOTFBaSYfDP4M0zi5GB
         40C9oAIiWaT3VcBZ1CZJTcVFq4g4a2DENN7hENh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 4.9 107/128] e1000e: Relax condition to trigger reset for ME workaround
Date:   Fri, 19 Jun 2020 16:33:21 +0200
Message-Id: <20200619141625.801951252@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Punit Agrawal <punit1.agrawal@toshiba.co.jp>

commit d601afcae2febc49665008e9a79e701248d56c50 upstream.

It's an error if the value of the RX/TX tail descriptor does not match
what was written. The error condition is true regardless the duration
of the interference from ME. But the driver only performs the reset if
E1000_ICH_FWSM_PCIM2PCI_COUNT (2000) iterations of 50us delay have
transpired. The extra condition can lead to inconsistency between the
state of hardware as expected by the driver.

Fix this by dropping the check for number of delay iterations.

While at it, also make __ew32_prepare() static as it's not used
anywhere else.

CC: stable <stable@vger.kernel.org>
Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/e1000.h  |    1 -
 drivers/net/ethernet/intel/e1000e/netdev.c |   12 +++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -589,7 +589,6 @@ static inline u32 __er32(struct e1000_hw
 
 #define er32(reg)	__er32(hw, E1000_##reg)
 
-s32 __ew32_prepare(struct e1000_hw *hw);
 void __ew32(struct e1000_hw *hw, unsigned long reg, u32 val);
 
 #define ew32(reg, val)	__ew32(hw, E1000_##reg, (val))
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -136,14 +136,12 @@ static const struct e1000_reg_info e1000
  * has bit 24 set while ME is accessing MAC CSR registers, wait if it is set
  * and try again a number of times.
  **/
-s32 __ew32_prepare(struct e1000_hw *hw)
+static void __ew32_prepare(struct e1000_hw *hw)
 {
 	s32 i = E1000_ICH_FWSM_PCIM2PCI_COUNT;
 
 	while ((er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI) && --i)
 		udelay(50);
-
-	return i;
 }
 
 void __ew32(struct e1000_hw *hw, unsigned long reg, u32 val)
@@ -624,11 +622,11 @@ static void e1000e_update_rdt_wa(struct
 {
 	struct e1000_adapter *adapter = rx_ring->adapter;
 	struct e1000_hw *hw = &adapter->hw;
-	s32 ret_val = __ew32_prepare(hw);
 
+	__ew32_prepare(hw);
 	writel(i, rx_ring->tail);
 
-	if (unlikely(!ret_val && (i != readl(rx_ring->tail)))) {
+	if (unlikely(i != readl(rx_ring->tail))) {
 		u32 rctl = er32(RCTL);
 
 		ew32(RCTL, rctl & ~E1000_RCTL_EN);
@@ -641,11 +639,11 @@ static void e1000e_update_tdt_wa(struct
 {
 	struct e1000_adapter *adapter = tx_ring->adapter;
 	struct e1000_hw *hw = &adapter->hw;
-	s32 ret_val = __ew32_prepare(hw);
 
+	__ew32_prepare(hw);
 	writel(i, tx_ring->tail);
 
-	if (unlikely(!ret_val && (i != readl(tx_ring->tail)))) {
+	if (unlikely(i != readl(tx_ring->tail))) {
 		u32 tctl = er32(TCTL);
 
 		ew32(TCTL, tctl & ~E1000_TCTL_EN);


