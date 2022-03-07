Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCC04CF775
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbiCGJqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbiCGJjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6D671CA5;
        Mon,  7 Mar 2022 01:35:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 833BF612A1;
        Mon,  7 Mar 2022 09:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE16C36AF4;
        Mon,  7 Mar 2022 09:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645689;
        bh=E0sv/+ymdpW1t95+oxHtrZQOeK+K6NNFlNKrGTzqv20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSZSB4UYttSU/mKsP4fzR2+b8V8Q/wzzTLT9Z6KUbTnu430CY15iytJw0Niz6YUnM
         ZVgvY9/ALG9ylr2k2Oq2Wi/hcGniYp9jMjLSENwCQfnHT3RRIIvTGTiQeGdWHx9dPj
         5jaIBd//r37PLRHaNZjeQpBpUA6EjPRnsVO4btTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 071/105] can: gs_usb: change active_channelss type from atomic_t to u8
Date:   Mon,  7 Mar 2022 10:19:14 +0100
Message-Id: <20220307091646.175077940@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

commit 035b0fcf02707d3c9c2890dc1484b11aa5335eb1 upstream.

The driver uses an atomic_t variable: gs_usb:active_channels to keep
track of the number of opened channels in order to only allocate
memory for the URBs when this count changes from zero to one.

However, the driver does not decrement the counter when an error
occurs in gs_can_open(). This issue is fixed by changing the type from
atomic_t to u8 and by simplifying the logic accordingly.

It is safe to use an u8 here because the network stack big kernel lock
(a.k.a. rtnl_mutex) is being hold. For details, please refer to [1].

[1] https://lore.kernel.org/linux-can/CAMZ6Rq+sHpiw34ijPsmp7vbUpDtJwvVtdV7CvRZJsLixjAFfrg@mail.gmail.com/T/#t

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://lore.kernel.org/all/20220214234814.1321599-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -190,8 +190,8 @@ struct gs_can {
 struct gs_usb {
 	struct gs_can *canch[GS_MAX_INTF];
 	struct usb_anchor rx_submitted;
-	atomic_t active_channels;
 	struct usb_device *udev;
+	u8 active_channels;
 };
 
 /* 'allocate' a tx context.
@@ -588,7 +588,7 @@ static int gs_can_open(struct net_device
 	if (rc)
 		return rc;
 
-	if (atomic_add_return(1, &parent->active_channels) == 1) {
+	if (!parent->active_channels) {
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
 			u8 *buf;
@@ -689,6 +689,7 @@ static int gs_can_open(struct net_device
 
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 
+	parent->active_channels++;
 	if (!(dev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY))
 		netif_start_queue(netdev);
 
@@ -704,7 +705,8 @@ static int gs_can_close(struct net_devic
 	netif_stop_queue(netdev);
 
 	/* Stop polling */
-	if (atomic_dec_and_test(&parent->active_channels))
+	parent->active_channels--;
+	if (!parent->active_channels)
 		usb_kill_anchored_urbs(&parent->rx_submitted);
 
 	/* Stop sending URBs */
@@ -983,8 +985,6 @@ static int gs_usb_probe(struct usb_inter
 
 	init_usb_anchor(&dev->rx_submitted);
 
-	atomic_set(&dev->active_channels, 0);
-
 	usb_set_intfdata(intf, dev);
 	dev->udev = interface_to_usbdev(intf);
 


