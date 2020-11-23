Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1C22C060D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgKWM1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:27:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730246AbgKWM1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:27:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9122076E;
        Mon, 23 Nov 2020 12:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134420;
        bh=xtQrkguwmuIXbhvImWjql0iMfj5+vxEFxJBOaVxU3Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrN7SvGAzN4+/VL3NN3/L+D5RrdPKwb7ZclbvHHmf18UlhLzyLpgkQCAfI1SAxesS
         76j7P0mw9IQubYqzaWGieWWZbG3R2aaQ4DNJOxgZlfGjMcyOG9T03CF/DQ+Y74mMnb
         uTyV8vu/iWA7ilKuztDrZgN8rSXADUB48SXqIjMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 13/60] net/mlx4_core: Fix init_hca fields offset
Date:   Mon, 23 Nov 2020 13:21:55 +0100
Message-Id: <20201123121805.680574374@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 6d9c8d15af0ef20a66a0b432cac0d08319920602 ]

Slave function read the following capabilities from the wrong offset:
1. log_mc_entry_sz
2. fs_log_entry_sz
3. log_mc_hash_sz

Fix that by adjusting these capabilities offset to match firmware
layout.

Due to the wrong offset read, the following issues might occur:
1+2. Negative value reported at max_mcast_qp_attach.
3. Driver to init FW with multicast hash size of zero.

Fixes: a40ded604365 ("net/mlx4_core: Add masking for a few queries on HCA caps")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20201118081922.553-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c |    6 +++---
 drivers/net/ethernet/mellanox/mlx4/fw.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1854,14 +1854,14 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev,
 #define	 INIT_HCA_LOG_RD_OFFSET		 (INIT_HCA_QPC_OFFSET + 0x77)
 #define INIT_HCA_MCAST_OFFSET		 0x0c0
 #define	 INIT_HCA_MC_BASE_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x00)
-#define	 INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x12)
-#define	 INIT_HCA_LOG_MC_HASH_SZ_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x16)
+#define	 INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x13)
+#define	 INIT_HCA_LOG_MC_HASH_SZ_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x17)
 #define  INIT_HCA_UC_STEERING_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x18)
 #define	 INIT_HCA_LOG_MC_TABLE_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x1b)
 #define  INIT_HCA_DEVICE_MANAGED_FLOW_STEERING_EN	0x6
 #define  INIT_HCA_FS_PARAM_OFFSET         0x1d0
 #define  INIT_HCA_FS_BASE_OFFSET          (INIT_HCA_FS_PARAM_OFFSET + 0x00)
-#define  INIT_HCA_FS_LOG_ENTRY_SZ_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x12)
+#define  INIT_HCA_FS_LOG_ENTRY_SZ_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x13)
 #define  INIT_HCA_FS_A0_OFFSET		  (INIT_HCA_FS_PARAM_OFFSET + 0x18)
 #define  INIT_HCA_FS_LOG_TABLE_SZ_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x1b)
 #define  INIT_HCA_FS_ETH_BITS_OFFSET      (INIT_HCA_FS_PARAM_OFFSET + 0x21)
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -181,8 +181,8 @@ struct mlx4_init_hca_param {
 	u64 cmpt_base;
 	u64 mtt_base;
 	u64 global_caps;
-	u16 log_mc_entry_sz;
-	u16 log_mc_hash_sz;
+	u8 log_mc_entry_sz;
+	u8 log_mc_hash_sz;
 	u16 hca_core_clock; /* Internal Clock Frequency (in MHz) */
 	u8  log_num_qps;
 	u8  log_num_srqs;


