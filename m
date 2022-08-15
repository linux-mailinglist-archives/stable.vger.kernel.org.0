Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68EC59482B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355473AbiHOX4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354619AbiHOXs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:48:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCB0157E6B;
        Mon, 15 Aug 2022 13:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140A460F70;
        Mon, 15 Aug 2022 20:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F25C433C1;
        Mon, 15 Aug 2022 20:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594542;
        bh=5D8R5ND/ejMtZ3MKYGCmT1b4bpEsntPeqRPpwjWiHjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wX+8+538idH80y48D09BunC3xf3yDZ4CQwNALQRcHUGNrP4LxEy/Tj7FG/KaZTw3r
         yxjtaTLLLRRWmxL9Q9ABWLiBkPE0X/eyGdeDQnXME/TbKatnuE/a5wFCLcoGYFhq6A
         YRvxMoE3ZVnRdbLMEbVah67jpRw7whXoykQIlAsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiao Ma <mqaio@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0446/1157] net: hinic: avoid kernel hung in hinic_get_stats64()
Date:   Mon, 15 Aug 2022 19:56:42 +0200
Message-Id: <20220815180457.441119576@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Qiao Ma <mqaio@linux.alibaba.com>

[ Upstream commit 98f9fcdee35add80505b6c73f72de5f750d5c03c ]

When using hinic device as a bond slave device, and reading device stats
of master bond device, the kernel may hung.

The kernel panic calltrace as follows:
Kernel panic - not syncing: softlockup: hung tasks
Call trace:
  native_queued_spin_lock_slowpath+0x1ec/0x31c
  dev_get_stats+0x60/0xcc
  dev_seq_printf_stats+0x40/0x120
  dev_seq_show+0x1c/0x40
  seq_read_iter+0x3c8/0x4dc
  seq_read+0xe0/0x130
  proc_reg_read+0xa8/0xe0
  vfs_read+0xb0/0x1d4
  ksys_read+0x70/0xfc
  __arm64_sys_read+0x20/0x30
  el0_svc_common+0x88/0x234
  do_el0_svc+0x2c/0x90
  el0_svc+0x1c/0x30
  el0_sync_handler+0xa8/0xb0
  el0_sync+0x148/0x180

And the calltrace of task that actually caused kernel hungs as follows:
  __switch_to+124
  __schedule+548
  schedule+72
  schedule_timeout+348
  __down_common+188
  __down+24
  down+104
  hinic_get_stats64+44 [hinic]
  dev_get_stats+92
  bond_get_stats+172 [bonding]
  dev_get_stats+92
  dev_seq_printf_stats+60
  dev_seq_show+24
  seq_read_iter+964
  seq_read+220
  proc_reg_read+164
  vfs_read+172
  ksys_read+108
  __arm64_sys_read+28
  el0_svc_common+132
  do_el0_svc+40
  el0_svc+24
  el0_sync_handler+164
  el0_sync+324

When getting device stats from bond, kernel will call bond_get_stats().
It first holds the spinlock bond->stats_lock, and then call
hinic_get_stats64() to collect hinic device's stats.
However, hinic_get_stats64() calls `down(&nic_dev->mgmt_lock)` to
protect its critical section, which may schedule current task out.
And if system is under high pressure, the task cannot be woken up
immediately, which eventually triggers kernel hung panic.

Since previous patch has replaced hinic_dev.tx_stats/rx_stats with local
variable in hinic_get_stats64(), there is nothing need to be protected
by lock, so just removing down()/up() is ok.

Fixes: edd384f682cc ("net-next/hinic: Add ethtool and stats")
Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 89dc52510fdc..c23ee2ddbce3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -842,13 +842,9 @@ static void hinic_get_stats64(struct net_device *netdev,
 	struct hinic_rxq_stats nic_rx_stats = {};
 	struct hinic_txq_stats nic_tx_stats = {};
 
-	down(&nic_dev->mgmt_lock);
-
 	if (nic_dev->flags & HINIC_INTF_UP)
 		gather_nic_stats(nic_dev, &nic_rx_stats, &nic_tx_stats);
 
-	up(&nic_dev->mgmt_lock);
-
 	stats->rx_bytes   = nic_rx_stats.bytes;
 	stats->rx_packets = nic_rx_stats.pkts;
 	stats->rx_errors  = nic_rx_stats.errors;
-- 
2.35.1



