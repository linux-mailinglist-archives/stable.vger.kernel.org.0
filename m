Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E038395D08
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhEaNkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhEaNhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE20261404;
        Mon, 31 May 2021 13:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467569;
        bh=sEQ2pVfC/wuxH4D2F2m0gKVgNHnaFOcCaEeW59XqaKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCQWJWbElejaXgmkfWMUvvNyAWEGwz0RE66FbMExQSCcG0ceLrk/QTz0b94lxhKoH
         Dfc6EAtJclaY2RE7LoHaF9fHJLuMBK+wBkhz8laxjYV3kshVek6vc11ME+rax7FetC
         9y8NKBuCDI5ezH0OmocT4JrvcgShmzKDgzeA5yNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 115/116] net: hns3: check the return of skb_checksum_help()
Date:   Mon, 31 May 2021 15:14:51 +0200
Message-Id: <20210531130644.018184394@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

commit 9bb5a495424fd4bfa672eb1f31481248562fa156 upstream.

Currently skb_checksum_help()'s return is ignored, but it may
return error when it fails to allocate memory when linearizing.

So adds checking for the return of skb_checksum_help().

Fixes: 76ad4f0ee747("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Fixes: 3db084d28dc0("net: hns3: Fix for vxlan tx checksum bug")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -702,8 +702,6 @@ static bool hns3_tunnel_csum_bug(struct
 	if (!(!skb->encapsulation && l4.udp->dest == htons(IANA_VXLAN_PORT)))
 		return false;
 
-	skb_checksum_help(skb);
-
 	return true;
 }
 
@@ -764,8 +762,7 @@ static int hns3_set_l3l4_type_csum(struc
 			/* the stack computes the IP header already,
 			 * driver calculate l4 checksum when not TSO.
 			 */
-			skb_checksum_help(skb);
-			return 0;
+			return skb_checksum_help(skb);
 		}
 
 		l3.hdr = skb_inner_network_header(skb);
@@ -796,7 +793,7 @@ static int hns3_set_l3l4_type_csum(struc
 		break;
 	case IPPROTO_UDP:
 		if (hns3_tunnel_csum_bug(skb))
-			break;
+			return skb_checksum_help(skb);
 
 		hnae3_set_bit(*type_cs_vlan_tso, HNS3_TXD_L4CS_B, 1);
 		hnae3_set_field(*type_cs_vlan_tso,
@@ -821,8 +818,7 @@ static int hns3_set_l3l4_type_csum(struc
 		/* the stack computes the IP header already,
 		 * driver calculate l4 checksum when not TSO.
 		 */
-		skb_checksum_help(skb);
-		return 0;
+		return skb_checksum_help(skb);
 	}
 
 	return 0;


