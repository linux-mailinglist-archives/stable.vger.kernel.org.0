Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185B5232D42
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgG3IIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbgG3IIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:08:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E872E2074B;
        Thu, 30 Jul 2020 08:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096517;
        bh=YQdGdyFZCQb1etR9mwK5uyrGf4eoBu/JddeSOQZWijc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVyvIfCpGrpdK4cEh11IJDdbWu8eK1iAmtPud0A0cdQgT8QEGFkKTFvBnWkJ9PaDG
         DuSyxFzWFlXZJ9wzkJOnej+ShByP0wF+G8asAgH/0KQsDNCgg4wHlXQF1mkGNiGl8o
         xePSoUFsjkSb4X00+fKuXgCFOV2DRKX8CdgHph3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 06/61] drivers/net/wan/lapbether: Fixed the value of hard_header_len
Date:   Thu, 30 Jul 2020 10:04:24 +0200
Message-Id: <20200730074421.121452110@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 9dc829a135fb5927f1519de11286e2bbb79f5b66 ]

When this driver transmits data,
  first this driver will remove a pseudo header of 1 byte,
  then the lapb module will prepend the LAPB header of 2 or 3 bytes,
  then this driver will prepend a length field of 2 bytes,
  then the underlying Ethernet device will prepend its own header.

So, the header length required should be:
  -1 + 3 + 2 + "the header length needed by the underlying device".

This patch fixes kernel panic when this driver is used with AF_PACKET
SOCK_DGRAM sockets.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 6676607164d65..f5657783fad4e 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -308,7 +308,6 @@ static void lapbeth_setup(struct net_device *dev)
 	dev->netdev_ops	     = &lapbeth_netdev_ops;
 	dev->destructor	     = free_netdev;
 	dev->type            = ARPHRD_X25;
-	dev->hard_header_len = 3;
 	dev->mtu             = 1000;
 	dev->addr_len        = 0;
 }
@@ -329,6 +328,14 @@ static int lapbeth_new_device(struct net_device *dev)
 	if (!ndev)
 		goto out;
 
+	/* When transmitting data:
+	 * first this driver removes a pseudo header of 1 byte,
+	 * then the lapb module prepends an LAPB header of at most 3 bytes,
+	 * then this driver prepends a length field of 2 bytes,
+	 * then the underlying Ethernet device prepends its own header.
+	 */
+	ndev->hard_header_len = -1 + 3 + 2 + dev->hard_header_len;
+
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;
 
-- 
2.25.1



