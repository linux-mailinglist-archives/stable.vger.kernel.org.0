Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501C517FC53
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgCJNHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730052AbgCJNHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:07:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDA1B246AA;
        Tue, 10 Mar 2020 13:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845660;
        bh=mG6NqNXNbj04E/zezRXFj4wxhEeaoA8AmqYdR2+zFMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a11jNpdN8BJaan8qwAEmso0Uu8TFYx/g/CIi+KrXtr8bw25ufWhx+GAb5pOuINS0Z
         fT11non2rrHu3ZN8mbZuzKcOiYfeP6FMkKWMvYl99P/X1+HE0+/uKoGl68K5083pf6
         +R6J4VkBOWDeeAZljjqmM9FuqHIcwgIuqUg3RgWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Lara Gomez <ezegomez@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 015/126] net: ena: add missing ethtool TX timestamping indication
Date:   Tue, 10 Mar 2020 13:40:36 +0100
Message-Id: <20200310124205.083799370@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit cf6d17fde93bdda23c9b02dd5906a12bf8c55209 ]

Current implementation of the driver calls skb_tx_timestamp()to add a
software tx timestamp to the skb, however the software-transmit capability
is not reported in ethtool -T.

This commit updates the ethtool structure to report the software-transmit
capability in ethtool -T using the standard ethtool_op_get_ts_info().
This function reports all software timestamping capabilities (tx and rx),
as well as setting phc_index = -1. phc_index is the index of the PTP
hardware clock device that will be used for hardware timestamps. Since we
don't have such a device in ENA, using the default -1 value is the correct
setting.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Ezequiel Lara Gomez <ezegomez@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index a2f02c23fe141..c58ad61909519 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -816,6 +816,7 @@ static const struct ethtool_ops ena_ethtool_ops = {
 	.get_channels		= ena_get_channels,
 	.get_tunable		= ena_get_tunable,
 	.set_tunable		= ena_set_tunable,
+	.get_ts_info            = ethtool_op_get_ts_info,
 };
 
 void ena_set_ethtool_ops(struct net_device *netdev)
-- 
2.20.1



