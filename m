Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836EC29B5EF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796392AbgJ0PSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796355AbgJ0PRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:17:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8F9E20657;
        Tue, 27 Oct 2020 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811860;
        bh=e/kq4bTTRlN/Yp+C428WMYYC2faor9rrUGJEjFvhGw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXzAd0cETJxWdUcqs6rQfwSP6WXNsQskUjR207arfeVVVMAvylLbKUmjj+dednn3c
         +PjhSMCaB+Xoyh8Ilfb/wbOS8/uUeV2Yq21ROqTGO1mEeitpJBVMBsBCN1lLSVxaAX
         eEi0yWioPpAqnhhOjdO2tTGIE+XzuCyUjTGqIx6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wilder <dwilder@us.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Cristobal Forno <cris.forno@ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 001/757] ibmveth: Switch order of ibmveth_helper calls.
Date:   Tue, 27 Oct 2020 14:44:11 +0100
Message-Id: <20201027135450.579883578@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Wilder <dwilder@us.ibm.com>

[ Upstream commit 5ce9ad815a296374ca21f43f3b1ab5083d202ee1 ]

ibmveth_rx_csum_helper() must be called after ibmveth_rx_mss_helper()
as ibmveth_rx_csum_helper() may alter ip and tcp checksum values.

Fixes: 66aa0678efc2 ("ibmveth: Support to enable LSO/CSO for Trunk VEA.")
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1385,16 +1385,16 @@ static int ibmveth_poll(struct napi_stru
 			skb_put(skb, length);
 			skb->protocol = eth_type_trans(skb, netdev);
 
-			if (csum_good) {
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
-				ibmveth_rx_csum_helper(skb, adapter);
-			}
-
 			if (length > netdev->mtu + ETH_HLEN) {
 				ibmveth_rx_mss_helper(skb, mss, lrg_pkt);
 				adapter->rx_large_packets++;
 			}
 
+			if (csum_good) {
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				ibmveth_rx_csum_helper(skb, adapter);
+			}
+
 			napi_gro_receive(napi, skb);	/* send it up */
 
 			netdev->stats.rx_packets++;


