Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3FA1070BF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfKVKio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:38:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbfKVKil (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:38:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C79420717;
        Fri, 22 Nov 2019 10:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419120;
        bh=uZ8AOgJ9LAjIUjnvJ3css1oOtMwLwVoIUPAeWo0udMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLBhAbKgwlgcRovUTWcjUEmyYMlhe+COnDWFOOFwa2bP3nQIXZ/AXQuTUVwlvjMmV
         HcnLGUdEdI2zkw07frQilIdP7uaGs97JYrpiTcHZykphRFoAjYHN7WJW705hoXPoNg
         cqdBzWrP9yPwBGZkt8ES5aWC6cLpmq9i2OwKKs18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radoslaw Tyl <radoslawx.tyl@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 127/159] ixgbe: Fix crash with VFs and flow director on interface flap
Date:   Fri, 22 Nov 2019 11:28:38 +0100
Message-Id: <20191122100832.307803950@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

[ Upstream commit 5d826d209164b0752c883607be4cdbbcf7cab494 ]

This patch fix crash when we have restore flow director filters after reset
adapter. In ixgbe_fdir_filter_restore() filter->action is outside of the
rx_ring array, as it has a VF identifier in the upper 32 bits.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index a5b443171b8bd..4521181aa0ed9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4532,6 +4532,7 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *filter;
+	u64 action;
 
 	spin_lock(&adapter->fdir_perfect_lock);
 
@@ -4540,12 +4541,17 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 
 	hlist_for_each_entry_safe(filter, node2,
 				  &adapter->fdir_filter_list, fdir_node) {
+		action = filter->action;
+		if (action != IXGBE_FDIR_DROP_QUEUE && action != 0)
+			action =
+			(action >> ETHTOOL_RX_FLOW_SPEC_RING_VF_OFF) - 1;
+
 		ixgbe_fdir_write_perfect_filter_82599(hw,
 				&filter->filter,
 				filter->sw_idx,
-				(filter->action == IXGBE_FDIR_DROP_QUEUE) ?
+				(action == IXGBE_FDIR_DROP_QUEUE) ?
 				IXGBE_FDIR_DROP_QUEUE :
-				adapter->rx_ring[filter->action]->reg_idx);
+				adapter->rx_ring[action]->reg_idx);
 	}
 
 	spin_unlock(&adapter->fdir_perfect_lock);
-- 
2.20.1



