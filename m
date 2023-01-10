Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958A8664877
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbjAJSLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239103AbjAJSKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E44B254
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:09:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C57B7B818D0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC28C433EF;
        Tue, 10 Jan 2023 18:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374167;
        bh=2oD/y0D3rpipucRQMgvxc9+/kWgAozyojY34wdQ/9q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEbxm9TZ71r74/lFeRgCpSN7z9EDVnfSCZeP/vIU+Nqma+kHVO9J9ZcKWyU61yw1P
         +sPldRy/g44nj3qLl0pt5lniVx0xu99/gRDBngREoDefCkFTQMg5rUH/gKKvQvIM/I
         XUVdDWnRQCTkliW6hgaknG34tblHr8KqlYyC33f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 040/148] vdpa/mlx5: Fix wrong mac address deletion
Date:   Tue, 10 Jan 2023 19:02:24 +0100
Message-Id: <20230110180018.489279361@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

[ Upstream commit 1ab53760d322c82fb4cb5e81b5817065801e3ec4 ]

Delete the old MAC from the table and not the new one which is not there
yet.

Fixes: baf2ad3f6a98 ("vdpa/mlx5: Add RX MAC VLAN filter support")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Message-Id: <20221114131759.57883-4-elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 3fb06dcee943..444d6572b2d0 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1686,7 +1686,7 @@ static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
 
 		/* Need recreate the flow table entry, so that the packet could forward back
 		 */
-		mac_vlan_del(ndev, ndev->config.mac, 0, false);
+		mac_vlan_del(ndev, mac_back, 0, false);
 
 		if (mac_vlan_add(ndev, ndev->config.mac, 0, false)) {
 			mlx5_vdpa_warn(mvdev, "failed to insert forward rules, try to restore\n");
-- 
2.35.1



