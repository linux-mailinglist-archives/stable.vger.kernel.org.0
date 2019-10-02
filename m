Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20D4C91B7
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbfJBTLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:11:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35764 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729294AbfJBTIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:15 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyu-00035v-Ea; Wed, 02 Oct 2019 20:08:12 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyq-0003gN-BF; Wed, 02 Oct 2019 20:08:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "YueHaibing" <yuehaibing@huawei.com>,
        "Jay Vosburgh" <jay.vosburgh@canonical.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.282268254@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 81/87] bonding: Add vlan tx offload to hw_enc_features
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

commit d595b03de2cb0bdf9bcdf35ff27840cc3a37158f upstream.

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1083,7 +1083,9 @@ static void bond_compute_features(struct
 
 done:
 	bond_dev->vlan_features = vlan_features;
-	bond_dev->hw_enc_features = enc_features;
+	bond_dev->hw_enc_features = enc_features |
+				    NETIF_F_HW_VLAN_CTAG_TX |
+				    NETIF_F_HW_VLAN_STAG_TX;
 	bond_dev->hard_header_len = max_hard_header_len;
 	bond_dev->gso_max_segs = gso_max_segs;
 	netif_set_gso_max_size(bond_dev, gso_max_size);

