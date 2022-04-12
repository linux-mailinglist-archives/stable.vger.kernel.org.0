Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A584FD429
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352087AbiDLHXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353119AbiDLHOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:14:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2309377FF;
        Mon, 11 Apr 2022 23:56:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C5F7B81B35;
        Tue, 12 Apr 2022 06:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DDEC385A6;
        Tue, 12 Apr 2022 06:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746587;
        bh=eM1K8P5zqIAJD0+Seq9LKWKSArSlKpfYialiGujAYB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yW96Cx/PmWGhJzvKrhVMt6Jt/KKGyRWVe6LRlpd2E06lEYAaaE/m64u6ytyIHHzM4
         9irA/A92/bX0ZsuwXJmAYHEXMWrKlqvCHaQqUe5tHVXx16aTMvKr3UDpXGX73vTq3x
         2IsrWL60ZD3Vc9TzPmRtLAo8Q7KnglYjei1iIxiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 058/285] net/mlx5e: Disable TX queues before registering the netdev
Date:   Tue, 12 Apr 2022 08:28:35 +0200
Message-Id: <20220412062945.344893622@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit d08c6e2a4d0308a7922d7ef3b1b3af45d4096aad ]

Normally, the queues are disabled when the channels are deactivated, and
enabled when the channels are activated. However, on register, the
channels are not active, but the queues are enabled by default. This
change fixes it, preventing mlx5e_xmit from running when the channels
are deactivated in the beginning.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 22de7327c5a8..4730d6c14aeb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5223,6 +5223,7 @@ mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *prof
 	}
 
 	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
 	dev_net_set(netdev, mlx5_core_net(mdev));
 
 	return netdev;
-- 
2.35.1



