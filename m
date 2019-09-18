Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0C6B5CE3
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbfIRG3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbfIRGZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A68B21906;
        Wed, 18 Sep 2019 06:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787940;
        bh=JFk5Jv4dKcXIkrB4AdcywhjcbvMFMjIgV59Vz693O0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYgRxwhwg7PUGcDe+awqw+npdhnqEimfBi5JKaGau3vYbNYr/NrSVI4aCE6Alpl9K
         8Kgjwa8WfXLWFDVm5l8O2eI/dr+zfl7QqmM3ucqWVgmoPM7Mn46FOEggqjGsmBOb30
         XBB/LjkLdBreNme4N6SvQMsCxQ8NGeYWXTgNdRAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Marley <michael@michaelmarley.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 05/85] ixgbe: Fix secpath usage for IPsec TX offload.
Date:   Wed, 18 Sep 2019 08:18:23 +0200
Message-Id: <20190918061234.300610892@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit f39b683d35dfa93a58f1b400a8ec0ff81296b37c ]

The ixgbe driver currently does IPsec TX offloading
based on an existing secpath. However, the secpath
can also come from the RX side, in this case it is
misinterpreted for TX offload and the packets are
dropped with a "bad sa_idx" error. Fix this by using
the xfrm_offload() function to test for TX offload.

Fixes: 592594704761 ("ixgbe: process the Tx ipsec offload")
Reported-by: Michael Marley <michael@michaelmarley.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -36,6 +36,7 @@
 #include <net/vxlan.h>
 #include <net/mpls.h>
 #include <net/xdp_sock.h>
+#include <net/xfrm.h>
 
 #include "ixgbe.h"
 #include "ixgbe_common.h"
@@ -8691,7 +8692,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct
 #endif /* IXGBE_FCOE */
 
 #ifdef CONFIG_IXGBE_IPSEC
-	if (secpath_exists(skb) &&
+	if (xfrm_offload(skb) &&
 	    !ixgbe_ipsec_tx(tx_ring, first, &ipsec_tx))
 		goto out_drop;
 #endif


