Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AB229B348
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766284AbgJ0Or6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766249AbgJ0Ort (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:47:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A48A720709;
        Tue, 27 Oct 2020 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810068;
        bh=e/kq4bTTRlN/Yp+C428WMYYC2faor9rrUGJEjFvhGw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpqB2V3uxM7nmJ12JIBZjcpoWwJvl29R9Q5UqmI5+VxKgkFOxMuwdXNXAqZVv5AxY
         NLKWTThHL3ztTZuqRUTi5aNEkBgelUetvzhmvKED8kX2v05hbrXY1xS7j8R5a+E+dB
         W5yRJZe9i0cF1UFv7WxWnRG2qFXlx9XHF5AHQPpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wilder <dwilder@us.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Cristobal Forno <cris.forno@ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 002/633] ibmveth: Switch order of ibmveth_helper calls.
Date:   Tue, 27 Oct 2020 14:45:45 +0100
Message-Id: <20201027135522.778009274@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
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


