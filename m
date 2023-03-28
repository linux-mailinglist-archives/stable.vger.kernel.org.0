Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C946CC3E6
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjC1O6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbjC1O6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:58:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F3FE053
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79080B81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF062C433EF;
        Tue, 28 Mar 2023 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015486;
        bh=vNroh2QMGhc7OWr35QoLlknnbeLPoR+fwLeH48ibTO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfo9JpGdVm/L6ZBJovjt+jHujdHqsxeeoUwBDmWx4t7wKrlUFBCxXP9KHiawrcsVU
         ZOAP0anY528XLOjAb2MjLv8ajG+lqArVEyO+FSkvXZwAOKinAvKGVezZAboaXEcuAo
         mdMjpHet7EasLb4qAIheR0ZL7B67P4imZK0Oerlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huy Nguyen <huyn@mellanox.com>,
        Lama Kayal <lkayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/224] net/mlx5: Fix steering rules cleanup
Date:   Tue, 28 Mar 2023 16:41:02 +0200
Message-Id: <20230328142620.094929803@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
index 43ba00d5e36ec..4b9d567c8f473 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -916,6 +916,7 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
+	esw_apply_vport_rx_mode(esw, vport, false, false);
 	esw_vport_cleanup(esw, vport);
 	esw->enabled_vports--;
 
-- 
2.39.2



