Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DE51B429E
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgDVKAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgDVKAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:00:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49E4520776;
        Wed, 22 Apr 2020 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549616;
        bh=RXGWWDNqVU5w/HtdHRoEklIc5A5zJOR7dLQpA+nJpVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKNyEYwdqj8yyhMZY7VG3qQvmCqdVaNU/Ssj+uk2NmXlG9hbV6NV4hV0ahauYA37z
         j4siQTOi+utCbY7teu4gCWdrg0qvMD+6lvDX64bgNesTnBWe1MWzknw2UAbi9PZkiD
         hp2LhQnye/aSW83fkI8uEsZ1kvpveTLuahy15RzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vineeth Remanan Pillai <vineethp@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 036/100] xen-netfront: Rework the fix for Rx stall during OOM and network stress
Date:   Wed, 22 Apr 2020 11:56:06 +0200
Message-Id: <20200422095029.087288097@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Remanan Pillai <vineethp@amazon.com>

commit 538d92912d3190a1dd809233a0d57277459f37b2 upstream.

The commit 90c311b0eeea ("xen-netfront: Fix Rx stall during network
stress and OOM") caused the refill timer to be triggerred almost on
all invocations of xennet_alloc_rx_buffers for certain workloads.
This reworks the fix by reverting to the old behaviour and taking into
consideration the skb allocation failure. Refill timer is now triggered
on insufficient requests or skb allocation failure.

Signed-off-by: Vineeth Remanan Pillai <vineethp@amazon.com>
Fixes: 90c311b0eeea (xen-netfront: Fix Rx stall during network stress and OOM)
Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netfront.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -283,6 +283,7 @@ static void xennet_alloc_rx_buffers(stru
 {
 	RING_IDX req_prod = queue->rx.req_prod_pvt;
 	int notify;
+	int err = 0;
 
 	if (unlikely(!netif_carrier_ok(queue->info->netdev)))
 		return;
@@ -297,8 +298,10 @@ static void xennet_alloc_rx_buffers(stru
 		struct xen_netif_rx_request *req;
 
 		skb = xennet_alloc_one_rx_buffer(queue);
-		if (!skb)
+		if (!skb) {
+			err = -ENOMEM;
 			break;
+		}
 
 		id = xennet_rxidx(req_prod);
 
@@ -322,8 +325,13 @@ static void xennet_alloc_rx_buffers(stru
 
 	queue->rx.req_prod_pvt = req_prod;
 
-	/* Not enough requests? Try again later. */
-	if (req_prod - queue->rx.sring->req_prod < NET_RX_SLOTS_MIN) {
+	/* Try again later if there are not enough requests or skb allocation
+	 * failed.
+	 * Enough requests is quantified as the sum of newly created slots and
+	 * the unconsumed slots at the backend.
+	 */
+	if (req_prod - queue->rx.rsp_cons < NET_RX_SLOTS_MIN ||
+	    unlikely(err)) {
 		mod_timer(&queue->rx_refill_timer, jiffies + (HZ/10));
 		return;
 	}


