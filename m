Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57C54A40B6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358335AbiAaK7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:59:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60252 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348448AbiAaK7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:59:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC97360B03;
        Mon, 31 Jan 2022 10:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9464C340E8;
        Mon, 31 Jan 2022 10:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626753;
        bh=S6vdptvFv56Eyz0nhwFQ/zLSBlr6zeYcd/EY1HFYt0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+m7CNlt+Mp+V/g/gDBbi0fqfHRmbgEaAH9a3fB7pinJbFWbaqmvbrC3gKYQN0DUx
         5nIZewzIvvlG1S99PcqrRECSJa8tbjPcznk76KnUJVJ08TLaZq2kv7mURykIQMlG8h
         00rEqQawkvUALn3FQuSXlDghXg/1w5Ud+yTqFWE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Damato <jdamato@fastly.com>,
        kernel test robot <lkp@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 28/64] i40e: fix unsigned stat widths
Date:   Mon, 31 Jan 2022 11:56:13 +0100
Message-Id: <20220131105216.623202023@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Damato <jdamato@fastly.com>

commit 3b8428b84539c78fdc8006c17ebd25afd4722d51 upstream.

Change i40e_update_vsi_stats and struct i40e_vsi to use u64 fields to match
the width of the stats counters in struct i40e_rx_queue_stats.

Update debugfs code to use the correct format specifier for u64.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Joe Damato <jdamato@fastly.com>
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h         |    8 ++++----
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c    |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -756,12 +756,12 @@ struct i40e_vsi {
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
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -234,7 +234,7 @@ static void i40e_dbg_dump_vsi_seid(struc
 		 (unsigned long int)vsi->net_stats_offsets.rx_compressed,
 		 (unsigned long int)vsi->net_stats_offsets.tx_compressed);
 	dev_info(&pf->pdev->dev,
-		 "    tx_restart = %d, tx_busy = %d, rx_buf_failed = %d, rx_page_failed = %d\n",
+		 "    tx_restart = %llu, tx_busy = %llu, rx_buf_failed = %llu, rx_page_failed = %llu\n",
 		 vsi->tx_restart, vsi->tx_busy,
 		 vsi->rx_buf_failed, vsi->rx_page_failed);
 	rcu_read_lock();
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -804,9 +804,9 @@ static void i40e_update_vsi_stats(struct
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


