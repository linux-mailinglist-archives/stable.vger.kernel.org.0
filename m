Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CC35F2BC6
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiJCI2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiJCI2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:28:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F417647DF;
        Mon,  3 Oct 2022 01:01:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31498B80E9F;
        Mon,  3 Oct 2022 07:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B13BC433C1;
        Mon,  3 Oct 2022 07:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781919;
        bh=6z4X8fdc30EX8EybZYHf6yJ9cjSlrxFgDetFSSUifgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9G7GjyJir+xaP+SrT5eSGVEphNR0xYgU3FIS5r7mLzBg8FZjHwdslCWUXnR2p/mP
         9WBF1aQ9tCEGP7nCcTNct+FfxDdrOgSBE02bQMo09rOl4Ecxy027DHR7wOrnpV7fmQ
         jehsBPrjtHM9KeWP1FF0CxVnJEtYDv88tAorCU/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <peilin.ye@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+dcd3e13cf4472f2e0ba1@syzkaller.appspotmail.com
Subject: [PATCH 4.19 21/25] usbnet: Fix memory leak in usbnet_disconnect()
Date:   Mon,  3 Oct 2022 09:12:24 +0200
Message-Id: <20221003070716.040690340@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
References: <20221003070715.406550966@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit a43206156263fbaf1f2b7f96257441f331e91bb7 ]

Currently usbnet_disconnect() unanchors and frees all deferred URBs
using usb_scuttle_anchored_urbs(), which does not free urb->context,
causing a memory leak as reported by syzbot.

Use a usb_get_from_anchor() while loop instead, similar to what we did
in commit 19cfe912c37b ("Bluetooth: btusb: Fix memory leak in
play_deferred").  Also free urb->sg.

Reported-and-tested-by: syzbot+dcd3e13cf4472f2e0ba1@syzkaller.appspotmail.com
Fixes: 69ee472f2706 ("usbnet & cdc-ether: Autosuspend for online devices")
Fixes: 638c5115a794 ("USBNET: support DMA SG")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Link: https://lore.kernel.org/r/20220923042551.2745-1-yepeilin.cs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 1316f5b0c0d7..2263a66f6314 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1596,6 +1596,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	struct usbnet		*dev;
 	struct usb_device	*xdev;
 	struct net_device	*net;
+	struct urb		*urb;
 
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
@@ -1612,7 +1613,11 @@ void usbnet_disconnect (struct usb_interface *intf)
 	net = dev->net;
 	unregister_netdev (net);
 
-	usb_scuttle_anchored_urbs(&dev->deferred);
+	while ((urb = usb_get_from_anchor(&dev->deferred))) {
+		dev_kfree_skb(urb->context);
+		kfree(urb->sg);
+		usb_free_urb(urb);
+	}
 
 	if (dev->driver_info->unbind)
 		dev->driver_info->unbind (dev, intf);
-- 
2.35.1



