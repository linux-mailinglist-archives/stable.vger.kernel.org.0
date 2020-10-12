Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BC828B887
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbgJLNxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731545AbgJLNrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:47:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6732521BE5;
        Mon, 12 Oct 2020 13:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510396;
        bh=tLPhuI9Wok5mWi/FhO8nCAIuI91Q9PkZIJNv7eWFK1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzI1s+GWTC13HHlW01P5ruZQCqeXdVwXsHjgKVcTH7ineybYAaKonR8YzUlyfq4hx
         wZb0wjZZC97S6vE9xkEkyls2BHO9IUAiCI5O1fA4cDJyEsFDd3ThRW/q9nGCyNC3Qv
         rTmxZycdBCpTI2IGj+L4xVB9yhpdPurium5AyBDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 080/124] octeontx2-pf: Fix TCP/UDP checksum offload for IPv6 frames
Date:   Mon, 12 Oct 2020 15:31:24 +0200
Message-Id: <20201012133150.732059486@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 89eae5e87b4fa799726a3e8911c90d418cb5d2b1 ]

For TCP/UDP checksum offload feature in Octeontx2
expects L3TYPE to be set irrespective of IP header
checksum is being offloaded or not. Currently for
IPv6 frames L3TYPE is not being set resulting in
packet drop with checksum error. This patch fixes
this issue.

Fixes: 3ca6c4c88 ("octeontx2-pf: Add packet transmission support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index b04f5429d72d9..334eab976ee4a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -524,6 +524,7 @@ static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 			sqe_hdr->ol3type = NIX_SENDL3TYPE_IP4_CKSUM;
 		} else if (skb->protocol == htons(ETH_P_IPV6)) {
 			proto = ipv6_hdr(skb)->nexthdr;
+			sqe_hdr->ol3type = NIX_SENDL3TYPE_IP6;
 		}
 
 		if (proto == IPPROTO_TCP)
-- 
2.25.1



