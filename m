Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCC36D47FD
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbjDCOY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbjDCOYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:24:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2920B2C9EC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFEA5B81BEE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0EDC433EF;
        Mon,  3 Apr 2023 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531886;
        bh=pCyrxbageN8xmEccIjdNvrm3nDTosGlupL/fRcIVJUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xl/jZMeHLuvRpys9aM4OAbAn2JPWJS4MwbUBdmWpe5czBMwwWDBMW/GYbwdCIckJJ
         Xk1yPu/yRx0nRRW7QBWSmFkyEkK7kjLiPKATyWanehWW+9XSeXPloZw0hzGkev2zY1
         8GfZ33gLM7En8NYwHnxtIwYO3IKt3EjCN/KQmAAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huy Nguyen <huyn@mellanox.com>,
        Lama Kayal <lkayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/173] net/mlx5: Fix steering rules cleanup
Date:   Mon,  3 Apr 2023 16:07:38 +0200
Message-Id: <20230403140415.803716442@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit 922f56e9a795d6f3dd72d3428ebdd7ee040fa855 ]

vport's mc, uc and multicast rules are not deleted in teardown path when
EEH happens. Since the vport's promisc settings(uc, mc and all) in
firmware are reset after EEH, mlx5 driver will try to delete the above
rules in the initialization path. This cause kernel crash because these
software rules are no longer valid.

Fix by nullifying these rules right after delete to avoid accessing any dangling
pointers.

Call Trace:
__list_del_entry_valid+0xcc/0x100 (unreliable)
tree_put_node+0xf4/0x1b0 [mlx5_core]
tree_remove_node+0x30/0x70 [mlx5_core]
mlx5_del_flow_rules+0x14c/0x1f0 [mlx5_core]
esw_apply_vport_rx_mode+0x10c/0x200 [mlx5_core]
esw_update_vport_rx_mode+0xb4/0x180 [mlx5_core]
esw_vport_change_handle_locked+0x1ec/0x230 [mlx5_core]
esw_enable_vport+0x130/0x260 [mlx5_core]
mlx5_eswitch_enable_sriov+0x2a0/0x2f0 [mlx5_core]
mlx5_device_enable_sriov+0x74/0x440 [mlx5_core]
mlx5_load_one+0x114c/0x1550 [mlx5_core]
mlx5_pci_resume+0x68/0xf0 [mlx5_core]
eeh_report_resume+0x1a4/0x230
eeh_pe_dev_traverse+0x98/0x170
eeh_handle_normal_event+0x3e4/0x640
eeh_handle_event+0x4c/0x370
eeh_event_handler+0x14c/0x210
kthread+0x168/0x1b0
ret_from_kernel_thread+0x5c/0x84

Fixes: a35f71f27a61 ("net/mlx5: E-Switch, Implement promiscuous rx modes vf request handling")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 78cc6f0bbc72b..3ae082c72a2b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1339,6 +1339,7 @@ static void esw_disable_vport(struct mlx5_eswitch *esw, u16 vport_num)
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
+	esw_apply_vport_rx_mode(esw, vport, false, false);
 	esw_vport_cleanup(esw, vport);
 	esw->enabled_vports--;
 
-- 
2.39.2



