Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB51CAF45
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgEHMo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729238AbgEHMoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A994208D6;
        Fri,  8 May 2020 12:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941895;
        bh=f9NddlUwWuf1KV2f/5zdXpJJEbo0ZdiNinJOTGjkalA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhEwnO9ZdA0oCUf+iX8Q/WK+iWcIBRpxdIsvCPSyGY9KMjdRu/HsOOs/Dr9TLMlhM
         0+x/VrGAdrvw7dMgPiAKZ4NRA/bnLbPDKYRfyAy/kI4mBTSYld3QOnOcjk1mI/89+X
         KpJObSyguGdHHLjc/LFtA+jjMWbzSM0zsTeOYVKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 215/312] net/mlx4_core: Check device state before unregistering it
Date:   Fri,  8 May 2020 14:33:26 +0200
Message-Id: <20200508123139.555770536@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

commit 9b022a6e0f26af108b9105b16b310393c898d9bd upstream.

Verify that the device state is registered before un-registering it.
This check is required to prevent an OOPS on flows that do
re-registration of the device and its previous state was
unregistered.

Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/intf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ -217,6 +217,9 @@ void mlx4_unregister_device(struct mlx4_
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_interface *intf;
 
+	if (!(dev->persist->interface_state & MLX4_INTERFACE_STATE_UP))
+		return;
+
 	mlx4_stop_catas_poll(dev);
 	if (dev->persist->interface_state & MLX4_INTERFACE_STATE_DELETION &&
 	    mlx4_is_slave(dev)) {


