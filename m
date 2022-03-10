Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CE94D4B79
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243403AbiCJOZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243614AbiCJOY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:24:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66B015B987;
        Thu, 10 Mar 2022 06:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A96AB825F3;
        Thu, 10 Mar 2022 14:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4B2C340EB;
        Thu, 10 Mar 2022 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922085;
        bh=1FnLQ0yxm0hkWZ8SMoKBS8VcDsHIwTu4gSbaHuCNTJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/8VpjkgOH+eGOhdALlAInI5M6e6BFLK5so/2egbXX3IpJ35ZbsJQTgt+d83xwpG/
         HJphT/DlHujIzo86EXlZinrWjbaDBcU3S4UrLLeisWIi7mnynmeWWaJgKLMh2mnLUB
         L56XD2sEAUMs5es42lVG35bW3KI/rundAQF4h+Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.14 31/31] xen/netfront: react properly to failing gnttab_end_foreign_access_ref()
Date:   Thu, 10 Mar 2022 15:18:44 +0100
Message-Id: <20220310140808.447773285@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140807.524313448@linuxfoundation.org>
References: <20220310140807.524313448@linuxfoundation.org>
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
@@ -839,7 +839,6 @@ static int xennet_get_responses(struct n
 	int max = XEN_NETIF_NR_SLOTS_MIN + (rx->status <= RX_COPY_THRESHOLD);
 	int slots = 1;
 	int err = 0;
-	unsigned long ret;
 
 	if (rx->flags & XEN_NETRXF_extra_info) {
 		err = xennet_get_extras(queue, extras, rp);
@@ -870,8 +869,13 @@ static int xennet_get_responses(struct n
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
 
@@ -1075,6 +1079,10 @@ static int xennet_poll(struct napi_struc
 		err = xennet_get_responses(queue, &rinfo, rp, &tmpq);
 
 		if (unlikely(err)) {
+			if (queue->info->broken) {
+				spin_unlock(&queue->rx_lock);
+				return 0;
+			}
 err:
 			while ((skb = __skb_dequeue(&tmpq)))
 				__skb_queue_tail(&errq, skb);
@@ -1652,7 +1660,7 @@ static int setup_netfront(struct xenbus_
 			struct netfront_queue *queue, unsigned int feature_split_evtchn)
 {
 	struct xen_netif_tx_sring *txs;
-	struct xen_netif_rx_sring *rxs;
+	struct xen_netif_rx_sring *rxs = NULL;
 	grant_ref_t gref;
 	int err;
 
@@ -1672,21 +1680,21 @@ static int setup_netfront(struct xenbus_
 
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
@@ -1699,22 +1707,28 @@ static int setup_netfront(struct xenbus_
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
 


