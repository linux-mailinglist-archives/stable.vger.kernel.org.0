Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7291B5CE0
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfIRGZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbfIRGZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7B0721920;
        Wed, 18 Sep 2019 06:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787943;
        bh=PdeyC84fRCyowusQdrGmvsk2ZMVF2PGxVuHZNfjeMaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bxcp2PnYyHp0AoXJIS6fu1ISi3cDDxLa3CrnOgYa+5ebfrf9b2DReblOP+ckdBd1T
         UhItfnBwNI3NETXe2ZvkCfIQ7BklngRHZk3ZgLWfXM7M5ukpwSuSuKEnCeu3E+9NpI
         wBHn0pgqPCWbY1zi22H5OAsdNy0jk7LSM0DeclyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jonathan Tooker <jonathan@reliablehosting.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 06/85] ixgbevf: Fix secpath usage for IPsec Tx offload
Date:   Wed, 18 Sep 2019 08:18:24 +0200
Message-Id: <20190918061234.332540855@linuxfoundation.org>
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

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

[ Upstream commit 8f6617badcc96a582678ea36ea96490c5ff26eb4 ]

Port the same fix for ixgbe to ixgbevf.

The ixgbevf driver currently does IPsec Tx offloading
based on an existing secpath. However, the secpath
can also come from the Rx side, in this case it is
misinterpreted for Tx offload and the packets are
dropped with a "bad sa_idx" error. Fix this by using
the xfrm_offload() function to test for Tx offload.

CC: Shannon Nelson <snelson@pensando.io>
Fixes: 7f68d4306701 ("ixgbevf: enable VF IPsec offload operations")
Reported-by: Jonathan Tooker <jonathan@reliablehosting.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Acked-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -30,6 +30,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/atomic.h>
+#include <net/xfrm.h>
 
 #include "ixgbevf.h"
 
@@ -4158,7 +4159,7 @@ static int ixgbevf_xmit_frame_ring(struc
 	first->protocol = vlan_get_protocol(skb);
 
 #ifdef CONFIG_IXGBEVF_IPSEC
-	if (secpath_exists(skb) && !ixgbevf_ipsec_tx(tx_ring, first, &ipsec_tx))
+	if (xfrm_offload(skb) && !ixgbevf_ipsec_tx(tx_ring, first, &ipsec_tx))
 		goto out_drop;
 #endif
 	tso = ixgbevf_tso(tx_ring, first, &hdr_len, &ipsec_tx);


