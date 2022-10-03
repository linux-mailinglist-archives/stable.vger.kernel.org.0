Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD245F2A76
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiJCHgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiJCHfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:35:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC7343E5D;
        Mon,  3 Oct 2022 00:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AD56B80E98;
        Mon,  3 Oct 2022 07:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771DCC433D6;
        Mon,  3 Oct 2022 07:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781724;
        bh=c8Dc731Ur8wLhOd4nAuMaLhjvTMf9rE2s5bLcJmWcAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T14fxw3/Ue7N8vD9OkTFOvqcsEJ81/Bik8toiGAMFLQTCMvcvblcC32e/Vc2UMG8Z
         aOJP0p2JIDs/33I+r2+J/ENARhPQn/R/usPhEoPfZIgFPsvUB3Uuic2WS5QPxfEjoR
         HcwpK1/BwEnbdJHf1jbfQih0pNfSHYAU7Bzou2Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <peilin.ye@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+dcd3e13cf4472f2e0ba1@syzkaller.appspotmail.com
Subject: [PATCH 5.10 41/52] usbnet: Fix memory leak in usbnet_disconnect()
Date:   Mon,  3 Oct 2022 09:11:48 +0200
Message-Id: <20221003070719.957905812@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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
index 1239fd57514b..43d70348343b 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1567,6 +1567,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	struct usbnet		*dev;
 	struct usb_device	*xdev;
 	struct net_device	*net;
+	struct urb		*urb;
 
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
@@ -1583,7 +1584,11 @@ void usbnet_disconnect (struct usb_interface *intf)
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



