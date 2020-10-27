Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD5429B17D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760001AbgJ0Oau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759287AbgJ0O2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:28:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30CE120754;
        Tue, 27 Oct 2020 14:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808928;
        bh=f3oZ6lt1048Bbse2Sgh8W9XGTvPRDZB4uRcJs7R8j4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DE0e83iJog+EhGbKeL0tTiN0XXV8Adhjw7aziZiCPbKzZs6OawUi4B4mezEn5RcOe
         9U3LfAnQza3BXN7u5SoRJJfLILvffNqEG9jvKMMHNUJUKdnsY/axD/sNm8VHSg0QKV
         vOvOjiaDXQ2IR+uGoVefPVTkd3eqnZCUMcRH+ATo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wilder <dwilder@us.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Cristobal Forno <cris.forno@ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 002/408] ibmveth: Identify ingress large send packets.
Date:   Tue, 27 Oct 2020 14:49:00 +0100
Message-Id: <20201027135455.154994986@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
@@ -1317,6 +1317,7 @@ static int ibmveth_poll(struct napi_stru
 			int offset = ibmveth_rxq_frame_offset(adapter);
 			int csum_good = ibmveth_rxq_csum_good(adapter);
 			int lrg_pkt = ibmveth_rxq_large_packet(adapter);
+			__sum16 iph_check = 0;
 
 			skb = ibmveth_rxq_get_buffer(adapter);
 
@@ -1353,7 +1354,17 @@ static int ibmveth_poll(struct napi_stru
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


