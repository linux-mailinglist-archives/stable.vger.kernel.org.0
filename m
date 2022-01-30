Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A8C4A36D0
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 15:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355053AbiA3Ome (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 09:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355046AbiA3Omd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 09:42:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53CDC061714
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 06:42:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4555E60EC1
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 14:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134F9C340E4;
        Sun, 30 Jan 2022 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643553752;
        bh=Xk8HwUsA3W2yDg/91ZrNTw3s2f3HMJ9xUznadQi+e30=;
        h=Subject:To:Cc:From:Date:From;
        b=cOodvAFhwoA/Dq4d0jPDZRerVm4dVexm2wItIk+Ymx3ago/Z+ZVPMz7pNL/xIjE/7
         byR6EAU4x8rD89kWrkhrRh+YiYr89eelJ+JGtJxmGHfgmbp7uxIonsy8bRuAMMshqz
         1/dWZNnOjN/E9kypXUrVtegLjvbWKV8jv+sAY8lQ=
Subject: FAILED: patch "[PATCH] i40e: fix unsigned stat widths" failed to apply to 4.4-stable tree
To:     jdamato@fastly.com, anthony.l.nguyen@intel.com,
        gurucharanx.g@intel.com, lkp@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 Jan 2022 15:42:29 +0100
Message-ID: <1643553749115182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b8428b84539c78fdc8006c17ebd25afd4722d51 Mon Sep 17 00:00:00 2001
From: Joe Damato <jdamato@fastly.com>
Date: Wed, 8 Dec 2021 17:56:33 -0800
Subject: [PATCH] i40e: fix unsigned stat widths

Change i40e_update_vsi_stats and struct i40e_vsi to use u64 fields to match
the width of the stats counters in struct i40e_rx_queue_stats.

Update debugfs code to use the correct format specifier for u64.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Joe Damato <jdamato@fastly.com>
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index c8cfe62d5e05..2e02cc68cd3f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -847,12 +847,12 @@ struct i40e_vsi {
 	struct rtnl_link_stats64 net_stats_offsets;
 	struct i40e_eth_stats eth_stats;
 	struct i40e_eth_stats eth_stats_offsets;
-	u32 tx_restart;
-	u32 tx_busy;
+	u64 tx_restart;
+	u64 tx_busy;
 	u64 tx_linearize;
 	u64 tx_force_wb;
-	u32 rx_buf_failed;
-	u32 rx_page_failed;
+	u64 rx_buf_failed;
+	u64 rx_page_failed;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 2c1b1da1220e..1e57cc8c47d7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -240,7 +240,7 @@ static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
 		 (unsigned long int)vsi->net_stats_offsets.rx_compressed,
 		 (unsigned long int)vsi->net_stats_offsets.tx_compressed);
 	dev_info(&pf->pdev->dev,
-		 "    tx_restart = %d, tx_busy = %d, rx_buf_failed = %d, rx_page_failed = %d\n",
+		 "    tx_restart = %llu, tx_busy = %llu, rx_buf_failed = %llu, rx_page_failed = %llu\n",
 		 vsi->tx_restart, vsi->tx_busy,
 		 vsi->rx_buf_failed, vsi->rx_page_failed);
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9b65cb50282c..f70c478dafdb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -778,9 +778,9 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	struct rtnl_link_stats64 *ns;   /* netdev stats */
 	struct i40e_eth_stats *oes;
 	struct i40e_eth_stats *es;     /* device's eth stats */
-	u32 tx_restart, tx_busy;
+	u64 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u32 rx_page, rx_buf;
+	u64 rx_page, rx_buf;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;

