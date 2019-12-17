Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627CE1236CA
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfLQULh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:11:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728771AbfLQULe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:11:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B57E21775;
        Tue, 17 Dec 2019 20:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613493;
        bh=CX09ACSy+ujDPWvoi8qHy2pMKluoG/nigOQ/yiAg414=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dV9R0RUO91n479ZgoE7TuRy0gzzRWxxkBw5qa699IOR9Cg7T7iGus84Dzp+693JU9
         z95ihxDf5MisUKbHWJJQCzuARAgbkAdUvY2NsLz2gz6pgReRUUPVflBdeMwakvgN59
         74fGMhyBame6mmsmHhrJVIaAclKTMfLLTDXi6ftM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mian Yousaf Kaukab <ykaukab@suse.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 09/37] net: thunderx: start phy before starting autonegotiation
Date:   Tue, 17 Dec 2019 21:09:30 +0100
Message-Id: <20191217200724.671079168@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

[ Upstream commit a350d2e7adbb57181d33e3aa6f0565632747feaa ]

Since commit 2b3e88ea6528 ("net: phy: improve phy state checking")
phy_start_aneg() expects phy state to be >= PHY_UP. Call phy_start()
before calling phy_start_aneg() during probe so that autonegotiation
is initiated.

As phy_start() takes care of calling phy_start_aneg(), drop the explicit
call to phy_start_aneg().

Network fails without this patch on Octeon TX.

Fixes: 2b3e88ea6528 ("net: phy: improve phy state checking")
Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1115,7 +1115,7 @@ static int bgx_lmac_enable(struct bgx *b
 				       phy_interface_mode(lmac->lmac_type)))
 			return -ENODEV;
 
-		phy_start_aneg(lmac->phydev);
+		phy_start(lmac->phydev);
 		return 0;
 	}
 


