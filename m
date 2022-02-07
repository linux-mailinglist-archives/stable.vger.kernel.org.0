Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8534ABA96
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383920AbiBGLYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355609AbiBGLMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:12:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E48C043181;
        Mon,  7 Feb 2022 03:12:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 737C16113B;
        Mon,  7 Feb 2022 11:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CDDC004E1;
        Mon,  7 Feb 2022 11:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232358;
        bh=21GWfXvoGM3JfY9PBYB8efgCAL2zUuXUMcw97qztprY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/Rv1sAF21vYsXTfvhjkCx8HThFmug5ZWCLlkwKZxliaG5Vt4Qe8rB4g2vaE+B4qc
         o7FTDbWfYygIIhDb0DsFPFYvfTSvXLIoSCTOEVZQ/qa80dsAr8rJaVpwI+Ysdric2e
         1l+oU6rIYcB0509TgVL0pK4AkYZnuQTF6sQitOQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Damato <jdamato@fastly.com>,
        kernel test robot <lkp@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 4.14 20/69] i40e: fix unsigned stat widths
Date:   Mon,  7 Feb 2022 12:05:42 +0100
Message-Id: <20220207103756.279586065@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -627,12 +627,12 @@ struct i40e_vsi {
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
@@ -259,7 +259,7 @@ static void i40e_dbg_dump_vsi_seid(struc
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
@@ -778,9 +778,9 @@ static void i40e_update_vsi_stats(struct
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


