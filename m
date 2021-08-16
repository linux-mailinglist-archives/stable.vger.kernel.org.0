Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3E3ED652
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhHPNU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239725AbhHPNQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6F62632BF;
        Mon, 16 Aug 2021 13:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119581;
        bh=EtGOxfWR9WDS1nktOBui5hOvwsID7jjx4ySm703hkJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v51x2a/ZEhrBWsVBSSCQhuk+d9YQ760w0KcdVdBytdMSLK7hjpmnLblmqKo1DI0e+
         9pU31NQwqDUiXI8r+xmi8u5JPhddtRtdSoYZKCyKKCd3f1QdUDEf7B9l4yutKzMXWL
         o3FGBxE+G9YYEncO/Xm4OzfUOChNsW2jPRjo7Wt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Vesker <valex@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 081/151] net/mlx5: DR, Add fail on error check on decap
Date:   Mon, 16 Aug 2021 15:01:51 +0200
Message-Id: <20210816125446.749007639@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Vesker <valex@nvidia.com>

[ Upstream commit d3875924dae632d5edd908d285fffc5f07c835a3 ]

While processing encapsulated packet on RX, one of the fields that is
checked is the inner packet length. If the length as specified in the header
doesn't match the actual inner packet length, the packet is invalid
and should be dropped. However, such packet caused the NIC to hang.

This patch turns on a 'fail_on_error' HW bit which allows HW to drop
such an invalid packet while processing RX packet and trying to decap it.

Fixes: ad17dc8cf910 ("net/mlx5: DR, Move STEv0 action apply logic")
Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 0757a4e8540e..42446e92aa38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -352,6 +352,7 @@ static void dr_ste_v0_set_rx_decap(u8 *hw_ste_p)
 {
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
 		 DR_STE_TUNL_ACTION_DECAP);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, fail_on_error, 1);
 }
 
 static void dr_ste_v0_set_rx_pop_vlan(u8 *hw_ste_p)
@@ -365,6 +366,7 @@ static void dr_ste_v0_set_rx_decap_l3(u8 *hw_ste_p, bool vlan)
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
 		 DR_STE_TUNL_ACTION_L3_DECAP);
 	MLX5_SET(ste_modify_packet, hw_ste_p, action_description, vlan ? 1 : 0);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, fail_on_error, 1);
 }
 
 static void dr_ste_v0_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
-- 
2.30.2



