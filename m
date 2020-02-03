Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B0F150C39
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgBCQeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbgBCQeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:23 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7619C2051A;
        Mon,  3 Feb 2020 16:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747662;
        bh=J2/5xfvvET5DcrUhAIhtNKGV81GhN+1uXDWXSIso8z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yb0mzlqnDUu9A2oBDSiHjZuKJSXIHfjJibcfD9mH30T3BEX/I/sWDOzupeAbPRhDd
         3mYJoMVlj/EkAULggSKKoHy/0LPKiJzjeYDtx4wQr7n1ZowCLszsT+F1qpoB7qzpwm
         EqX+j1iPiq1k0QqyZDoCZTRUYLl1TzIT4kC10cC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/90] e1000e: Drop unnecessary __E1000_DOWN bit twiddling
Date:   Mon,  3 Feb 2020 16:19:09 +0000
Message-Id: <20200203161918.428841772@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

[ Upstream commit daee5598e491d8d3979bd4ad6c447d89ce57b446 ]

Since we no longer check for __E1000_DOWN in e1000e_close we can drop the
spot where we were restoring the bit. This saves us a bit of unnecessary
complexity.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index d7d56e42a6aac..aa9fdda839148 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7407,15 +7407,13 @@ static void e1000_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	bool down = test_bit(__E1000_DOWN, &adapter->state);
 
 	e1000e_ptp_remove(adapter);
 
 	/* The timers may be rescheduled, so explicitly disable them
 	 * from being rescheduled.
 	 */
-	if (!down)
-		set_bit(__E1000_DOWN, &adapter->state);
+	set_bit(__E1000_DOWN, &adapter->state);
 	del_timer_sync(&adapter->phy_info_timer);
 
 	cancel_work_sync(&adapter->reset_task);
@@ -7435,9 +7433,6 @@ static void e1000_remove(struct pci_dev *pdev)
 		}
 	}
 
-	/* Don't lie to e1000_close() down the road. */
-	if (!down)
-		clear_bit(__E1000_DOWN, &adapter->state);
 	unregister_netdev(netdev);
 
 	if (pci_dev_run_wake(pdev))
-- 
2.20.1



