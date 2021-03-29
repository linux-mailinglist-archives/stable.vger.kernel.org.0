Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8F34CA6A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhC2Iie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234464AbhC2IgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF1061996;
        Mon, 29 Mar 2021 08:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006940;
        bh=wtSuQVK3pJ4EFbYAzASKCXRFT6BsDWsG2FeA192Pphs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDt9UB/msgmTowVFmQ29rnpg/oDCxk+Z6946qKkPAW3YnoknTSuI3D7E7lQErp1R8
         856PjWoJTXi6d6hjw9D0UTcnBAy8v4XitUWUN6fUR7751/3A+3VnBjbE6hPrdoYelC
         sxfsIvDhptkH6/7QUy23N87EDxor2bCaA5H++fFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 125/254] igc: reinit_locked() should be called with rtnl_lock
Date:   Mon, 29 Mar 2021 09:57:21 +0200
Message-Id: <20210329075637.335628960@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 6da262378c99b17b1a1ac2e42aa65acc1bd471c7 ]

This commit applies to the igc_reset_task the same changes that
were applied to the igb driver in commit 024a8168b749 ("igb:
reinit_locked() should be called with rtnl_lock")
and fix possible race in reset subtask.

Fixes: 0507ef8a0372 ("igc: Add transmit and receive fastpath and interrupt handlers")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index afd6a62da29d..93874e930abf 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3847,10 +3847,19 @@ static void igc_reset_task(struct work_struct *work)
 
 	adapter = container_of(work, struct igc_adapter, reset_task);
 
+	rtnl_lock();
+	/* If we're already down or resetting, just bail */
+	if (test_bit(__IGC_DOWN, &adapter->state) ||
+	    test_bit(__IGC_RESETTING, &adapter->state)) {
+		rtnl_unlock();
+		return;
+	}
+
 	igc_rings_dump(adapter);
 	igc_regs_dump(adapter);
 	netdev_err(adapter->netdev, "Reset adapter\n");
 	igc_reinit_locked(adapter);
+	rtnl_unlock();
 }
 
 /**
-- 
2.30.1



