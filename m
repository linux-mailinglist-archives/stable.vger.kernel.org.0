Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC35412573
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353802AbhITSpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382848AbhITSmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9354F6333F;
        Mon, 20 Sep 2021 17:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159129;
        bh=i0kSyFcrz71ejy3rw1SVLqgXk9vAxKmQLRiRx8lscrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqYmOJ73tq80Ez5cf2JZazZzThWd1qa9gFZXesWErj2vdzrKAbybLfB8hMLxY49uM
         81V5lem9bkTTtwjjCCkHFmIZRNAwZDUVd9JfQRybNJwRRK5gbJ6tvIcOlbffrGQoLS
         GlvHpaKc0HvQ7n+mQpwoFuDN4SqTlFkhhnpCAZ2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asmaa Mnebhi <asmaa@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 089/168] mlxbf_gige: clear valid_polarity upon open
Date:   Mon, 20 Sep 2021 18:43:47 +0200
Message-Id: <20210920163924.560471903@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit ee8a9600b5391f434905c46bec7f77d34505083e ]

The network interface managed by the mlxbf_gige driver can
get into a problem state where traffic does not flow.
In this state, the interface will be up and enabled, but
will stop processing received packets.  This problem state
will happen if three specific conditions occur:
    1) driver has received more than (N * RxRingSize) packets but
       less than (N+1 * RxRingSize) packets, where N is an odd number
       Note: the command "ethtool -g <interface>" will display the
       current receive ring size, which currently defaults to 128
    2) the driver's interface was disabled via "ifconfig oob_net0 down"
       during the window described in #1.
    3) the driver's interface is re-enabled via "ifconfig oob_net0 up"

This patch ensures that the driver's "valid_polarity" field is
cleared during the open() method so that it always matches the
receive polarity used by hardware.  Without this fix, the driver
needs to be unloaded and reloaded to correct this problem state.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index a0a059e0154f..04c7dc224eff 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -142,6 +142,13 @@ static int mlxbf_gige_open(struct net_device *netdev)
 	err = mlxbf_gige_clean_port(priv);
 	if (err)
 		goto free_irqs;
+
+	/* Clear driver's valid_polarity to match hardware,
+	 * since the above call to clean_port() resets the
+	 * receive polarity used by hardware.
+	 */
+	priv->valid_polarity = 0;
+
 	err = mlxbf_gige_rx_init(priv);
 	if (err)
 		goto free_irqs;
-- 
2.30.2



