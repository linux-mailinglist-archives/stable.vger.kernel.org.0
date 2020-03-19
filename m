Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0618B756
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgCSNPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729402AbgCSNP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:15:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ABAD20787;
        Thu, 19 Mar 2020 13:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623726;
        bh=9xBXI2zA3y1pn93vgSUUtgTS2XXTyTJNZqWiOC1ufwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4xp1pMuF6SO3cl1l7PJ4AdRmAACLLSNZnq1kr3NO7qfCMBrixjZ8ylKo6zuybXgj
         aUvJS8N+q9ItA9kQwtuqK5+rXV5MVuNdvPbEgME6HMejctu5SbHjxWjbboFf5o3xCU
         0Rvb/4o9yTm2JkE4pGCqsZk+5nx+CCLV0Zoyyb04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 31/99] net: fec: validate the new settings in fec_enet_set_coalesce()
Date:   Thu, 19 Mar 2020 14:03:09 +0100
Message-Id: <20200319123951.159284234@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
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
@@ -2478,15 +2478,15 @@ fec_enet_set_coalesce(struct net_device
 		return -EINVAL;
 	}
 
-	cycle = fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr);
+	cycle = fec_enet_us_to_itr_clock(ndev, ec->rx_coalesce_usecs);
 	if (cycle > 0xFFFF) {
 		pr_err("Rx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
-	cycle = fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr);
+	cycle = fec_enet_us_to_itr_clock(ndev, ec->tx_coalesce_usecs);
 	if (cycle > 0xFFFF) {
-		pr_err("Rx coalesced usec exceed hardware limitation\n");
+		pr_err("Tx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 


