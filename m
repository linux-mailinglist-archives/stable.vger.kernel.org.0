Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B7E3288FE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbhCARsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:48:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238405AbhCARmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:42:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 338CE650CA;
        Mon,  1 Mar 2021 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617844;
        bh=b4vDhz2ZtElJJnNA1zdD/kdLdM73YcY5VI3HwbTk7vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQ0kb6OLw58byVB/lIA1tBF6KMD524kDioy/HXQUI6qyDTd9huj5PvsdOhYKMyTFM
         Vcvg20+I/98wI1ma6Xoa1/ZoQTHUQUNtZqC7oPDTEqOmXBdUhIh6V7vEk7ldV/1IEh
         apEUz+azOljALiO7oX+oh39sOCX0OmlR50llC6WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Laba <slawomirx.laba@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 216/340] i40e: Fix flow for IPv6 next header (extension header)
Date:   Mon,  1 Mar 2021 17:12:40 +0100
Message-Id: <20210301161058.934239239@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

[ Upstream commit 92c6058024e87087cf1b99b0389d67c0a886360e ]

When a packet contains an IPv6 header with next header which is
an extension header and not a protocol one, the kernel function
skb_transport_header called with such sk_buff will return a
pointer to the extension header and not to the TCP one.

The above explained call caused a problem with packet processing
for skb with encapsulation for tunnel with I40E_TX_CTX_EXT_IP_IPV6.
The extension header was not skipped at all.

The ipv6_skip_exthdr function does check if next header of the IPV6
header is an extension header and doesn't modify the l4_proto pointer
if it points to a protocol header value so its safe to omit the
comparison of exthdr and l4.hdr pointers. The ipv6_skip_exthdr can
return value -1. This means that the skipping process failed
and there is something wrong with the packet so it will be dropped.

Fixes: a3fd9d8876a5 ("i40e/i40evf: Handle IPv6 extension headers in checksum offload")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f47841f3a69d5..218aada8949d9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3093,13 +3093,16 @@ static int i40e_tx_enable_csum(struct sk_buff *skb, u32 *tx_flags,
 
 			l4_proto = ip.v4->protocol;
 		} else if (*tx_flags & I40E_TX_FLAGS_IPV6) {
+			int ret;
+
 			tunnel |= I40E_TX_CTX_EXT_IP_IPV6;
 
 			exthdr = ip.hdr + sizeof(*ip.v6);
 			l4_proto = ip.v6->nexthdr;
-			if (l4.hdr != exthdr)
-				ipv6_skip_exthdr(skb, exthdr - skb->data,
-						 &l4_proto, &frag_off);
+			ret = ipv6_skip_exthdr(skb, exthdr - skb->data,
+					       &l4_proto, &frag_off);
+			if (ret < 0)
+				return -1;
 		}
 
 		/* define outer transport */
-- 
2.27.0



