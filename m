Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE3229AF45
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755217AbgJ0OIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755209AbgJ0OIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:08:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20C0E218AC;
        Tue, 27 Oct 2020 14:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807728;
        bh=8U+TANC7bT8j4Xv3yj9o0yRB161qVMo01V9ACXwU/UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqgsNhO9qJIW752iKflt558E9dQ73gDSJB0kIzCEuwjwvVtPTVGyhzE6JNFILpY9M
         5upCe/6NR0wHs8QFxwTbFezjCJE9u1ycnd7X1xEZxFe016B/8tJYSlacGAEf2VzJcW
         TAkLPYp6l4vRURiLT0YIoMGdAd8rDmauY+31Kx+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wilder <dwilder@us.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Cristobal Forno <cris.forno@ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 002/191] ibmveth: Identify ingress large send packets.
Date:   Tue, 27 Oct 2020 14:47:37 +0100
Message-Id: <20201027134909.828139615@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Wilder <dwilder@us.ibm.com>

[ Upstream commit 413f142cc05cb03f2d1ea83388e40c1ddc0d74e9 ]

Ingress large send packets are identified by either:
The IBMVETH_RXQ_LRG_PKT flag in the receive buffer
or with a -1 placed in the ip header checksum.
The method used depends on firmware version. Frame
geometry and sufficient header validation is performed by the
hypervisor eliminating the need for further header checks here.

Fixes: 7b5967389f5a ("ibmveth: set correct gso_size and gso_type")
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1330,6 +1330,7 @@ static int ibmveth_poll(struct napi_stru
 			int offset = ibmveth_rxq_frame_offset(adapter);
 			int csum_good = ibmveth_rxq_csum_good(adapter);
 			int lrg_pkt = ibmveth_rxq_large_packet(adapter);
+			__sum16 iph_check = 0;
 
 			skb = ibmveth_rxq_get_buffer(adapter);
 
@@ -1366,7 +1367,17 @@ static int ibmveth_poll(struct napi_stru
 			skb_put(skb, length);
 			skb->protocol = eth_type_trans(skb, netdev);
 
-			if (length > netdev->mtu + ETH_HLEN) {
+			/* PHYP without PLSO support places a -1 in the ip
+			 * checksum for large send frames.
+			 */
+			if (skb->protocol == cpu_to_be16(ETH_P_IP)) {
+				struct iphdr *iph = (struct iphdr *)skb->data;
+
+				iph_check = iph->check;
+			}
+
+			if ((length > netdev->mtu + ETH_HLEN) ||
+			    lrg_pkt || iph_check == 0xffff) {
 				ibmveth_rx_mss_helper(skb, mss, lrg_pkt);
 				adapter->rx_large_packets++;
 			}


