Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C44664935
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbjAJSTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbjAJSSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:18:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A497B559C1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:16:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5979AB8189A
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A007CC433EF;
        Tue, 10 Jan 2023 18:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374599;
        bh=NLDaGtG/aGC806gBRUr5J9DkRwkEETYuF4Z0jBKtvJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwmgqCuodRqMfNRsgWYbb7KHfENEFe+OEQkPB0wvJYCwsUG5ig/pe7fVg+2Ox3nY+
         zALG40DMmOyMdzv/zJI+0yKH/6qW/527VxrlqzPSMti3LJ6surQm3xZ0qJqf9to0yH
         Y0amts+gfWqIdMe0Jpgv9Q82PnQ8ZK43g7ReVvA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/159] vdpa/mlx5: Fix rule forwarding VLAN to TIR
Date:   Tue, 10 Jan 2023 19:03:08 +0100
Message-Id: <20230110180019.590326141@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit a6ce72c0fb6041f9871f880b2d02b294f7f49cb4 ]

Set the VLAN id to the header values field instead of overwriting the
headers criteria field.

Before this fix, VLAN filtering would not really work and tagged packets
would be forwarded unfiltered to the TIR.

Fixes: baf2ad3f6a98 ("vdpa/mlx5: Add RX MAC VLAN filter support")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Message-Id: <20221114131759.57883-2-elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 90913365def4..3fb06dcee943 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1468,11 +1468,13 @@ static int mlx5_vdpa_add_mac_vlan_rules(struct mlx5_vdpa_net *ndev, u8 *mac,
 	dmac_v = MLX5_ADDR_OF(fte_match_param, headers_v, outer_headers.dmac_47_16);
 	eth_broadcast_addr(dmac_c);
 	ether_addr_copy(dmac_v, mac);
-	MLX5_SET(fte_match_set_lyr_2_4, headers_c, cvlan_tag, 1);
+	if (ndev->mvdev.actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VLAN)) {
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, cvlan_tag, 1);
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, first_vid);
+	}
 	if (tagged) {
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, cvlan_tag, 1);
-		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, first_vid);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, first_vid, vid);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, first_vid, vid);
 	}
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-- 
2.35.1



