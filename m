Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F047218B40D
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbgCSNGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbgCSNGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:06:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1350620757;
        Thu, 19 Mar 2020 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623179;
        bh=tSGx6QS93TLBr3DbDH8503ElFe7+phZmfxR5mRRQpPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muywRrgMVC+uZBfhGt19IoEgwO0IDwNx35k44ukj0uOO7QFrNIln3vUowzzl+3T29
         zsm931jvH17iaUAoWcAemC6o4AeIdr6bwpo3Le5ZoaGF889nuBUkxdBLmZUFZhgPA3
         Atrlcj1Um+J4cmY6j6pEjJs23cWy0tAAI85BfaT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 18/93] net: fec: validate the new settings in fec_enet_set_coalesce()
Date:   Thu, 19 Mar 2020 13:59:22 +0100
Message-Id: <20200319123930.998552506@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ab14961d10d02d20767612c78ce148f6eb85bd58 ]

fec_enet_set_coalesce() validates the previously set params
and if they are within range proceeds to apply the new ones.
The new ones, however, are not validated. This seems backwards,
probably a copy-paste error?

Compile tested only.

Fixes: d851b47b22fc ("net: fec: add interrupt coalescence feature support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2510,15 +2510,15 @@ fec_enet_set_coalesce(struct net_device
 		return -EINVAL;
 	}
 
-	cycle = fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr);
+	cycle = fec_enet_us_to_itr_clock(ndev, ec->rx_coalesce_usecs);
 	if (cycle > 0xFFFF) {
 		pr_err("Rx coalesed usec exceeed hardware limiation");
 		return -EINVAL;
 	}
 
-	cycle = fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr);
+	cycle = fec_enet_us_to_itr_clock(ndev, ec->tx_coalesce_usecs);
 	if (cycle > 0xFFFF) {
-		pr_err("Rx coalesed usec exceeed hardware limiation");
+		pr_err("Tx coalesed usec exceeed hardware limiation");
 		return -EINVAL;
 	}
 


