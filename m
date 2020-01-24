Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1E2147F21
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732568AbgAXK7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgAXK7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:59:52 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DAA02075D;
        Fri, 24 Jan 2020 10:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863590;
        bh=3mmc3PDtfehLLwV237Gk+nHKseBFviRguBuXz9ea8HE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hMOWb3Fwv1UzmPNtN/Aw0ch9H+qmMZADIh8AbHRiCv/Kt1C4sD5HpKSZDOfAun6V
         hUgSXBjqmnfRbIuzOhXQExW6Gj5brWDNu7qt8ZIyTIrjAbwj7nfaTol0e33WO9P/Yt
         AZ4dAoFZ4i3GoDDaKLraSJlXpwpJV21254wKjOxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <shannon.nelson@oracle.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/639] ixgbe: dont clear IPsec sa counters on HW clearing
Date:   Fri, 24 Jan 2020 10:23:11 +0100
Message-Id: <20200124093049.855617662@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <shannon.nelson@oracle.com>

[ Upstream commit 9e3f2f5ecee69b0f70003fb3e07639151e91de73 ]

The software SA record counters should not be cleared when clearing
the hardware tables.  This causes the counters to be out of sync
after a driver reset.

Fixes: 63a67fe229ea ("ixgbe: add ipsec offload add and remove SA")
Signed-off-by: Shannon Nelson <shannon.nelson@oracle.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index b27f7a968820d..49e6d66ccf802 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -114,7 +114,6 @@ static void ixgbe_ipsec_set_rx_ip(struct ixgbe_hw *hw, u16 idx, __be32 addr[])
  **/
 static void ixgbe_ipsec_clear_hw_tables(struct ixgbe_adapter *adapter)
 {
-	struct ixgbe_ipsec *ipsec = adapter->ipsec;
 	struct ixgbe_hw *hw = &adapter->hw;
 	u32 buf[4] = {0, 0, 0, 0};
 	u16 idx;
@@ -133,9 +132,6 @@ static void ixgbe_ipsec_clear_hw_tables(struct ixgbe_adapter *adapter)
 		ixgbe_ipsec_set_tx_sa(hw, idx, buf, 0);
 		ixgbe_ipsec_set_rx_sa(hw, idx, 0, buf, 0, 0, 0);
 	}
-
-	ipsec->num_rx_sa = 0;
-	ipsec->num_tx_sa = 0;
 }
 
 /**
-- 
2.20.1



