Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9643341258D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383989AbhITSqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382624AbhITSmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1343360EDF;
        Mon, 20 Sep 2021 17:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159096;
        bh=2ukfzemYUJPIp38Lz1VzoE+4LlfYKGpUjT+Qwg6EOaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1ul84jbXxpsaKdcG1BRmTRNA+fOIIwi51blMAKNc6fhthlTkg8RuRxTkhQGlzx6f
         wWEv2gctSHfg+wjuesFZu8Fx1N0T1v5fSgJlnx0+skbXL7KP8nwafytTglcHQsE4Su
         6zOKER9KhuCualqNCUBypqacHx9y74oji7jayKkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 075/168] net: hns3: pad the short tunnel frame before sending to hardware
Date:   Mon, 20 Sep 2021 18:43:33 +0200
Message-Id: <20210920163924.107492833@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

commit d18e81183b1cb9c309266cbbce9acd3e0c528d04 upstream.

The hardware cannot handle short tunnel frames below 65 bytes,
and will cause vlan tag missing problem. So pads packet size to
65 bytes for tunnel frames to fix this bug.

Fixes: 3db084d28dc0("net: hns3: Fix for vxlan tx checksum bug")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -73,6 +73,7 @@ MODULE_PARM_DESC(tx_sgl, "Minimum number
 #define HNS3_OUTER_VLAN_TAG	2
 
 #define HNS3_MIN_TX_LEN		33U
+#define HNS3_MIN_TUN_PKT_LEN	65U
 
 /* hns3_pci_tbl - PCI Device ID Table
  *
@@ -1425,8 +1426,11 @@ static int hns3_set_l2l3l4(struct sk_buf
 			       l4.tcp->doff);
 		break;
 	case IPPROTO_UDP:
-		if (hns3_tunnel_csum_bug(skb))
-			return skb_checksum_help(skb);
+		if (hns3_tunnel_csum_bug(skb)) {
+			int ret = skb_put_padto(skb, HNS3_MIN_TUN_PKT_LEN);
+
+			return ret ? ret : skb_checksum_help(skb);
+		}
 
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4CS_B, 1);
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4T_S,


