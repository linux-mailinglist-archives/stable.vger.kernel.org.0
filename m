Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC223D5F0B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbhGZPQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236307AbhGZPLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7CC860F59;
        Mon, 26 Jul 2021 15:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314705;
        bh=uBHGnnweV2Kr9KOe4qq44mmeWZOuKU4teDMHUGPBclc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bA7nU5kHr12iV4xuJkK35z7YB3maJ7zKXgSdSmR3yIZCWT80l0VN9QwIkeUwtYmrH
         l9iaIpbRgpLS+Iio94Qi2EZxkQsouN5MhajkXrWj+PpPT5pd/mmgu5iR5NqwgJJRMZ
         VSIzXCIt1YhghgQTzuL803KmF//C7SvvXN/0+GJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/120] igb: Fix position of assignment to *ring
Date:   Mon, 26 Jul 2021 17:38:32 +0200
Message-Id: <20210726153834.310818370@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit 382a7c20d9253bcd5715789b8179528d0f3de72c ]

Assignment to *ring should be done after correctness check of the
argument queue.

Fixes: 91db364236c8 ("igb: Refactor igb_configure_cbs()")
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 243e304c35cd..6221dafc76b9 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1692,14 +1692,15 @@ static bool is_any_txtime_enabled(struct igb_adapter *adapter)
  **/
 static void igb_config_tx_modes(struct igb_adapter *adapter, int queue)
 {
-	struct igb_ring *ring = adapter->tx_ring[queue];
 	struct net_device *netdev = adapter->netdev;
 	struct e1000_hw *hw = &adapter->hw;
+	struct igb_ring *ring;
 	u32 tqavcc, tqavctrl;
 	u16 value;
 
 	WARN_ON(hw->mac.type != e1000_i210);
 	WARN_ON(queue < 0 || queue > 1);
+	ring = adapter->tx_ring[queue];
 
 	/* If any of the Qav features is enabled, configure queues as SR and
 	 * with HIGH PRIO. If none is, then configure them with LOW PRIO and
-- 
2.30.2



