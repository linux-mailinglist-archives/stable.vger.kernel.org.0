Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04D66CC4CE
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjC1PIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjC1PIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:08:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FF9EB7A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F9F61861
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2419EC433D2;
        Tue, 28 Mar 2023 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016049;
        bh=Q32/6+TsZJJ3KK0x8gxFd/V0r3DKGMRhewgyufDP76s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxjKpime95txerNvthUHtTDQGqHpxy6UQIWnhZEly3uqi/oryZ/GhgX3mkXtL4wjX
         BQqj2dkb/ev/MHZdYA5JbfU1BHK5yQrjAU7r5fBGnm71jqbY3AduY+TQtcs/ueVY86
         3dhsH/1HmNU6mDWIQ9VuTQgTn6YII50pc6/juYZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huy Nguyen <huyn@mellanox.com>,
        Lama Kayal <lkayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/146] net/mlx5: Fix steering rules cleanup
Date:   Tue, 28 Mar 2023 16:42:16 +0200
Message-Id: <20230328142604.658311025@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index 2b9278002354c..7315bf447e061 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -918,6 +918,7 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
+	esw_apply_vport_rx_mode(esw, vport, false, false);
 	esw_vport_cleanup(esw, vport);
 	esw->enabled_vports--;
 
-- 
2.39.2



