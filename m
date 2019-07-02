Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42885CB2C
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbfGBIKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728780AbfGBIKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:10:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0201D21850;
        Tue,  2 Jul 2019 08:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562055006;
        bh=jBVB3WzKRU53r2hTnkZMtlZ8EDAE5zf3xnFZfNvLmJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqk9+917YB0AWw91xOiPlAGogDlhNy3KHzVwYsr6mFnHso2Ynvr+HKcpizlaJH/c6
         pxIlrFzJ0P837P9nb0U2yVUTD8u+TiOro4ojI+ofFcv3+ueMv1cObHjkm335PxTJaf
         znchOiL6KmOW0/U93/tFUe/EED68e7VAiEwEjRdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 36/43] team: Always enable vlan tx offload
Date:   Tue,  2 Jul 2019 10:02:16 +0200
Message-Id: <20190702080125.785807949@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit ee4297420d56a0033a8593e80b33fcc93fda8509 ]

We should rather have vlan_tci filled all the way down
to the transmitting netdevice and let it do the hw/sw
vlan implementation.

Suggested-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2131,12 +2131,12 @@ static void team_setup(struct net_device
 	dev->features |= NETIF_F_NETNS_LOCAL;
 
 	dev->hw_features = TEAM_VLAN_FEATURES |
-			   NETIF_F_HW_VLAN_CTAG_TX |
 			   NETIF_F_HW_VLAN_CTAG_RX |
 			   NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int team_newlink(struct net *src_net, struct net_device *dev,


