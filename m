Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE748F7E91
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbfKKSkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:40:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729268AbfKKSkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:40:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B269120659;
        Mon, 11 Nov 2019 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497634;
        bh=wsDtpteRxJ9ePmyiYulL0S7/1MWNO3mYb0vesPf9eFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACmP3TlCdOf4RGFrJZyrURKrDFvTh8hQAO5v+a1Dqc7Ix/Ji8pgRV79XlXDqZJET7
         cHLR2Q0x4c9BqciNOq5HV+4se3ZhCgXmXZz7PrLom9fbxFu92WilagR6t7LSXn4msB
         YfqKGZ7yjYYmXZSoq6U3kq/6mgsn5lFRfRXIvAx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 013/125] net: mscc: ocelot: fix NULL pointer on LAG slave removal
Date:   Mon, 11 Nov 2019 19:27:32 +0100
Message-Id: <20191111181441.401781032@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 3b3eed8eec47259939ee6c3d58aea1c311ddee3b ]

lag_upper_info may be NULL on slave removal.

Fixes: dc96ee3730fc ("net: mscc: ocelot: add bonding support")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1550,7 +1550,8 @@ static int ocelot_netdevice_event(struct
 		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
 		struct netlink_ext_ack *extack;
 
-		if (lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
+		if (lag_upper_info &&
+		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
 			extack = netdev_notifier_info_to_extack(&info->info);
 			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
 


