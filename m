Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DAA4CF921
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbiCGKDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239927AbiCGKA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8217D023;
        Mon,  7 Mar 2022 01:46:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 727ED61220;
        Mon,  7 Mar 2022 09:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769EFC340E9;
        Mon,  7 Mar 2022 09:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646393;
        bh=RBIP91LgZUyqhUHzo0CuYJAho8yLrXfh2cIdnSzoUw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RV0cmJxB0YLFEK4RyWyioQQ1SWZyW6+qMGxdAcRQtbgJr5Cm82ljnErcNmfr8gyJ3
         YTDmU/g3fAJXBgTzbSgg8xnNXWoUE0WRjDUIUClvsucHu4OmqYBP7TmrFzrBsnq/+s
         cGJFtpY6h2w57fXtzCLy9NRwlesxJZl2YxepcB+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Laba <slawomirx.laba@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/262] iavf: Add waiting so the port is initialized in remove
Date:   Mon,  7 Mar 2022 10:19:34 +0100
Message-Id: <20220307091709.708747963@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

[ Upstream commit 974578017fc1fdd06cea8afb9dfa32602e8529ed ]

There exist races when port is being configured and remove is
triggered.

unregister_netdev is not and can't be called under crit_lock
mutex since it is calling ndo_stop -> iavf_close which requires
this lock. Depending on init state the netdev could be still
unregistered so unregister_netdev never cleans up, when shortly
after that the device could become registered.

Make iavf_remove wait until port finishes initialization.
All critical state changes are atomic (under crit_lock).
Crashes that come from iavf_reset_interrupt_capability and
iavf_free_traffic_irqs should now be solved in a graceful
manner.

Fixes: 605ca7c5c6707 ("iavf: Fix kernel BUG in free_msi_irqs")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 27 ++++++++++++---------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index e97a8dbbbc89..60e6f55c6dc5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3979,7 +3979,6 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 static void iavf_remove(struct pci_dev *pdev)
 {
 	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
-	enum iavf_state_t prev_state = adapter->last_state;
 	struct net_device *netdev = adapter->netdev;
 	struct iavf_fdir_fltr *fdir, *fdirtmp;
 	struct iavf_vlan_filter *vlf, *vlftmp;
@@ -3989,6 +3988,22 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
 
+	/* Wait until port initialization is complete.
+	 * There are flows where register/unregister netdev may race.
+	 */
+	while (1) {
+		mutex_lock(&adapter->crit_lock);
+		if (adapter->state == __IAVF_RUNNING ||
+		    adapter->state == __IAVF_DOWN) {
+			mutex_unlock(&adapter->crit_lock);
+			break;
+		}
+
+		mutex_unlock(&adapter->crit_lock);
+		usleep_range(500, 1000);
+	}
+	cancel_delayed_work_sync(&adapter->watchdog_task);
+
 	if (adapter->netdev_registered) {
 		unregister_netdev(netdev);
 		adapter->netdev_registered = false;
@@ -4026,16 +4041,6 @@ static void iavf_remove(struct pci_dev *pdev)
 	iavf_free_all_rx_resources(adapter);
 	iavf_free_misc_irq(adapter);
 
-	/* In case we enter iavf_remove from erroneous state, free traffic irqs
-	 * here, so as to not cause a kernel crash, when calling
-	 * iavf_reset_interrupt_capability.
-	 */
-	if ((adapter->last_state == __IAVF_RESETTING &&
-	     prev_state != __IAVF_DOWN) ||
-	    (adapter->last_state == __IAVF_RUNNING &&
-	     !(netdev->flags & IFF_UP)))
-		iavf_free_traffic_irqs(adapter);
-
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_q_vectors(adapter);
 
-- 
2.34.1



