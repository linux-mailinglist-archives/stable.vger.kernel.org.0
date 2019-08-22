Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8487D99D01
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391535AbfHVRi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391502AbfHVRYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:21 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 014D72341C;
        Thu, 22 Aug 2019 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494661;
        bh=uO1DtXYY5dFWAVZQ7w613gpheeo7EbjiYk6aLMvzxU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilYsBxeBuAilzNTZfkSrmn7o1K9W8ikYN8jeB90NC3SrzR9uMe5ym4uhycwvE6RbN
         XLha9WqV2v8HEUrJzsgUw8c0rtpvvEoT2TbhfF3ici1WFjraqeLJuHzy94AWl0yVOp
         GXtuCGuu2ZXgLIyTQCh28TDOF7t9c/z9/pePW0Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 103/103] bonding: Add vlan tx offload to hw_enc_features
Date:   Thu, 22 Aug 2019 10:19:31 -0700
Message-Id: <20190822171733.315253131@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit d595b03de2cb0bdf9bcdf35ff27840cc3a37158f ]

As commit 30d8177e8ac7 ("bonding: Always enable vlan tx offload")
said, we should always enable bonding's vlan tx offload, pass the
vlan packets to the slave devices with vlan tci, let them to handle
vlan implementation.

Now if encapsulation protocols like VXLAN is used, skb->encapsulation
may be set, then the packet is passed to vlan device which based on
bonding device. However in netif_skb_features(), the check of
hw_enc_features:

	 if (skb->encapsulation)
                 features &= dev->hw_enc_features;

clears NETIF_F_HW_VLAN_CTAG_TX/NETIF_F_HW_VLAN_STAG_TX. This results
in same issue in commit 30d8177e8ac7 like this:

vlan_dev_hard_start_xmit
  -->dev_queue_xmit
    -->validate_xmit_skb
      -->netif_skb_features //NETIF_F_HW_VLAN_CTAG_TX is cleared
      -->validate_xmit_vlan
        -->__vlan_hwaccel_push_inside //skb->tci is cleared
...
 --> bond_start_xmit
   --> bond_xmit_hash //BOND_XMIT_POLICY_ENCAP34
     --> __skb_flow_dissect // nhoff point to IP header
        -->  case htons(ETH_P_8021Q)
             // skb_vlan_tag_present is false, so
             vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan),
             //vlan point to ip header wrongly

Fixes: b2a103e6d0af ("bonding: convert to ndo_fix_features")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1107,7 +1107,9 @@ static void bond_compute_features(struct
 
 done:
 	bond_dev->vlan_features = vlan_features;
-	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
+	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
+				    NETIF_F_HW_VLAN_CTAG_TX |
+				    NETIF_F_HW_VLAN_STAG_TX;
 	bond_dev->hard_header_len = max_hard_header_len;
 	bond_dev->gso_max_segs = gso_max_segs;
 	netif_set_gso_max_size(bond_dev, gso_max_size);


