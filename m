Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE1FF7BFD
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbfKKSl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728363AbfKKSl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:41:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB7B2067B;
        Mon, 11 Nov 2019 18:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497716;
        bh=giBDff9O7kGZpcHJsi8iF1++Tk1Wti0CrGIcIhoN+to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8zYbt5MevbTTtDuCZLcGZKKhz7NRtI7cEofsDsnblnZYagsIiGgranb4dJz9D0w0
         qHXaStGrUGlYbfKtpy9pP4nLUZ60xTyItsGPdEvlSOY/91ncW/CUxiYz89eHVDzw9Q
         zx3P0mrf5giaKtNMzN+MMHDas55WB6y+PGlF+LmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 004/125] net: ethernet: octeon_mgmt: Account for second possible VLAN header
Date:   Mon, 11 Nov 2019 19:27:23 +0100
Message-Id: <20191111181439.829060299@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

[ Upstream commit e4dd5608033efe7b6030cde359bfdbaeb73bc22d ]

Octeon's input ring-buffer entry has 14 bits-wide size field, so to account
for second possible VLAN header max_mtu must be further reduced.

Fixes: 109cc16526c6d ("ethernet/cavium: use core min/max MTU checking")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1495,7 +1495,7 @@ static int octeon_mgmt_probe(struct plat
 	netdev->ethtool_ops = &octeon_mgmt_ethtool_ops;
 
 	netdev->min_mtu = 64 - OCTEON_MGMT_RX_HEADROOM;
-	netdev->max_mtu = 16383 - OCTEON_MGMT_RX_HEADROOM;
+	netdev->max_mtu = 16383 - OCTEON_MGMT_RX_HEADROOM - VLAN_HLEN;
 
 	mac = of_get_mac_address(pdev->dev.of_node);
 


