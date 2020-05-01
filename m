Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF99F1C13A6
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgEANbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730159AbgEANbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:31:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C432166E;
        Fri,  1 May 2020 13:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339903;
        bh=4nCNXyD6obRTeY32cehx4jMoRbm/cRm7MqVJD+jLOSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDct6ryfM/Et1wBRX+uk7jDvnnT35yWk7Ed2FYMUUV7ubi8cqJhdeVNOZOu33k/2A
         zk6ursb6WXKVuuWAi6RkkmLenciG2JScgxbwXhkvG8zxj56S5qN7Gk2MysjEnLrtap
         /HmZOxaOn21hAxDi7MEN/GEwB6CoVKeawfGNWrw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 026/117] macsec: avoid to set wrong mtu
Date:   Fri,  1 May 2020 15:21:02 +0200
Message-Id: <20200501131548.038530034@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 7f327080364abccf923fa5a5b24e038eb0ba1407 ]

When a macsec interface is created, the mtu is calculated with the lower
interface's mtu value.
If the mtu of lower interface is lower than the length, which is needed
by macsec interface, macsec's mtu value will be overflowed.
So, if the lower interface's mtu is too low, macsec interface's mtu
should be set to 0.

Test commands:
    ip link add dummy0 mtu 10 type dummy
    ip link add macsec0 link dummy0 type macsec
    ip link show macsec0

Before:
    11: macsec0@dummy0: <BROADCAST,MULTICAST,M-DOWN> mtu 4294967274
After:
    11: macsec0@dummy0: <BROADCAST,MULTICAST,M-DOWN> mtu 0

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3209,11 +3209,11 @@ static int macsec_newlink(struct net *ne
 			  struct netlink_ext_ack *extack)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
+	rx_handler_func_t *rx_handler;
+	u8 icv_len = DEFAULT_ICV_LEN;
 	struct net_device *real_dev;
-	int err;
+	int err, mtu;
 	sci_t sci;
-	u8 icv_len = DEFAULT_ICV_LEN;
-	rx_handler_func_t *rx_handler;
 
 	if (!tb[IFLA_LINK])
 		return -EINVAL;
@@ -3229,7 +3229,11 @@ static int macsec_newlink(struct net *ne
 
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
-	dev->mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
+	mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
+	if (mtu < 0)
+		dev->mtu = 0;
+	else
+		dev->mtu = mtu;
 
 	rx_handler = rtnl_dereference(real_dev->rx_handler);
 	if (rx_handler && rx_handler != macsec_handle_frame)


