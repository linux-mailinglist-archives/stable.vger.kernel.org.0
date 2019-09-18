Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C630CB5C1C
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfIRGWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfIRGWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:22:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77E8120678;
        Wed, 18 Sep 2019 06:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787771;
        bh=6i7efIOM550mZw18GJ5GyN2fkPsj4EWhQYI8fpBo4g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2dBWkpGskHX0+nXFhUp7GLDTxJlYgSnyRMWcCt2WMRgGJCgNwkRygNCsr01hO3OCq
         z7YX7dp6F+HupDMNonXJRcuvKMc76aM0+KwV+jj+8IKWFAtjd7evKBUQtOtNAsSzHa
         XVO25TW4S8ePasQ5xyTTSiU7z6FN2bMJvnui/MgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Marley <michael@michaelmarley.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 05/50] ixgbe: Fix secpath usage for IPsec TX offload.
Date:   Wed, 18 Sep 2019 08:18:48 +0200
Message-Id: <20190918061223.591034226@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
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
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -34,6 +34,7 @@
 #include <net/tc_act/tc_mirred.h>
 #include <net/vxlan.h>
 #include <net/mpls.h>
+#include <net/xfrm.h>
 
 #include "ixgbe.h"
 #include "ixgbe_common.h"
@@ -8599,7 +8600,8 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct
 #endif /* IXGBE_FCOE */
 
 #ifdef CONFIG_XFRM_OFFLOAD
-	if (skb->sp && !ixgbe_ipsec_tx(tx_ring, first, &ipsec_tx))
+	if (xfrm_offload(skb) &&
+	    !ixgbe_ipsec_tx(tx_ring, first, &ipsec_tx))
 		goto out_drop;
 #endif
 	tso = ixgbe_tso(tx_ring, first, &hdr_len, &ipsec_tx);


