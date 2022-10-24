Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3459660A275
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiJXLnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiJXLnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:43:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6900F10FCD;
        Mon, 24 Oct 2022 04:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E30036126B;
        Mon, 24 Oct 2022 11:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD6BC433D7;
        Mon, 24 Oct 2022 11:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611518;
        bh=CcO3P73nWihKfZZsy5MC4W4ujZ0qIP4yl3E6Fxe4K1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJSuuj0ng8DZkj0cVJhwwKzJeRHf0JidSo6fTa0QCBXtFgjJqllWoMAqib7qP6U5w
         zrOi9pK2PAwEMHbgDY2D8/tagyyuB2MwphFzipmrZ75vc9NwUhIHZn5bYCUu2WZl/t
         tMrtL7GFxWFm0NkXGTvencs7An/dnNIOufKSnUsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <peilin.ye@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+dcd3e13cf4472f2e0ba1@syzkaller.appspotmail.com
Subject: [PATCH 4.9 010/159] usbnet: Fix memory leak in usbnet_disconnect()
Date:   Mon, 24 Oct 2022 13:29:24 +0200
Message-Id: <20221024112949.732978269@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f1cb512c55ac..810e4e65e2a3 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1559,6 +1559,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	struct usbnet		*dev;
 	struct usb_device	*xdev;
 	struct net_device	*net;
+	struct urb		*urb;
 
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
@@ -1575,7 +1576,11 @@ void usbnet_disconnect (struct usb_interface *intf)
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



