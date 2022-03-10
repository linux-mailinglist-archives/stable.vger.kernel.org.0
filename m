Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE13D4D4B03
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244701AbiCJOdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244123AbiCJO2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:28:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6228BF539;
        Thu, 10 Mar 2022 06:23:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A00BB61B32;
        Thu, 10 Mar 2022 14:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4BDC340E8;
        Thu, 10 Mar 2022 14:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922192;
        bh=B7AC+2jyNOILFU+cFx5Aid/yCzuBCeO7lVTC68n5Ens=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuKX5Rjt3vW8hZfstjMgparX7R+ZRi3MsbHkOnRXCjel047ttjtBoqTgU9k8wt9LN
         yP0OfSfex+H2BkRPuoqJiXN6KJL72iYyccy8aYtaCitQZLzY+xQC3ivWC/ADJluMGX
         4pGF7dbXLCZl2AbfjhEMOh6TnNEZ45V7fd2VcCLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.19 33/33] xen/netfront: react properly to failing gnttab_end_foreign_access_ref()
Date:   Thu, 10 Mar 2022 15:19:00 +0100
Message-Id: <20220310140808.718555574@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
References: <20220310140807.749164737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Commit 66e3531b33ee51dad17c463b4d9c9f52e341503d upstream.

When calling gnttab_end_foreign_access_ref() the returned value must
be tested and the reaction to that value should be appropriate.

In case of failure in xennet_get_responses() the reaction should not be
to crash the system, but to disable the network device.

The calls in setup_netfront() can be replaced by calls of
gnttab_end_foreign_access(). While at it avoid double free of ring
pages and grant references via xennet_disconnect_backend() in this case.

This is CVE-2022-23042 / part of XSA-396.

Reported-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   48 +++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 17 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -862,7 +862,6 @@ static int xennet_get_responses(struct n
 	int max = XEN_NETIF_NR_SLOTS_MIN + (rx->status <= RX_COPY_THRESHOLD);
 	int slots = 1;
 	int err = 0;
-	unsigned long ret;
 
 	if (rx->flags & XEN_NETRXF_extra_info) {
 		err = xennet_get_extras(queue, extras, rp);
@@ -893,8 +892,13 @@ static int xennet_get_responses(struct n
 			goto next;
 		}
 
-		ret = gnttab_end_foreign_access_ref(ref, 0);
-		BUG_ON(!ret);
+		if (!gnttab_end_foreign_access_ref(ref, 0)) {
+			dev_alert(dev,
+				  "Grant still in use by backend domain\n");
+			queue->info->broken = true;
+			dev_alert(dev, "Disabled for further use\n");
+			return -EINVAL;
+		}
 
 		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
 
@@ -1098,6 +1102,10 @@ static int xennet_poll(struct napi_struc
 		err = xennet_get_responses(queue, &rinfo, rp, &tmpq);
 
 		if (unlikely(err)) {
+			if (queue->info->broken) {
+				spin_unlock(&queue->rx_lock);
+				return 0;
+			}
 err:
 			while ((skb = __skb_dequeue(&tmpq)))
 				__skb_queue_tail(&errq, skb);
@@ -1676,7 +1684,7 @@ static int setup_netfront(struct xenbus_
 			struct netfront_queue *queue, unsigned int feature_split_evtchn)
 {
 	struct xen_netif_tx_sring *txs;
-	struct xen_netif_rx_sring *rxs;
+	struct xen_netif_rx_sring *rxs = NULL;
 	grant_ref_t gref;
 	int err;
 
@@ -1696,21 +1704,21 @@ static int setup_netfront(struct xenbus_
 
 	err = xenbus_grant_ring(dev, txs, 1, &gref);
 	if (err < 0)
-		goto grant_tx_ring_fail;
+		goto fail;
 	queue->tx_ring_ref = gref;
 
 	rxs = (struct xen_netif_rx_sring *)get_zeroed_page(GFP_NOIO | __GFP_HIGH);
 	if (!rxs) {
 		err = -ENOMEM;
 		xenbus_dev_fatal(dev, err, "allocating rx ring page");
-		goto alloc_rx_ring_fail;
+		goto fail;
 	}
 	SHARED_RING_INIT(rxs);
 	FRONT_RING_INIT(&queue->rx, rxs, XEN_PAGE_SIZE);
 
 	err = xenbus_grant_ring(dev, rxs, 1, &gref);
 	if (err < 0)
-		goto grant_rx_ring_fail;
+		goto fail;
 	queue->rx_ring_ref = gref;
 
 	if (feature_split_evtchn)
@@ -1723,22 +1731,28 @@ static int setup_netfront(struct xenbus_
 		err = setup_netfront_single(queue);
 
 	if (err)
-		goto alloc_evtchn_fail;
+		goto fail;
 
 	return 0;
 
 	/* If we fail to setup netfront, it is safe to just revoke access to
 	 * granted pages because backend is not accessing it at this point.
 	 */
-alloc_evtchn_fail:
-	gnttab_end_foreign_access_ref(queue->rx_ring_ref, 0);
-grant_rx_ring_fail:
-	free_page((unsigned long)rxs);
-alloc_rx_ring_fail:
-	gnttab_end_foreign_access_ref(queue->tx_ring_ref, 0);
-grant_tx_ring_fail:
-	free_page((unsigned long)txs);
-fail:
+ fail:
+	if (queue->rx_ring_ref != GRANT_INVALID_REF) {
+		gnttab_end_foreign_access(queue->rx_ring_ref, 0,
+					  (unsigned long)rxs);
+		queue->rx_ring_ref = GRANT_INVALID_REF;
+	} else {
+		free_page((unsigned long)rxs);
+	}
+	if (queue->tx_ring_ref != GRANT_INVALID_REF) {
+		gnttab_end_foreign_access(queue->tx_ring_ref, 0,
+					  (unsigned long)txs);
+		queue->tx_ring_ref = GRANT_INVALID_REF;
+	} else {
+		free_page((unsigned long)txs);
+	}
 	return err;
 }
 


