Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9E84C73F8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbiB1Rjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238493AbiB1Rh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:37:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042B945ADD;
        Mon, 28 Feb 2022 09:32:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D63C561359;
        Mon, 28 Feb 2022 17:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8ACC340E7;
        Mon, 28 Feb 2022 17:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069566;
        bh=TP4BwGbN624ZpZnVOC+khdGnLxAgv8yriN6zeGOsyyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7fZ6gQ+7Y7/uPdxtdy8aM8Y1dWAKqoT6rU3n2iXmKqdJfWTctoBae+QZogURjsDe
         viS5LFtiTgr2RafLwkTckbwtdz4bwursiGCV3Ysg92QoQ6R/Hcw1gpIGzoQfGqToWS
         RMlfY0DNYyGfD1M1Du1m1r/bZ/krlHfXFXGo2jT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Ross Maynard <bids.7405@bigpond.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 13/80] USB: zaurus: support another broken Zaurus
Date:   Mon, 28 Feb 2022 18:23:54 +0100
Message-Id: <20220228172313.217510281@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 6605cc67ca18b9d583eb96e18a20f5f4e726103c upstream.

This SL-6000 says Direct Line, not Ethernet

v2: added Reporter and Link

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: Ross Maynard <bids.7405@bigpond.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215361
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ether.c |   12 ++++++++++++
 drivers/net/usb/zaurus.c    |   12 ++++++++++++
 2 files changed, 24 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -570,6 +570,11 @@ static const struct usb_device_id	produc
 	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
 	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
 
+#define ZAURUS_FAKE_INTERFACE \
+	.bInterfaceClass	= USB_CLASS_COMM, \
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
+	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
+
 /* SA-1100 based Sharp Zaurus ("collie"), or compatible;
  * wire-incompatible with true CDC Ethernet implementations.
  * (And, it seems, needlessly so...)
@@ -625,6 +630,13 @@ static const struct usb_device_id	produc
 	.driver_info		= 0,
 }, {
 	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
+		 | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor               = 0x04DD,
+	.idProduct              = 0x9032,	/* SL-6000 */
+	ZAURUS_FAKE_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
 		 | USB_DEVICE_ID_MATCH_DEVICE,
 	.idVendor               = 0x04DD,
 	/* reported with some C860 units */
--- a/drivers/net/usb/zaurus.c
+++ b/drivers/net/usb/zaurus.c
@@ -256,6 +256,11 @@ static const struct usb_device_id	produc
 	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
 	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
 
+#define ZAURUS_FAKE_INTERFACE \
+	.bInterfaceClass	= USB_CLASS_COMM, \
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
+	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
+
 /* SA-1100 based Sharp Zaurus ("collie"), or compatible. */
 {
 	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
@@ -315,6 +320,13 @@ static const struct usb_device_id	produc
 	.driver_info = ZAURUS_PXA_INFO,
 }, {
 	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
+			    | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x04DD,
+	.idProduct		= 0x9032,	/* SL-6000 */
+	ZAURUS_FAKE_INTERFACE,
+	.driver_info = (unsigned long)&bogus_mdlm_info,
+}, {
+	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
 		 | USB_DEVICE_ID_MATCH_DEVICE,
 	.idVendor               = 0x04DD,
 	/* reported with some C860 units */


