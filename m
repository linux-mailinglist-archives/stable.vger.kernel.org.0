Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1434120C8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349031AbhITR57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354098AbhITRzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 201AE61C32;
        Mon, 20 Sep 2021 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158053;
        bh=MDXbSHNeFmO2QL8MktIbPU1VVV71M8hRf35mfMnmNXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goPZxWoI3XBCzpAj158mdEDZ0Cn7gwgl0xuJYgOafQldlXkTSQOl5H1QVKcOpR/4W
         BqGrJKQztv4U4G8UwYMNg5b2kNZKdS7Zrqw0NOrs+PBI9i65TGC3n3tsq1HiUwVZa7
         lvcIewvaaMyrP07I/giyN0XLDg1lE47L6dN6gYcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 272/293] net: hns3: pad the short tunnel frame before sending to hardware
Date:   Mon, 20 Sep 2021 18:43:54 +0200
Message-Id: <20210920163942.718769239@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -29,6 +29,8 @@ static const char hns3_driver_string[] =
 static const char hns3_copyright[] = "Copyright (c) 2017 Huawei Corporation.";
 static struct hnae3_client client;
 
+#define HNS3_MIN_TUN_PKT_LEN	65U
+
 /* hns3_pci_tbl - PCI Device ID Table
  *
  * Last entry must be all 0s
@@ -792,8 +794,11 @@ static int hns3_set_l3l4_type_csum(struc
 				HNS3_L4T_TCP);
 		break;
 	case IPPROTO_UDP:
-		if (hns3_tunnel_csum_bug(skb))
-			return skb_checksum_help(skb);
+		if (hns3_tunnel_csum_bug(skb)) {
+			int ret = skb_put_padto(skb, HNS3_MIN_TUN_PKT_LEN);
+
+			return ret ? ret : skb_checksum_help(skb);
+		}
 
 		hnae3_set_bit(*type_cs_vlan_tso, HNS3_TXD_L4CS_B, 1);
 		hnae3_set_field(*type_cs_vlan_tso,


